tac = nil
local Vehicles

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_lscustom:buyMod')
AddEventHandler('tac_lscustom:buyMod', function(price)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	price = tonumber(price)

	if Config.IsMechanicJobOnly then
		local societyAccount

		TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mecano', function(account)
			societyAccount = account
		end)

		if price < societyAccount.money then
			TriggerClientEvent('tac_lscustom:installMod', _source)
			TriggerClientEvent('tac:showNotification', _source, _U('purchased'))
			societyAccount.removeMoney(price)
		else
			TriggerClientEvent('tac_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('tac:showNotification', _source, _U('not_enough_money'))
		end
	else
		if price < xPlayer.getMoney() then
			TriggerClientEvent('tac_lscustom:installMod', _source)
			TriggerClientEvent('tac:showNotification', _source, _U('purchased'))
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('tac_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('tac:showNotification', _source, _U('not_enough_money'))
		end
	end
end)

RegisterServerEvent('tac_lscustom:refreshOwnedVehicle')
AddEventHandler('tac_lscustom:refreshOwnedVehicle', function(vehicleProps)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == vehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			else
				print(('tac_lscustom: %s attempted to upgrade vehicle with mismatching vehicle model!'):format(xPlayer.identifier))
			end
		end
	end)
end)

tac.RegisterServerCallback('tac_lscustom:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)