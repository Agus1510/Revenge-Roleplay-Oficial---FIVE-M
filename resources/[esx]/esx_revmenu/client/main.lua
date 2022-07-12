Citizen.CreateThread(function()
    while tac == nil do
        TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
        Citizen.Wait(0)
    end

    while tac.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    while true do
        tac.PlayerData = tac.GetPlayerData()
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)

        if not IsPedDeadOrDying(ped, 1) then
            if IsControlJustPressed(1,170) and GetLastInputMethod(2) then
                OpenMobileAIOActionsMenu()
            end
        else
            Citizen.Wait(500)
        end
    end
end)

function setVoice()
    voice.current = (voice.current + 1) % 3

    if voice.current == 0 then
        NetworkSetTalkerProximity(voice.default)
        voice.level = _U('normal')
    elseif voice.current == 1 then
        NetworkSetTalkerProximity(voice.shout)
        voice.level = _U('shout')
    elseif voice.current == 2 then
        NetworkSetTalkerProximity(voice.whisper)
        voice.level = _U('whisper')
    end
end

function OpenMobileAIOActionsMenu()

    tac.UI.Menu.CloseAll()

    tac.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_aio_actions', {
        title    = _U('aiomenu'),
        align    = 'bottom-right',
        elements = {
            {label = _U('interactions_menu'), value = 'interactions_menu'},
            {label = _U('vehicle_menu'), value = 'vehicle_menu'},
            {label = _U('tac_menu'), value = 'tac_menu'},
            {label = _U('jobs_menu'), value = 'jobs_menu'}
        }
    }, function(data, menu)
        if data.current.value == 'interactions_menu' then
            tac.UI.Menu.Open('default', GetCurrentResourceName(), 'interactions_menu', {
                title    = _U('aiomenu'),
                align    = 'bottom-right',
                elements = {
                    {label = _U('my_phone_number'), value = 'my_phone_number'},
                    {label = _U('give_phone_number'), value = 'give_phone_number'}
                }
            }, function(data, menu)
                if data.current.value == 'my_phone_number' then
                        TriggerServerEvent('esx_aiomenu:givePhoneNumber', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                        ESX.UI.Menu.CloseAll()
                elseif data.current.value == 'give_phone_number' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 2.0 then
                        ESX.ShowNotification(_U('no_players'))
                    elseif closestPlayer ~= -1 and closestDistance <= 2.0 then
                        TriggerServerEvent('esx_aiomenu:givePhoneNumber', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                    end
                 end
            end, function(data, menu)
                menu.close()
            end)
        elseif data.current.value == 'vehicle_menu' then
            local ped = GetPlayerPed(-1)
            if IsPedInAnyVehicle(ped, true) then 
                tac.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_menu', {
                    title    = _U('aiomenu'),
                    align    = 'bottom-right',
                    elements = {
                        {label = _U('window_controls'), value = 'window_controls'},
                        {label = _U('door_controls'), value = 'door_controls'}
                    }
                }, function(data, menu)
                    if data.current.value == 'window_controls' then
                        tac.UI.Menu.Open('default', GetCurrentResourceName(), 'window_controls', {
                            title    = _U('aiomenu'),
                            align    = 'bottom-right',
                            elements = {
                                {label = _U('windows_up'), value = 'windows_up'},
                                {label = _U('windows_down'), value = 'windows_down'},
                                {label = _U('individual_window_controls'), value = 'individual_window_controls'}
                            }
                        }, function(data, menu)
                            if data.current.value == 'windows_up' then
                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                    local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
                                    local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
                                    local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
                                    local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
                                    local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
                                    local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
                                    if frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or frontMiddleWindow ~= -1 or rearMiddleWindow ~= -1 then
                                        RollUpWindow(vehicle, 0)
                                        RollUpWindow(vehicle, 1)
                                        RollUpWindow(vehicle, 2)
                                        RollUpWindow(vehicle, 3)
                                        RollUpWindow(vehicle, 4)
                                        RollUpWindow(vehicle, 5)
                                    else
                                        tac.ShowNotification('Este vehiculo no tiene ventanas.')
                                    end
                                else
                                    tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                end
                            elseif data.current.value == 'windows_down' then
                                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                        local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
                                        local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
                                        local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
                                        local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
                                        local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
                                        local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
                                        if frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or frontMiddleWindow ~= -1 or rearMiddleWindow ~= -1 then
                                            RollDownWindow(vehicle, 0)
                                            RollDownWindow(vehicle, 1)
                                            RollDownWindow(vehicle, 2)
                                            RollDownWindow(vehicle, 3)
                                            RollDownWindow(vehicle, 4)
                                            RollDownWindow(vehicle, 5)
                                        else
                                            tac.ShowNotification('Este vehiculo no tiene ventanas.')
                                        end
                                    else
                                        tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                    end
                            elseif data.current.value == 'individual_window_controls' then
                                tac.UI.Menu.Open('default', GetCurrentResourceName(), 'individual_window_controls', {
                                    title    = _U('aiomenu'),
                                    align    = 'bottom-right',
                                    elements = {
                                        {label = _U('lf_window_up'), value = 'lf_window_up'},
                                        {label = _U('lf_window_down'), value = 'lf_window_down'},
                                        {label = _U('rf_window_up'), value = 'rf_window_up'},
                                        {label = _U('rf_window_down'), value = 'rf_window_down'},
                                        {label = _U('lr_window_up'), value = 'lr_window_up'},
                                        {label = _U('lr_window_down'), value = 'lr_window_down'},
                                        {label = _U('rr_window_up'), value = 'rr_window_up'},
                                        {label = _U('rr_window_down'), value = 'rr_window_down'},
                                        {label = _U('mf_window_up'), value = 'mf_window_up'},
                                        {label = _U('mf_window_down'), value = 'mf_window_down'},
                                        {label = _U('mr_window_up'), value = 'mr_window_up'},
                                        {label = _U('mr_window_down'), value = 'mr_window_down'}
                                    }
                                }, function(data, menu)
                                    if data.current.value == 'lf_window_up' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
                                            if frontLeftWindow ~= -1 then
                                                RollUpWindow(vehicle, 0)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana delantera izquierda.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'lf_window_down' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
                                            if frontLeftWindow ~= -1 then
                                                RollDownWindow(vehicle, 0)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana delantera izquierda.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'rf_window_up' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
                                            if frontRightWindow ~= -1 then
                                                RollUpWindow(vehicle, 1)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana delantera derecha.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'rf_window_down' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
                                            if frontRightWindow ~= -1 then
                                                RollDownWindow(vehicle, 1)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana delantera derecha.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'lr_window_up' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
                                            if rearLeftWindow ~= -1 then
                                                RollUpWindow(vehicle, 2)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana trasera izquierda.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'lr_window_down' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
                                            if rearLeftWindow ~= -1 then
                                                RollDownWindow(vehicle, 2)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana trasera izquierda.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'rr_window_up' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
                                            if rearRightWindow ~= -1 then
                                                RollUpWindow(vehicle, 3)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana trasera derecha.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'rr_window_down' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
                                            if rearRightWindow ~= -1 then
                                                RollDownWindow(vehicle, 3)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana trasera derecha.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'mf_window_up' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
                                            if frontMiddleWindow ~= -1 then
                                                RollUpWindow(vehicle, 4)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana delantera central.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'mf_window_down' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
                                            if frontMiddleWindow ~= -1 then
                                                RollDownWindow(vehicle, 4)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana delantera central.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'mr_window_up' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
                                            if rearMiddleWindow ~= -1 then
                                                RollUpWindow(vehicle, 5)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana trasera central.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'mr_window_down' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
                                            if rearMiddleWindow ~= -1 then
                                                RollDownWindow(vehicle, 5)
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene ventana trasera central.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    end
                                end, function(data, menu)
                                    menu.close()
                                end)
                            end
                        end, function(data, menu)
                            menu.close()
                        end)
                    elseif data.current.value == 'door_controls' then
                        tac.UI.Menu.Open('default', GetCurrentResourceName(), 'window_controls', {
                            title    = _U('aiomenu'),
                            align    = 'bottom-right',
                            elements = {
                                {label = _U('toggle_all_doors'), value = 'toggle_all_doors'},
                                {label = _U('individual_door_controls'), value = 'individual_door_controls'}
                            }
                        }, function(data, menu)
                            if data.current.value == 'toggle_all_doors' then
                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                    if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then 
                                        SetVehicleDoorShut(vehicle, 0, false)
                                        SetVehicleDoorShut(vehicle, 1, false)
                                        SetVehicleDoorShut(vehicle, 2, false)	
                                        SetVehicleDoorShut(vehicle, 3, false)	
                                        SetVehicleDoorShut(vehicle, 4, false)	
                                        SetVehicleDoorShut(vehicle, 5, false)				
                                    else
                                        SetVehicleDoorOpen(vehicle, 0, false) 
                                        SetVehicleDoorOpen(vehicle, 1, false)   
                                        SetVehicleDoorOpen(vehicle, 2, false)   
                                        SetVehicleDoorOpen(vehicle, 3, false)   
                                        SetVehicleDoorOpen(vehicle, 4, false)   
                                        SetVehicleDoorOpen(vehicle, 5, false)               
                                    end
                                else
                                    tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                end
                            elseif data.current.value == 'individual_door_controls' then
                                tac.UI.Menu.Open('default', GetCurrentResourceName(), 'individual_door_controls', {
                                    title    = _U('aiomenu'),
                                    align    = 'bottom-right',
                                    elements = {
                                        {label = _U('toggle_hood'), value = 'toggle_hood'},
                                        {label = _U('toggle_trunk'), value = 'toggle_trunk'},
                                        {label = _U('lf_toggle_door'), value = 'lf_toggle_door'},
                                        {label = _U('rf_toggle_door'), value = 'rf_toggle_door'},
                                        {label = _U('lr_toggle_door'), value = 'lr_toggle_door'},
                                        {label = _U('rr_toggle_door'), value = 'rr_toggle_door'}
                                    }
                                }, function(data, menu)
                                    if data.current.value == 'toggle_hood' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local bonnet = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'bonnet')
                                            if bonnet ~= -1 then
                                                if GetVehicleDoorAngleRatio(vehicle, 4) > 0.0 then 
                                                    SetVehicleDoorShut(vehicle, 4, false)            
                                                else
                                                    SetVehicleDoorOpen(vehicle, 4, false)             
                                                end
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene capot.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'toggle_trunk' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local boot = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'boot')
                                            if boot ~= -1 then
                                                if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then 
                                                    SetVehicleDoorShut(vehicle, 5, false)            
                                                else
                                                    SetVehicleDoorOpen(vehicle, 5, false)             
                                                end
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene baul.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'lf_toggle_door' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_dside_f')
                                            if frontLeftDoor ~= -1 then
                                                if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then 
                                                    SetVehicleDoorShut(vehicle, 0, false)            
                                                else
                                                    SetVehicleDoorOpen(vehicle, 0, false)             
                                                end
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene Puerta delantera de conductor.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'rf_toggle_door' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local frontRightDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_pside_f')
                                            if frontRightDoor ~= -1 then
                                                if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then 
                                                    SetVehicleDoorShut(vehicle, 1, false)            
                                                else
                                                    SetVehicleDoorOpen(vehicle, 1, false)             
                                                end
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene delantera del pasajero.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'lr_toggle_door' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_dside_r')
                                            if rearLeftDoor ~= -1 then
                                                if GetVehicleDoorAngleRatio(vehicle, 2) > 0.0 then 
                                                    SetVehicleDoorShut(vehicle, 2, false)            
                                                else
                                                    SetVehicleDoorOpen(vehicle, 2, false)             
                                                end
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene puerta trasera de conductor.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    elseif data.current.value == 'rr_toggle_door' then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                                            local rearRightDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_pside_r')
                                            if rearRightDoor ~= -1 then
                                                if GetVehicleDoorAngleRatio(vehicle, 3) > 0.0 then 
                                                    SetVehicleDoorShut(vehicle, 3, false)            
                                                else
                                                    SetVehicleDoorOpen(vehicle, 3, false)             
                                                end
                                            else
                                                tac.ShowNotification('Este vehiculo no tiene trasera de pasajero.')
                                            end
                                        else
                                            tac.ShowNotification('Debes ser el conductor para hacer esto.')
                                        end
                                    end
                                end, function(data, menu)
                                    menu.close()
                                end)
                            end
                        end, function(data, menu)
                            menu.close()
                        end)
                    end
                end, function(data, menu)
                    menu.close()
                end)
            else
                tac.ShowNotification(_U('need_to_be_in_vehicle'))
            end
        elseif data.current.value == 'tac_menu' then
            tac.UI.Menu.Open('default', GetCurrentResourceName(), 'tac_menu', {
                title    = _U('tac_menu'),
                align    = 'bottom-right',
                elements = {
                    {label = _U('invoices_button'), value = 'invoices_button'},
                    {label = _U('voice_range_button'), value = 'voice_range_button'},
                    {label = _U('animations_button'), value = 'animations_button'},
					{label = _U('boton_licencias'), value = 'boton_licencias'},
				    {label = _U('boton_ropa'), value = 'boton_ropa'},
					{label = _U('animaciones2'), value = 'animaciones2'},
					
                }
            }, function(data, menu)
                if data.current.value == 'invoices_button' then
                    exports['esx_billing']:ShowBillsMenu()
                elseif data.current.value == 'voice_range_button' then
                    exports['esx_voice']:setVoice()
                elseif data.current.value == 'animations_button' then
                    exports['esx_animations']:OpenAnimationsMenu()
			    elseif data.current.value == 'boton_licencias' then
                    exports['idcard']:openMenu()
                elseif data.current.value == 'boton_ropa' then
                    exports['clothesmerfik']:OpenActionMenuInteraction()
			    elseif data.current.value == 'animaciones2' then
                    exports['dpemotes']:OpenEmoteMenu()
                end
            end, function(data, menu)
                menu.close()
            end)
        elseif data.current.value == 'jobs_menu' then
            if tac ~= nil then
                if tac.PlayerData ~= nil then
                    if tac.PlayerData.job ~= nil then
                        if tac.PlayerData.job.name ~= nil then
                            if tac.PlayerData.job.name == 'ambulance' then
                                tac.UI.Menu.CloseAll()
                                exports['esx_ambulancejob']:OpenMobileAmbulanceActionsMenu()
                            elseif tac.PlayerData.job.name == 'police' then
                                tac.UI.Menu.CloseAll()
                                exports['esx_policejob']:OpenPoliceActionsMenu()
                            elseif tac.PlayerData.job.name == 'mecano' then
                                tac.UI.Menu.CloseAll()
                                exports['esx_mecanojob']:OpenMobileMechanicActionsMenu()
                            elseif tac.PlayerData.job.name == 'taxi' then
                                tac.UI.Menu.CloseAll()
                                exports['esx_taxijob']:OpenMobileTaxiActionsMenu()
                            end
                        end
                    end
                end
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('tac_aiomenu:givePhoneNumber')
AddEventHandler('tac_aiomenu:givePhoneNumber', function(data)
    if data.phoneNumber ~= 'nil' then	
        tac.ShowNotification(data.name .. '\'s numero es ' .. data.phoneNumber .. '.')
    else
        tac.ShowNotification(data.name .. '\'s no tiene el telefono encendido.')
    end	
end)

RegisterNetEvent('tac_aiomenu:showID')
AddEventHandler('tac_aiomenu:showID', function(data)
    if data.name ~= 'Nil' then	
        tac.UI.Menu.Open('default', GetCurrentResourceName(), 'show_id', {
            title    = _U('aiomenu'),
            align    = 'bottom-right',
            elements = {
                {label = 'Nombre: ' .. tostring(data.name), value = 'nil'},
                {label = 'Fecha de nacimiento: ' .. tostring(data.dob), value = 'nil'},
                {label = 'Sexo: ' .. tostring(data.sex), value = 'nil'},
                {label = 'Altura: ' .. tostring(data.height), value = 'nil'}
            }
        }, function(data, menu)

        end, function(data, menu)
            menu.close()
        end)
    else
        tac.ShowNotification('Error with Show ID. Please contact the developer of tac AIOMenu.')
    end	
end)
