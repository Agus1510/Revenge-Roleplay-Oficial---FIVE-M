tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function SetPropertyOwned(name, price, rented, owner)
	MySQL.Async.execute('INSERT INTO owned_properties (name, price, rented, owner) VALUES (@name, @price, @rented, @owner)', {
		['@name']   = name,
		['@price']  = price,
		['@rented'] = (rented and 1 or 0),
		['@owner']  = owner
	}, function(rowsChanged)
		local xPlayer = tac.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('tac_property:setPropertyOwned', xPlayer.source, name, true)

			if rented then
				xPlayer.showNotification(_U('rented_for', tac.Math.GroupDigits(price)))
			else
				xPlayer.showNotification(_U('purchased_for', tac.Math.GroupDigits(price)))
			end
		end
	end)
end

function RemoveOwnedProperty(name, owner)
	MySQL.Async.execute('DELETE FROM owned_properties WHERE name = @name AND owner = @owner', {
		['@name']  = name,
		['@owner'] = owner
	}, function(rowsChanged)
		local xPlayer = tac.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('tac_property:setPropertyOwned', xPlayer.source, name, false)
			xPlayer.showNotification(_U('made_property'))
		end
	end)
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

		for i=1, #properties, 1 do
			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
			local roomMenu  = nil

			if properties[i].entering ~= nil then
				entering = json.decode(properties[i].entering)
			end

			if properties[i].exit ~= nil then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside ~= nil then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside ~= nil then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end

			if properties[i].room_menu ~= nil then
				roomMenu = json.decode(properties[i].room_menu)
			end

			table.insert(Config.Properties, {
				name      = properties[i].name,
				label     = properties[i].label,
				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(properties[i].ipls),
				gateway   = properties[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				roomMenu  = roomMenu,
				price     = properties[i].price
			})
		end

		TriggerClientEvent('tac_property:sendProperties', -1, Config.Properties)
	end)
end)

tac.RegisterServerCallback('tac_property:getProperties', function(source, cb)
	cb(Config.Properties)
end)

AddEventHandler('tac_ownedproperty:getOwnedProperties', function(cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties', {}, function(result)
		local properties = {}

		for i=1, #result, 1 do
			table.insert(properties, {
				id     = result[i].id,
				name   = result[i].name,
				label  = GetProperty(result[i].name).label,
				price  = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner  = result[i].owner
			})
		end

		cb(properties)
	end)
end)

AddEventHandler('tac_property:setPropertyOwned', function(name, price, rented, owner)
	SetPropertyOwned(name, price, rented, owner)
end)

AddEventHandler('tac_property:removeOwnedProperty', function(name, owner)
	RemoveOwnedProperty(name, owner)
end)

RegisterServerEvent('tac_property:rentProperty')
AddEventHandler('tac_property:rentProperty', function(propertyName)
	local xPlayer  = tac.GetPlayerFromId(source)
	local property = GetProperty(propertyName)
	local rent     = tac.Math.Round(property.price / 200)

	SetPropertyOwned(propertyName, rent, true, xPlayer.identifier)
end)

RegisterServerEvent('tac_property:buyProperty')
AddEventHandler('tac_property:buyProperty', function(propertyName)
	local xPlayer  = tac.GetPlayerFromId(source)
	local property = GetProperty(propertyName)

	if property.price <= xPlayer.getMoney() then
		xPlayer.removeMoney(property.price)
		SetPropertyOwned(propertyName, property.price, false, xPlayer.identifier)
	else
		xPlayer.showNotification(_U('not_enough'))
	end
end)

RegisterServerEvent('tac_property:removeOwnedProperty')
AddEventHandler('tac_property:removeOwnedProperty', function(propertyName)
	local xPlayer = tac.GetPlayerFromId(source)
	RemoveOwnedProperty(propertyName, xPlayer.identifier)
end)

AddEventHandler('tac_property:removeOwnedPropertyIdentifier', function(propertyName, identifier)
	RemoveOwnedProperty(propertyName, identifier)
end)

RegisterServerEvent('tac_property:saveLastProperty')
AddEventHandler('tac_property:saveLastProperty', function(property)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = @last_property WHERE identifier = @identifier', {
		['@last_property'] = property,
		['@identifier']    = xPlayer.identifier
	})
