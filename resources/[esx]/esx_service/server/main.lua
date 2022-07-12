tac                = nil
local InService    = {}
local MaxInService = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function GetInServiceCount(name)
	local count = 0

	for k,v in pairs(InService[name]) do
		if v == true then
			count = count + 1
		end
	end

	return count
end

AddEventHandler('tac_service:activateService', function(name, max)
	InService[name]    = {}
	MaxInService[name] = max
end)

RegisterServerEvent('tac_service:disableService')
AddEventHandler('tac_service:disableService', function(name)
	InService[name][source] = nil
end)

RegisterServerEvent('tac_service:notifyAllInService')
AddEventHandler('tac_service:notifyAllInService', function(notification, name)
	for k,v in pairs(InService[name]) do
		if v == true then
			TriggerClientEvent('tac_service:notifyAllInService', k, notification, source)
		end
	end
end)

tac.RegisterServerCallback('tac_service:enableService', function(source, cb, name)
	local inServiceCount = GetInServiceCount(name)

	if inServiceCount >= MaxInService[name] then
		cb(false, MaxInService[name], inServiceCount)
	else
		InService[name][source] = true
		cb(true, MaxInService[name], inServiceCount)
	end
end)

tac.RegisterServerCallback('tac_service:isInService', function(source, cb, name)
	local isInService = false

	if InService[name][source] then
		isInService = true
	end

	cb(isInService)
end)

tac.RegisterServerCallback('tac_service:getInServiceList', function(source, cb, name)
	cb(InService[name])
end)

AddEventHandler('playerDropped', function()
	local _source = source
		
	for k,v in pairs(InService) do
		if v[_source] == true then
			v[_source] = nil
		end
	end
end)