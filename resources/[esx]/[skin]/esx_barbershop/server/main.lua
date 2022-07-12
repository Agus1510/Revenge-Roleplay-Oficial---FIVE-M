tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_barbershop:pay')
AddEventHandler('tac_barbershop:pay', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid', tac.Math.GroupDigits(Config.Price)))
end)

tac.RegisterServerCallback('tac_barbershop:checkMoney', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	cb(xPlayer.getMoney() >= Config.Price)
end)
