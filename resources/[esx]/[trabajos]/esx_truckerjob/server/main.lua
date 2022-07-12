tac = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_truckerjob:pay')
AddEventHandler('tac_truckerjob:pay', function(payment)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(payment))
end)