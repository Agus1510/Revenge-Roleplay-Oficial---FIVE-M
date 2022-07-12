tac                           = nil
local PlayerData              = {}
local Busy, Nearby  	      = false, false

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end

	while tac.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = tac.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlPressed(2, 246) and GetLastInputMethod(2) and Busy == false and PlayerData.job.name ~= nil and PlayerData.job.name == "police" then
                TriggerServerEvent("tac_walkie:playSoundWithinDistanceServer", 10, "copradiooff", 0.6) 
                TriggerServerEvent("tac_walkie:startActionB") -- Aktion für andere Personen starten
                DisableActions(GetPlayerPed(-1))
                TriggerEvent("tac_walkie:startAnim", source)
                Busy = true
            -- Aktiviere tac_walkie Talkie
        elseif not IsControlPressed(2, 246) and GetLastInputMethod(2) and Busy == true and PlayerData.job.name ~= nil and PlayerData.job.name == "police" then
            -- Deaktiviere tac_walkie Talkie
                TriggerServerEvent("tac_walkie:stopActionB") -- Aktion für andere Personen stoppen
                EnableActions(GetPlayerPed(-1))
                TriggerEvent("tac_walkie:stopAnim", source)
                Busy = false
            else
        end
    end
end)

-- FUNCTIONS

function EnableActions(ped)
	EnableControlAction(1, 140, true)
	EnableControlAction(1, 141, true)
	EnableControlAction(1, 142, true)
	EnableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, false) -- Disable weapon firing
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

-- EVENTS

RegisterNetEvent('tac:setJob')
AddEventHandler('tac:setJob', function(job)
    PlayerData.job = job
    
    Citizen.Wait(5000)
end)

RegisterNetEvent("tac_walkie:startActionB") -- Aktion Person B
AddEventHandler("tac_walkie:startActionB", function()
    NetworkSetTalkerProximity(0.00) -- Sprachreichweite wird unbegrenzt
end)

RegisterNetEvent("tac_walkie:stopActionB") -- Aktion Person B
AddEventHandler("tac_walkie:stopActionB", function()
    NetworkSetTalkerProximity(6.00) -- Sprachreichweite wird 6 Meter
end)

RegisterNetEvent("tac_walkie:startAnim") -- Event, um andere Personen Animation starten zu lassen
AddEventHandler("tac_walkie:startAnim", function(player)
    Citizen.CreateThread(function()
    	if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        RequestAnimDict("random@arrests")
        while not HasAnimDictLoaded( "random@arrests") do
            Citizen.Wait(1)
        end
        TaskPlayAnim(GetPlayerPed(-1), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
    end
    end)
end)
RegisterNetEvent("tac_walkie:stopAnim")
AddEventHandler("tac_walkie:stopAnim", function(player)
    Citizen.CreateThread(function()
        Citizen.Wait(1)
        ClearPedTasks(GetPlayerPed(-1))
    end)
end)

RegisterNetEvent('tac_walkie:playSoundWithinDistanceClient')
AddEventHandler('tac_walkie:playSoundWithinDistanceClient', function(playerNetId, maxDistance, soundFile, soundVolume)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume
        })
    end
end)
