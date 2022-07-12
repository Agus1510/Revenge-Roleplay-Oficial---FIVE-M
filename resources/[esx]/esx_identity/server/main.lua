tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function getIdentity(source, callback)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				identifier	= result[1].identifier,
				firstname	= result[1].firstname,
				lastname	= result[1].lastname,
				dateofbirth	= result[1].dateofbirth,
				sex			= result[1].sex,
				height		= result[1].height
			}

			callback(data)
		else
			local data = {
				identifier	= '',
				firstname	= '',
				lastname	= '',
				dateofbirth	= '',
				sex			= '',
				height		= ''
			}

			callback(data)
		end
	end)
end

function setIdentity(identifier, data, callback)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function updateIdentity(playerId, data, callback)
	local xPlayer = tac.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= xPlayer.identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			TriggerEvent('tac_identity:characterUpdated', playerId, data)
			callback(true)
		end
	end)
end

function deleteIdentity(source)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= xPlayer.identifier,
		['@firstname']		= '',
		['@lastname']		= '',
		['@dateofbirth']	= '',
		['@sex']			= '',
		['@height']			= '',
	})
end

RegisterServerEvent('tac_identity:setIdentity')
AddEventHandler('tac_identity:setIdentity', function(data, myIdentifiers)
	local xPlayer = tac.GetPlayerFromId(source)
	setIdentity(myIdentifiers.steamid, data, function(callback)
		if callback then
			TriggerClientEvent('tac_identity:identityCheck', myIdentifiers.playerid, true)
			TriggerEvent('tac_identity:characterUpdated', myIdentifiers.playerid, data)
		else
			xPlayer.showNotification(_U('failed_identity'))
		end
	end)
end)

AddEventHandler('tac:playerLoaded', function(playerId, xPlayer)
	local myID = {
		steamid = xPlayer.identifier,
		playerid = playerId
	}

	TriggerClientEvent('tac_identity:saveID', playerId, myID)

	getIdentity(playerId, function(data)
		if data.firstname == '' then
			TriggerClientEvent('tac_identity:identityCheck', playerId, false)
			TriggerClientEvent('tac_identity:showRegisterIdentity', playerId)
		else
			TriggerClientEvent('tac_identity:identityCheck', playerId, true)
			TriggerEvent('tac_identity:characterUpdated', playerId, data)
		end
	end)
end)

AddEventHandler('tac_identity:characterUpdated', function(playerId, data)
	local xPlayer = tac.GetPlayerFromId(playerId)

	if xPlayer then
		xPlayer.setName(('%s %s'):format(data.firstname, data.lastname))
		xPlayer.set('firstName', data.firstname)
		xPlayer.set('lastName', data.lastname)
		xPlayer.set('dateofbirth', data.dateofbirth)
		xPlayer.set('sex', data.sex)
		xPlayer.set('height', data.height)
	end
end)

-- Set all the client side variables for connected users one new time
AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(3000)
		local xPlayers = tac.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = tac.GetPlayerFromId(xPlayers[i])

			if xPlayer then
				local myID = {
					steamid  = xPlayer.identifier,
					playerid = xPlayer.source
				}
	
				TriggerClientEvent('tac_identity:saveID', xPlayer.source, myID)
	
				getIdentity(xPlayer.source, function(data)
					if data.firstname == '' then
						TriggerClientEvent('tac_identity:identityCheck', xPlayer.source, false)
						TriggerClientEvent('tac_identity:showRegisterIdentity', xPlayer.source)
					else
						TriggerClientEvent('tac_identity:identityCheck', xPlayer.source, true)
						TriggerEvent('tac_identity:characterUpdated', xPlayer.source, data)
					end
				end)
			end
		end
	end
end)

tac.RegisterCommand('register', 'user', function(xPlayer, args, showError)
	getIdentity(xPlayer.source, function(data)
		if data.firstname ~= '' then
			xPlayer.showNotification(_U('already_registered'))
		else
			TriggerClientEvent('tac_identity:showRegisterIdentity', xPlayer.source)
		end
	end)
end, false, {help = _U('show_registration')})

tac.RegisterCommand('char', 'user', function(xPlayer, args, showError)
	getIdentity(xPlayer.source, function(data)
		if data.firstname == '' then
			xPlayer.showNotification(_U('not_registered'))
		else
			xPlayer.showNotification(_U('active_character', data.firstname, data.lastname))
		end
	end)
end, false, {help = _U('show_active_character')})

tac.RegisterCommand('chardel', 'user', function(xPlayer, args, showError)
	getIdentity(xPlayer.source, function(data)
		if data.firstname == '' then
			xPlayer.showNotification(_U('not_registered'))
		else
			deleteIdentity(xPlayer.source)
			xPlayer.showNotification(_U('deleted_character'))
			TriggerClientEvent('tac_identity:showRegisterIdentity', xPlayer.source)
		end
	end)
end, false, {help = _U('delete_character')})