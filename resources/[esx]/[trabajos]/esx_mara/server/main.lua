tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('tac_service:activateService', 'bloods', Config.MaxInService)
end

-- TriggerEvent('tac_phone:registerNumber', 'mafia', _U('alert_mafia'), true, true)
TriggerEvent('tac_society:registerSociety', 'bloods', 'Bloods', 'society_bloods', 'society_bloods', 'society_bloods', {type = 'public'})

RegisterServerEvent('tac_bloodsjob:giveWeapon')
AddEventHandler('tac_bloodsjob:giveWeapon', function(weapon, ammo)
  local xPlayer = tac.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('tac_bloodsjob:confiscatePlayerItem')
AddEventHandler('tac_bloodsjob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = tac.GetPlayerFromId(source)
  local targetXPlayer = tac.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    TriggerClientEvent('tac:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('tac:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('tac:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('tac:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('tac:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. tac.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('tac:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confweapon') .. tac.GetWeaponLabel(itemName))

  end

end)

RegisterServerEvent('tac_bloodsjob:handcuff')
AddEventHandler('tac_bloodsjob:handcuff', function(target)
  TriggerClientEvent('tac_bloodsjob:handcuff', target)
end)

RegisterServerEvent('tac_bloodsjob:drag')
AddEventHandler('tac_bloodsjob:drag', function(target)
  local _source = source
  TriggerClientEvent('tac_bloodsjob:drag', target, _source)
end)

RegisterServerEvent('tac_bloodsjob:putInVehicle')
AddEventHandler('tac_bloodsjob:putInVehicle', function(target)
  TriggerClientEvent('tac_bloodsjob:putInVehicle', target)
end)

RegisterServerEvent('tac_bloodsjob:OutVehicle')
AddEventHandler('tac_bloodsjob:OutVehicle', function(target)
    TriggerClientEvent('tac_bloodsjob:OutVehicle', target)
end)

RegisterServerEvent('tac_bloodsjob:getStockItem')
AddEventHandler('tac_bloodsjob:getStockItem', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_bloods', function(inventory)

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

RegisterServerEvent('tac_bloodsjob:putStockItems')
AddEventHandler('tac_bloodsjob:putStockItems', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_bloods', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('tac:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('tac:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

tac.RegisterServerCallback('tac_bloodsjob:getOtherPlayerData', function(source, cb, target)

  if Config.EnabletacIdentity then

    local xPlayer = tac.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    TriggerEvent('tac_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('tac_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = tac.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('tac_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('tac_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

tac.RegisterServerCallback('tac_bloodsjob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_mafia WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

tac.RegisterServerCallback('tac_bloodsjob:getVehicleInfos', function(source, cb, plate)

  if Config.EnabletacIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

tac.RegisterServerCallback('tac_bloodsjob:getArmoryWeapons', function(source, cb)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_bloods', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

tac.RegisterServerCallback('tac_bloodsjob:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = tac.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_bloods', function(store)

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

tac.RegisterServerCallback('tac_bloodsjob:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = tac.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_bloods', function(store)

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


tac.RegisterServerCallback('tac_bloodsjob:buy', function(source, cb, amount)

  TriggerEvent('tac_addonaccount:getSharedAccount', 'society_bloods', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

tac.RegisterServerCallback('tac_bloodsjob:getStockItems', function(source, cb)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_bloods', function(inventory)
    cb(inventory.items)
  end)

end)

tac.RegisterServerCallback('tac_bloodsjob:getPlayerInventory', function(source, cb)

  local xPlayer = tac.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)
