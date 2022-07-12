tac               = nil
local blowtorching = false
local clearweld = false
local dooropen = false
local blowtorchingtime = 300
Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

-----

RegisterNetEvent('tac_blowtorch:startblowtorch')
AddEventHandler('tac_blowtorch:startblowtorch', function(source)
	blowtorchAnimation()
	Citizen.CreateThread(function()
		while true do
			if blowtorching then
				DisableControlAction(0, 73,   true) -- LookLeftRight
			end
			Citizen.Wait(10)
		end
	end)
end)

RegisterNetEvent('tac_blowtorch:finishclear')
AddEventHandler('tac_blowtorch:finishclear', function(source)
	clearweld = false
end)


RegisterNetEvent('tac_blowtorch:clearweld')
AddEventHandler('tac_blowtorch:clearweld', function(x,y,z)
		clearweld = true
		Citizen.CreateThread(function()
			while clearweld do
				Wait(1000)
				local weld = tac.Game.GetClosestObject('prop_weld_torch', vector3(x,y,z))
				tac.Game.DeleteObject(weld)
			end
		end)
end)

RegisterNetEvent('tac_blowtorch:stopblowtorching')
AddEventHandler('tac_blowtorch:stopblowtorching', function()
	blowtorching = false
	blowtorchingtime = 0
	ClearPedTasksImmediately(GetPlayerPed(-1))
end)

--RegisterNetEvent('tac_blowtorch:opendoors')
--AddEventHandler('tac_blowtorch:opendoors', function(x,y,z)
	--Citizen.CreateThread(function()
	--while dooropen do
		--Wait(5000)
		--tac.ShowNotification('abrete sesamo')
		--local obs, distance = tac.Game.GetClosestObject('V_ILEV_GB_VAULDR', {x,y,z})
		--local pos = GetEntityCoords(obs);
		--tac.ShowNotification(' hola' .. distance)
		--SetEntityHeading(obs, GetEntityHeading(obs) + 70.0)
	--end
	--end)
--end)

function blowtorchAnimation()
	local playerPed = GetPlayerPed(-1)
	blowtorchingtime = 300
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('tac_holdupbank:clearweld', {coords.x, coords.y, coords.z})
	Citizen.CreateThread(function()
			blowtorching = true
			Citizen.CreateThread(function()
				while blowtorching do
						Wait(2000)
						--local weld = tac.Game.GetClosestObject('prop_weld_torch', GetEntityCoords(GetPlayerPed(-1)))
						--tac.Game.DeleteObject(weld)
						TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
						blowtorchingtime = blowtorchingtime - 1
						if blowtorchingtime <= 0 then
							blowtorching = false
							ClearPedTasksImmediately(PlayerPedId())
						end
				end
			end)
			
			--while blowtorching do
				--TaskPlayAnim(playerPed, "amb@world_human_const_blowtorch@male@blowtorch@base", "base", 2.0, 1.0, 5000, 5000, 1, true, true, true)
				TaskPlayAnim(playerPed, "atimetable@reunited@ig_7", "thanksdad_bag_02", 2.0, 1.0, 5000, 5000, 1, true, true, true)
				--if IsControlJustReleased(1, 51) then
					
				--end
			--end
		--end
	end)
end

--[[function blowtorchAnimation()
	tac.ShowNotification(' llego')
	local playerPed = GetPlayerPed(-1)
	Citizen.CreateThread(function()
	--while true do	
		--Wait(100)
		
		while true do	
		Wait(100)
		end
	--end
	end)
	--anim@heists@fleeca_bank@blowtorching
	--blowtorch_right_door
	--amb@lo_res_idles@
	--world_human_const_blowtorch_lo_res_base
end

--[[
TASK_PLAY_ANIM(Ped ped, char* animDictionary, char* animationName, float speed, float speedMultiplier, int duration, int flag, float playbackRate, BOOL lockX, BOOL lockY, BOOL lockZ);


]]--
