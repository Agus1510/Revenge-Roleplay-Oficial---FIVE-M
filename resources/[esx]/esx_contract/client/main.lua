tac = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('tac_contract:getVehicle')
AddEventHandler('tac_contract:getVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local closestPlayer, playerDistance = tac.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and playerDistance <= 3.0 then
		local vehicle = tac.Game.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			local vehProps = tac.Game.GetVehicleProperties(vehicle)
			tac.ShowNotification(_U('writingcontract', vehProps.plate))
			TriggerServerEvent('tac_clothes:sellVehicle', GetPlayerServerId(closestPlayer), vehProps.plate)
		else
			tac.ShowNotification(_U('nonearby'))
		end
	else
		tac.ShowNotification(_U('nonearbybuyer'))
	end
	
end)

RegisterNetEvent('tac_contract:showAnim')
AddEventHandler('tac_contract:showAnim', function(player)
	loadAnimDict('anim@amb@nightclub@peds@')
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, false)
	Citizen.Wait(20000)
	ClearPedTasks(PlayerPedId())
end)


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end