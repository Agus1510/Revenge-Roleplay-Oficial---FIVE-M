tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('tac_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('tac_rvphone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('tac_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('tac_policejob:confiscatePlayerItem')
AddEventHandler('tac_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = tac.GetPlayerFromId(_source)
	local targetXPlayer = tac.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'police' then
		print(('tac_policejob: %s attempted to confiscate!'):format(xPlayer.identifier))
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('tac:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('tac:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('tac:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('tac:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('tac:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('tac:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('tac:showNotification', _source, _U('you_confiscated_weapon', tac.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('tac:showNotification', target,  _U('got_confiscated_weapon', tac.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('tac_policejob:requestarrest')
AddEventHandler('tac_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('tac_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('tac_policejob:doarrested', _source)
end)

RegisterServerEvent('tac_policejob:requestrelease')
AddEventHandler('tac_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('tac_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('tac_policejob:douncuffing', _source)
end)


RegisterServerEvent('tac_policejob:handcuff1')
AddEventHandler('tac_policejob:handcuff1', function(target)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('tac_policejob:handcuff1', target)
	else
		print(('tac_policejob: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_policejob:drag')
AddEventHandler('tac_policejob:drag', function(target)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('tac_policejob:drag', target, source)
	else
		print(('tac_policejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_policejob:putInVehicle')
AddEventHandler('tac_policejob:putInVehicle', function(target)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('tac_policejob:putInVehicle', target)
	else
		print(('tac_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_policejob:OutVehicle')
AddEventHandler('tac_policejob:OutVehicle', function(target)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('tac_policejob:OutVehicle', target)
	else
		print(('tac_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_policejob:getStockItem')
AddEventHandler('tac_policejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('tac:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('tac:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('tac:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('tac_policejob:putStockItems')
AddEventHandler('tac_policejob:putStockItems', function(itemName, count)
	local xPlayer = tac.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('tac:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('tac:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('tac_policejob:getStockItem1')
AddEventHandler('tac_policejob:getStockItem1', function(itemName, count)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_police1', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('tac:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('tac:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('tac:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('tac_policejob:putStockItems1')
AddEventHandler('tac_policejob:putStockItems1', function(itemName, count)
	local xPlayer = tac.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_police1', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('tac:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('tac:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

tac.RegisterServerCallback('tac_policejob:getOtherPlayerData', function(source, cb, target)
	if Config.EnabletacIdentity then
		local xPlayer = tac.GetPlayerFromId(target)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('tac_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('tac_license:getLicenses', target, function(licenses)
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

		TriggerEvent('tac_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('tac_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)

tac.RegisterServerCallback('tac_policejob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

tac.RegisterServerCallback('tac_policejob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnabletacIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

tac.RegisterServerCallback('tac_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnabletacIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

tac.RegisterServerCallback('tac_policejob:getArmoryWeapons', function(source, cb)
	TriggerEvent('tac_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

tac.RegisterServerCallback('tac_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = tac.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
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

tac.RegisterServerCallback('tac_policejob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
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

tac.RegisterServerCallback('tac_policejob:buyWeapon', function(source, cb, weaponName, type, componentNum)
	local xPlayer = tac.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon = Config.AuthorizedWeapons[xPlayer.job.grade_name]

	for k,v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('tac_policejob: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	else
		-- Weapon
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addWeapon(weaponName, 100)

				cb(true)
			else
				cb(false)
			end

		-- Weapon Component
		elseif type == 2 then
			local price = selectedWeapon.components[componentNum]
			local weaponNum, weapon = tac.GetWeapon(weaponName)

			local component = weapon.components[componentNum]

			if component then
				if xPlayer.getMoney() >= price then
					xPlayer.removeMoney(price)
					xPlayer.addWeaponComponent(weaponName, component.name)

					cb(true)
				else
					cb(false)
				end
			else
				print(('tac_policejob: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
				cb(false)
			end
		end
	end
end)


tac.RegisterServerCallback('tac_policejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = tac.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('tac_policejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

tac.RegisterServerCallback('tac_policejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = tac.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('tac_policejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]
		local shared = Config.AuthorizedVehicles['Shared']

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end

		for k,v in ipairs(shared) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

tac.RegisterServerCallback('tac_policejob:getStockItems', function(source, cb)
	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

tac.RegisterServerCallback('tac_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = tac.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
			Citizen.Wait(5000)
			TriggerClientEvent('tac_policejob:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('tac_policejob:spawned')
AddEventHandler('tac_policejob:spawned', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
		Citizen.Wait(5000)
		TriggerClientEvent('tac_policejob:updateBlip', -1)
	end
end)

RegisterServerEvent('tac_policejob:forceBlip')
AddEventHandler('tac_policejob:forceBlip', function()
	TriggerClientEvent('tac_policejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('tac_policejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('tac_rvphone:removeNumber', 'police')
	end
end)

RegisterServerEvent('tac_policejob:message')
AddEventHandler('tac_policejob:message', function(target, msg)
	TriggerClientEvent('tac:showNotification', target, msg)
end)