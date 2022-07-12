local rob = false
local robbers = {}
tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('tac_holdupbank:toofar')
AddEventHandler('tac_holdupbank:toofar', function(robb)
	local source = source
	local xPlayers = tac.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Banks[robb].nameofbank)
			TriggerClientEvent('tac_holdupbank:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('tac_holdupbank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('tac:showNotification', source, _U('robbery_has_cancelled') .. Banks[robb].nameofbank)
	end
end)

RegisterServerEvent('tac_holdupbank:toofarhack')
AddEventHandler('tac_holdupbank:toofarhack', function(robb)
	local source = source
	local xPlayers = tac.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Banks[robb].nameofbank)
			TriggerClientEvent('tac_holdupbank:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('tac_holdupbank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('tac:showNotification', source, _U('robbery_has_cancelled') .. Banks[robb].nameofbank)
	end
end)

RegisterServerEvent('tac_holdupbank:rob')
AddEventHandler('tac_holdupbank:rob', function(robb)

	local source = source
	local xPlayer = tac.GetPlayerFromId(source)
	local xPlayers = tac.GetPlayers()
	
	if Banks[robb] then

		local bank = Banks[robb]

		if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then

			TriggerClientEvent('tac:showNotification', source, _U('already_robbed') .. (1800 - (os.time() - bank.lastrobbed)) .. _U('seconds'))
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
		
			if xPlayer.getInventoryItem('blowtorch').count >= 1 then
				xPlayer.removeInventoryItem('blowtorch', 1)

				if(cops >= Config.NumberOfCopsRequired)then

					rob = true
					for i=1, #xPlayers, 1 do
						local xPlayer = tac.GetPlayerFromId(xPlayers[i])
						if xPlayer.job.name == 'police' then
								TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. bank.nameofbank)
								TriggerClientEvent('tac:showNotification', xPlayers[i], _U('rob_in_prog') .. bank.nameofbank)
								TriggerClientEvent('tac_holdupbank:killblip', xPlayers[i])							
								TriggerClientEvent('tac_holdupbank:setblip', xPlayers[i], Banks[robb].position)
						end
					end

					TriggerClientEvent('tac:showNotification', source, _U('started_to_rob') .. bank.nameofbank .. _U('do_not_move'))
					TriggerClientEvent('tac:showNotification', source, _U('alarm_triggered'))
					TriggerClientEvent('tac:showNotification', source, _U('hold_pos'))
					TriggerClientEvent('tac_holdupbank:currentlyrobbing', source, robb)
					TriggerClientEvent('tac_blowtorch:startblowtorch', source)
					Banks[robb].lastrobbed = os.time()
					robbers[source] = robb
					local savedSource = source
					SetTimeout(300000, function()

						if(robbers[savedSource])then

							rob = false
							TriggerClientEvent('tac_holdupbank:robberycomplete', savedSource, job)
							if(xPlayer)then

								--Updated to choose between cash or black money
								if Config.moneyType == 'cash' then
									xPlayer.addMoney(bank.reward)
								elseif Config.moneyType == 'black' then
									xPlayer.addAccountMoney('black_money',bank.reward)
								end

								local xPlayers = tac.GetPlayers()
								for i=1, #xPlayers, 1 do
									local xPlayer = tac.GetPlayerFromId(xPlayers[i])
									if xPlayer.job.name == 'police' then
											TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_complete_at') .. bank.nameofbank)
											TriggerClientEvent('tac_holdupbank:killblip', xPlayers[i])
									end
								end
							end
						end
					end)
				else
					TriggerClientEvent('tac:showNotification', source, _U('min_two_police')..Config.NumberOfCopsRequired)
				end
			else
				TriggerClientEvent('tac:showNotification', source, _U('blowtorch_needed'))
			end

		else
			TriggerClientEvent('tac:showNotification', source, _U('robbery_already'))
		end
	end
end)

RegisterServerEvent('tac_holdupbank:hack')
AddEventHandler('tac_holdupbank:hack', function(robb)

	local source = source
	local xPlayer = tac.GetPlayerFromId(source)
	local xPlayers = tac.GetPlayers()
	
	if Banks[robb] then

		local bank = Banks[robb]

		if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then

			TriggerClientEvent('tac:showNotification', source, _U('already_robbed') .. (1800 - (os.time() - bank.lastrobbed)) .. _U('seconds'))
			return
		end


		local cops = 0
		for i=1, #xPlayers, 1 do
 		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end



			if(cops >= Config.NumberOfCopsRequired)then

				if xPlayer.getInventoryItem('raspberry').count >= 1 then
					xPlayer.removeInventoryItem('raspberry', 1)

					TriggerClientEvent('tac:showNotification', source, _U('started_to_hack') .. bank.nameofbank .. _U('do_not_move'))
					TriggerClientEvent('tac:showNotification', source, _U('hold_pos_hack'))
					TriggerClientEvent('tac_holdupbank:currentlyhacking', source, robb, Banks[robb])



				else
					TriggerClientEvent('tac:showNotification', source, _U('raspberry_needed'))
				end
			else
				TriggerClientEvent('tac:showNotification', source, _U('min_two_police'))
			end
	end
end)

