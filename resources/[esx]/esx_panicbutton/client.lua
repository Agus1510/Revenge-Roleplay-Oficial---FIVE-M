tac                           = nil
local PlayerData              = {}
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

RegisterNetEvent('tac:setJob')
AddEventHandler('tac:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 19) and GetLastInputMethod( 0 ) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then -- Set to the "LEFT ALT" Key
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped, false))
            local streetName, crossing = GetStreetNameAtCoord(x, y, z)
            streetName = GetStreetNameFromHashKey(streetName)
            local message = ""
            if crossing ~= nil then
                crossing = GetStreetNameFromHashKey(crossing)
                message = "^4" .. GetPlayerName(PlayerId()) .. "^1 Llamo a un 10-13 cerca de ^3" .. streetName .. " ^calle ^3" .. crossing .. " ^Todas las unidades dirigirse al codigo 3."
            else
                message = "^4" .. GetPlayerName(PlayerId()) .. "^1 Llamo aun 10-13 cerca de ^3" .. streetName .. " ^Todas las unidades dirigirse al codigo 3."
            end
            TriggerServerEvent('sendChatMessage', message)
        end
    end
end)
