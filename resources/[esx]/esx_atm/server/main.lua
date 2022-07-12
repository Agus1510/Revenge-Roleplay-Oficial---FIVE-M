tac = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_atm:deposit')
AddEventHandler('tac_atm:deposit', function(amount)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	amount = tonumber(amount)

	if not tonumber(amount) then return end
	amount = tac.Math.Round(amount)

	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('tac:showNotification', _source, _U('invalid_amount'))
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', amount)
		TriggerClientEvent('tac:showNotification', _source, _U('deposit_money', amount))
	end
end)

RegisterServerEvent('tac_atm:withdraw')
AddEventHandler('tac_atm:withdraw', function(amount)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	amount = tonumber(amount)
	local accountMoney = xPlayer.getAccount('bank').money

	if not tonumber(amount) then return end
	amount = tac.Math.Round(amount)

	if amount == nil or amount <= 0 or amount > accountMoney then
		TriggerClientEvent('tac:showNotification', _source, _U('invalid_amount'))
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('tac:showNotification', _source, _U('withdraw_money', amount))
	end
end)
