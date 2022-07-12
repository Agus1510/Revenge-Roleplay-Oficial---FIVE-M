tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_clotheshop:saveOutfit')
AddEventHandler('tac_clotheshop:saveOutfit', function(label, skin)
	local xPlayer = tac.GetPlayerFromId(source)

	TriggerEvent('tac_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
	end)
end)

tac.RegisterServerCallback('tac_clotheshop:buyClothes', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.Price then
		xPlayer.removeMoney(Config.Price)
		TriggerClientEvent('tac:showNotification', source, _U('you_paid', Config.Price))
		cb(true)
	else
		cb(false)
	end
end)

tac.RegisterServerCallback('tac_clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	local foundStore = false

	TriggerEvent('tac_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)
