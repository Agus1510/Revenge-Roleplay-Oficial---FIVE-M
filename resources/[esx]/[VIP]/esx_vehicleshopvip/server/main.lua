tac = nil
local categories, vehicles = {}, {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

TriggerEvent('tac_phone:registerNumber', 'cardealervip', _U('dealer_customers'), false, false)
TriggerEvent('tac_society:registerSociety', 'cardealervip', _U('car_dealer'), 'society_cardealervip', 'society_cardealervip', 'society_cardealervip', {type = 'private'})

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('[tac_vehicleshopvip] [^3WARNING^7] Plate character count reached, %s/8 characters!'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM vehicle_categoriesvip', {}, function(_categories)
		categories = _categories

		MySQL.Async.fetchAll('SELECT * FROM vehiclesvip', {}, function(_vehicles)
			vehicles = _vehicles

			for k,v in ipairs(vehicles) do
				for k2,v2 in ipairs(categories) do
					if v2.name == v.category then
						vehicles[k].categoryLabel = v2.label
						break
					end
				end
			end

			-- send information after db has loaded, making sure everyone gets vehicle information
			TriggerClientEvent('tac_vehicleshopvip:sendCategories', -1, categories)
			TriggerClientEvent('tac_vehicleshopvip:sendVehicles', -1, vehicles)
		end)
	end)
end)

function getVehicleLabelFromModel(model)
	for k,v in ipairs(vehicles) do
		if v.model == model then
			return v.name
		end
	end

	return
end

RegisterNetEvent('tac_vehicleshopvip:setVehicleOwnedPlayerId')
AddEventHandler('tac_vehicleshopvip:setVehicleOwnedPlayerId', function(playerId, vehicleProps, model, label)
	local xPlayer, xTarget = tac.GetPlayerFromId(source), tac.GetPlayerFromId(playerId)

	if xPlayer.job.name == 'cardealervip' and xTarget then
		MySQL.Async.fetchAll('SELECT id FROM cardealervip_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = model
		}, function(result)
			if result[1] then
				local id = result[1].id

				MySQL.Async.execute('DELETE FROM cardealervip_vehicles WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
							['@owner']   = xTarget.identifier,
							['@plate']   = vehicleProps.plate,
							['@vehicle'] = json.encode(vehicleProps)
						}, function(rowsChanged)
							xPlayer.showNotification(_U('vehicle_set_owned', vehicleProps.plate, xTarget.getName()))
							xTarget.showNotification(_U('vehicle_belongs', vehicleProps.plate))
						end)

						local dateNow = os.date('%Y-%m-%d %H:%M')

						MySQL.Async.execute('INSERT INTO vehicle_sold (client, model, plate, soldby, date) VALUES (@client, @model, @plate, @soldby, @date)', {
							['@client'] = xTarget.getName(),
							['@model'] = label,
							['@plate'] = vehicleProps.plate,
							['@soldby'] = xPlayer.getName(),
							['@date'] = dateNow
						})
					end
				end)
			end
		end)
	end
end)

tac.RegisterServerCallback('tac_vehicleshopvip:getSoldVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT client, model, plate, soldby, date FROM vehicle_sold', {}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('tac_vehicleshopvip:rentVehicle')
AddEventHandler('tac_vehicleshopvip:rentVehicle', function(vehicle, plate, rentPrice, playerId)
	local xPlayer, xTarget = tac.GetPlayerFromId(source), tac.GetPlayerFromId(playerId)

	if xPlayer.job.name == 'cardealervip' and xTarget then
		MySQL.Async.fetchAll('SELECT id, price FROM cardealervip_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicle
		}, function(result)
			if result[1] then
				local price = result[1].price

				MySQL.Async.execute('DELETE FROM cardealervip_vehicles WHERE id = @id', {
					['@id'] = result[1].id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						MySQL.Async.execute('INSERT INTO rented_vehicles (vehicle, plate, player_name, base_price, rent_price, owner) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner)', {
							['@vehicle']     = vehicle,
							['@plate']       = plate,
							['@player_name'] = xTarget.getName(),
							['@base_price']  = price,
							['@rent_price']  = rentPrice,
							['@owner']       = xTarget.identifier
						}, function(rowsChanged2)
							xPlayer.showNotification(_U('vehicle_set_rented', plate, xTarget.getName()))
						end)
					end
				end)
			end
		end)
	end
end)

RegisterNetEvent('tac_vehicleshopvip:getStockItem')
AddEventHandler('tac_vehicleshopvip:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_cardealervip', function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, item.label))
			else
				xPlayer.showNotification(_U('player_cannot_hold'))
			end
		else
			xPlayer.showNotification(_U('not_enough_in_society'))
		end
	end)
end)

RegisterNetEvent('tac_vehicleshopvip:putStockItems')
AddEventHandler('tac_vehicleshopvip:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_cardealervip', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, item.label))
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	end)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:getCategories', function(source, cb)
	cb(categories)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:getVehicles', function(source, cb)
	cb(vehicles)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:buyVehicle', function(source, cb, model, plate)
	local xPlayer = tac.GetPlayerFromId(source)
	local modelPrice

	for k,v in ipairs(vehicles) do
		if model == v.model then
			modelPrice = v.price
			break
		end
	end

	if modelPrice and xPlayer.getMoney() >= modelPrice then
		xPlayer.removeMoney(modelPrice)

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = plate,
			['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
		}, function(rowsChanged)
			xPlayer.showNotification(_U('vehicle_belongs', plate))
			cb(true)
		end)
	else
		cb(false)
	end
end)

