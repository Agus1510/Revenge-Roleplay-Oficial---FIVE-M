tac = {}
tac.Players = {}
tac.UsableItemsCallbacks = {}
tac.Items = {}
tac.ServerCallbacks = {}
tac.TimeoutCount = -1
tac.CancelledTimeouts = {}
tac.LastPlayerData = {}
tac.Pickups = {}
tac.PickupId = 0
tac.Jobs = {}

AddEventHandler('tac:getSharedObject', function(cb)
	cb(tac)
end)

function getSharedObject()
	return tac
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for k,v in ipairs(result) do
			tac.Items[v.name] = {
				label = v.label,
				weight = v.weight,
				rare = v.rare,
				canRemove = v.can_remove
			}
		end
	end)

	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		tac.Jobs[result[i].name] = result[i]
		tac.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if tac.Jobs[result2[i].job_name] then
			tac.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('es_extended: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(tac.Jobs) do
		if next(v.grades) == nil then
			tac.Jobs[v.name] = nil
			print(('es_extended: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end
end)

AddEventHandler('tac:playerLoaded', function(source)
	local xPlayer         = tac.GetPlayerFromId(source)
	local accounts        = {}
	local items           = {}
	local xPlayerAccounts = xPlayer.getAccounts()
	local xPlayerItems    = xPlayer.getInventory()

	for i=1, #xPlayerAccounts, 1 do
		accounts[xPlayerAccounts[i].name] = xPlayerAccounts[i].money
	end

	for i=1, #xPlayerItems, 1 do
		items[xPlayerItems[i].name] = xPlayerItems[i].count
	end

	tac.LastPlayerData[source] = {
		accounts = accounts,
		items    = items
	}
end)

RegisterServerEvent('tac:clientLog')
AddEventHandler('tac:clientLog', function(msg)
	RconPrint(msg .. "\n")
end)

RegisterServerEvent('tac:triggerServerCallback')
AddEventHandler('tac:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	tac.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('tac:serverCallback', _source, requestId, ...)
	end, ...)
end)
