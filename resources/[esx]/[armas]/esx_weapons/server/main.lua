tac               = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)


function IsInList(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

RegisterServerEvent('tac:onAddInventoryItem')
AddEventHandler('tac:onAddInventoryItem', function(source, item, count)
  local _source = source
  local _item = item.name
  if IsInList(Config.WeaponList, _item) and item.count >= 1 then
    TriggerClientEvent('tac_weapons:addWeapon', _source, _item)
  end
end)

RegisterServerEvent('tac:onRemoveInventoryItem')
AddEventHandler('tac:onRemoveInventoryItem', function(source, item, count)
  local _source = source
  local _item = item.name
  if IsInList(Config.WeaponList, _item) and item.count < 1 then
    TriggerClientEvent('tac_weapons:removeWeapon', _source, _item)
  end
  if IsInList(Config.ComponentList, _item) and item.count < 1 then
    TriggerClientEvent('tac_weapons:removeComponent', _source, _item)
  end
end)

RegisterNetEvent('tac_weapons:loadWeapons')
AddEventHandler('tac_weapons:loadWeapons', function()
  local _source = source
  local xPlayer = tac.GetPlayerFromId(_source)
  for i=1, #xPlayer.inventory, 1 do
    local weaponName  = xPlayer.inventory[i].name
    local weaponCount = xPlayer.inventory[i].count
    if IsInList(Config.WeaponList, weaponName) and weaponCount > 0 then
      TriggerClientEvent('tac_weapons:addWeapon', _source, weaponName)
    end
  end
end)


------------------------------
------ COMPONENT ITEMS -------
------------------------------

-- PISTOL SUPPRESSOR
tac.RegisterUsableItem('COMPONENT_AT_PI_SUPP', function(source)
  local component = 'COMPONENT_AT_PI_SUPP'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- RIFLE SUPPRESSOR
tac.RegisterUsableItem('COMPONENT_AT_AR_SUPP_02', function(source)
  local component = 'COMPONENT_AT_AR_SUPP_02'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- PISTOL FLASHLIGHT
tac.RegisterUsableItem('COMPONENT_AT_PI_FLSH', function(source)
  local component = 'COMPONENT_AT_PI_FLSH'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- RIFLE FLASHLIGHT
tac.RegisterUsableItem('COMPONENT_AT_AR_FLSH', function(source)
  local component = 'COMPONENT_AT_AR_FLSH'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- RIFLE GRIP
tac.RegisterUsableItem('COMPONENT_AT_AR_AFGRIP', function(source)
  local component = 'COMPONENT_AT_AR_AFGRIP'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- PISTOL CLIP
tac.RegisterUsableItem('COMPONENT_AT_PI_CLIP_02', function(source)
  local component = 'COMPONENT_AT_PI_CLIP_02'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- RIFLE CLIP
tac.RegisterUsableItem('COMPONENT_AT_AR_CLIP_02', function(source)
  local component = 'COMPONENT_AT_AR_CLIP_02'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- RIFLE EXTENDED CLIP
tac.RegisterUsableItem('COMPONENT_AT_AR_CLIP_03', function(source)
  local component = 'COMPONENT_AT_AR_CLIP_03'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- RIFLE SCOPE
tac.RegisterUsableItem('COMPONENT_AT_SCOPE_MACRO', function(source)
  local component = 'COMPONENT_AT_SCOPE_MACRO'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- FINISH LUXE
tac.RegisterUsableItem('COMPONENT_VARMOD_LUXE', function(source)
  local component = 'COMPONENT_VARMOD_LUXE'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
-- FINISH LOWRIDER
tac.RegisterUsableItem('COMPONENT_VARMOD_LOWRIDER', function(source)
  local component = 'COMPONENT_VARMOD_LOWRIDER'
  TriggerClientEvent('tac_weapons:components', source, component)
end)

-- REVOLVER
tac.RegisterUsableItem('COMPONENT_REVOLVER_VARMOD_BOSS', function(source)
  local component = 'COMPONENT_REVOLVER_VARMOD_BOSS'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_REVOLVER_VARMOD_GOON', function(source)
  local component = 'COMPONENT_REVOLVER_VARMOD_GOON'
  TriggerClientEvent('tac_weapons:components', source, component)
end)

-- PISTOL MK2
tac.RegisterUsableItem('COMPONENT_AT_PI_COMP', function(source)
  local component = 'COMPONENT_AT_PI_COMP'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_AT_PI_RAIL', function(source)
  local component = 'COMPONENT_AT_PI_RAIL'
  TriggerClientEvent('tac_weapons:components', source, component)
end)

-- SMG MK2
tac.RegisterUsableItem('COMPONENT_AT_SIGHTS_SMG', function(source)
  local component = 'COMPONENT_AT_SIGHTS_SMG'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_AT_MUZZLE_03', function(source)
  local component = 'COMPONENT_AT_MUZZLE_03'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_AT_SB_BARREL_02', function(source)
  local component = 'COMPONENT_AT_SB_BARREL_02'
  TriggerClientEvent('tac_weapons:components', source, component)
end)

-- SWITCHBLADE
tac.RegisterUsableItem('COMPONENT_SWITCHBLADE_VARMOD_VAR1', function(source)
  local component = 'COMPONENT_SWITCHBLADE_VARMOD_VAR1'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_SWITCHBLADE_VARMOD_VAR2', function(source)
  local component = 'COMPONENT_SWITCHBLADE_VARMOD_VAR2'
  TriggerClientEvent('tac_weapons:components', source, component)
end)

-- KNUCKLE
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_PIMP', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_PIMP'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_BALLAS', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_BALLAS'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_DOLLAR', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_DOLLAR'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_DIAMOND', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_DIAMOND'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_HATE', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_HATE'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_LOVE', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_LOVE'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_PLAYER', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_PLAYER'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_KING', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_KING'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_KNUCKLE_VARMOD_VAGOS', function(source)
  local component = 'COMPONENT_KNUCKLE_VARMOD_VAGOS'
  TriggerClientEvent('tac_weapons:components', source, component)
end)

------------------------------
------------------------------

------------------------------
---- COMPONENT CAMO ITEMS ----
------------------------------
tac.RegisterUsableItem('COMPONENT_MK2_CAMO', function(source)
  local component = 'COMPONENT_MK2_CAMO'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_01', function(source)
  local component = 'COMPONENT_MK2_CAMO_01'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_02', function(source)
  local component = 'COMPONENT_MK2_CAMO_02'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_03', function(source)
  local component = 'COMPONENT_MK2_CAMO_03'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_04', function(source)
  local component = 'COMPONENT_MK2_CAMO_04'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_05', function(source)
  local component = 'COMPONENT_MK2_CAMO_05'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_06', function(source)
  local component = 'COMPONENT_MK2_CAMO_06'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_07', function(source)
  local component = 'COMPONENT_MK2_CAMO_07'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_08', function(source)
  local component = 'COMPONENT_MK2_CAMO_08'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_09', function(source)
  local component = 'COMPONENT_MK2_CAMO_09'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_10', function(source)
  local component = 'COMPONENT_MK2_CAMO_10'
  TriggerClientEvent('tac_weapons:components', source, component)
end)
tac.RegisterUsableItem('COMPONENT_MK2_CAMO_IND_01', function(source)
  local component = 'COMPONENT_MK2_CAMO_IND_01'
  TriggerClientEvent('tac_weapons:components', source, component)
end)

------------------------------
------------------------------

------------------------------
---- COMPONENT TINT ITEMS ----
------------------------------

tac.RegisterUsableItem('COMPONENT_TINT_01', function(source)
  local tintComponent = 1
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_02', function(source)
  local tintComponent = 2
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_03', function(source)
  local tintComponent = 3
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_04', function(source)
  local tintComponent = 4
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_05', function(source)
  local tintComponent = 5
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_06', function(source)
  local tintComponent = 6
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_07', function(source)
  local tintComponent = 7
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_08', function(source)
  local tintComponent = 8
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_09', function(source)
  local tintComponent = 9
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_10', function(source)
  local tintComponent = 10
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_11', function(source)
  local tintComponent = 11
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_12', function(source)
  local tintComponent = 12
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_13', function(source)
  local tintComponent = 13
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_14', function(source)
  local tintComponent = 14
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_15', function(source)
  local tintComponent = 15
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_16', function(source)
  local tintComponent = 16
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_17', function(source)
  local tintComponent = 17
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_18', function(source)
  local tintComponent = 18
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_19', function(source)
  local tintComponent = 19
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_20', function(source)
  local tintComponent = 20
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_21', function(source)
  local tintComponent = 21
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_22', function(source)
  local tintComponent = 22
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_23', function(source)
  local tintComponent = 23
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_24', function(source)
  local tintComponent = 24
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_25', function(source)
  local tintComponent = 25
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_26', function(source)
  local tintComponent = 26
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_27', function(source)
  local tintComponent = 27
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_28', function(source)
  local tintComponent = 28
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_29', function(source)
  local tintComponent = 29
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_30', function(source)
  local tintComponent = 30
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)
tac.RegisterUsableItem('COMPONENT_TINT_31', function(source)
  local tintComponent = 31
  TriggerClientEvent('tac_weapons:compTints', source, tintComponent)
end)

------------------------------
------------------------------

------------------------------
--------- TINT ITEMS ---------
------------------------------

tac.RegisterUsableItem('TINT_01', function(source)
  local tint = 1
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_02', function(source)
  local tint = 2
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_03', function(source)
  local tint = 3
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_04', function(source)
  local tint = 4
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_05', function(source)
  local tint = 5
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_06', function(source)
  local tint = 6
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_07', function(source)
  local tint = 7
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_01', function(source)
  local tint = 1
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_02', function(source)
  local tint = 2
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_03', function(source)
  local tint = 3
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_04', function(source)
  local tint = 4
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_05', function(source)
  local tint = 5
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_06', function(source)
  local tint = 6
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_07', function(source)
  local tint = 7
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_08', function(source)
  local tint = 8
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_09', function(source)
  local tint = 9
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_10', function(source)
  local tint = 10
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_11', function(source)
  local tint = 11
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_12', function(source)
  local tint = 12
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_13', function(source)
  local tint = 13
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_14', function(source)
  local tint = 14
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_15', function(source)
  local tint = 15
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_16', function(source)
  local tint = 16
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_17', function(source)
  local tint = 17
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_18', function(source)
  local tint = 18
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_19', function(source)
  local tint = 19
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_20', function(source)
  local tint = 20
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_21', function(source)
  local tint = 21
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_22', function(source)
  local tint = 22
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_23', function(source)
  local tint = 23
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_24', function(source)
  local tint = 24
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_25', function(source)
  local tint = 25
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_26', function(source)
  local tint = 26
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_27', function(source)
  local tint = 27
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_28', function(source)
  local tint = 28
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_29', function(source)
  local tint = 29
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_30', function(source)
  local tint = 30
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)
tac.RegisterUsableItem('TINT_MK2_31', function(source)
  local tint = 31
  TriggerClientEvent('tac_weapons:tints', source, tint)
end)

------------------------------
------------------------------