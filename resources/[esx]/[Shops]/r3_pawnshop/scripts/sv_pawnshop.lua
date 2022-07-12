tac = nil

TriggerEvent('tac:getSharedObject', function(obj)
    tac = obj
end) 

RegisterServerEvent("r3_prospecting:sellItem")
AddEventHandler("r3_prospecting:sellItem", function(itemName, amount)
	local xPlayer = tac.GetPlayerFromId(source)
	local price = Config.PawnshopItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('r3_prospecting: %s Intento vender un item invalido!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent("r3_notifications:client:sendNotification", source, "No tienes suficientes items!", "error", 5000)
		return
	end

	price = tac.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)
	TriggerClientEvent("r3_notifications:client:sendNotification", source, "Vendiste " .. amount .. " " .. xItem.label .. " Por $" .. tac.Math.GroupDigits(price), "success", 5000)
end)