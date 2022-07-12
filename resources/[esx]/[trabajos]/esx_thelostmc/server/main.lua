tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('tac_service:activateService', 'thelostmc', Config.MaxInService)
end

TriggerEvent('tac_society:registerSociety', 'thelostmc', 'TheLostMC', 'society_thelostmc', 'society_thelostmc', 'society_thelostmc', {type = 'whitelisted'})

RegisterServerEvent('tac_thelostmcjob:giveWeapon')
AddEventHandler('tac_thelostmcjob:giveWeapon', function(weapon, ammo)
  local xPlayer = tac.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('tac_thelostmcjob:confiscatePlayerItem')
AddEventHandler('tac_thelostmcjob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = tac.GetPlayerFromId(source)
  local targetXPlayer = tac.GetPlayerFromId(target)

    if itemType == 'item_standard' then

     local label = sourceXPlayer.getInventoryItem(itemName).label

     targetXPlayer.removeInventoryItem(itemName, amount)
     sourceXPlayer.addInventoryItem(itemName, amount)

	    sourceXPlayer.showNotification(_U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    	targetXPlayer.showNotification( '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

     end

     if itemType == 'item_account' then

      targetXPlayer.removeAccountMoney(itemName, amount)
      sourceXPlayer.addAccountMoney(itemName, amount)

    	sourceXPlayer.showNotification(_U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    	targetXPlayer.showNotification('~b~' .. targetXPlayer.name .. _U('confdm') .. amount)
	
     end

     if itemType == 'item_weapon' then

      targetXPlayer.removeWeapon(itemName)
      sourceXPlayer.addWeapon(itemName, amount)

	    sourceXPlayer.showNotification(_U('you_have_confweapon') .. tac.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
	    targetXPlayer.showNotification('~b~' .. targetXPlayer.name .. _U('confweapon') .. tac.GetWeaponLabel(itemName))
	
     end

end)

RegisterServerEvent('tac_thelostmcjob:handcuff')
AddEventHandler('tac_thelostmcjob:handcuff', function(target)
	TriggerClientEvent('tac_thelostmcjob:handcuff', target)
end)

RegisterServerEvent('tac_thelostmcjob:drag')
AddEventHandler('tac_thelostmcjob:drag', function(target)
	local _source = source
	TriggerClientEvent('tac_thelostmcjob:drag', target, _source)
end)

RegisterServerEvent('tac_thelostmcjob:putInVehicle')
AddEventHandler('tac_thelostmcjob:putInVehicle', function(target)
	TriggerClientEvent('tac_thelostmcjob:putInVehicle', target)
end)

RegisterServerEvent('tac_thelostmcjob:OutVehicle')
AddEventHandler('tac_thelostmcjob:OutVehicle', function(target)
	TriggerClientEvent('tac_thelostmcjob:OutVehicle', target)
end)

RegisterServerEvent('tac_thelostmcjob:getStockItem')
AddEventHandler('tac_thelostmcjob:getStockItem', function(itemName, count)

	local xPlayer = tac.GetPlayerFromId(source)

	  TriggerEvent('tac_addoninventory:getSharedInventory', 'society_thelostmc', function(inventory)

		  local item = inventory.getItem(itemName)

	  	if item.count >= count then
		  	inventory.removeItem(itemName, count)
		  	xPlayer.addInventoryItem(itemName, count)
	  	else
		  	xPlayer.showNotification(_U('quantity_invalid'))
		  end

	  	xPlayer.showNotification(_U('have_withdrawn') .. count .. ' ' .. item.label)

  	end)

end)

RegisterServerEvent('tac_thelostmcjob:putStockItems')
AddEventHandler('tac_thelostmcjob:putStockItems', function(itemName, count)

	local xPlayer = tac.GetPlayerFromId(source)

  	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_thelostmc', function(inventory)

	  	local item = inventory.getItem(itemName)

		  if item.count >= 0 then
		  	xPlayer.removeInventoryItem(itemName, count)
		  	inventory.addItem(itemName, count)
		  else
		  	xPlayer.showNotification(_U('quantity_invalid'))
	  	end

		  xPlayer.showNotification(_U('added') .. count .. ' ' .. item.label)

  	end)

end)

tac.RegisterServerCallback('tac_thelostmcjob:getOtherPlayerData', function(source, cb, target)

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

tac.RegisterServerCallback('tac_thelostmcjob:getVehicleInfos', function(source, cb, plate)

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

tac.RegisterServerCallback('tac_thelostmcjob:getArmoryWeapons', function(source, cb)

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_thelostmc', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
		weapons = {}
		end

		cb(weapons)

	end)

end)

tac.RegisterServerCallback('tac_thelostmcjob:addArmoryWeapon', function(source, cb, weaponName)
	
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeWeapon(weaponName)

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_thelostmc', function(store)
		
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

tac.RegisterServerCallback('tac_thelostmcjob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 1000)

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_thelostmc', function(store)

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


tac.RegisterServerCallback('tac_thelostmcjob:buy', function(source, cb, amount)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_thelostmc', function(account)

		if account.money >= amount then
		account.removeMoney(amount)
		cb(true)
		else
		cb(false)
		end
		
	end)
	
end)

tac.RegisterServerCallback('tac_thelostmcjob:getStockItems', function(source, cb)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_thelostmc', function(inventory)
		cb(inventory.items)
	end)
	
end)

tac.RegisterServerCallback('tac_thelostmcjob:getPlayerInventory', function(source, cb)

	local xPlayer = tac.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({
		items = items
	})

end)
