tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

-- Make sure all Vehicles are Stored on restart
MySQL.ready(function()
	if Config.ParkVehicles then
		ParkVehicles()
	else
		print('tac_advancedgarage: Parking Vehicles on restart is currently set to false.')
	end
end)

function ParkVehicles()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = false
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('tac_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
		end
	end)
end

-- Get Owned Properties
tac.RegisterServerCallback('tac_advancedgarage:getOwnedProperties', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.getIdentifier()
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

-- Fetch Owned Aircrafts
tac.RegisterServerCallback('tac_advancedgarage:getOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'aircraft',
			['@job']    = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'aircraft',
			['@job']    = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	end
end)

-- Fetch Owned Boats
tac.RegisterServerCallback('tac_advancedgarage:getOwnedBoats', function(source, cb)
	local ownedBoats = {}

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'boat',
			['@job']    = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'boat',
			['@job']    = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	end
end)

-- Fetch Owned Cars
tac.RegisterServerCallback('tac_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car',
			['@job']    = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car',
			['@job']    = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	end
end)

-- Store Vehicles
tac.RegisterServerCallback('tac_advancedgarage:storeVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner']  = GetPlayerIdentifiers(source)[1],
					['@vehicle'] = json.encode(vehicleProps),
					['@plate']  = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('tac_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(GetPlayerIdentifiers(source)[1]))
					end
					cb(true)
				end)
			else
				if Config.KickPossibleCheaters == true then
					if Config.UseCustomKickMessage == true then
						print(('tac_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						DropPlayer(source, _U('custom_kick'))
						cb(false)
					else
						print(('tac_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('tac_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
					cb(false)
				end
			end
		else
			print(('tac_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(GetPlayerIdentifiers(source)[1]))
			cb(false)
		end
	end)
end)

-- Fetch Pounded Aircrafts
tac.RegisterServerCallback('tac_advancedgarage:getOutOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'aircraft',
		['@job']    = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, vehicle)
		end
		cb(ownedAircrafts)
	end)
end)

-- Fetch Pounded Boats
tac.RegisterServerCallback('tac_advancedgarage:getOutOwnedBoats', function(source, cb)
	local ownedBoats = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'boat',
		['@job']    = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, vehicle)
		end
		cb(ownedBoats)
	end)
end)

-- Fetch Pounded Cars
tac.RegisterServerCallback('tac_advancedgarage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'car',
		['@job']    = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, vehicle)
		end
		cb(ownedCars)
	end)
end)

-- Fetch Pounded Policing Vehicles
tac.RegisterServerCallback('tac_advancedgarage:getOutOwnedPolicingCars', function(source, cb)
	local ownedPolicingCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'police',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedPolicingCars, vehicle)
		end
		cb(ownedPolicingCars)
	end)
end)

-- Fetch Pounded Ambulance Vehicles
tac.RegisterServerCallback('tac_advancedgarage:getOutOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'ambulance',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAmbulanceCars, vehicle)
		end
		cb(ownedAmbulanceCars)
	end)
end)

-- Check Money for Pounded Aircrafts
tac.RegisterServerCallback('tac_advancedgarage:checkMoneyAircrafts', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.AircraftPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Boats
tac.RegisterServerCallback('tac_advancedgarage:checkMoneyBoats', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.BoatPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Cars
tac.RegisterServerCallback('tac_advancedgarage:checkMoneyCars', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Policing
tac.RegisterServerCallback('tac_advancedgarage:checkMoneyPolicing', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.PolicingPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Ambulance
tac.RegisterServerCallback('tac_advancedgarage:checkMoneyAmbulance', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.AmbulancePoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Pay for Pounded Aircrafts
RegisterServerEvent('tac_advancedgarage:payAircraft')
AddEventHandler('tac_advancedgarage:payAircraft', function()
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AircraftPoundPrice)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid') .. Config.AircraftPoundPrice)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(Config.AircraftPoundPrice)
	end)
end)

-- Pay for Pounded Boats
RegisterServerEvent('tac_advancedgarage:payBoat')
AddEventHandler('tac_advancedgarage:payBoat', function()
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.BoatPoundPrice)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid') .. Config.BoatPoundPrice)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(Config.BoatPoundPrice)
	end)
end)

-- Pay for Pounded Cars
RegisterServerEvent('tac_advancedgarage:payCar')
AddEventHandler('tac_advancedgarage:payCar', function()
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.CarPoundPrice)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid') .. Config.CarPoundPrice)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(Config.CarPoundPrice)
	end)
end)

-- Pay for Pounded Policing
RegisterServerEvent('tac_advancedgarage:payPolicing')
AddEventHandler('tac_advancedgarage:payPolicing', function()
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.PolicingPoundPrice)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid') .. Config.PolicingPoundPrice)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(Config.PolicingPoundPrice)
	end)
end)

-- Pay for Pounded Ambulance
RegisterServerEvent('tac_advancedgarage:payAmbulance')
AddEventHandler('tac_advancedgarage:payAmbulance', function()
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AmbulancePoundPrice)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid') .. Config.AmbulancePoundPrice)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(Config.AmbulancePoundPrice)
	end)
end)

-- Pay to Return Broken Vehicles
RegisterServerEvent('tac_advancedgarage:payhealth')
AddEventHandler('tac_advancedgarage:payhealth', function(price)
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeMoney(price)
	TriggerClientEvent('tac:showNotification', source, _U('you_paid') .. price)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(price)
	end)
end)

-- Modify State of Vehicles
RegisterServerEvent('tac_advancedgarage:setVehicleState')
AddEventHandler('tac_advancedgarage:setVehicleState', function(plate, state)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('tac_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
