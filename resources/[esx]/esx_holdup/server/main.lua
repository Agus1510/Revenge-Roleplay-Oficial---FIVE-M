local rob = false
local robbers = {}
tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_holdup:tooFar')
AddEventHandler('tac_holdup:tooFar', function(currentStore)
	local _source = source
	local xPlayers = tac.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
			TriggerClientEvent('tac_holdup:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('tac_holdup:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('tac:showNotification', _source, _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
	end
end)

RegisterServerEvent('tac_holdup:robberyStarted')
AddEventHandler('tac_holdup:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = tac.GetPlayerFromId(_source)
	local xPlayers = tac.GetPlayers()

	if Stores[currentStore] then
		local store = Stores[currentStore]

		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			TriggerClientEvent('tac:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastRobbed)))
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = tac.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= Config.PoliceNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = tac.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('tac:showNotification', xPlayers[i], _U('rob_in_prog', store.nameOfStore))
						TriggerClientEvent('tac_holdup:setBlip', xPlayers[i], Stores[currentStore].position)
					end
				end

				TriggerClientEvent('tac:showNotification', _source, _U('started_to_rob', store.nameOfStore))
				TriggerClientEvent('tac:showNotification', _source, _U('alarm_triggered'))
				
				TriggerClientEvent('tac_holdup:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('tac_holdup:startTimer', _source)
				
				Stores[currentStore].lastRobbed = os.time()
				robbers[_source] = currentStore

				SetTimeout(store.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('tac_holdup:robberyComplete', _source, store.reward)

							if Config.GiveBlackMoney then
								xPlayer.addAccountMoney('black_money', store.reward)
							else
								xPlayer.addMoney(store.reward)
							end
							
							local xPlayers, xPlayer = tac.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = tac.GetPlayerFromId(xPlayers[i])

								if xPlayer.job.name == 'police' then
									TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_complete_at', store.nameOfStore))
									TriggerClientEvent('tac_holdup:killBlip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('tac:showNotification', _source, _U('min_police', Config.PoliceNumberRequired))
			end
		else
			TriggerClientEvent('tac:showNotification', _source, _U('robbery_already'))
		end
	end
end)
