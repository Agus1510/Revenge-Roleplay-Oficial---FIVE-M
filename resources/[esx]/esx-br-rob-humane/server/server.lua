local rob = false
local robbers = {}
tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('tac-br-rob-humane:toofar')
AddEventHandler('tac-br-rob-humane:toofar', function(robb)
	local source = source
	local xPlayers = tac.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Banks[robb].nameofbank)
			TriggerClientEvent('tac-br-rob-humane:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('tac-br-rob-humane:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('tac:showNotification', source, _U('robbery_has_cancelled') .. Banks[robb].nameofbank)
	end
end)

RegisterServerEvent('tac-br-rob-humane:rob')
AddEventHandler('tac-br-rob-humane:rob', function(robb)

	local source = source
	local xPlayer = tac.GetPlayerFromId(source)
	local pendrive = xPlayer.getInventoryItem('pendrive')
	local xPlayers = tac.GetPlayers()
	
	if Banks[robb] then

		local bank = Banks[robb]

		if (os.time() - bank.lastrobbed) < 43200 and bank.lastrobbed ~= 0 then

			TriggerClientEvent('tac:showNotification', source, _U('already_robbed') .. (2 - (os.time() - bank.lastrobbed)) .. _U('seconds'))
			return
		end


		local cops = 0
		for i=1, #xPlayers, 1 do
 		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end


		if rob == false then
		   
		  if xPlayer.getInventoryItem('pendrive').count >= 1 then
		     xPlayer.removeInventoryItem('pendrive', 1)

			if(cops >= Config.NumberOfCopsRequired)then

				rob = true
				for i=1, #xPlayers, 1 do
					local xPlayer = tac.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
							TriggerClientEvent('tac:showNotification', xPlayers[i], _U('rob_in_prog') .. bank.nameofbank)
							TriggerClientEvent('tac-br-rob-humane:setblip', xPlayers[i], Banks[robb].position)
					end
				end

				TriggerClientEvent('tac:showNotification', source, _U('started_to_rob') .. bank.nameofbank .. _U('do_not_move'))
				TriggerClientEvent('tac:showNotification', source, _U('alarm_triggered'))
				TriggerClientEvent('tac:showNotification', source, _U('hold_pos'))
				TriggerClientEvent('tac_borrmaskin_yacht:startpendrive', source)
				TriggerClientEvent('tac-br-rob-humane:currentlyrobbing', source, robb)
				Banks[robb].lastrobbed = os.time()
				robbers[source] = robb
				local savedSource = source
				SetTimeout(600000, function()

					if(robbers[savedSource])then

						rob = false
						TriggerClientEvent('tac-br-rob-humane:robberycomplete', savedSource, job)
						if(xPlayer)then

							xPlayer.addAccountMoney('black_money', bank.reward)
							local xPlayers = tac.GetPlayers()
							for i=1, #xPlayers, 1 do
								local xPlayer = tac.GetPlayerFromId(xPlayers[i])
								if xPlayer.job.name == 'police' then
										TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_complete_at') .. bank.nameofbank)
										TriggerClientEvent('tac-br-rob-humane:killblip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('tac:showNotification', source, _U('min_two_police') .. Config.NumberOfCopsRequired)
			end
		end
		else
			TriggerClientEvent('tac:showNotification', source, _U('robbery_already'))
		end
	end
end)
