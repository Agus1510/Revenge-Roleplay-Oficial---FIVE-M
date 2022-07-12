tac              = nil
local lSpeed	 = 1.49

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
  if Config.userSpeed == true then
  	TriggerServerEvent("tac_advanced_inventory:initSpeed")
  end
end)

RegisterNetEvent("tac_advanced_inventory:speed")
AddEventHandler("tac_advanced_inventory:speed", function(speed)
  if Config.userSpeed == true then
  	lSpeed = speed
  end
end)


--Citizen.CreateThread(function()
	--while true do
	--	Citizen.Wait(0)
	--	SetEntityMaxSpeed(GetPlayerPed(-1), speed)
	--end
--end)
