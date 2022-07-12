tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('tac_service:activateService', 'mafia2', Config.MaxInService)
end

-- TriggerEvent('tac_phone:registerNumber', 'mafia', _U('alert_mafia'), true, true)
TriggerEvent('tac_society:registerSociety', 'mafia2', 'Mafia2', 'society_mafia2', 'society_mafia2', 'society_mafia2', {type = 'public'})

RegisterServerEvent('tac_mafiajob2:giveWeapon')
AddEventHandler('tac_mafiajob2:giveWeapon', function(weapon, ammo)
  local xPlayer = tac.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('tac_mafiajob2:confiscatePlayerItem')
AddEventHandler('tac_mafiajob2:confiscatePlayerItem', function(target, itemType, itemName, amount)

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

RegisterServerEvent('tac_mafiajob2:handcuff')
AddEventHandler('tac_mafiajob2:handcuff', function(target)
  TriggerClientEvent('tac_mafiajob2:handcuff', target)
end)

RegisterServerEvent('tac_mafiajob2:drag')
AddEventHandler('tac_mafiajob2:drag', function(target)
  local _source = source
  TriggerClientEvent('tac_mafiajob2:drag', target, _source)
end)

RegisterServerEvent('tac_mafiajob2:putInVehicle')
AddEventHandler('tac_mafiajob2:putInVehicle', function(target)
  TriggerClientEvent('tac_mafiajob2:putInVehicle', target)
end)

RegisterServerEvent('tac_mafiajob2:OutVehicle')
AddEventHandler('tac_mafiajob2:OutVehicle', function(target)
    TriggerClientEvent('tac_mafiajob2:OutVehicle', target)
end)

RegisterServerEvent('tac_mafiajob2:getStockItem')
AddEventHandler('tac_mafiajob2:getStockItem', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_mafia2', function(inventory)

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

RegisterServerEvent('tac_mafiajob2:putStockItems')
AddEventHandler('tac_mafiajob2:putStockItems', function(itemName, count)

  local xPlayer = tac.GetPlayerFromId(source)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_mafia2', function(inventory)

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

tac.RegisterServerCallback('tac_mafiajob2:getOtherPlayerData', function(source, cb, target)

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

tac.RegisterServerCallback('tac_mafiajob2:getFineList', function(source, cb, category)

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

tac.RegisterServerCallback('tac_mafiajob2:getVehicleInfos', function(source, cb, plate)

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

tac.RegisterServerCallback('tac_mafiajob2:getArmoryWeapons', function(source, cb)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_mafia2', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

tac.RegisterServerCallback('tac_mafiajob2:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = tac.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_mafia2', function(store)

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

tac.RegisterServerCallback('tac_mafiajob2:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = tac.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('tac_datastore:getSharedDataStore', 'society_mafia2', function(store)

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


tac.RegisterServerCallback('tac_mafiajob2:buy', function(source, cb, amount)

  TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mafia2', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

tac.RegisterServerCallback('tac_mafiajob2:getStockItems', function(source, cb)

  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_mafia2', function(inventory)
    cb(inventory.items)
  end)

end)

tac.RegisterServerCallback('tac_mafiajob2:getPlayerInventory', function(source, cb)

  local xPlayer = tac.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)