end)

RegisterServerEvent('tac_property:deleteLastProperty')
AddEventHandler('tac_property:deleteLastProperty', function()
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = NULL WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('tac_property:getItem')
AddEventHandler('tac_property:getItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = tac.GetPlayerFromId(_source)
	local xPlayerOwner = tac.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then


		TriggerEvent('tac_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)

			-- is there enough in the property?
			if count > 0 and inventoryItem.count >= count then
			
				-- can the player carry the said amount of x item?
				if xPlayer.canCarryItem(item, count) then
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					xPlayer.showNotification(_U('have_withdrawn', count, inventoryItem.label))
				else
					xPlayer.showNotification(_U('player_cannot_hold'))
				end
			else
				xPlayer.showNotification(_U('not_enough_in_property'))
			end
		end)

	elseif type == 'item_account' then

		TriggerEvent('tac_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
			else
				xPlayer.showNotification(_U('amount_invalid'))
			end
		end)

	elseif type == 'item_weapon' then

		TriggerEvent('tac_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}
			local weaponName   = nil
			local ammo         = nil

			for i=1, #storeWeapons, 1 do
				if storeWeapons[i].name == item then
					weaponName = storeWeapons[i].name
					ammo       = storeWeapons[i].ammo

					table.remove(storeWeapons, i)
					break
				end
			end

			store.set('weapons', storeWeapons)
			xPlayer.addWeapon(weaponName, ammo)
		end)

	end
end)

RegisterServerEvent('tac_property:putItem')
AddEventHandler('tac_property:putItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = tac.GetPlayerFromId(_source)
	local xPlayerOwner = tac.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('tac_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
				xPlayer.showNotification(_U('have_deposited', count, inventory.getItem(item).label))
			end)
		else
			xPlayer.showNotification(_U('invalid_quantity'))
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('tac_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
				account.addMoney(count)
			end)
		else
			xPlayer.showNotification(_U('amount_invalid'))
		end

	elseif type == 'item_weapon' then

		TriggerEvent('tac_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}

			table.insert(storeWeapons, {
				name = item,
				ammo = count
			})

			store.set('weapons', storeWeapons)
			xPlayer.removeWeapon(item)
		end)

	end
end)

tac.RegisterServerCallback('tac_property:getOwnedProperties', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(ownedProperties)
		local properties = {}

		for i=1, #ownedProperties, 1 do
			table.insert(properties, ownedProperties[i].name)
		end

		cb(properties)
	end)
end)

tac.RegisterServerCallback('tac_property:getLastProperty', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT last_property FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		cb(users[1].last_property)
	end)
end)

tac.RegisterServerCallback('tac_property:getPropertyInventory', function(source, cb, owner)
	local xPlayer    = tac.GetPlayerFromIdentifier(owner)
	local blackMoney = 0
	local items      = {}
	local weapons    = {}

	TriggerEvent('tac_addonaccount:getAccount', 'property_black_money', xPlayer.identifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('tac_addoninventory:getInventory', 'property', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	TriggerEvent('tac_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		weapons = store.get('weapons') or {}
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
		weapons    = weapons
	})
end)

tac.RegisterServerCallback('tac_property:getPlayerInventory', function(source, cb)
	local xPlayer    = tac.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
		weapons    = xPlayer.getLoadout()
	})
end)

tac.RegisterServerCallback('tac_property:getPlayerDressing', function(source, cb)
	local xPlayer  = tac.GetPlayerFromId(source)

	TriggerEvent('tac_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

tac.RegisterServerCallback('tac_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = tac.GetPlayerFromId(source)

	TriggerEvent('tac_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('tac_property:removeOutfit')
AddEventHandler('tac_property:removeOutfit', function(label)
	local xPlayer = tac.GetPlayerFromId(source)

	TriggerEvent('tac_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE rented = 1', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = tac.GetPlayerFromIdentifier(result[i].owner)

			-- message player if connected
			if xPlayer then
				xPlayer.removeAccountMoney('bank', result[i].price)
				xPlayer.showNotification(_U('paid_rent', tac.Math.GroupDigits(result[i].price)))
			else -- pay rent either way
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', {
					['@bank']       = result[i].price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('tac_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
				account.addMoney(result[i].price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 0, PayRent)
