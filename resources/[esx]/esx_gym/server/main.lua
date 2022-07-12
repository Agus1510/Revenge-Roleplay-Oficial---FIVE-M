tac = nil

TriggerEvent('tac:getSharedObject', function(obj)
	tac = obj
end)

RegisterServerEvent('tac_gym:hireBmx')
AddEventHandler('tac_gym:hireBmx', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 250) then
		xPlayer.removeMoney(250)
			
		notification("You hired a ~g~BMX")
	else
		notification("You stole the bike because you didn't have enough ~r~money")
	end	
end)

RegisterServerEvent('tac_gym:hireCruiser')
AddEventHandler('tac_gym:hireCruiser', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 300) then
		xPlayer.removeMoney(300)
			
		notification("You hired a ~g~CRUISER")
	else
		notification("You stole the bike because you didn't have enough ~r~money")
	end	
end)

RegisterServerEvent('tac_gym:hireFixter')
AddEventHandler('tac_gym:hireFixter', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 329) then
		xPlayer.removeMoney(329)
			
		notification("You hired a ~g~FIXTER")
	else
		notification("You stole the bike because you didn't have enough ~r~money")
	end	
end)

RegisterServerEvent('tac_gym:hireScorcher')
AddEventHandler('tac_gym:hireScorcher', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 400) then
		xPlayer.removeMoney(400)
			
		notification("You hired a ~g~SCORCHER")
	else
		notification("You stole the bike because you didn't have enough ~r~money")
	end	
end)

RegisterServerEvent('tac_gym:checkChip')
AddEventHandler('tac_gym:checkChip', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local oneQuantity = xPlayer.getInventoryItem('gym_membership').count
	
	if oneQuantity > 0 then
		TriggerClientEvent('tac_gym:trueMembership', source) -- true
	else
		TriggerClientEvent('tac_gym:falseMembership', source) -- false
	end
end)

tac.RegisterUsableItem('gym_bandage', function(source)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('gym_bandage', 1)	
	
	TriggerClientEvent('tac_gym:useBandage', source)
end)

RegisterServerEvent('tac_gym:buyBandage')
AddEventHandler('tac_gym:buyBandage', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 50) then
		xPlayer.removeMoney(50)
		
		xPlayer.addInventoryItem('gym_bandage', 1)		
		notification("You purchased a ~g~bandage")
	else
		notification("You do not have enough ~r~money")
	end	
end)

RegisterServerEvent('tac_gym:buyMembership')
AddEventHandler('tac_gym:buyMembership', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 800) then
		xPlayer.removeMoney(800)
		
		xPlayer.addInventoryItem('gym_membership', 1)		
		notification("You purchased a ~g~membership")
		
		TriggerClientEvent('tac_gym:trueMembership', source) -- true
	else
		notification("You do not have enough ~r~money")
	end	
end)


RegisterServerEvent('tac_gym:buyProteinshake')
AddEventHandler('tac_gym:buyProteinshake', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 6) then
		xPlayer.removeMoney(6)
		
		xPlayer.addInventoryItem('protein_shake', 1)
		
		notification("You purchased a ~g~protein shake")
	else
		notification("You do not have enough ~r~money")
	end	
end)

tac.RegisterUsableItem('protein_shake', function(source)

	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('protein_shake', 1)

	TriggerClientEvent('tac_status:add', source, 'thirst', 350000)
	TriggerClientEvent('tac_basicneeds:onDrink', source)
	TriggerClientEvent('tac:showNotification', source, 'You drank a ~g~protein shake')

end)

RegisterServerEvent('tac_gym:buyWater')
AddEventHandler('tac_gym:buyWater', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 1) then
		xPlayer.removeMoney(1)
		
		xPlayer.addInventoryItem('water', 1)
		
		notification("You purchased a ~g~water")
	else
		notification("You do not have enough ~r~money")
	end		
end)

RegisterServerEvent('tac_gym:buySportlunch')
AddEventHandler('tac_gym:buySportlunch', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 2) then
		xPlayer.removeMoney(2)
		
		xPlayer.addInventoryItem('sportlunch', 1)
		
		notification("You purchased a ~g~sportlunch")
	else
		notification("You do not have enough ~r~money")
	end		
end)

tac.RegisterUsableItem('sportlunch', function(source)

	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sportlunch', 1)

	TriggerClientEvent('tac_status:add', source, 'hunger', 350000)
	TriggerClientEvent('tac_basicneeds:onEat', source)
	TriggerClientEvent('tac:showNotification', source, 'You ate a ~g~sportlunch')

end)

RegisterServerEvent('tac_gym:buyPowerade')
AddEventHandler('tac_gym:buyPowerade', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 4) then
		xPlayer.removeMoney(4)
		
		xPlayer.addInventoryItem('powerade', 1)
		
		notification("You purchased a ~g~powerade")
	else
		notification("You do not have enough ~r~money")
	end		
end)

tac.RegisterUsableItem('powerade', function(source)

	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('powerade', 1)

	TriggerClientEvent('tac_status:add', source, 'thirst', 700000)
	TriggerClientEvent('tac_basicneeds:onDrink', source)
	TriggerClientEvent('tac:showNotification', source, 'You drank a ~g~powerade')

end)

-- FUNCTIONS IN THE FUTURE (COMING SOON...)

--RegisterServerEvent('tac_gym:trainArms')
--AddEventHandler('tac_gym:trainArms', function()
	
--end)

--RegisterServerEvent('tac_gym:trainChins')
--AddEventHandler('tac_gym:trainArms', function()
	
--end)

--RegisterServerEvent('tac_gym:trainPushups')
--AddEventHandler('tac_gym:trainPushups', function()
	
--end)

--RegisterServerEvent('tac_gym:trainYoga')
--AddEventHandler('tac_gym:trainYoga', function()
	
--end)

--RegisterServerEvent('tac_gym:trainSitups')
--AddEventHandler('tac_gym:trainSitups', function()
	
--end)

function notification(text)
	TriggerClientEvent('tac:showNotification', source, text)
end
