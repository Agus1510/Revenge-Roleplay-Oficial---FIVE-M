tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_plasticsurgery:pay')
AddEventHandler('tac_plasticsurgery:pay', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid', tac.Math.GroupDigits(Config.Price)))
end)

tac.RegisterServerCallback('tac_plasticsurgery:checkMoney', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	cb(xPlayer.get('money') >= Config.Price)
end)
