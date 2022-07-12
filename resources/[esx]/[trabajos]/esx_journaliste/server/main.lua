tac                = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('tac_service:activateService', 'journaliste', Config.MaxInService)
end

TriggerEvent('tac_phone:registerNumber', 'journaliste', _U('journaliste_customer'), true, true)
TriggerEvent('tac_society:registerSociety', 'journaliste', 'journaliste', 'society_journaliste', 'society_journaliste', 'society_journaliste', {type = 'private'})

RegisterServerEvent('tac_journaliste:getStockItem')
AddEventHandler('tac_journaliste:getStockItem', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_journaliste', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('tac:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('tac:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

tac.RegisterServerCallback('tac_journaliste:getStockItems', function(source, cb)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_journaliste', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('tac_journaliste:putStockItems')
AddEventHandler('tac_journaliste:putStockItems', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_journaliste', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('tac:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('tac:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


tac.RegisterServerCallback('tac_journaliste:getPlayerInventory', function(source, cb)

  local xPlayer    = tac.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

tac.RegisterServerCallback('tac_journaliste:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_journaliste WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

tac.RegisterServerCallback('tac_journaliste:getVaultWeapons', function(source, cb)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_journaliste', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

tac.RegisterServerCallback('tac_journaliste:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = tac.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_journaliste', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

tac.RegisterServerCallback('tac_journaliste:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = tac.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_journaliste', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)