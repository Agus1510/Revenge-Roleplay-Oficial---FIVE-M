----------------------------------------
--Dev by Thom512#0990 for Patoche#4702--
----------------------------------------

local Shop = {x = 487.64,  y = -3215.49,  z = 14.3}
local NPC = {
    {seller = true, model = "ig_g", x = 487.54,  y = -3214.32,  z = 14.31, h = 179.0},
	{seller = true, model = "ig_g", x = 2555.35,  y = 4663.14,  z = 33.07, h = 205.48},
    {seller = false, model = "csb_mweather", x = 485.37,  y = -3212.07,  z = 14,21, h = 212,87},
    {seller = false, model = "csb_mweather", x = 484.59,  y = -3214.45,  z = 13.73, h = 270.23},
}


tac = nil

Citizen.CreateThread(function()
    while tac == nil do
	TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
	Citizen.Wait(0)
    end
    for _, v in pairs(NPC) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1)
        end
        local npc = CreatePed(4, v.model, v.x, v.y, v.z, v.h,  false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        if v.seller then 
            RequestAnimDict("missfbi_s4mop")
            while not HasAnimDictLoaded("missfbi_s4mop") do
                Wait(1)
            end
            TaskPlayAnim(npc, "missfbi_s4mop" ,"guard_idle_a" ,8.0, 1, -1, 49, 0, false, false, false)
        else
            GiveWeaponToPed(npc, GetHashKey("WEAPON_ADVANCEDRIFLE"), 2800, true, true)
        end
    end
end)
    
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Weapons","~b~Heavy weapons", 5, 100,"shopui_title_gr_gunmod", "shopui_title_gr_gunmod",nil,255,255,255,230)
_menuPool:Add(mainMenu)

function AddShopsIllegalMenu()
    _menuPool:CloseAllMenus()
    mainMenu:Clear()
    for _,v in pairs(Config.Weapons) do
        local weapitem = NativeUI.CreateItem(tac.GetWeaponLabel(v.weapon), "")
        weapitem:RightLabel(v.price.."$", Colours.Red , Colours.Black)
        mainMenu:AddItem(weapitem)
    end
    mainMenu.OnItemSelect = function(_,item,Index)
        tac.TriggerServerCallback('weapon512:buyWeapon', function(bought)
            if bought then
                DisplayBoughtScaleform(Config.Weapons[Index].weapon, Config.Weapons[Index].price)
            else
                PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
            end
        end, Config.Weapons[Index].weapon, Config.Weapons[Index].price)
    end
    mainMenu:Visible(true)
end

function DisplayBoughtScaleform(weaponName, price)
	local scaleform = tac.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
	local sec = GetGameTimer() + 4000
	BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')
	PushScaleformMovieMethodParameterString("You bought ".. tac.GetWeaponLabel(weaponName).." for ".. price .. "$")
	PushScaleformMovieMethodParameterString(tac.GetWeaponLabel(weaponName))
	PushScaleformMovieMethodParameterInt(GetHashKey(weaponName))
	PushScaleformMovieMethodParameterString('')
	PushScaleformMovieMethodParameterInt(100)
	EndScaleformMovieMethod()
	PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)
	Citizen.CreateThread(function()
		while sec > GetGameTimer() do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
	end)
end

_menuPool:RefreshIndex()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false);
        isNearShop = false
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Shop.x, Shop.y, Shop.z)
        if dist <= 2.5 then
            isNearShop = true
            tac.ShowHelpNotification("~INPUT_TALK~ para hablr con el ~r~ vendedor")
            if IsControlJustPressed(1,51) then 
                AddShopsIllegalMenu()
            end
        end
        if isNearShop and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isNearShop and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			mainMenu:Visible(false)
		end
    end
end)





