tac = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end

	while not tac.GetPlayerData().job do
		Citizen.Wait(10)
	end

	tac.PlayerData = tac.GetPlayerData()

	-- Update the door list
	tac.TriggerServerCallback('tac_doorlock:getDoorState', function(doorState)
		for index,state in pairs(doorState) do
			Config.DoorList[index].locked = state
		end
	end)
end)

RegisterNetEvent('tac:setJob')
AddEventHandler('tac:setJob', function(job) tac.PlayerData.job = job end)

RegisterNetEvent('tac_doorlock:setDoorState')
AddEventHandler('tac_doorlock:setDoorState', function(index, state) Config.DoorList[index].locked = state end)

Citizen.CreateThread(function()
	while true do
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,v in ipairs(Config.DoorList) do
			v.isAuthorized = isAuthorized(v)

			if v.doors then
				for k2,v2 in ipairs(v.doors) do
					if v2.object and DoesEntityExist(v2.object) then
						if k2 == 1 then
							v.distanceToPlayer = #(playerCoords - GetEntityCoords(v2.object))
						end

						if v.locked and v2.objHeading and tac.Math.Round(GetEntityHeading(v2.object)) ~= v2.objHeading then
							SetEntityHeading(v2.object, v2.objHeading)
						end
					else
						v.distanceToPlayer = nil
						v2.object = GetClosestObjectOfType(v2.objCoords, 1.0, v2.objHash, false, false, false)
					end
				end
			else
				if v.object and DoesEntityExist(v.object) then
					v.distanceToPlayer = #(playerCoords - GetEntityCoords(v.object))

					if v.locked and v.objHeading and tac.Math.Round(GetEntityHeading(v.object)) ~= v.objHeading then
						SetEntityHeading(v.object, v.objHeading)
					end
				else
					v.distanceToPlayer = nil
					v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
				end
			end
		end

		Citizen.Wait(500)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local letSleep = true

		for k,v in ipairs(Config.DoorList) do
			if v.distanceToPlayer and v.distanceToPlayer < 50 then
				letSleep = false

				if v.doors then
					for k2,v2 in ipairs(v.doors) do
						FreezeEntityPosition(v2.object, v.locked)
					end
				else
					FreezeEntityPosition(v.object, v.locked)
				end
			end

			if v.distanceToPlayer and v.distanceToPlayer < v.maxDistance then
				local size, displayText = 1, _U('unlocked')

				if v.size then size = v.size end
				if v.locked then displayText = _U('locked') end
				if v.isAuthorized then displayText = _U('press_button', displayText) end

				tac.Game.Utils.DrawText3D(v.textCoords, displayText, size)

				if IsControlJustReleased(0, 38) then
					if v.isAuthorized then
						v.locked = not v.locked
						TriggerServerEvent('tac_doorlock:updateState', k, v.locked) -- broadcast new state of the door to everyone
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function isAuthorized(door)
	if not tac or not tac.PlayerData.job then
		return false
	end

	for k,job in pairs(door.authorizedJobs) do
		if job == tac.PlayerData.job.name then
			return true
		end
	end

	return false
end
