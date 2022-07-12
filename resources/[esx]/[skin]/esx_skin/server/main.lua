tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_skin:save')
AddEventHandler('tac_skin:save', function(skin)
	local xPlayer = tac.GetPlayerFromId(source)
	local defaultMaxWeight = tac.GetConfig().MaxWeight
	local backpackModifier = Config.BackpackWeight[skin.bags_1]

	if backpackModifier then
		xPlayer.setMaxWeight(defaultMaxWeight + backpackModifier)
	else
		xPlayer.setMaxWeight(defaultMaxWeight)
	end

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('tac_skin:responseSaveSkin')
AddEventHandler('tac_skin:responseSaveSkin', function(skin)

	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
				local file = io.open('resources/[tac]/tac_skin/skins.txt', "a")

				file:write(json.encode(skin) .. "\n\n")
				file:flush()
				file:close()
			else
				print(('tac_skin: %s attempted saving skin to file'):format(user.getIdentifier()))
			end
		end)
	end)

end)

tac.RegisterServerCallback('tac_skin:getPlayerSkin', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

-- Commands
TriggerEvent('es:addGroupCommand', 'skin', 'admin', function(source, args, user)
	TriggerClientEvent('tac_skin:openSaveableMenu', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('skin')})

TriggerEvent('es:addGroupCommand', 'skinsave', 'admin', function(source, args, user)
	TriggerClientEvent('tac_skin:requestSaveSkin', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('saveskin')})