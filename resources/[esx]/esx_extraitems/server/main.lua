tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

-- Start of Dark Net

TriggerEvent('tac_rvphone:registerNumber', 'darknet', _U('phone_darknet'), true, false, true, true)

function OnDarkNetItemChange(source)
	local xPlayer  = tac.GetPlayerFromId(source)
	local found    = false
	local darknet  = xPlayer.getInventoryItem('darknet')

	if darknet.count > 0 then
		found = true
	end

	if found then
		TriggerEvent('tac_rvphone:addSource', 'darknet', source)
	else
		TriggerEvent('tac_rvphone:removeSource', 'darknet', source)
	end
end

RegisterServerEvent('tac_rvphone:reload')
AddEventHandler('tac_rvphone:reload', function(phoneNumber)
--AddEventHandler('tac:playerLoaded', function(source)
	local xPlayer  = tac.GetPlayerFromId(source)
	local darknet  = xPlayer.getInventoryItem('darknet')

	if darknet.count > 0 then
		TriggerEvent('tac_rvphone:addSource', 'darknet', source)
	end
end)

AddEventHandler('tac:playerDropped', function(source)
	TriggerEvent('tac_rvphone:removeSource', 'darknet', source)
end)

AddEventHandler('tac:onAddInventoryItem', function(source, item, count)
	if item.name == 'darknet' then
		OnDarkNetItemChange(source)
	end
end)

AddEventHandler('tac:onRemoveInventoryItem', function(source, item, count)
	if item.name == 'darknet' then
		OnDarkNetItemChange(source)
	end
end)

-- End of Dark Net

-- Oxygen Mask
tac.RegisterUsableItem('oxygen_mask', function(source)
	TriggerClientEvent('tac_extraitems:oxygen_mask', source)
	local xPlayer  = tac.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('oxygen_mask', 1)
end)

-- Bullet-Proof Vest
tac.RegisterUsableItem('bulletproof', function(source)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_extraitems:bulletproof', source)
	xPlayer.removeInventoryItem('bulletproof', 1)
end)

-- First Aid Kit
tac.RegisterUsableItem('firstaidkit', function(source)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_extraitems:firstaidkit', source)
	xPlayer.removeInventoryItem('firstaidkit', 1)
end)

-- Weapon Clip
tac.RegisterUsableItem('clip', function(source)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_extraitems:clipcli', source)
	xPlayer.removeInventoryItem('clip', 1)
end)

-- Drill
tac.RegisterUsableItem('drill', function(source)
    local xPlayer = tac.GetPlayerFromId(source)
    TriggerClientEvent('tac_extraitems:startDrill', source)
	xPlayer.removeInventoryItem('drill', 1)
end)

-- Lock Pick
tac.RegisterUsableItem('lockpick', function(source)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_extraitems:lockpick', _source)
	xPlayer.removeInventoryItem('lockpick', 1)
end)

-- Binoculars
tac.RegisterUsableItem('binoculars', function(source)
	local xPlayer = tac.GetPlayerFromId(source)
	TriggerClientEvent('tac_extraitems:binoculars', source)
end)
