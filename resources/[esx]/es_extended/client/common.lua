AddEventHandler('tac:getSharedObject', function(cb)
	cb(tac)
end)

function getSharedObject()
	return tac
end
