tac                = nil
PlayersHarvesting  = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting    = {}
PlayersCrafting2   = {}
PlayersCrafting3   = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('tac_service:activateService', 'mecano', Config.MaxInService)
end

TriggerEvent('tac_rvphone:registerNumber', 'mecano', _U('mechanic_customer'), true, true)
TriggerEvent('tac_society:registerSociety', 'mecano', 'Mecano', 'society_mecano', 'society_mecano', 'society_mecano', {type = 'private'})

-------------- Récupération bouteille de gaz -------------
---- Sqlut je teste ------
local function Harvest(source)

  SetTimeout(4000, function()

    if PlayersHarvesting[source] == true then

      local xPlayer  = tac.GetPlayerFromId(source)
      local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

      if GazBottleQuantity >= 5 then
        TriggerClientEvent('tac:showNotification', source, _U('you_do_not_room'))
      else
                xPlayer.addInventoryItem('gazbottle', 1)

        Harvest(source)
      end
    end
  end)
end

RegisterServerEvent('tac_mecanojob:startHarvest')
AddEventHandler('tac_mecanojob:startHarvest', function()
  local _source = source
  PlayersHarvesting[_source] = true
  TriggerClientEvent('tac:showNotification', _source, _U('recovery_gas_can'))
  Harvest(source)
end)

RegisterServerEvent('tac_mecanojob:stopHarvest')
AddEventHandler('tac_mecanojob:stopHarvest', function()
  local _source = source
  PlayersHarvesting[_source] = false
end)
------------ Récupération Outils Réparation --------------
local function Harvest2(source)

  SetTimeout(4000, function()

    if PlayersHarvesting2[source] == true then

      local xPlayer  = tac.GetPlayerFromId(source)
      local FixToolQuantity  = xPlayer.getInventoryItem('fixtool').count
      if FixToolQuantity >= 5 then
        TriggerClientEvent('tac:showNotification', source, _U('you_do_not_room'))
      else
                xPlayer.addInventoryItem('fixtool', 1)

        Harvest2(source)
      end
    end
  end)
end

RegisterServerEvent('tac_mecanojob:startHarvest2')
AddEventHandler('tac_mecanojob:startHarvest2', function()
  local _source = source
  PlayersHarvesting2[_source] = true
  TriggerClientEvent('tac:showNotification', _source, _U('recovery_repair_tools'))
  Harvest2(_source)
end)

RegisterServerEvent('tac_mecanojob:stopHarvest2')
AddEventHandler('tac_mecanojob:stopHarvest2', function()
  local _source = source
  PlayersHarvesting2[_source] = false
end)
----------------- Récupération Outils Carosserie ----------------
local function Harvest3(source)

  SetTimeout(4000, function()

    if PlayersHarvesting3[source] == true then

      local xPlayer  = tac.GetPlayerFromId(source)
      local CaroToolQuantity  = xPlayer.getInventoryItem('carotool').count
            if CaroToolQuantity >= 5 then
        TriggerClientEvent('tac:showNotification', source, _U('you_do_not_room'))
      else
                xPlayer.addInventoryItem('carotool', 1)

        Harvest3(source)
      end
    end
  end)
end

RegisterServerEvent('tac_mecanojob:startHarvest3')
AddEventHandler('tac_mecanojob:startHarvest3', function()
  local _source = source
  PlayersHarvesting3[_source] = true
  TriggerClientEvent('tac:showNotification', _source, _U('recovery_body_tools'))
  Harvest3(_source)
end)

RegisterServerEvent('tac_mecanojob:stopHarvest3')
AddEventHandler('tac_mecanojob:stopHarvest3', function()
  local _source = source
  PlayersHarvesting3[_source] = false
end)
------------ Craft Chalumeau -------------------
local function Craft(source)

  SetTimeout(4000, function()

    if PlayersCrafting[source] == true then

      local xPlayer  = tac.GetPlayerFromId(source)
      local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

      if GazBottleQuantity <= 0 then
        TriggerClientEvent('tac:showNotification', source, _U('not_enough_gas_can'))
      else
                xPlayer.removeInventoryItem('gazbottle', 1)
                xPlayer.addInventoryItem('blowpipe', 1)

        Craft(source)
      end
    end
  end)
end

RegisterServerEvent('tac_mecanojob:startCraft')
AddEventHandler('tac_mecanojob:startCraft', function()
  local _source = source
  PlayersCrafting[_source] = true
  TriggerClientEvent('tac:showNotification', _source, _U('assembling_blowtorch'))
  Craft(_source)
end)

