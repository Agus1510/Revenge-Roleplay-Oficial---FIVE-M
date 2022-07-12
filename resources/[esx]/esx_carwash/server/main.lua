tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterServerCallback('tac_carwash:canAfford', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	if Config.EnablePrice then
		if xPlayer.getMoney() >= Config.Price then
			xPlayer.removeMoney(Config.Price)
			cb(true)
		else
			cb(false)
		end
	else
		cb(true)
	end
end)