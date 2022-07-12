tac = nil
local Users = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterServerCallback('tac_thief:getValue', function(source, cb, targetSID)
	if Users[targetSID] then
		cb(Users[targetSID])
	else
		cb({value = false, time = 0})
	end
end)

tac.RegisterServerCallback('tac_thief:getOtherPlayerData', function(source, cb, target)
	local xPlayer = tac.GetPlayerFromId(target)

	local data = {
		name = GetPlayerName(target),
		inventory = xPlayer.inventory,
		accounts = xPlayer.accounts,
		money = xPlayer.getMoney()
	}

	cb(data)
end)

RegisterServerEvent('tac_thief:stealPlayerItem')
AddEventHandler('tac_thief:stealPlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = tac.GetPlayerFromId(_source)
	local targetXPlayer = tac.GetPlayerFromId(target)

	if itemType == 'item_standard' then

		local label = sourceXPlayer.getInventoryItem(itemName).label
		local itemLimit = sourceXPlayer.getInventoryItem(itemName).limit
		local sourceItemCount = sourceXPlayer.getInventoryItem(itemName).count
		local targetItemCount = targetXPlayer.getInventoryItem(itemName).count

		if amount > 0 and targetItemCount >= amount then
			if itemLimit ~= -1 and (sourceItemCount + amount) > itemLimit then
				TriggerClientEvent('tac:showNotification', targetXPlayer.source, _U('ex_inv_lim_target'))
				TriggerClientEvent('tac:showNotification', sourceXPlayer.source, _U('ex_inv_lim_source'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)

				TriggerClientEvent('tac:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~x' .. amount .. ' ' .. label .. ' ~w~' .. _U('from_your_target') )
				TriggerClientEvent('tac:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~x'  .. amount .. ' ' .. label )
			end
		else
			TriggerClientEvent('tac:showNotification', _source, _U('invalid_quantity'))
		end

	elseif itemType == 'item_money' then

		if amount > 0 and targetXPlayer.get('money') >= amount then
			targetXPlayer.removeMoney(amount)
			sourceXPlayer.addMoney(amount)

			TriggerClientEvent('tac:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~$' .. amount .. ' ~w~' .. _U('from_your_target') )
			TriggerClientEvent('tac:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~$'  .. amount )
		else
			TriggerClientEvent('tac:showNotification', _source, _U('imp_invalid_amount'))
		end

	elseif itemType == 'item_account' then

		if amount > 0 and targetXPlayer.getAccount(itemName).money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney(itemName, amount)

			TriggerClientEvent('tac:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~$' .. amount .. ' ~w~' .. _U('of_black_money') .. ' ' .. _U('from_your_target') )
			TriggerClientEvent('tac:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~$'  .. amount .. ' ~w~' .. _U('of_black_money') )
		else
			TriggerClientEvent('tac:showNotification', _source, _U('imp_invalid_amount'))
		end

	end
end)

RegisterServerEvent('tac_thief:update')
AddEventHandler('tac_thief:update', function(bool)
	local _source = source
	Users[_source] = {value = bool, time = os.time()}
end)

RegisterServerEvent('tac_thief:getValue')
AddEventHandler('tac_thief:getValue', function(targetSID)
	local _source = source
	if Users[targetSID] then
		TriggerClientEvent('tac_thief:returnValue', _source, Users[targetSID])
	else
		TriggerClientEvent('tac_thief:returnValue', _source, Users[targetSID])
	end
end)