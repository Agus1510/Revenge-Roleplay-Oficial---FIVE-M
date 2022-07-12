tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterServerCallback('tac_tattooshop:requestPlayerTattoos', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

tac.RegisterServerCallback('tac_tattooshop:purchaseTattoo', function(source, cb, tattooList, price, tattoo)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		table.insert(tattooList, tattoo)

		MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
			['@tattoos'] = json.encode(tattooList),
			['@identifier'] = xPlayer.identifier
		})

		TriggerClientEvent('tac:showNotification', source, _U('bought_tattoo', tac.Math.GroupDigits(price)))
		cb(true)
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('tac:showNotification', source, _U('not_enough_money', tac.Math.GroupDigits(missingMoney)))
		cb(false)
	end
end)
