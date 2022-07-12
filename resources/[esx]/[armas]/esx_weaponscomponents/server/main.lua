tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

------------------------------------
---- Utiliser équipement Pistol ----
------------------------------------

tac.RegisterUsableItem('silence_pistol', function(source)
    TriggerClientEvent('tac_component:EquipSilencePistol', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Silencieux (Pistolet)')

end)

--------------------------------------
---- Utiliser équipement Pistol50 ----
--------------------------------------

tac.RegisterUsableItem('silence_pistol50', function(source)
    TriggerClientEvent('tac_component:EquipSilencePistol50', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Silencieux (Pistolet50)')

end)

-----------------------------------------
---- Utiliser équipement SniperRifle ----
-----------------------------------------

tac.RegisterUsableItem('silence_sniperrifle', function(source)
    TriggerClientEvent('tac_component:EquipSilenceSniperRifle', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Silencieux (Sniper)')

end)

tac.RegisterUsableItem('advancedscoped_sniperrifle', function(source)
    TriggerClientEvent('tac_component:EquipAdvancedScopedSniperRifle', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Lunette (Sniper)')

end)

---------------------------------------------------------
-------------- Utiliser Equipement CARBINERIFLE----------
---------------------------------------------------------

tac.RegisterUsableItem('scope_smg', function(source)
    TriggerClientEvent('tac_component:EquipScopeSMG', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~lunette sur votre SMG')

end)

tac.RegisterUsableItem('lowrider_smg', function(source)
    TriggerClientEvent('tac_component:EquipLowRiderSMG', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~LowRider sur votre SMG')

end)

tac.RegisterUsableItem('supp_smg', function(source)
    TriggerClientEvent('tac_component:EquipSuppSMG', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Silencieux sur votre SMG')

end)

tac.RegisterUsableItem('grip_smg', function(source)
    TriggerClientEvent('tac_component:EquipGripSMG', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Poignée sur votre SMG')
end)

tac.RegisterUsableItem('flashlight_assaultsmg', function(source)
    TriggerClientEvent('tac_component:EquipFlashlightSMG', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~lampe sur votre SMG')

end)

---------------------------------------------------------
-------------- Utiliser Equipement COMBATPISTOL----------
---------------------------------------------------------

tac.RegisterUsableItem('supp_cp', function(source)
    TriggerClientEvent('tac_component:EquipSuppCP', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Silencieux sur votre Glock17')
end)

tac.RegisterUsableItem('flash_cp', function(source)
    TriggerClientEvent('tac_component:EquipFlashCP', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Lampe sur votre Glock17')
end)

tac.RegisterUsableItem('lowrider_cp', function(source)
    TriggerClientEvent('tac_component:EquipLowRiderCP', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~LowRider sur votre Glock17')
end)

--------------------------------------------------------
------------ Utiliser Equipement GUSENBERG -------------
--------------------------------------------------------

tac.RegisterUsableItem('clip_gus', function(source)
    TriggerClientEvent('tac_component:EquipClipGus', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Chargeur amélioré sur la GUSENBERG')
end)

-------------------------------------------------------------
------------ Utiliser Equipement SPECIALCARBINE -------------
-------------------------------------------------------------
tac.RegisterUsableItem('clip_sc', function(source)
    TriggerClientEvent('tac_component:EquipClipSC', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Chargeur amélioré sur le SCAR')
end)

tac.RegisterUsableItem('grip_sc', function(source)
    TriggerClientEvent('tac_component:EquipGripSC', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Poignée sur le SCAR')
end)

tac.RegisterUsableItem('supp_sc', function(source)
    TriggerClientEvent('tac_component:EquipSuppSC', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Silencieux sur le SCAR')
end)

-------------------------------------------------------------
------------ Utiliser Equipement HEAVYPISTOL-----------------
-------------------------------------------------------------
tac.RegisterUsableItem('clip_heavypistol', function(source)
    TriggerClientEvent('tac_component:EquipClipHeavyPistol', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Chargeur amélioré sur le Pistolet')
end)

tac.RegisterUsableItem('supp_heavypistol', function(source)
    TriggerClientEvent('tac_component:EquipSuppHeavyPistol', source)
    TriggerClientEvent('tac:showNotification', source, 'Vous avez équipé ~g~1x ~b~Silencieux sur le Pistolet Lourd')
end)
