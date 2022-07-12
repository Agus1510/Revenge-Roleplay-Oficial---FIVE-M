tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterUsableItem('bread', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('tac_status:add', source, 'hunger', 200000)
	TriggerClientEvent('tac_basicneeds:onEat', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_bread'))
end)

tac.RegisterUsableItem('chocolate', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chocolate', 1)

	TriggerClientEvent('tac_status:add', source, 'hunger', 100000)
	TriggerClientEvent('tac_status:add', source, 'thirst', 40000)
	TriggerClientEvent('tac_basicneeds:onEatChocolate', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_chocolate'))
end)

tac.RegisterUsableItem('sandwich', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sandwich', 1)

	TriggerClientEvent('tac_status:add', source, 'hunger', 150000)
	TriggerClientEvent('tac_status:add', source, 'thirst', 70000)
	TriggerClientEvent('tac_basicneeds:onEatSandwich', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_sandwich'))
end)

tac.RegisterUsableItem('hamburger', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburger', 1)

	TriggerClientEvent('tac_status:add', source, 'hunger', 350000)
	TriggerClientEvent('tac_status:add', source, 'thirst', 70000)
	TriggerClientEvent('tac_basicneeds:onEat', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_hamburger'))
end)

tac.RegisterUsableItem('cupcake', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cupcake', 1)

	TriggerClientEvent('tac_status:add', source, 'hunger', 100000)
	TriggerClientEvent('tac_status:add', source, 'thirst', 30000)
	TriggerClientEvent('tac_basicneeds:onEatCupCake', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_cupcake'))
end)

tac.RegisterUsableItem('chips', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chips', 1)

	TriggerClientEvent('tac_status:add', source, 'hunger', 250000)
	TriggerClientEvent('tac_status:add', source, 'thirst', 30000)
	TriggerClientEvent('tac_basicneeds:onEatChips', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_chips'))
end)

tac.RegisterUsableItem('water', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('tac_status:add', source, 'thirst', 200000)
	TriggerClientEvent('tac_status:add', source, 'hunger', 30000)
	TriggerClientEvent('tac_basicneeds:onDrink', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_water'))
end)

tac.RegisterUsableItem('cocacola', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cocacola', 1)

	TriggerClientEvent('tac_status:add', source, 'thirst', 200000)
	TriggerClientEvent('tac_status:add', source, 'hunger', 60000)
	TriggerClientEvent('tac_basicneeds:onDrinkCocaCola', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_cocacola'))
end)

tac.RegisterUsableItem('icetea', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('icetea', 1)

	TriggerClientEvent('tac_status:add', source, 'thirst', 200000)
	TriggerClientEvent('tac_status:add', source, 'hunger', 80000)
	TriggerClientEvent('tac_basicneeds:onDrinkIceTea', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_icetea'))
end)

tac.RegisterUsableItem('coffe', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coffe', 1)

	TriggerClientEvent('tac_status:add', source, 'thirst', 200000)
	TriggerClientEvent('tac_status:add', source, 'hunger', 40000)
	TriggerClientEvent('tac_basicneeds:onDrinkCoffe', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_coffe'))
end)

-- Bar stuff
tac.RegisterUsableItem('wine', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('wine', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 100000)
	TriggerClientEvent('tac_basicneeds:onDrinkWine', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_wine'))
end)

tac.RegisterUsableItem('beer', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 150000)
	TriggerClientEvent('tac_basicneeds:onDrinkBeer', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_beer'))
end)

tac.RegisterUsableItem('vodka', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 350000)
	TriggerClientEvent('tac_basicneeds:onDrinkVodka', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_vodka'))
end)

tac.RegisterUsableItem('whisky', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 250000)
	TriggerClientEvent('tac_basicneeds:onDrinkWhisky', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_whisky'))
end)

tac.RegisterUsableItem('tequila', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tequila', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 200000)
	TriggerClientEvent('tac_basicneeds:onDrinkTequila', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_tequila'))
end)

tac.RegisterUsableItem('milk', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('milk', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', -100000)
	TriggerClientEvent('tac_basicneeds:onDrinkMilk', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_milk'))
end)

-- Disco Stuff
tac.RegisterUsableItem('gintonic', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('gintonic', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 150000)
	TriggerClientEvent('tac_basicneeds:onDrinkGin', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_gintonic'))
end)

tac.RegisterUsableItem('absinthe', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('absinthe', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 400000)
	TriggerClientEvent('tac_basicneeds:onDrinkAbsinthe', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_absinthe'))
end)

tac.RegisterUsableItem('champagne', function(source)
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('champagne', 1)

	TriggerClientEvent('tac_status:add', source, 'drunk', 50000)
	TriggerClientEvent('tac_basicneeds:onDrinkChampagne', source)
	TriggerClientEvent('tac:showNotification', source, _U('used_champagne'))
end)

-- Cigarett
tac.RegisterUsableItem('cigarett', function(source)
	local xPlayer = tac.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
		if lighter.count > 0 then
			xPlayer.removeInventoryItem('cigarett', 1)
			TriggerClientEvent('tac_cigarett:startSmoke', source)
		else
			TriggerClientEvent('tac:showNotification', source, ('Não tens ~r~isqueiro'))
		end
end)

TriggerEvent('es:addGroupCommand', 'heal', 'admin', function(source, args, user)
	-- heal another player - don't heal source
	if args[1] then
		local target = tonumber(args[1])
		
		-- is the argument a number?
		if target ~= nil then
			
			-- is the number a valid player?
			if GetPlayerName(target) then
				print('tac_basicneeds: ' .. GetPlayerName(source) .. ' is healing a player!')
				TriggerClientEvent('tac_basicneeds:healPlayer', target)
				TriggerClientEvent('chatMessage', target, "HEAL", {223, 66, 244}, "You have been healed!")
			else
				TriggerClientEvent('chatMessage', source, "HEAL", {255, 0, 0}, "Player not found!")
			end
		else
			TriggerClientEvent('chatMessage', source, "HEAL", {255, 0, 0}, "Incorrect syntax! You must provide a valid player ID")
		end
	else
		-- heal source
		print('tac_basicneeds: ' .. GetPlayerName(source) .. ' is healing!')
		TriggerClientEvent('tac_basicneeds:healPlayer', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "HEAL", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Heal a player, or yourself - restores thirst, hunger and health."})
