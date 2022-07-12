tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_clothes:sellVehicle')
AddEventHandler('tac_clothes:sellVehicle', function(target, plate)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local _target = target
	local tPlayer = tac.GetPlayerFromId(_target)
	local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
			['@identifier'] = xPlayer.identifier,
			['@plate'] = plate
		})
	if result[1] ~= nil then
		MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = plate,
			['@target'] = tPlayer.identifier
		}, function (rowsChanged)
			if rowsChanged ~= 0 then
				TriggerClientEvent('tac_contract:showAnim', _source)
				Wait(22000)
				TriggerClientEvent('tac_contract:showAnim', _target)
				Wait(22000)
				TriggerClientEvent('tac:showNotification', _source, _U('soldvehicle', plate))
				TriggerClientEvent('tac:showNotification', _target, _U('boughtvehicle', plate))
				xPlayer.removeInventoryItem('contract', 1)
			end
		end)
	else
		TriggerClientEvent('tac:showNotification', _source, _U('notyourcar'))
	end
end)

tac.RegisterUsableItem('contract', function(source)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	TriggerClientEvent('tac_contract:getVehicle', _source)
end)