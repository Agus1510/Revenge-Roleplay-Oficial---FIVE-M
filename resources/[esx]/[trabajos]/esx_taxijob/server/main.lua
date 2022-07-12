tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('tac_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('tac_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('tac_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('tac_taxijob:success')
AddEventHandler('tac_taxijob:success', function()
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('tac_taxijob: %s attempted to trigger success!'):format(xPlayer.identifier))
		return
	end

	math.randomseed(os.time())

	local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)
	local societyAccount

	if xPlayer.job.grade >= 3 then
		total = total * 2
	end

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_taxi', function(account)
		societyAccount = account
	end)

	if societyAccount then
		local playerMoney  = tac.Math.Round(total / 100 * 30)
		local societyMoney = tac.Math.Round(total / 100 * 70)

		xPlayer.addMoney(playerMoney)
		societyAccount.addMoney(societyMoney)

		xPlayer.showNotification(_U('comp_earned', societyMoney, playerMoney))
	else
		xPlayer.addMoney(total)
		xPlayer.showNotification(_U('have_earned', total))
	end

end)

RegisterServerEvent('tac_taxijob:getStockItem')
AddEventHandler('tac_taxijob:getStockItem', function(itemName, count)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('tac_taxijob: %s attempted to trigger getStockItem!'):format(xPlayer.identifier))
		return
	end
	
	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
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
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

tac.RegisterServerCallback('tac_taxijob:getStockItems', function(source, cb)
	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('tac_taxijob:putStockItems')
AddEventHandler('tac_taxijob:putStockItems', function(itemName, count)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('tac_taxijob: %s attempted to trigger putStockItems!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('tac_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, item.label))
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end

	end)

end)

tac.RegisterServerCallback('tac_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)
