Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playedPed = GetPlayerPed(-1)

        if (not IsEntityVisible(playedPed)) then
            TAC.TriggerServerEvent('revengeanticheat:banPlayer', 'visible')
        end

        if (IsPedSittingInAnyVehicle(playedPed) and IsVehicleVisible(GetVehiclePedIsIn(playedPed, 1))) then
            TAC.TriggerServerEvent('revengeanticheat:banPlayer', 'invisiblevehicle')
        end
    end
end)