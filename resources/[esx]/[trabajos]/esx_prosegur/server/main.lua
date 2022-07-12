tac = nil
local PlayersSell = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_brinks:GiveItem')
AddEventHandler('tac_brinks:GiveItem', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	local quantity = xPlayer.getInventoryItem(Config.Zones.Sell.ItemRequires).count

	if quantity >= 20 then
		TriggerClientEvent('tac:showNotification', _source, _U('stop_npc'))
		return
	else
		local amount = Config.Zones.Sell.ItemAdd
		local item = Config.Zones.Sell.ItemDb_name

		xPlayer.addInventoryItem(item, amount)
		TriggerClientEvent('tac:showNotification', _source, 'Vous avez vidé ~g~x' .. amount .. ' DAB')
	end
end)

local function Sell(source)
	SetTimeout(Config.Zones.Sell.ItemTime, function()
		if PlayersSell[source] == true then
			local _source = source
			local xPlayer = tac.GetPlayerFromId(_source)

			local quantity = xPlayer.getInventoryItem(Config.Zones.Sell.ItemRequires).count

			if quantity < Config.Zones.Sell.ItemRemove then
				TriggerClientEvent('tac:showNotification', _source, '~r~Vous n\'avez plus de sac de billets !')
				PlayersSell[_source] = false
			else
				local amount = Config.Zones.Sell.ItemRemove
				local item = Config.Zones.Sell.ItemRequires

				xPlayer.removeInventoryItem(item, amount)
				xPlayer.addMoney(Config.Zones.Sell.ItemPrice)
				TriggerClientEvent('tac:showNotification', _source, 'Vous avez reçu ~g~$' .. Config.Zones.Sell.ItemPrice)
				Sell(_source)
			end
		end
	end)
end

RegisterServerEvent('tac_brinks:startSell')
AddEventHandler('tac_brinks:startSell', function()
	local _source = source

	if PlayersSell[_source] == false then
		TriggerClientEvent('tac:showNotification', _source, '~r~Sortez et revenez dans la zone !')
		PlayersSell[_source] = false
	else
		PlayersSell[_source] = true
		TriggerClientEvent('tac:showNotification', _source, '~g~Action ~w~en cours...')
		Sell(_source)
	end
end)

RegisterServerEvent('tac_brinks:stopSell')
AddEventHandler('tac_brinks:stopSell', function()
	local _source = source

	if PlayersSell[_source] == true then
		PlayersSell[_source] = false
	else
		PlayersSell[_source] = true
	end
end)