RegisterServerEvent('tac_mecanojob:stopCraft')
AddEventHandler('tac_mecanojob:stopCraft', function()
  local _source = source
  PlayersCrafting[_source] = false
end)
------------ Craft kit Réparation --------------
local function Craft2(source)

  SetTimeout(4000, function()

    if PlayersCrafting2[source] == true then

      local xPlayer  = tac.GetPlayerFromId(source)
      local FixToolQuantity  = xPlayer.getInventoryItem('fixtool').count
      if FixToolQuantity <= 0 then
        TriggerClientEvent('tac:showNotification', source, _U('not_enough_repair_tools'))
      else
                xPlayer.removeInventoryItem('fixtool', 1)
                xPlayer.addInventoryItem('fixkit', 1)

        Craft2(source)
      end
    end
  end)
end

RegisterServerEvent('tac_mecanojob:startCraft2')
AddEventHandler('tac_mecanojob:startCraft2', function()
  local _source = source
  PlayersCrafting2[_source] = true
  TriggerClientEvent('tac:showNotification', _source, _U('assembling_blowtorch'))
  Craft2(_source)
end)

RegisterServerEvent('tac_mecanojob:stopCraft2')
AddEventHandler('tac_mecanojob:stopCraft2', function()
  local _source = source
  PlayersCrafting2[_source] = false
end)
----------------- Craft kit Carosserie ----------------
local function Craft3(source)

  SetTimeout(4000, function()

    if PlayersCrafting3[source] == true then

      local xPlayer  = tac.GetPlayerFromId(source)
      local CaroToolQuantity  = xPlayer.getInventoryItem('carotool').count
            if CaroToolQuantity <= 0 then
        TriggerClientEvent('tac:showNotification', source, _U('not_enough_body_tools'))
      else
                xPlayer.removeInventoryItem('carotool', 1)
                xPlayer.addInventoryItem('carokit', 1)

        Craft3(source)
      end
    end
  end)
end

RegisterServerEvent('tac_mecanojob:startCraft3')
AddEventHandler('tac_mecanojob:startCraft3', function()
  local _source = source
  PlayersCrafting3[_source] = true
  TriggerClientEvent('tac:showNotification', _source, _U('assembling_body_kit'))
  Craft3(_source)
end)

RegisterServerEvent('tac_mecanojob:stopCraft3')
AddEventHandler('tac_mecanojob:stopCraft3', function()
  local _source = source
  PlayersCrafting3[_source] = false
end)

---------------------------- NPC Job Earnings ------------------------------------------------------

RegisterServerEvent('tac_mecanojob:onNPCJobMissionCompleted')
AddEventHandler('tac_mecanojob:onNPCJobMissionCompleted', function()

  local _source = source
  local xPlayer = tac.GetPlayerFromId(_source)
  local total   = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);

  if xPlayer.job.grade >= 3 then
    total = total * 2
  end

  TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mechanic', function(account)
    account.addMoney(total)
  end)

  TriggerClientEvent("tac:showNotification", _source, _U('your_comp_earned').. total)

end)


---------------------------- register usable item --------------------------------------------------
tac.RegisterUsableItem('blowpipe', function(source)

  local _source = source
  local xPlayer  = tac.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('blowpipe', 1)

  TriggerClientEvent('tac_mecanojob:onHijack', _source)
    TriggerClientEvent('tac:showNotification', _source, _U('you_used_blowtorch'))

end)

tac.RegisterUsableItem('fixkit', function(source)

  local _source = source
  local xPlayer  = tac.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('fixkit', 1)

  TriggerClientEvent('tac_mecanojob:onFixkit', _source)
    TriggerClientEvent('tac:showNotification', _source, _U('you_used_repair_kit'))

end)

tac.RegisterUsableItem('carokit', function(source)

  local _source = source
  local xPlayer  = tac.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('carokit', 1)

  TriggerClientEvent('tac_mecanojob:onCarokit', _source)
    TriggerClientEvent('tac:showNotification', _source, _U('you_used_body_kit'))

end)

----------------------------------
---- Ajout Gestion Stock Boss ----
----------------------------------

RegisterServerEvent('tac_mecanojob:getStockItem')
AddEventHandler('tac_mecanojob:getStockItem', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_mecano', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('tac:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('tac:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

tac.RegisterServerCallback('tac_mecanojob:getStockItems', function(source, cb)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
    cb(inventory.items)
  end)

end)

-------------
-- AJOUT 2 --
-------------

RegisterServerEvent('tac_mecanojob:putStockItems')
AddEventHandler('tac_mecanojob:putStockItems', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_mecano', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('tac:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('tac:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)

--tac.RegisterServerCallback('tac_mecanojob:putStockItems', function(source, cb)

--  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_policestock', function(inventory)
--    cb(inventory.items)
--  end)

--end)

tac.RegisterServerCallback('tac_mecanojob:getPlayerInventory', function(source, cb)

  local xPlayer    = tac.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
