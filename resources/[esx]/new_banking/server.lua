--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('banco:deposit')
AddEventHandler('banco:deposit', function(amount)
	local _source = source
	
	local xPlayer = tac.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('banco:result', _source, "error", "Monto invalido.")
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
		TriggerClientEvent('banco:result', _source, "success", "Deposito completado.")
	end
end)


RegisterServerEvent('banco:withdraw')
AddEventHandler('banco:withdraw', function(amount)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('banco:result', _source, "error", "Monto invalido.")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('banco:result', _source, "success", "Retiro completado.")
	end
end)

RegisterServerEvent('banco:balance')
AddEventHandler('banco:balance', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)
end)


RegisterServerEvent('banco:transfer')
AddEventHandler('banco:transfer', function(to, amountt)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local zPlayer = tac.GetPlayerFromId(to)
	local balance = 0

	if(zPlayer == nil or zPlayer == -1) then
		TriggerClientEvent('banco:result', _source, "error", "Destinatario invalido.")
	else
		balance = xPlayer.getAccount('bank').money
		zbalance = zPlayer.getAccount('bank').money
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('banco:result', _source, "error", "No podes transferirte a vos mismo.")
		else
			if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent('banco:result', _source, "error", "No tienes suficiente dinero en el banco.")
			else
				xPlayer.removeAccountMoney('bank', tonumber(amountt))
				zPlayer.addAccountMoney('bank', tonumber(amountt))
				TriggerClientEvent('banco:result', _source, "success", "Transferencia realizada.")
			end
		end
	end
end)





