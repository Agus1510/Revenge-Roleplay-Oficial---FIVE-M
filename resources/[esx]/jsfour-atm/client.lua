-- *******
-- Copyright (C) JSFOUR - All Rights Reserved
-- You are not allowed to sell this script or re-upload it
-- Visit my page at https://github.com/jonassvensson4
-- Written by Jonas Svensson, July 2018
-- *******

local tac	 = nil
local open = false
local type = 'fleeca'

-- tac
Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

-- Notification
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Enter / Exit zones
Citizen.CreateThread(function ()
  SetNuiFocus(false, false)
	time = 500
	x = 1
  while true do
    Citizen.Wait(time)
		inMarker = false
		inBankMarker = false

    for i=1, #Config.ATMS, 1 do
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) < 2  then
				x = i
				time = 0
				if ( Config.ATMS[i].b == nil ) then
					inMarker = true
					hintToDisplay('Presiona ~INPUT_PICKUP~ para usar el cajero')
				else
					inBankMarker = true
					type = Config.ATMS[i].t
					hintToDisplay('Presiona ~INPUT_PICKUP~ para ser servido')
				end
			elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[x].x, Config.ATMS[x].y, Config.ATMS[x].z, true) > 4 then
				time = 500
			end
    end

	end
end)

-- Create account when the script is started
Citizen.CreateThread(function ()
	Wait(10000)
	TriggerServerEvent('jsfour-atm:createAccount')
end)

-- Key event
Citizen.CreateThread(function ()
  while true do
    Wait(0)
		if IsControlJustReleased(0, 38) and inMarker then
			--tac.TriggerServerCallback('jsfour-atm:item', function( hasItem )
			--	if hasItem then
					tac.TriggerServerCallback('jsfour-atm:getMoney', function( data )
						SetNuiFocus(true, true)
						open = true
						SendNUIMessage({
						  action = "open",
							bank = data.bank,
							cash = data.cash
						})
					end)
			--	else
				--	tac.ShowNotification('You have no credit card. Go to the bank')
				--end
			--end)
		end
		if IsControlJustReleased(0, 38) and inBankMarker then
			tac.TriggerServerCallback('jsfour-atm:getMoney', function( data )
				tac.TriggerServerCallback('jsfour-atm:getUser', function( dataUser )
					SetNuiFocus(true, true)
					open = true
					SendNUIMessage({
						action = "openBank",
						bank = data.bank,
						cash = data.cash,
						type = type,
						firstname = dataUser[1].firstname,
						lastname = dataUser[1].lastname,
						account = dataUser[1].account
					})
				end)
			end)
		end
		if open then
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 24, true) -- Attack
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
	end
end)

-- Insert money
RegisterNUICallback('insert', function(data, cb)
	cb('ok')
	TriggerServerEvent('jsfour-atm:insert', data.money)
end)

-- Take money
RegisterNUICallback('take', function(data, cb)
	cb('ok')
	TriggerServerEvent('jsfour-atm:take', data.money)
end)

-- Transfer money
RegisterNUICallback('transfer', function(data, cb)
	cb('ok')
	TriggerServerEvent('jsfour-atm:transfer', data.money, data.account)
end)

-- Close the NUI/HTML window
RegisterNUICallback('escape', function(data, cb)
	SetNuiFocus(false, false)
	open = false
	cb('ok')
end)

-- Handles the error message
RegisterNUICallback('error', function(data, cb)
	SetNuiFocus(false, false)
	open = false
	cb('ok')
	tac.ShowNotification('La maquina esta trabajando , porfavor espera')
end)