-- Plant a bomb

RegisterServerEvent('tac_holdupbank:plantbomb')
AddEventHandler('tac_holdupbank:plantbomb', function(robb)

    local source = source
    local xPlayer = tac.GetPlayerFromId(source)
    local xPlayers = tac.GetPlayers()

    if Banks[robb] then

        local bank = Banks[robb]

        if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then

            TriggerClientEvent('tac:showNotification', source, _U('already_robbed') .. (1800 - (os.time() - bank.lastrobbed)) .. _U('seconds'))
            return
        end


        local cops = 0
        for i=1, #xPlayers, 1 do
            local xPlayer = tac.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                cops = cops + 1
            end
        end


        if(cops >= Config.NumberOfCopsRequired)then

			if xPlayer.getInventoryItem('c4_bank').count >= 1 then
				xPlayer.removeInventoryItem('c4_bank', 1)
				for i=1, #xPlayers, 1 do
				local xPlayer = tac.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robo en progreso en ^2" .. bank.nameofbank)
						TriggerClientEvent('tac:showNotification', xPlayers[i], _U('rob_in_prog') .. bank.nameofbank)
						TriggerClientEvent('tac_holdupbank:setblip', xPlayers[i], Banks[robb].position)
					end
				end

				TriggerClientEvent('tac:showNotification', source, _U('started_to_plantbomb') .. bank.nameofbank .. _U('do_not_move'))

				TriggerClientEvent('tac:showNotification', source, _U('hold_pos_plantbomb'))
				TriggerClientEvent('tac_holdupbank:plantingbomb', source, robb, Banks[robb])

				robbers[source] = robb
				local savedSource = source

				SetTimeout(20000, function()

					if(robbers[savedSource])then

						rob = false
						TriggerClientEvent('tac_holdupbank:plantbombcomplete', savedSource, Banks[robb])
						if(xPlayer)then

							TriggerClientEvent('tac:showNotification', xPlayer, _U('bombplanted_run'))
							local xPlayers = tac.GetPlayers()
							for i=1, #xPlayers, 1 do
								local xPlayer = tac.GetPlayerFromId(xPlayers[i])
								if xPlayer.job.name == 'police' then
									TriggerClientEvent('tac:showNotification', xPlayers[i], _U('bombplanted_at') .. bank.nameofbank)

								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('tac:showNotification', source, _U('c4_needed'))
			end
        else
            TriggerClientEvent('tac:showNotification', source, _U('min_two_police'))
        end

    end
end)

RegisterServerEvent('tac_holdupbank:clearweld')
AddEventHandler('tac_holdupbank:clearweld', function(x,y,z)

	TriggerClientEvent('tac_blowtorch:clearweld', -1, x,y,z)
end)

RegisterServerEvent('tac_holdupbank:opendoor')
AddEventHandler('tac_holdupbank:opendoor', function(x,y,z, doortype)

	TriggerClientEvent('tac_holdupbank:opendoors', -1, x,y,z, doortype)
end)

RegisterServerEvent('tac_holdupbank:plantbombtoall')
AddEventHandler('tac_holdupbank:plantbombtoall', function(x,y,z, doortype)
    SetTimeout(20000, function()
        TriggerClientEvent('tac_holdupbank:plantedbomb', -1, x,y,z, doortype)
    end)
end)

RegisterServerEvent('tac_holdupbank:finishclear')
AddEventHandler('tac_holdupbank:finishclear', function()
	TriggerClientEvent('tac_blowtorch:finishclear', -1)
end)

RegisterServerEvent('tac_holdupbank:closedoor')
AddEventHandler('tac_holdupbank:closedoor', function()

	TriggerClientEvent('tac_holdupbank:closedoor', -1)
end)

RegisterServerEvent('tac_holdupbank:plantbomb')
AddEventHandler('tac_holdupbank:plantbomb', function()
    TriggerClientEvent('tac_holdupbank:plantbomb', -1)
end)
