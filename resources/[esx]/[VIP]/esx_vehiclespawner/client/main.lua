local CurrentActionData, this_Spawner = {}, {}
local HasAlreadyEnteredMarker = false
local LastZone, CurrentAction, CurrentActionMsg
tac = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

-- Vehicle Spawn Menu
function OpenSpawnerMenu()
	IsInMainMenu = true
	local elements = {
		{label = _U('dont_abuse')}
	}

	for i=1, #Config.Vehicles, 1 do
		table.insert(elements, {
			label = Config.Vehicles[i].label,
			model = Config.Vehicles[i].model
		})
	end

	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = _U('vehicle_spawner'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		IsInMainMenu = false
		menu.close()
		SpawnVehicle(data.current.model)
	end, function(data, menu)
		IsInMainMenu = false
		menu.close()

		CurrentAction     = 'spawner_point'
		CurrentActionMsg  = _U('press_to_enter')
		CurrentActionData = {}
	end)
end

-- Vehicle Return Menu
function OpenReturnMenu()
	local playerCoords = GetEntityCoords(PlayerPedId())

	vehicles = tac.Game.GetVehiclesInArea(playerCoords, 5.0)
	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do
			tac.Game.DeleteVehicle(v)
		end
	end
end

function SpawnVehicle(model)
	tac.Game.SpawnVehicle(model, this_Spawner.Loc, this_Spawner.Heading)
end



AddEventHandler('tac_vehiclespawner:hasEnteredMarker', function(zone)
	if zone == 'spawner_point' then
		CurrentAction     = 'spawner_point'
		CurrentActionMsg  = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'deleter_point' then
		CurrentAction     = 'deleter_point'
		CurrentActionMsg  = _U('press_to_enter2')
		CurrentActionData = {}
	end
end)

-- Exited Marker
AddEventHandler('tac_vehiclespawner:hasExitedMarker', function()
	if not IsInMainMenu then
		tac.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Resource Stop
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInMainMenu then
			tac.UI.Menu.CloseAll()
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		local blip = AddBlipForCoord(v.Pos)

		SetBlipSprite (blip, Config.BlipVehicleSpawner.Sprite)
		SetBlipColour (blip, Config.BlipVehicleSpawner.Color)
		SetBlipDisplay(blip, Config.BlipVehicleSpawner.Display)
		SetBlipScale  (blip, Config.BlipVehicleSpawner.Scale)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('blip_spawner'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Enter / Exit marker events & Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true
		
		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v.Pos)
			local distance2 = #(playerCoords - v.Del)
			
			if distance < Config.DrawDistance then
				letSleep = false
				
				if Config.MenuMarker.Type ~= -1 then
					DrawMarker(Config.MenuMarker.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MenuMarker.x, Config.MenuMarker.y, Config.MenuMarker.z, Config.MenuMarker.r, Config.MenuMarker.g, Config.MenuMarker.b, 100, false, true, 2, false, false, false, false)
				end
				
				if Config.DelMarker.Type ~= -1 then
					DrawMarker(Config.DelMarker.Type, v.Del, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.DelMarker.x, Config.DelMarker.y, Config.DelMarker.z, Config.DelMarker.r, Config.DelMarker.g, Config.DelMarker.b, 100, false, true, 2, false, false, false, false)
				end
				
				if distance < Config.MenuMarker.x then
					isInMarker, currentZone = true, 'spawner_point'
					this_Spawner = v
				end
				
				if distance2 < Config.DelMarker.x then
					isInMarker, currentZone = true, 'deleter_point'
					this_Spawner = v
				end
			end
		end
		
		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			TriggerEvent('tac_vehiclespawner:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('tac_vehiclespawner:hasExitedMarker', LastZone)
		end
		
		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			tac.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'spawner_point' then
					tac.TriggerServerCallback('pxrp_vip:getVIPStatus', function(isVIP)
					if isVIP then
						OpenSpawnerMenu()
					else
						tac.ShowNotification("No eres vip , para mas informacion entrar a discord.")
					end
				end, GetPlayerServerId(PlayerId()), '1')
				elseif CurrentAction == 'deleter_point' then
					tac.TriggerServerCallback('pxrp_vip:getVIPStatus', function(isVIP)
					if isVIP then
						OpenReturnMenu()
					else
						tac.ShowNotification("No eres vip , para mas informacion entrar a discord.")
					end
				end, GetPlayerServerId(PlayerId()), '1')
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

