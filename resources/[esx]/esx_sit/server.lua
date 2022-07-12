tac = nil

local SeatsTaken = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

-- SEATS
RegisterServerEvent('tac_interact:takePlace')
AddEventHandler('tac_interact:takePlace', function(object)
	table.insert(SeatsTaken, object)
end)

RegisterServerEvent('tac_interact:leavePlace')
AddEventHandler('tac_interact:leavePlace', function(object)

	local _SeatsTaken = {}

	for i=1, #SeatsTaken, 1 do
		if object ~= SeatsTaken[i] then
			table.insert(_SeatsTaken, SeatsTaken[i])
		end
	end

	SeatsTaken = _SeatsTaken
	
end)

tac.RegisterServerCallback('tac_interact:getPlace', function(source, cb, id)
	local found = false

	for i=1, #SeatsTaken, 1 do
		if SeatsTaken[i] == id then
			found = true
		end
	end
	cb(found)
end)