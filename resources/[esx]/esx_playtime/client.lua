local currentTags = {}
local tac = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterNetEvent('timeplay:set_tags')
AddEventHandler('timeplay:set_tags', function (newPlayers)
    currentTags = newPlayers
end)

 Citizen.CreateThread(function ()

    while true do
        Citizen.Wait(0)

        local currentPed = PlayerPedId()
        local currentPos = GetEntityCoords(currentPed)

        local cx,cy,cz = table.unpack(currentPos)
        cz = cz + 1.2
        
        for k, v in pairs(currentTags) do
            local label = Config.label
            local newPlayer = GetPlayerPed(GetPlayerFromServerId(v.source))
            local newPlayerCoords = GetEntityCoords(newPlayer)
            local x,y,z = table.unpack(newPlayerCoords)
            z = z + 1.2

            local distance = GetDistanceBetweenCoords(vector3(cx,cy,cz), vector3(x,y,z), true)
            
            if label then
                if distance < 5 and GetPlayerServerId(PlayerId()) ~= v.source and HasEntityClearLosToEntity(currentPed, newPlayer, 17) then
                    tac.Game.Utils.DrawText3D(vector3(x,y,z), label, 1.5)
                end
            end
        end
    end

end)