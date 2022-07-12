tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	local players = tac.GetPlayers()

	for _,playerId in ipairs(players) do
		local xPlayer = tac.GetPlayerFromId(playerId)

		MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local data = {}

			if result[1].status then
				data = json.decode(result[1].status)
			end

			xPlayer.set('status', data)
			TriggerClientEvent('tac_status:load', playerId, data)
		end)
	end
end)

AddEventHandler('tac:playerLoaded', function(playerId, xPlayer)
	MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {}

		if result[1].status then
			data = json.decode(result[1].status)
		end

		xPlayer.set('status', data)
		TriggerClientEvent('tac_status:load', playerId, data)
	end)
end)

AddEventHandler('tac:playerDropped', function(playerId, reason)
	local xPlayer = tac.GetPlayerFromId(playerId)
	local status = xPlayer.get('status')

	MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
		['@status']     = json.encode(status),
		['@identifier'] = xPlayer.identifier
	})
end)

AddEventHandler('tac_status:getStatus', function(playerId, statusName, cb)
	local xPlayer = tac.GetPlayerFromId(playerId)
	local status  = xPlayer.get('status')

	for i=1, #status, 1 do
		if status[i].name == statusName then
			cb(status[i])
			break
		end
	end
end)

RegisterServerEvent('tac_status:update')
AddEventHandler('tac_status:update', function(status)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.set('status', status)
	end
end)

function SaveData()
	local xPlayers = tac.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
		local status  = xPlayer.get('status')

		MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
			['@status']     = json.encode(status),
			['@identifier'] = xPlayer.identifier
		})
	end

	SetTimeout(10 * 60 * 1000, SaveData)
end

SaveData()
