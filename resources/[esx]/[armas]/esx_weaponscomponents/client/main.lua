local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PID           		  = 0
local GUI           		  = {}
tac 			    		  = nil
GUI.Time            		  = 0
local PlayerData 			  = {}
local GUI 					  = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(1)
	end
end)

----------------------------
---- Equip Silence Pistol---
----------------------------
RegisterNetEvent('tac_component:EquipSilencePistol')
AddEventHandler('tac_component:EquipSilencePistol', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("weapon_pistol"), GetHashKey("component_at_pi_supp_02"))
end)

----------------------------
-- Equip Silence Pistol50 --
----------------------------
RegisterNetEvent('tac_component:EquipSilencePistol50')
AddEventHandler('tac_component:EquipSilencePistol50', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))
end)


-------------------------------
------ EQUIP SNIPER RIFLE------
-------------------------------
RegisterNetEvent('tac_component:EquipSilenceSniperRifle')
AddEventHandler('tac_component:EquipSilenceSniperRifle', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SNIPERRIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))
end)

RegisterNetEvent('tac_component:EquipAdvancedScopedSniperRifle')
AddEventHandler('tac_component:EquipAdvancedScopedSniperRifle', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SNIPERRIFLE"), GetHashKey("COMPONENT_AT_SCOPE_MAX"))
end)

----------------------------------------------
------------ EQUIP CARBINE RIFLE -------------
----------------------------------------------

RegisterNetEvent('tac_component:EquipFlashlightSMG')
AddEventHandler('tac_component:EquipFlashlightSMG', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))
end)

RegisterNetEvent('tac_component:EquipScopeSMG')
AddEventHandler('tac_component:EquipScopeSMG', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_SCOPE_MACRO"))
end)

RegisterNetEvent('tac_component:EquipLowRiderSMG')
AddEventHandler('tac_component:EquipLowRiderSMG', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER"))
end)

RegisterNetEvent('tac_component:EquipSuppSMG')
AddEventHandler('tac_component:EquipSuppSMG', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))
end)

RegisterNetEvent('tac_component:EquipGripSMG')
AddEventHandler('tac_component:EquipGripSMG', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))
end)


---------------------------------------------
------------ Equip COMBATPISTOL -------------
---------------------------------------------
RegisterNetEvent('tac_component:EquipSuppCP')
AddEventHandler('tac_component:EquipSuppCP', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))
end)

RegisterNetEvent('tac_component:EquipFlashCP')
AddEventHandler('tac_component:EquipFlashCP', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
end)

RegisterNetEvent('tac_component:EquipLowRiderCP')
AddEventHandler('tac_component:EquipLowRiderCP', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER"))
end)

------------------------------------------
------------ Equip GUSENBERG -------------
------------------------------------------
RegisterNetEvent('tac_component:EquipClipGus')
AddEventHandler('tac_component:EquipClipGus', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_GUSENBERG"), GetHashKey("COMPONENT_GUSENBERG_CLIP_02"))
end)


------------------------------------------------
------------ Equip SPECIALCARBINE -------------
------------------------------------------------
RegisterNetEvent('tac_component:EquipClipSC')
AddEventHandler('tac_component:EquipClipSC', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_03"))
end)

RegisterNetEvent('tac_component:EquipGripSC')
AddEventHandler('tac_component:EquipGripSC', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))
end)

RegisterNetEvent('tac_component:EquipSuppSC')
AddEventHandler('tac_component:EquipSuppSC', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))
end)

----------------------------
---- Equip HEAVYPISTOL -----
----------------------------
RegisterNetEvent('tac_component:EquipClipHeavyPistol')
AddEventHandler('tac_component:EquipClipHeavyPistol', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_HEAVYPISTOL_CLIP_02"))
end)

RegisterNetEvent('tac_component:EquipSuppHeavyPistol')
AddEventHandler('tac_component:EquipSuppHeavyPistol', function()
   GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))
end)

---------------------------------
--------- ikNox#6088 ------------
---------------------------------