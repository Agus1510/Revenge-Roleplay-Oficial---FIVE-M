tac               = nil

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

RegisterNetEvent('tac_borrmaskin_humane:startpendrive')
AddEventHandler('tac_borrmaskin_humane:startpendrive', function(source)
	DrillAnimation()
end)

function DrillAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_XHUMAN_CONST_DRILL", 0, true)          
	end)
end