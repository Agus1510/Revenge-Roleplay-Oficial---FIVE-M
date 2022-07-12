tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)


RegisterNetEvent("tac_walkie:startActionB")
AddEventHandler("tac_walkie:startActionB", function()
	local xPlayers = tac.GetPlayers()

		for i=1, #xPlayers, 1 do

			local xPlayer = tac.GetPlayerFromId(xPlayers[i])

			if xPlayer.job.name ~= nil and xPlayer.job.name == "police" then
				TriggerClientEvent("tac_walkie:startAnim", xPlayer.source) -- Client Event auf Animatonen start
				TriggerClientEvent("tac_walkie:startActionB", xPlayer.source) -- Client Event auf Aktionen start
				
			end
		end
end)

RegisterNetEvent("tac_walkie:stopActionB")
AddEventHandler("tac_walkie:stopActionB", function()
	local xPlayers = tac.GetPlayers()

		for i=1, #xPlayers, 1 do

			local xPlayer = tac.GetPlayerFromId(xPlayers[i])

			if xPlayer.job.name ~= nil and xPlayer.job.name == "police" then
				TriggerClientEvent("tac_walkie:stopAnim", xPlayer.source) -- Client Event auf Animatonen start
				TriggerClientEvent("tac_walkie:stopActionB", xPlayer.source) -- Client Event auf Aktionen start

			end
		end
end)

RegisterServerEvent('tac_walkie:playSoundWithinDistanceServer')
AddEventHandler('tac_walkie:playSoundWithinDistanceServer', function(maxDistance, soundFile, soundVolume)
	local xPlayers = tac.GetPlayers()

		for i=1, #xPlayers, 1 do

			local xPlayer = tac.GetPlayerFromId(xPlayers[i])

			if xPlayer.job.name ~= nil and xPlayer.job.name == "police" then
				TriggerClientEvent('tac_walkie:playSoundWithinDistanceClient', -1, xPlayer.source, maxDistance, soundFile, soundVolume)
			end
		end
end)
