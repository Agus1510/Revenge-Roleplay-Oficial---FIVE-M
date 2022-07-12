----------------------------------------
--Dev by Thom512#0990 for Patoche#4702--
----------------------------------------

tac = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterServerCallback('weapon512:buyWeapon', function(source, cb, weaponName, price)
    local _source = source
	local xPlayer = tac.GetPlayerFromId(source)
	if Config.ArgentSale then
		if xPlayer.getAccount('black_money').money >= price then
			xPlayer.removeAccountMoney('black_money', price)
			xPlayer.addWeapon(weaponName, 200)

			cb(true)
		else
			TriggerClientEvent('tac:showAdvancedNotification', _source, "Seller", "", "You don't have enough black money" , "CHAR_MP_MERRYWEATHER", 1)
			cb(false)
		end
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)
			xPlayer.addWeapon(weaponName, 200)

			cb(true)
		else
			TriggerClientEvent('tac:showAdvancedNotification', _source, "Seller", "", "No tienes suficiente dinero" , "CHAR_MP_MERRYWEATHER", 1)
			cb(false)
		end
	end
end)