tac = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

-- Make the kit usable!
tac.RegisterUsableItem('enginekiller', function(source)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if Config.AllowMecano then
		TriggerClientEvent('tac_enginekiller:onUse', _source)
	else
		if xPlayer.job.name ~= 'mecano' then
			TriggerClientEvent('tac_enginekiller:onUse', _source)
		end
	end
end)

RegisterNetEvent('tac_enginekiller:removeKiller')
AddEventHandler('tac_enginekiller:removeKiller', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	if not Config.InfiniteEngineKillers then
		xPlayer.removeInventoryItem('enginekiller', 1)
		TriggerClientEvent('tac:showNotification', _source, _U('used_killer'))
	end
end)