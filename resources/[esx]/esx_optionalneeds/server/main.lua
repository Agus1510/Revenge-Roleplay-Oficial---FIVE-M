tac = nil

TriggerEvent('tac:getSharedObject', function(obj)
	tac = obj
end)

tac.RegisterUsableItem('beer', function(source)

	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 250000)
	TriggerClientEvent('tac_optionalneeds:onDrink', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_beer'))

end)
