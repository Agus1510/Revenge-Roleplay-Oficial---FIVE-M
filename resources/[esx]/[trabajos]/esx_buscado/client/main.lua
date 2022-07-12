local PlayerData = {}
local NumberCharset = {}
local wantedTime = 0
blip = nil
blips = {}
tac = nil
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end

	while tac.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = tac.GetPlayerData()
end)

AddEventHandler('onClientMapStart', function()
	Citizen.Wait(20000)

	tac.TriggerServerCallback("tac_wanted:retrieveWantedTime", function(inWanted, newWantedTime, id)
		if inWanted then

			wantedTime = newWantedTime
			tac.ShowNotification(_U('player_loaded'))
			InWanted()
		end
	end)
end)

RegisterNetEvent("tac_wanted:wantedPlayer")
AddEventHandler("tac_wanted:wantedPlayer", function(newWantedTime)
	wantedTime = newWantedTime

	InWanted()
end)

RegisterNetEvent("tac_wanted:unWantedPlayer")
AddEventHandler("tac_wanted:unWantedPlayer", function()
	wantedTime = 0

	InWanted()
end)

function InWanted()

	Citizen.CreateThread(function()

		while wantedTime > 0 do

			wantedTime = wantedTime - 1

			tac.ShowNotification(_U('time_left', wantedTime))

			TriggerServerEvent("tac_wanted:updateWantedTime", wantedTime)

			if wantedTime == 0 then
				tac.ShowNotification(_U('player_out'))
				TriggerServerEvent("tac_wanted:updateWantedTime", 0)
			end

			Citizen.Wait(60000)

		end

	end)
end

RegisterNetEvent("tac_wanted:openWantedMenu")
AddEventHandler("tac_wanted:openWantedMenu", function()
	OpenPoliceWantedMenu()
end)

function OpenPoliceWantedMenu()
	tac.UI.Menu.CloseAll()

	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'police_wanted', {
		title    = _U('add_chat'),
		align    = 'top-left',
		elements = {
			{label = _U('open_wanted'), value = 'open_wanted'},
			{label = _U('open_unwanted'), value = 'open_unwanted'},
			{label = _U('open_feature'), value = 'open_feature'}
	}}, function(data, menu)
		if data.current.value == 'open_wanted' then
			tac.TriggerServerCallback('tac_wanted:getOnlinePlayers', function(players)
				local elements = {}
				for i=1, #players, 1 do
						table.insert(elements, {
							label = players[i].name,
							value = players[i].source,
							name = players[i].name,
							identifier = players[i].identifier
						})
				end
				tac.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_', {
					title    = _U('open_wanted'),
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
		
					tac.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_', {
						title    = _U('are_you_sure', data2.current.name),
						align    = 'top-left',
						elements = {
							{label = _U('set_time'), value = 'time'},
							{label = _U('no'), value = 'no'}
						}
					}, function(data3, menu3)
						menu3.close()
						local name = data2.current.name
						local Playerid = data2.current.value
		
						if data3.current.value == 'time' then
							
							menu3.close()
		
							tac.UI.Menu.Open(
								'dialog', GetCurrentResourceName(), 'wanted_choose_time_menu',
								{
									title = _U('set_min')
								},
							function(data4, menu4)
		
								local wantedTime = tonumber(data4.value)
		
								if wantedTime == nil then
									tac.ShowNotification(_U('time_error'))
								else
									menu4.close()
		
										tac.UI.Menu.Open(
											'dialog', GetCurrentResourceName(), 'wanted_choose_reason_menu',
											{
											title = _U('reason')
											},
										function(data5, menu5)
						
											local reason = data5.value
						
											if reason == nil then
												tac.ShowNotification(_U('reason_error'))
											else
												menu5.close()
						
												TriggerServerEvent("tac_wanted:wantedPlayer",Playerid,name, wantedTime, reason)

												if Config.GcphoneMessageAddWanted then
													TriggerServerEvent('rvphone:sendMessage', 'police',_U('rvphone_message_add_wanted', name, wantedTime))
												end
												if PlayerData.job and PlayerData.job.name == 'police' then
													tac.ShowNotification(_U('police_message',name,wantedTime))
												end

											end
						
										end, function(data5, menu5)
											menu5.close()
										end)
								end
							end, function(data4, menu4)
								menu4.close()
							end)
						end
					end, function(data3, menu3)
						menu3.close()
					end)
		
				end, function(data2, menu2)
					menu2.close()
				end)
		
			end)
		elseif data.current.value == 'open_unwanted' then
			local elements = {}

			tac.TriggerServerCallback("tac_wanted:retrieveWantedPlayers", function(playerArray)
		
				if #playerArray == 0 then
					tac.ShowNotification(_U('no_wanted'))
					return
				end
		
				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = _U('wanted_player', playerArray[i].name, playerArray[i].wantedTime),name = playerArray[i].name, value = playerArray[i].identifier })
				end
		
				tac.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'wanted_unwanted_menu',
					{
						title = _U('open_unwanted'),
						align = "center",
						elements = elements
					},
				function(data2, menu2)
					local identifier = data2.current.value
					local playername = data2.current.name
		
					TriggerServerEvent("tac_wanted:unWantedPlayer",playername,identifier)
					if Config.GcphoneMessageUnWanted then
						TriggerServerEvent('rvphone:sendMessage', 'police',_U('gcphone_message_unwanted', playername))
					end

					if PlayerData.job and PlayerData.job.name == 'police' then
						tac.ShowNotification(_U('police_message_un',playername))
					end
		
					menu2.close()
		
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		elseif data.current.value == 'open_feature' then
			tac.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'wanted_choose_time_menu',
				{
					title = _U('set_min')
				},
			function(data, menu)

				local wantedTime = tonumber(data.value)

				if wantedTime == nil then
					tac.ShowNotification(_U('time_error'))
				else
					menu.close()

						tac.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'wanted_choose_feature_menu',
							{
							title = _U('feature')
							},
						function(data2, menu2)
		
							local feature = data2.value
		
							if feature == nil then
								tac.ShowNotification(_U('feature_error'))
							else
								menu2.close()
								local number = GetRandomNumber(4)
								TriggerServerEvent("tac_wanted:wantedFeature", number, wantedTime, feature)
							end
		
						end, function(data2, menu2)
							menu2.close()
						end)
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

RegisterNetEvent('tac_wanted:setBlip')
AddEventHandler('tac_wanted:setBlip', function(Playerid)
	if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' then
		local id = GetPlayerFromServerId(Playerid)
		local ped = GetPlayerPed(id)
		local x, y, z = table.unpack(GetEntityCoords(ped, true))
		blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 161)
		SetBlipScale(blip, 3.0)
		SetBlipColour(blip, 1)
		SetBlipDisplay(blip, 4)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('wanted_player_show'))
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip, true)
		table.insert(blips, blip)
		Wait(Config.ShowTime)
		for i, blip in pairs(blips) do 
			RemoveBlip(blip)
		end
	end
end)