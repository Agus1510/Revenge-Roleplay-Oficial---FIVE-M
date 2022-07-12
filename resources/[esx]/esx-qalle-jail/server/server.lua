tac                = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterCommand("jail", function(src, args, raw)

	local xPlayer = tac.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]
		local jailTime = tonumber(args[2])
		local jailReason = args[3]

		if GetPlayerName(jailPlayer) ~= nil then

			if jailTime ~= nil then
				JailPlayer(jailPlayer, jailTime)

				TriggerClientEvent("tac:showNotification", src, GetPlayerName(jailPlayer) .. " encarcelado por " .. jailTime .. " minutos!")
				
				if args[3] ~= nil then
					GetRPName(jailPlayer, function(Firstname, Lastname)
						TriggerClientEvent('chat:addMessage', -1, { args = { "JUEZ",  Firstname .. " " .. Lastname .. " Esta ahora en prision por: " .. args[3] }, color = { 249, 166, 0 } })
					end)
				end
			else
				TriggerClientEvent("tac:showNotification", src, "Tiempo invalido!")
			end
		else
			TriggerClientEvent("tac:showNotification", src, "Esta id no esta conectada!")
		end
	else
		TriggerClientEvent("tac:showNotification", src, "No eres un policia!")
	end
end)

RegisterCommand("unjail", function(src, args)

	local xPlayer = tac.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]

		if GetPlayerName(jailPlayer) ~= nil then
			UnJail(jailPlayer)
		else
			TriggerClientEvent("tac:showNotification", src, "Esta id no esta conectada!")
		end
	else
		TriggerClientEvent("tac:showNotification", src, "No eres un policia!")
	end
end)

RegisterServerEvent("tac-qalle-jail:jailPlayer1")
AddEventHandler("tac-qalle-jail:jailPlayer1", function(targetSrc, jailTime, jailReason)
	local src = source
	local targetSrc = tonumber(targetSrc)
	local xPlayer = tac.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then
	JailPlayer(targetSrc, jailTime)

	GetRPName(targetSrc, function(Firstname, Lastname)
		TriggerClientEvent('chat:addMessage', -1, { args = { "JUEZ",  Firstname .. " " .. Lastname .. " Esta ahora en prision por: " .. jailReason }, color = { 249, 166, 0 } })
	end)

	TriggerClientEvent("tac:showNotification", src, GetPlayerName(targetSrc) .. " encarcelado por " .. jailTime .. " minutos!")
	else
	notifMsg    = "[tac_qalle_jail] | " ..xPlayer.name.. " ["..xPlayer.identifier.. "] fue kickeado automáticamente por intentar meter a todos en la cárcel."
	print(notifMsg)
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..xPlayer.name.. "^1 Fue kickeado por intentar meter a todos en la càrcel.")
	DropPlayer(source, 'Lua Execution')
	TriggerEvent('DiscordBot:ToDiscord', 'cheat', 'AntiCheat', notifMsg, 'https://scotchandiron.org/gameassets/anticheat-icon.png', true)
	end
end)

RegisterServerEvent("tac-qalle-jail:unJailPlayer")
AddEventHandler("tac-qalle-jail:unJailPlayer", function(targetIdentifier)
	local src = source
	local xPlayer = tac.GetPlayerFromIdentifier(targetIdentifier)

	if xPlayer ~= nil then
		UnJail(xPlayer.source)
	else
		MySQL.Async.execute(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
	end

	TriggerClientEvent("tac:showNotification", src, xPlayer.name .. " Unjailed!")
end)

RegisterServerEvent("tac-qalle-jail:updateJailTime")
AddEventHandler("tac-qalle-jail:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

RegisterServerEvent("tac-qalle-jail:prisonWorkReward")
AddEventHandler("tac-qalle-jail:prisonWorkReward", function()
	local src = source

	local xPlayer = tac.GetPlayerFromId(src)

	xPlayer.addMoney(math.random(13, 21))
	xPlayer.addInventoryItem('bread', 1)
	xPlayer.addInventoryItem('water', 1)

	TriggerClientEvent("tac:showNotification", src, "Gracias, aqui tienes algo de dinero por la comida!")
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("tac-qalle-jail:jailPlayer1", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("tac-qalle-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = tac.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier

	MySQL.Async.execute(
       "UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

function GetRPName(playerId, data)
	local Identifier = tac.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

tac.RegisterServerCallback("tac-qalle-jail:retrieveJailedPlayers", function(source, cb)
	
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

tac.RegisterServerCallback("tac-qalle-jail:retrieveJailTime", function(source, cb)

	local src = source

	local xPlayer = tac.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		local JailTime = tonumber(result[1].jail)

		if JailTime > 0 then

			cb(true, JailTime)
		else
			cb(false, 0)
		end

	end)
end)