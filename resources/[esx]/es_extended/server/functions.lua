tac.Trace = function(str)
	if Config.EnableDebug then
		print('tac> ' .. str)
	end
end

tac.SetTimeout = function(msec, cb)
	local id = tac.TimeoutCount + 1

	SetTimeout(msec, function()
		if tac.CancelledTimeouts[id] then
			tac.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	tac.TimeoutCount = id

	return id
end

tac.ClearTimeout = function(id)
	tac.CancelledTimeouts[id] = true
end

tac.RegisterServerCallback = function(name, cb)
	tac.ServerCallbacks[name] = cb
end

tac.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if tac.ServerCallbacks[name] ~= nil then
		tac.ServerCallbacks[name](source, cb, ...)
	else
		print('es_extended: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

tac.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}
	xPlayer.setLastPosition(xPlayer.getCoords())

	-- User accounts
	for k,v in ipairs(xPlayer.accounts) do
		if tac.LastPlayerData[xPlayer.source].accounts[v.name] ~= v.money then
			table.insert(asyncTasks, function(cb)
				MySQL.Async.execute('UPDATE user_accounts SET money = @money WHERE identifier = @identifier AND name = @name', {
					['@money']      = v.money,
					['@identifier'] = xPlayer.identifier,
					['@name']       = v.name
				}, function(rowsChanged)
					cb()
				end)
			end)

			tac.LastPlayerData[xPlayer.source].accounts[v.name] = v.money
		end
	end

	-- Inventory items
	for k,v in ipairs(xPlayer.inventory) do
		if tac.LastPlayerData[xPlayer.source].items[v.name] ~= v.count then
			table.insert(asyncTasks, function(cb)
				MySQL.Async.execute('UPDATE user_inventory SET count = @count WHERE identifier = @identifier AND item = @item', {
					['@count']      = v.count,
					['@identifier'] = xPlayer.identifier,
					['@item']       = v.name
				}, function(rowsChanged)
					cb()
				end)
			end)

			tac.LastPlayerData[xPlayer.source].items[v.name] = v.count
		end
	end

	-- Job, loadout and position
	table.insert(asyncTasks, function(cb)
		MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade, loadout = @loadout, position = @position WHERE identifier = @identifier', {
			['@job']        = xPlayer.job.name,
			['@job_grade']  = xPlayer.job.grade,
			['@loadout']    = json.encode(xPlayer.getLoadout()),
			['@position']   = json.encode(xPlayer.getLastPosition()),
			['@identifier'] = xPlayer.identifier
		}, function(rowsChanged)
			cb()
		end)
	end)

	Async.parallel(asyncTasks, function(results)
		RconPrint('[SAVED] ' .. xPlayer.name .. "^7\n")

		if cb ~= nil then
			cb()
		end
	end)
end

tac.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = tac.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			local xPlayer = tac.GetPlayerFromId(xPlayers[i])
			tac.SavePlayer(xPlayer, cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		RconPrint('[SAVED] All players' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

tac.StartDBSync = function()
	function saveData()
		tac.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

tac.GetPlayers = function()
	local sources = {}

	for k,v in pairs(tac.Players) do
		table.insert(sources, k)
	end

	return sources
end

tac.GetPlayerFromId = function(source)
	return tac.Players[tonumber(source)]
end

tac.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(tac.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

tac.RegisterUsableItem = function(item, cb)
	tac.UsableItemsCallbacks[item] = cb
end

tac.UseItem = function(source, item)
	tac.UsableItemsCallbacks[item](source)
end

tac.GetItemLabel = function(item)
	if tac.Items[item] ~= nil then
		return tac.Items[item].label
	end
end

tac.CreatePickup = function(type, name, count, label, playerId)
	local pickupId = (tac.PickupId == 65635 and 0 or tac.PickupId + 1)
	local xPlayer = tac.GetPlayerFromId(playerId)

	tac.Pickups[pickupId] = {
		type  = type,
		name  = name,
		count = count,
		label = label,
		coords = xPlayer.getCoords()
	}

	TriggerClientEvent('tac:pickup', -1, pickupId, label, playerId)
	tac.PickupId = pickupId
end

tac.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if tac.Jobs[job] and tac.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end