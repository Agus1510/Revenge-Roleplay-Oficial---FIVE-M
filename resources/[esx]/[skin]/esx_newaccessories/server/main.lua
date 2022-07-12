tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_newaccessories:pay')
AddEventHandler('tac_newaccessories:pay', function()
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid', tac.Math.GroupDigits(Config.Price)))
end)

RegisterServerEvent('tac_newaccessories:save')
AddEventHandler('tac_newaccessories:save', function(skin, accessory)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	TriggerEvent('tac_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
		store.set('has' .. accessory, true)

		local itemSkin = {}
		local item1 = string.lower(accessory) .. '_1'
		local item2 = string.lower(accessory) .. '_2'
		itemSkin[item1] = skin[item1]
		itemSkin[item2] = skin[item2]

		store.set('skin', itemSkin)
	end)
end)

tac.RegisterServerCallback('tac_newaccessories:get', function(source, cb, accessory)
	local xPlayer = tac.GetPlayerFromId(source)

	TriggerEvent('tac_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
		local hasAccessory = (store.get('has' .. accessory) and store.get('has' .. accessory) or false)
		local skin = (store.get('skin') and store.get('skin') or {})

		cb(hasAccessory, skin)
	end)

end)

tac.RegisterServerCallback('tac_newaccessories:checkMoney', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	cb(xPlayer.get('money') >= Config.Price)
end)
