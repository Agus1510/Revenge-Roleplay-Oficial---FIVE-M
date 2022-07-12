tac                           = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end

end)



Citizen.CreateThread(function()
  local dict = "anim@mp_player_intmenu@key_fob@"
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
      Citizen.Wait(0)
  end
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, 303)) then
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local hasAlreadyLocked = false
		cars = tac.Game.GetVehiclesInArea(coords, 30)
		local carstrie = {}
		local cars_dist = {}		
		notowned = 0
		if #cars == 0 then
			tac.ShowNotification("No hay vehiculos cerca.")
		else
			for j=1, #cars, 1 do
				local coordscar = GetEntityCoords(cars[j])
				local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
				table.insert(cars_dist, {cars[j], distance})
			end
			for k=1, #cars_dist, 1 do
				local z = -1
				local distance, car = 999
				for l=1, #cars_dist, 1 do
					if cars_dist[l][2] < distance then
						distance = cars_dist[l][2]
						car = cars_dist[l][1]
						z = l
					end
				end
				if z ~= -1 then
					table.remove(cars_dist, z)
					table.insert(carstrie, car)
				end
			end
			for i=1, #carstrie, 1 do
				local plate = tac.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
				tac.TriggerServerCallback('carlock:isVehicleOwner', function(owner)
					if owner and hasAlreadyLocked ~= true then
						local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
						vehicleLabel = GetLabelText(vehicleLabel)
						local lock = GetVehicleDoorLockStatus(carstrie[i])
						if lock == 1 or lock == 0 then
							SetVehicleDoorShut(carstrie[i], 0, false)
							SetVehicleDoorShut(carstrie[i], 1, false)
							SetVehicleDoorShut(carstrie[i], 2, false)
							SetVehicleDoorShut(carstrie[i], 3, false)
							SetVehicleDoorsLocked(carstrie[i], 2)
							PlayVehicleDoorCloseSound(carstrie[i], 1)
							tac.ShowNotification('~r~Cerraste~s~ tu vehiculo ~y~'..vehicleLabel..'~s~.')
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetVehicleLights(carstrie[i], 2)
							Citizen.Wait(150)
							SetVehicleLights(carstrie[i], 0)
							Citizen.Wait(150)
							SetVehicleLights(carstrie[i], 2)
							Citizen.Wait(150)
							SetVehicleLights(carstrie[i], 0)
							hasAlreadyLocked = true
						elseif lock == 2 then
							SetVehicleDoorsLocked(carstrie[i], 1)
							PlayVehicleDoorOpenSound(carstrie[i], 0)
							tac.ShowNotification('~g~Abriste~s~ tu vehiculo ~y~'..vehicleLabel..'~s~.')
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetVehicleLights(carstrie[i], 2)
							Citizen.Wait(150)
							SetVehicleLights(carstrie[i], 0)
							Citizen.Wait(150)
							SetVehicleLights(carstrie[i], 2)
							Citizen.Wait(150)
							SetVehicleLights(carstrie[i], 0)
							hasAlreadyLocked = true
						end
					else
						notowned = notowned + 1
					end
					if notowned == #carstrie then
						tac.ShowNotification("No hay vehiculos cerca.")
					end	
				end, plate)
			end			
		end
	end
  end
end)
