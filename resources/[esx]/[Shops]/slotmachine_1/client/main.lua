local input = {["E"] = 38,["DOWN"] = 173,["TOP"] = 27,["NENTER"] =  201}
tac                           = nil
local PlayerData                = {}



Citizen.CreateThread(function()
  while tac == nil do
    TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
    Citizen.Wait(1)
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
SetNuiFocus(false, false)
end)


RegisterNetEvent('errormessage2')
AddEventHandler('errormessage2', function()
PlaySound(GetPlayerServerId(GetPlayerPed(-1)), "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
end)


RegisterNetEvent('spinit2')
AddEventHandler('spinit2', function()
	PlaySound(GetPlayerServerId(GetPlayerPed(-1)), "Apt_Style_Purchase", "DLC_APT_Apartment_SoundSet", 0, 0, 1)

	SendNUIMessage({
			canspin = true
		})
	Citizen.Wait(100)

		SendNUIMessage({
			canspin = false
		})

end)


RegisterNUICallback('close', function(data, cb)

	SetNuiFocus(false, false)
	SendNUIMessage({
		show = false
	})
	cb("ok")
	PlaySound(GetPlayerServerId(GetPlayerPed(-1)), "Apt_Style_Purchase", "DLC_APT_Apartment_SoundSet", 0, 0, 1)

end)




RegisterNUICallback('payforplayer', function(winnings, cb)
	PlaySound(GetPlayerServerId(GetPlayerPed(-1)), "ROBBERY_MONEY_TOTAL", "HUD_FRONTEND_CUSTOM_SOUNDSET", 0, 0, 1)
	TriggerServerEvent('payforplayer2',winnings)
end)


RegisterNUICallback('playerpays', function(bet, cb)
	TriggerServerEvent('playerpays2',bet)
end)

local moneymachine_slot = {
	{ ['x'] = 980.93, ['y'] = 46.12, ['z'] = 74.00 },
	{ ['x'] = 980.91, ['y'] = 51.8, ['z'] = 74.00 },
	{ ['x'] = 986.41, ['y'] = 48.2, ['z'] = 74.00 },
	{ ['x'] = 984.09, ['y'] = 54.43, ['z'] = 74.00 },
	{ ['x'] = 980.48, ['y'] = 55.1, ['z'] = 74.00 },
	{ ['x'] = 978.38, ['y'] = 53.45, ['z'] = 74.00 },
	{ ['x'] = 974.25, ['y'] = 55.61, ['z'] = 74.00 },
	{ ['x'] = 971.62, ['y'] = 56.04, ['z'] = 74.00 },
	{ ['x'] = 973.2, ['y'] = 51.48, ['z'] = 74.00 },

	--penthouse
	{ ['x'] = 944.73, ['y'] = 20.86, ['z'] = 116.16 },
	{ ['x'] = 941.25, ['y'] = 8.86, ['z'] = 116.16 },
	{ ['x'] = 943.2, ['y'] = 7.67, ['z'] = 116.16 },
	{ ['x'] = 942.07, ['y'] = 5.96, ['z'] = 116.16 },
	{ ['x'] = 940.18, ['y'] = 7.06, ['z'] = 116.16 },
}



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(moneymachine_slot) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 20.0)then
				DrawMarker(29, v.x, v.y, v.z + 0.2, 0, 0, 0, 0, 0, 0, 0.6001, 1.0001, 0.6, 0, 255, 5, 90, 1,0, 0,1)
				if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 1.0)then
						DisplayHelpText("Presione ~INPUT_CONTEXT~   ~y~para jugar tragamonedas")
					if IsControlJustPressed(1,input["E"]) then
						SendNUIMessage({
							show = true
						})
						SetNuiFocus(true,true)
						PlaySound(GetPlayerServerId(GetPlayerPed(-1)), "Apt_Style_Purchase", "DLC_APT_Apartment_SoundSet", 0, 0, 1)
					end
				end
			end
		end
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

