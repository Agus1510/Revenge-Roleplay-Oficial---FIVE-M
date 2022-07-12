tac = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	TriggerEvent('tac_gps:removeGPS')

	for i=1, #PlayerData.inventory, 1 do
		if PlayerData.inventory[i].name == 'gps' then
			if PlayerData.inventory[i].count > 0 then
				TriggerEvent('tac_gps:addGPS')
			end
		end
	end

end)

RegisterNetEvent('tac_gps:addGPS')
AddEventHandler('tac_gps:addGPS', function()
	DisplayRadar(true)
end)

RegisterNetEvent('tac_gps:removeGPS')
AddEventHandler('tac_gps:removeGPS', function()
	DisplayRadar(false)
end)