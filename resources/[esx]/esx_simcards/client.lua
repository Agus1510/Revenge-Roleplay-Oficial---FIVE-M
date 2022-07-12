tac                           = nil  
local PlayerData              = {}  

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
  
RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
    PlayerData = xPlayer    
end)

RegisterCommand("simcard", function(source, args, rawCommand)
    local playerPed = GetPlayerPed(-1)
    if args[1] ~= nil then
        local rawNumber = args[1]
        local isValid = tonumber(rawNumber) ~= nil
        if string.len(rawNumber) == 7 then
            if isValid then
                if Config.RequiresSimItem then
                    local inventory = tac.GetPlayerData().inventory
                    local simCardCount = nil
                    for i=1, #inventory, 1 do                          
                        if inventory[i].name == 'sim_card' then
                            simCardCount = inventory[i].count
                        end
                    end
                    if simCardCount > 0 then
                        TriggerServerEvent('matriarch_simcards:useSimCard', args)               
                    else 
                        tac.ShowNotification("No tienes un chip")
                    end
                else
                    TriggerServerEvent('matriarch_simcards:useSimCard', args)   
                end                  
            else
                tac.ShowNotification('El numero solo puede contener 7 digitos')
            end             
        else
            tac.ShowNotification('El numero tiene que ser de ~r~7 ~w~digitos')
        end
        
    else
        tac.ShowNotification('~r~Falta el numero - ~w~Usa /simcard {numero}')
    end     
end)

RegisterNetEvent('matriarch_simcards:startNumChange')
AddEventHandler('matriarch_simcards:startNumChange', function(newNum)
    if Config.UseAnimation then
        exports.dpemotes:OnEmotePlay({"cellphone@", "cellphone_text_read_base", "Phone", AnimationOptions =
        {
            Prop = "prop_npc_phone_02",
            PropBone = 28422,
            PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
            EmoteLoop = true,
            EmoteMoving = true,
        }})
        -- PROGRESS START
        -- REPLACE THIS WITH WHATEVER PROGRESS MOD YOU USE
        local complete = false
        Citizen.Wait(Config.TimeToChange)
        complete = true
        -- PROGRESS END        
        if complete then
            TriggerServerEvent('matriarch_simcards:changeNumber', newNum)        
            exports.dpemotes:EmoteCancel()                                              
            tac.ShowNotification('Se cambio el numero a ~g~' .. newNum)                                        
            if Config.rvphoneEnabled then
                Citizen.Wait(2000) -- just give the update 2 seconds to hit DB before calling the rvphone update
                TriggerServerEvent('rvphone:allUpdate')
            end         
        end   
    else
        TriggerServerEvent('matriarch_simcards:changeNumber', newNum)   
        tac.ShowNotification('Se cambio el numero a ~g~' .. newNum)
        Citizen.Wait(2000)                             
        if Config.rvphoneEnabled then
            TriggerServerEvent('rvphone:allUpdate')
        end  
    end
	 
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end