tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterUsableItem('hifi', function(source)
	local xPlayer = tac.GetPlayerFromId(source)
	
	xPlayer.removeInventoryItem('hifi', 1)
	
	TriggerClientEvent('tac_hifi:place_hifi', source)
	TriggerClientEvent('tac:showNotification', source, _U('put_hifi'))
end)

RegisterServerEvent('tac_hifi:remove_hifi')
AddEventHandler('tac_hifi:remove_hifi', function(coords)
	local xPlayer = tac.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('hifi').count < xPlayer.getInventoryItem('hifi').limit then
		xPlayer.addInventoryItem('hifi', 1)
	end
	TriggerClientEvent('tac_hifi:stop_music', -1, coords)
end)


RegisterServerEvent('tac_hifi:play_music')
AddEventHandler('tac_hifi:play_music', function(id, coords)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_hifi:play_music', -1, id, coords)
end)

RegisterServerEvent('tac_hifi:stop_music')
AddEventHandler('tac_hifi:stop_music', function(coords)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_hifi:stop_music', -1, coords)
end)

RegisterServerEvent('tac_hifi:setVolume')
AddEventHandler('tac_hifi:setVolume', function(volume, coords)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_hifi:setVolume', -1, volume, coords)
end)
