tac = nil


TriggerEvent('tac:getSharedObject', function(obj)
	tac = obj
end)

tac.RegisterUsableItem('weed', function(source)
        
        local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('tac_status:add', _source, 'drug', 166000)
	TriggerClientEvent('tac_drugeffects:onWeed', source)
end)

tac.RegisterUsableItem('opium', function(source)
       
        local _source = source
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('opium', 1)

	TriggerClientEvent('tac_status:add', _source, 'drug', 249000)
	TriggerClientEvent('tac_drugeffects:onOpium', source)
end)

tac.RegisterUsableItem('meth', function(source)
        
        local _source = source
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('meth', 1)

	TriggerClientEvent('tac_status:add', _source, 'drug', 333000)
	TriggerClientEvent('tac_drugeffects:onMeth', source)
end)

tac.RegisterUsableItem('coke', function(source)
        
        local _source = source
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coke', 1)

	TriggerClientEvent('tac_status:add', _source, 'drug', 499000)
	TriggerClientEvent('tac_drugeffects:onCoke', source)
end)

tac.RegisterUsableItem('xanax', function(source)
        
        local _source = source
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('xanax', 1)

	TriggerClientEvent('tac_status:remove', _source, 'drug', 249000)
end)