tac.RegisterServerCallback('tac_vehicleshopvip:getCommercialVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT price, vehicle FROM cardealervip_vehicles ORDER BY vehicle ASC', {}, function(result)
		cb(result)
	end)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:buycardealervipVehicle', function(source, cb, model)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'cardealervip' then
		local modelPrice

		for k,v in ipairs(vehicles) do
			if model == v.model then
				modelPrice = v.price
				break
			end
		end

		if modelPrice then
			TriggerEvent('tac_addonaccount:getSharedAccount', 'society_cardealervipvip', function(account)
				if account.money >= modelPrice then
					account.removeMoney(modelPrice)

					MySQL.Async.execute('INSERT INTO cardealervip_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
						['@vehicle'] = model,
						['@price'] = modelPrice
					}, function(rowsChanged)
						cb(true)
					end)
				else
					cb(false)
				end
			end)
		end
	end
end)

RegisterNetEvent('tac_vehicleshopvip:returnProvider')
AddEventHandler('tac_vehicleshopvip:returnProvider', function(vehicleModel)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'cardealervip' then
		MySQL.Async.fetchAll('SELECT id, price FROM cardealervip_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicleModel
		}, function(result)
			if result[1] then
				local id = result[1].id

				MySQL.Async.execute('DELETE FROM cardealervip_vehicles WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						TriggerEvent('tac_addonaccount:getSharedAccount', 'society_cardealervip', function(account)
							local price = tac.Math.Round(result[1].price * 0.75)
							local vehicleLabel = getVehicleLabelFromModel(vehicleModel)

							account.addMoney(price)
							xPlayer.showNotification(_U('vehicle_sold_for', vehicleLabel, tac.Math.GroupDigits(price)))
						end)
					end
				end)
			else
				print(('[tac_vehicleshopvip] [^3WARNING^7] %s attempted selling an invalid vehicle!'):format(xPlayer.identifier))
			end
		end)
	end
end)

tac.RegisterServerCallback('tac_vehicleshopvip:getRentedVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles ORDER BY player_name ASC', {}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				plate = result[i].plate,
				playerName = result[i].player_name
			})
		end

		cb(vehicles)
	end)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:giveBackVehicle', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT base_price, vehicle FROM rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			local vehicle = result[1].vehicle
			local basePrice = result[1].base_price

			MySQL.Async.execute('DELETE FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(rowsChanged)
				MySQL.Async.execute('INSERT INTO cardealervip_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
					['@vehicle'] = vehicle,
					['@price']   = basePrice
				})

				RemoveOwnedVehicle(plate)
				cb(true)
			end)
		else
			cb(false)
		end
	end)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:resellVehicle', function(source, cb, plate, model)
	local xPlayer, resellPrice = tac.GetPlayerFromId(source)

	if xPlayer.job.name == 'cardealervip' then
		-- calculate the resell price
		for i=1, #vehicles, 1 do
			if GetHashKey(vehicles[i].model) == model then
				resellPrice = tac.Math.Round(vehicles[i].price / 100 * Config.ResellPercentage)
				break
			end
		end

		if not resellPrice then
			print(('[tac_vehicleshopvip] [^3WARNING^7] %s attempted to sell an unknown vehicle!'):format(xPlayer.identifier))
			cb(false)
		else
			MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(result)
				if result[1] then -- is it a rented vehicle?
					cb(false) -- it is, don't let the player sell it since he doesn't own it
				else
					MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
						['@owner'] = xPlayer.identifier,
						['@plate'] = plate
					}, function(result)
						if result[1] then -- does the owner match?
							local vehicle = json.decode(result[1].vehicle)

							if vehicle.model == model then
								if vehicle.plate == plate then
									xPlayer.addMoney(resellPrice)
									RemoveOwnedVehicle(plate)
									cb(true)
								else
									print(('[tac_vehicleshopvip] [^3WARNING^7] %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
									cb(false)
								end
							else
								print(('[tac_vehicleshopvip] [^3WARNING^7] %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
								cb(false)
							end
						end
					end)
				end
			end)
		end
	end
end)

tac.RegisterServerCallback('tac_vehicleshopvip:getStockItems', function(source, cb)
	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_cardealervip', function(inventory)
		cb(inventory.items)
	end)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:getPlayerInventory', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({items = items})
end)

tac.RegisterServerCallback('tac_vehicleshopvip:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

tac.RegisterServerCallback('tac_vehicleshopvip:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('tac_vehicleshopvip:setJobVehicleState')
AddEventHandler('tac_vehicleshopvip:setJobVehicleState', function(plate, state)
	local xPlayer = tac.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[tac_vehicleshopvip] [^3WARNING^7] %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

function PayRent(d, h, m)
	local tasks, timeStart = {}, os.clock()
	print('[tac_vehicleshopvip] [^2INFO^7] Paying rent cron job started')

	MySQL.Async.fetchAll('SELECT owner, rent_price FROM rented_vehicles', {}, function(result)
		for i=1, #result, 1 do
			table.insert(tasks, function(cb)
				local xPlayer = tac.GetPlayerFromIdentifier(result[i].owner)

				if xPlayer then -- message player if connected
					xPlayer.removeAccountMoney('bank', result[i].rent_price)
					xPlayer.showNotification(_U('paid_rental', tac.Math.GroupDigits(result[i].rent_price)))
				else -- pay rent by updating SQL
					MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', {
						['@bank'] = result[i].rent_price,
						['@identifier'] = result[i].owner
					})
				end

				TriggerEvent('tac_addonaccount:getSharedAccount', 'society_cardealervip', function(account)
					account.addMoney(result[i].rent_price)
				end)

				cb()
			end)
		end

		Async.parallelLimit(tasks, 5, function(results) end)

		local elapsedTime = os.clock() - timeStart
		print(('[tac_vehicleshopvip] [^2INFO^7] Paying rent cron job took %s seconds'):format(elapsedTime))
	end)
end

TriggerEvent('cron:runAt', 22, 00, PayRent)
