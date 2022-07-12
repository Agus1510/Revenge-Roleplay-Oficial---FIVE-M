tac = nil
passanger1 = nil
passanger2 = nil
passanger3 = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_garbage:pay')
AddEventHandler('tac_garbage:pay', function(amount)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local payamount = math.ceil(amount)
	xPlayer.addMoney(tonumber(payamount))
	TriggerClientEvent('tac:showNotification', source, '~s~Recebido~g~ '..payamount..' ~s~por su trabajo~s~!')
end)

RegisterServerEvent('tac_garbage:binselect')
AddEventHandler('tac_garbage:binselect', function(binpos, platenumber, bagnumb)
	TriggerClientEvent('tac_garbage:setbin', -1, binpos, platenumber,  bagnumb)
end)

RegisterServerEvent('tac_garbage:requestpay')
AddEventHandler('tac_garbage:requestpay', function(platenumber, amount)
	print('pedido recebido para começar a pagar: '..platenumber.." para "..amount)
	TriggerClientEvent('tac_garbage:startpayrequest', -1, platenumber, amount)
end)

RegisterServerEvent('tac_garbage:bagremoval')
AddEventHandler('tac_garbage:bagremoval', function(platenumber)
	TriggerClientEvent('tac_garbage:removedbag', -1, platenumber)

end)

RegisterServerEvent('tac_garbage:endcollection')
AddEventHandler('tac_garbage:endcollection', function(platenumber)
	TriggerClientEvent('tac_garbage:clearjob', -1, platenumber)
end)

RegisterServerEvent('tac_garbage:reportbags')
AddEventHandler('tac_garbage:reportbags', function(platenumber)
	TriggerClientEvent('tac_garbage:countbagtotal', -1, platenumber)
end)

RegisterServerEvent('tac_garbage:bagsdone')
AddEventHandler('tac_garbage:bagsdone', function(platenumber, bagstopay)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	TriggerClientEvent('tac_garbage:addbags', -1, platenumber, bagstopay, xPlayer )
end)
