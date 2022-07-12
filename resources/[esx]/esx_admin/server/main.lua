tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterServerCallback("tac_admin:getSteamId", function(source, cb)
    local _source = source
    cb(GetPlayerIdentifiers(_source)[1])
end)

RegisterServerEvent('tac_admin:customerDeposit')
AddEventHandler('tac_admin:customerDeposit', function(amount)
    local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.addMoney(amount)
end)

RegisterServerEvent('tac_admin:customeraccount')
AddEventHandler('tac_admin:customeraccount', function(target, amount)
    local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.addAccountMoney('bank',amount)
end)

RegisterServerEvent('tac_admin:customerdirtDeposit')
AddEventHandler('tac_admin:customerdirtDeposit', function(amount)
    local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.addAccountMoney('black_money',amount)
end)

RegisterServerEvent('tac_admin:additem')
AddEventHandler('tac_admin:additem', function(item)
    local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('tac_admin:giveweapon')
AddEventHandler('tac_admin:giveweapon', function(text)
    local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.addWeapon(text, 2500)
end)

RegisterServerEvent('tac_admin:phone')
AddEventHandler('tac_admin:phone', function(target, text)
	local _source = source
	local xPlayers = tac.GetPlayers()
	local xPlayer = tac.GetPlayerFromId(source)

	TriggerClientEvent('tac_phone:onMessage', target, '',text  , xPlayer.get('coords'), true, 'Alert Police', true)
end)

RegisterServerEvent('tac_admin:policealert')
AddEventHandler('tac_admin:policealert', function(text)
	local _source = source
	local xPlayers = tac.GetPlayers()
	local xPlayer = tac.GetPlayerFromId(source)

	for i=1, #xPlayers, 1 do

		local xPlayer2 = tac.GetPlayerFromId(xPlayers[i])
		if xPlayer2.job.name == 'police' or xPlayer2.job.name == 'sherif' then
			TriggerClientEvent('tac_phone:onMessage', xPlayer2.source, '', text , xPlayer.get('coords'), true, 'Alert Police', true)
		end
	end

	print('Alert Police : ' .. text)
end)

RegisterServerEvent('tac_admin:gangalert')
AddEventHandler('tac_admin:gangalert', function(text)
	local _source = source
	local xPlayers = tac.GetPlayers()
	local xPlayer = tac.GetPlayerFromId(source)

	for i=1, #xPlayers, 1 do

		local xPlayer2 = tac.GetPlayerFromId(xPlayers[i])
		if xPlayer2.job.name == 'gang_weed' or xPlayer2.job.name == 'gang_meth' or xPlayer2.job.name == 'gang_coke' then
			TriggerClientEvent('tac_phone:onMessage', xPlayer2.source, '', text , xPlayer.get('coords'), true, 'Deepweb', true)
		end
	end

	print('Deepweb : ' .. text)
end)

RegisterServerEvent('tac_admin:pickup')
AddEventHandler('tac_admin:pickup', function(item)
	local itemName = item
	local total = 1
	local itemCount = 1

	tac.CreatePickup('item_standard', itemName, total, "Inconnue [" .. itemCount .. "]", _source)
end)

RegisterServerEvent('tac_admin:addInventoryItem')
AddEventHandler('tac_admin:addInventoryItem', function(type, model, plate, item, count, name, owned)
  local _source = source
  MySQL.Async.fetchAll(
    'INSERT INTO truck_inventory (item,count,plate,name,owned) VALUES (@item,@qty,@plate,@name,@owned) ON DUPLICATE KEY UPDATE count=count+ @qty',
    {
      ['@plate'] = plate,
      ['@qty'] = count,
      ['@item'] = item,
      ['@name'] = name,
      ['@owned'] = "0",
    }, function(result)
      TriggerEvent("tac:adminAddInventory", _source, type, model, plate, item, count, name)
    end)
end)

RegisterServerEvent('tac_admin:brinks_police')
AddEventHandler('tac_admin:brinks_police', function(item)
	local _source 	 = source
	local xPlayers	 = tac.GetPlayers()
	local xPlayer    = tac.GetPlayerFromId(source)

	for i=1, #xPlayers, 1 do

		local xPlayer2 = tac.GetPlayerFromId(xPlayers[i])
		if xPlayer2.job.name == 'gang_weed' or xPlayer2.job.name == 'gang_meth' or xPlayer2.job.name == 'gang_coke' then
			TriggerClientEvent('tac_phone:onMessage', xPlayer2.source, '', "Un camion de la brinks vient d'être attaqué", xPlayer.get('coords'), true, 'Deepweb', true)
		end
		if xPlayer2.job.name == 'police' or xPlayer2.job.name == 'sherif' then
			TriggerClientEvent('tac_phone:onMessage', xPlayer2.source, '', "Un camion de la brinks vient d'être attaqué" , xPlayer.get('coords'), true, 'Alert Police', true)
		end
	end
end)

RegisterServerEvent('tac_admin:callbrinks1')
AddEventHandler('tac_admin:callbrinks1', function(item)
	local _source 	 = source
	local xPlayers	 = tac.GetPlayers()
	local xPlayer    = tac.GetPlayerFromId(source)

	for i=1, #xPlayers, 1 do

		local xPlayer2 = tac.GetPlayerFromId(xPlayers[i])
		if xPlayer2.job.name == 'police' or xPlayer2.job.name == 'sherif' then
			TriggerClientEvent('tac_phone:onMessage', xPlayer2.source, 'Brinks', "Nous allons faire plusieur transfére, merci de faire de votre mieux pour nous protéger" , xPlayer.get('coords'), false, 'Brinks', false)
		end
	end
end)

RegisterServerEvent('tac_admin:getStockItem')
AddEventHandler('tac_admin:getStockItem', function(itemName, count)
	local xPlayer = tac.GetPlayerFromId(source)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_admin', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('tac:showNotification', xPlayer.source, 'Quantité invalide')
		end

		TriggerClientEvent('tac:showNotification', xPlayer.source, 'Vous avez retiré x' .. count .. ' ' .. item.label)
	end)
end)

