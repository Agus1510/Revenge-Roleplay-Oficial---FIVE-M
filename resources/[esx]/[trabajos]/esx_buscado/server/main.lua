tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterCommand("buscado", function(src, args, raw)

	local xPlayer = tac.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local wantedPlayer = args[1]
		local wantedTime = tonumber(args[2])
        local wantedReason = args[3]
        local name = GetPlayerName(wantedPlayer)

		if GetPlayerName(wantedPlayer) ~= nil then

			if wantedTime ~= nil then
				WantedPlayer(wantedPlayer, wantedTime)

				TriggerClientEvent("tac:showNotification", src,_U('police_message', name, wantedTime))
				if args[3] ~= nil then
                    TriggerClientEvent('chat:addMessage', -1, { args = { _U('add_chat'), _('add_chat_message', name, args[3]) }, color = { 249, 166, 0 } })
                end
			else
				TriggerClientEvent("tac:showNotification", src,_U('time_error'))
			end
		else
			TriggerClientEvent("tac:showNotification", src,_U('id_not_online'))
		end
	else
		TriggerClientEvent("tac:showNotification", src,_U('not_cops'))
	end
end)

RegisterCommand("nosebusca", function(src, args)

	local xPlayer = tac.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local wantedPlayer = args[1]

		if GetPlayerName(wantedPlayer) ~= nil then
			UnWanted(wantedPlayer)
		else
			TriggerClientEvent("tac:showNotification", src,_U('id_not_online'))
		end
	else
		TriggerClientEvent("tac:showNotification", src,_U('not_cops'))
	end
end)

tac.RegisterServerCallback('tac_wanted:getOnlinePlayers', function(source, cb)
	local xPlayers = tac.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
            name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

RegisterServerEvent("tac_wanted:wantedPlayer")
AddEventHandler("tac_wanted:wantedPlayer", function(Playerid, name, wantedTime, wantedReason)
    local src = source
    local Playerid = tonumber(Playerid)
    local xPlayer = tac.GetPlayerFromId(source)
	WantedPlayer(Playerid, wantedTime)
	TriggerClientEvent('chat:addMessage', -1, { args = { _U('add_chat'), _('add_chat_message', name, wantedReason) }, color = { 23, 80, 165 } })
    TriggerClientEvent("tac:showNotification", Playerid,_U('player_wanted', wantedReason, wantedTime))
    if Config.Discord then
        policeToDiscord(_U('discord_head'), _U('discord_message',GetPlayerName(src),name,wantedReason,wantedTime), 56108)
    end
end)

RegisterServerEvent("tac_wanted:wantedFeature")
AddEventHandler("tac_wanted:wantedFeature", function(Number, wantedTime, wantedFeature)
	local src = source
	TriggerClientEvent('chat:addMessage', -1, { args = { _U('add_chat'), _('add_chat_message_feature', Number, wantedFeature, wantedTime) }, color = { 23, 80, 165 } })
	FeatureTime(Number, wantedTime)
    if Config.Discord then
        policeToDiscord(_U('discord_head'), _U('discord_message_feature',GetPlayerName(src),Number,wantedFeature,wantedTime), 56108)
    end
end)

function FeatureTime(Number, wantedTime)
    Citizen.CreateThread(function()

		while wantedTime > 0 do

			wantedTime = wantedTime - 1
			if wantedTime == 0 then
				TriggerClientEvent('chat:addMessage', -1, { args = { _U('add_chat'), _('add_chat_message_unfeature', Number) }, color = { 23, 80, 165 } })
				if Config.Discord then
					policeToDiscord(_U('discord_head_unwanted'), _U('discord_message_unfeature',Number), 16711680)
				end
			end

			Citizen.Wait(60000)

		end

	end)
end

function WantedPlayer(wantedPlayer, wantedTime)
    TriggerClientEvent("tac_wanted:wantedPlayer",wantedPlayer, wantedTime)

	EditWantedTime(wantedPlayer, wantedTime)
end

function EditWantedTime(wantedPlayer, wantedTime)

    local xPlayer = tac.GetPlayerFromId(wantedPlayer)
	local Identifier = xPlayer.identifier
	MySQL.Async.execute(
       "UPDATE users SET wanted = @newWantedTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newWantedTime'] = tonumber(wantedTime)
		}
	)
end

tac.RegisterServerCallback("tac_wanted:retrieveWantedPlayers", function(source, cb)
	
	local wantedPersons = {}

    MySQL.Async.fetchAll("SELECT firstname, lastname, wanted, identifier FROM users WHERE wanted > @wanted", { ["@wanted"] = 0 }, function(result)


        for i = 1, #result, 1 do
            table.insert(wantedPersons, { 
                name = result[i].firstname,
                wantedTime = result[i].wanted,
                identifier = result[i].identifier,
            })
		end

		cb(wantedPersons)
	end)
end)

function UnWanted(wantedPlayer)
	local src = source
    local xPlayer = tac.GetPlayerFromId(wantedPlayer)
    TriggerClientEvent("tac_wanted:unWantedPlayer", wantedPlayer)

    TriggerClientEvent("tac:showNotification", wantedPlayer,  _U('player_unwanted'))

	EditWantedTime(wantedPlayer, 0)
end

tac.RegisterServerCallback("tac_wanted:retrieveWantedTime", function(source, cb)

	local src = source

	local xPlayer = tac.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT wanted FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

        local WantedTime = tonumber(result[1].wanted)

		if WantedTime > 0 then

            cb(true, WantedTime, src)
		else
			cb(false, 0)
		end

	end)
end)

RegisterServerEvent("tac_wanted:updateWantedTime")
AddEventHandler("tac_wanted:updateWantedTime", function(newWantedTime)
    local src = source
    EditWantedTime(src, newWantedTime)
    if Config.WantedBlip then
        TriggerClientEvent('tac_wanted:setBlip', -1, src)
    end
end)

RegisterServerEvent("tac_wanted:unWantedPlayer")
AddEventHandler("tac_wanted:unWantedPlayer", function(playername,Player)
	local src = source
    local xPlayer = tac.GetPlayerFromIdentifier(Player)
    if xPlayer ~= nil then
		UnWanted(xPlayer.source)
	else
        TriggerClientEvent("tac:showNotification", src,_U('police_unwanted', playername))
	    MySQL.Async.execute(
			"UPDATE users SET wanted = @newWantedTime WHERE identifier = @identifier",
			{
				['@identifier'] = Player,
				['@newWantedTime'] = 0
			}
        )
    end
    if Config.Discord then
        policeToDiscord(_U('discord_head_unwanted'), _U('discord_message_unwanted',GetPlayerName(src),playername), 16711680)
    end
end)

function policeToDiscord (name,message,color)
    local DiscordWebHook = Config.DiscordWebHook

    local embeds = {
        {
            ["title"]=message,
            ["type"]="rich",
            ["color"] =color,
            ["footer"]=  {
            ["text"]= os.date("%Y/%m/%d\nTime: %X"), -- [中文化> (日期: "%Y/%m/%d\n時間: %X")] --
            },
        }
    }
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
