tac = nil
local doorState = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_doorlock:updateState')
AddEventHandler('tac_doorlock:updateState', function(doorIndex, state)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer and type(doorIndex) == 'number' and type(state) == 'boolean' and Config.DoorList[doorIndex] and isAuthorized(xPlayer.job.name, Config.DoorList[doorIndex]) then
		doorState[doorIndex] = state
		TriggerClientEvent('tac_doorlock:setDoorState', -1, doorIndex, state)
	end
end)

tac.RegisterServerCallback('tac_doorlock:getDoorState', function(source, cb)
	cb(doorState)
end)

function isAuthorized(jobName, doorObject)
	for k,job in pairs(doorObject.authorizedJobs) do
		if job == jobName then
			return true
		end
	end

	return false
end
