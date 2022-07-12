tac = nil
local playersHealing = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_ambulancejob:revive')
AddEventHandler('tac_ambulancejob:revive', function(target)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		xPlayer.addMoney(Config.ReviveReward)
		TriggerClientEvent('tac_ambulancejob:revive', target)
	else
		print(('tac_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_ambulancejob:heal')
AddEventHandler('tac_ambulancejob:heal', function(target, type)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('tac_ambulancejob:heal', target, type)
	else
		print(('tac_ambulancejob: %s attempted to heal!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_ambulancejob:putInVehicle')
AddEventHandler('tac_ambulancejob:putInVehicle', function(target)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('tac_ambulancejob:putInVehicle', target)
	else
		print(('tac_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
	end
end)

TriggerEvent('tac_rvphone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('tac_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

tac.RegisterServerCallback('tac_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

if Config.EarlyRespawnFine then
	tac.RegisterServerCallback('tac_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = tac.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('tac_ambulancejob:payFine')
	AddEventHandler('tac_ambulancejob:payFine', function()
		local xPlayer = tac.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		xPlayer.showNotification(_U('respawn_bleedout_fine_msg', tac.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

tac.RegisterServerCallback('tac_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = tac.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

tac.RegisterServerCallback('tac_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = tac.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('tac_ambulancejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

tac.RegisterServerCallback('tac_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = tac.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('tac_ambulancejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterServerEvent('tac_ambulancejob:removeItem')
AddEventHandler('tac_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		xPlayer.showNotification(_U('used_bandage'))
	elseif item == 'medikit' then
		xPlayer.showNotification(_U('used_medikit'))
	end
end)

RegisterServerEvent('tac_ambulancejob:giveItem')
AddEventHandler('tac_ambulancejob:giveItem', function(itemName, amount)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('tac_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		print(('tac_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end

	if xPlayer.canCarryItem(itemName, amount) then
		xPlayer.addInventoryItem(itemName, amount)
	else
		xPlayer.showNotification(_U('max_item'))
	end
end)

TriggerEvent('es:addGroupCommand', 'revive', 'admin', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			print(('tac_ambulancejob: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('tac_ambulancejob:revive', tonumber(args[1]))
		end
	else
		TriggerClientEvent('tac_ambulancejob:revive', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })


tac.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = tac.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)

		playersHealing[source] = true
		TriggerClientEvent('tac_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

tac.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = tac.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)

		playersHealing[source] = true
		TriggerClientEvent('tac_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

tac.RegisterServerCallback('tac_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then
			print(('tac_ambulancejob: %s attempted combat logging!'):format(identifier))
		end

		cb(isDead)
	end)
end)

RegisterServerEvent('tac_ambulancejob:setDeathStatus')
AddEventHandler('tac_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	if type(isDead) ~= 'boolean' then
		print(('tac_ambulancejob: %s attempted to parse something else than a boolean to setDeathStatus!'):format(identifier))
		return
	end

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)
