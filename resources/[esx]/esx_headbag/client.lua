tac = nil
local HaveBagOnHead = false

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

function NajblizszyGracz() --This function send to server closestplayer

local closestPlayer, closestDistance = tac.Game.GetClosestPlayer()
local player = GetPlayerPed(-1)

if closestPlayer == -1 or closestDistance > 2.0 then 
    tac.ShowNotification('~r~No hay jugadores cerca')
else
  if not HaveBagOnHead then
    TriggerServerEvent('tac_worek:sendclosest', GetPlayerServerId(closestPlayer))
    tac.ShowNotification('~g~Le pusiste la bolsa ~w~' .. GetPlayerName(closestPlayer))
    TriggerServerEvent('tac_worek:closest')
  else
    tac.ShowNotification('~r~Este jugador ya tiene una bolsa en la cabeza')
  end
end

end

RegisterNetEvent('tac_worek:naloz') --This event open menu
AddEventHandler('tac_worek:naloz', function()
    OpenBagMenu()
end)

RegisterNetEvent('tac_worek:nalozNa') --This event put head bag on nearest player
AddEventHandler('tac_worek:nalozNa', function(gracz)
    local playerPed = GetPlayerPed(-1)
    Worek = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true) -- Create head bag object!
    AttachEntityToEntity(Worek, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openGeneral'})
    HaveBagOnHead = true
end)    

AddEventHandler('playerSpawned', function() --This event delete head bag when player is spawn again
DeleteEntity(Worek)
SetEntityAsNoLongerNeeded(Worek)
SendNUIMessage({type = 'closeAll'})
HaveBagOnHead = false
end)

RegisterNetEvent('tac_worek:zdejmijc') --This event delete head bag from player head
AddEventHandler('tac_worek:zdejmijc', function(gracz)
    tac.ShowNotification('~g~Alguien te saco la bolsa de la cabeza!')
    DeleteEntity(Worek)
    SetEntityAsNoLongerNeeded(Worek)
    SendNUIMessage({type = 'closeAll'})
    HaveBagOnHead = false
end)

function OpenBagMenu() --This function is menu function

    local elements = {
          {label = 'Poner bolsa en la cabeza', value = 'puton'},
          {label = 'Sacar bolsa', value = 'putoff'},
          
        }
  
    tac.UI.Menu.CloseAll()
  
    tac.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'headbagging',
      {
        title    = 'Menu Bolsa en la cabeza',
        align    = 'top-left',
        elements = elements
        },
  
            function(data2, menu2)
  
  
              local player, distance = tac.Game.GetClosestPlayer()
  
              if distance ~= -1 and distance <= 2.0 then
  
                if data2.current.value == 'puton' then
                    NajblizszyGracz()
                end
  
                if data2.current.value == 'putoff' then
                  TriggerServerEvent('tac_worek:zdejmij')
                end
              else
                tac.ShowNotification('~r~No hay jugadores cerca.')
              end
            end,
      function(data2, menu2)
        menu2.close()
      end
    )
  
  end

