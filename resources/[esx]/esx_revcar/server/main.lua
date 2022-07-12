tac = nil

local Categories = {}
local Vehicles   = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)




--1:模组名 2:车牌
TriggerEvent('es:addGroupCommand', 'givecar', 'superadmin', function(source, args, user)
	TriggerClientEvent('nuo:spawnVehicleBySql',source,args[1],args[2])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,'')
end)

RegisterServerEvent('nuo:setVehicleBySql')
AddEventHandler('nuo:setVehicleBySql', function (vehicleProps)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)
		TriggerClientEvent('tac:showNotification', _source,'addCar:palte:'..vehicleProps.plate)
	end)
end)

--1:模组名 2:车牌 3:玩家id
TriggerEvent('es:addGroupCommand', 'giveyoucar', 'superadmin', function(source, args, user)
	--TriggerClientEvent('tac:spawnVehicle', source, args[1])
	TriggerClientEvent('nuo:spawnYouVehicleBySql',source,args[1],args[2],args[3])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,'')
end)

RegisterServerEvent('nuo:setYouVehicleBySql')
AddEventHandler('nuo:setYouVehicleBySql', function (vehicleProps,youId)
	local _source = youId
	local xPlayer = tac.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)
		TriggerClientEvent('tac:showNotification', _source,'addCar:palte:'..vehicleProps.plate)
	end)
end)


--根据车牌删除车
TriggerEvent('es:addGroupCommand', 'delcarbyplate', 'superadmin', function(source, args, user)	
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = args[1]
	})
	TriggerClientEvent('tac:showNotification', source,'delcar:palte:'..args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,'')
end)