RegisterServerEvent('tac_admin:putStockItems')
AddEventHandler('tac_admin:putStockItems', function(itemName, count)
	local xPlayer = tac.GetPlayerFromId(source)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_admin', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('tac:showNotification', xPlayer.source, '~r~Quantité invalide')
		end

		TriggerClientEvent('tac:showNotification', xPlayer.source, 'Vous avez ajouté ~y~x' .. count .. '~b~ ' .. item.label)
	end)
end)

tac.RegisterServerCallback('tac_admin:getStockItems', function(source, cb)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_admin', function(inventory)
		cb(inventory.items)
	end)
end)

tac.RegisterServerCallback('tac_admin:getPlayerInventory', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({
		items = items
	})
end)

tac.RegisterServerCallback('tac_admin:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 1000)

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_admin', function(store)
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

tac.RegisterServerCallback('tac_admin:getArmoryWeapons', function(source, cb)

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_admin', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

tac.RegisterServerCallback('tac_admin:addArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeWeapon(weaponName)

	TriggerEvent('tac_datastore:getSharedDataStore', 'society_admin', function(store)
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

RegisterServerEvent('tac_admin:addstatus')
AddEventHandler('tac_admin:addstatus', function(target,amount)
	local xPlayer = tac.GetPlayerFromId(source)

	TriggerClientEvent('tac_status:set', source, 'hunger', amount)
	TriggerClientEvent('tac_status:set', source, 'thirst', amount)
end)

RegisterServerEvent('tac_admin:withdraw')
AddEventHandler('tac_admin:withdraw', function(amount)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_accountant', function(account)
		account.removeMoney(amount)
	end)
end)

RegisterServerEvent('tac_admin:deposit')
AddEventHandler('tac_admin:deposit', function(amount)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_accountant', function(account)
		account.addMoney(amount)
	end)
end)

RegisterServerEvent('tac_admin:confiscatePlayerItem')
AddEventHandler('tac_admin:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local sourceXPlayer = tac.GetPlayerFromId(source)
	local targetXPlayer = tac.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local label = sourceXPlayer.getInventoryItem(itemName).label

		targetXPlayer.removeInventoryItem(itemName, amount)
		sourceXPlayer.addInventoryItem(itemName, amount)

		TriggerClientEvent('tac:showNotification', sourceXPlayer.source, "'Vous avez confisqué ~y~x'" .. amount .. ' ' .. label .."'~s~ à ~b~'" .. targetXPlayer.name)
	end

	if itemType == 'item_money' then

		targetXPlayer.removeMoney(amount)
		sourceXPlayer.addMoney(amount)

		TriggerClientEvent('tac:showNotification', sourceXPlayer.source, "'Vous avez confisqué ~y~$'" .. amount .."'~s~ à ~b~'" .. targetXPlayer.name)
	end

	if itemType == 'item_account' then

		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

		TriggerClientEvent('tac:showNotification', sourceXPlayer.source, "'Vous avez confisqué ~y~$'" .. amount .."'~s~ à ~b~'" .. targetXPlayer.name)
	end

	if itemType == 'item_weapon' then

		targetXPlayer.removeWeapon(itemName)
		sourceXPlayer.addWeapon(itemName, amount)

		TriggerClientEvent('tac:showNotification', sourceXPlayer.source,'Vous avez confisqué ~y~x1 ' .. tac.GetWeaponLabel(itemName) .."'~s~ à ~b~'" .. targetXPlayer.name)
	end
end)

tac.RegisterServerCallback('tac_admin:getCustomers', function(source, cb)
	local xPlayers   = tac.GetPlayers()
	local customers  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])

		table.insert(customers, {
			type         = 'player',
			name         = GetPlayerName(xPlayer.source),
			identifier   = xPlayer.identifier,
			group        = xPlayer.getGroup(),
			accounts     = xPlayer.get('bank'),
			dirtmoney	 = xPlayer.accounts[i].money,
			job          = xPlayer.job['name'],
			grade        = xPlayer.job.grade_name,
			money        = xPlayer.get('money'),
			phone		 = xPlayer.get('phoneNumber'),
		})
	end

	cb(customers)
end)
