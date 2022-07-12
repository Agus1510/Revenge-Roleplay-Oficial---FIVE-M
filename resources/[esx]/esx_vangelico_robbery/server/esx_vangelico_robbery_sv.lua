local rob = false
local robbers = {}
PlayersCrafting    = {}
local CopsConnected  = 0
tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

function CountCops()

	local xPlayers = tac.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

RegisterServerEvent('tac_vangelico_robbery:toofar')
AddEventHandler('tac_vangelico_robbery:toofar', function(robb)
	local source = source
	local xPlayers = tac.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tac:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Stores[robb].nameofstore)
			TriggerClientEvent('tac_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('tac_vangelico_robbery:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('tac:showNotification', source, _U('robbery_has_cancelled') .. Stores[robb].nameofstore)
	end
end)

RegisterServerEvent('tac_vangelico_robbery:endrob')
AddEventHandler('tac_vangelico_robbery:endrob', function(robb)
	local source = source
	local xPlayers = tac.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tac:showNotification', xPlayers[i], _U('end'))
			TriggerClientEvent('tac_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('tac_vangelico_robbery:robberycomplete', source)
		robbers[source] = nil
		TriggerClientEvent('tac:showNotification', source, _U('robbery_has_ended') .. Stores[robb].nameofstore)
	end
end)

RegisterServerEvent('tac_vangelico_robbery:rob')
AddEventHandler('tac_vangelico_robbery:rob', function(robb)

	local source = source
	local xPlayer = tac.GetPlayerFromId(source)
	local xPlayers = tac.GetPlayers()
	
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.SecBetwNextRob and store.lastrobbed ~= 0 then

            TriggerClientEvent('tac_vangelico_robbery:togliblip', source)
			TriggerClientEvent('tac:showNotification', source, _U('already_robbed') .. (Config.SecBetwNextRob - (os.time() - store.lastrobbed)) .. _U('seconds'))
			return
		end

		if rob == false then

			rob = true
			for i=1, #xPlayers, 1 do
				local xPlayer = tac.GetPlayerFromId(xPlayers[i])
				if xPlayer.job.name == 'police' then
					TriggerClientEvent('tac:showNotification', xPlayers[i], _U('rob_in_prog') .. store.nameofstore)
					TriggerClientEvent('tac_vangelico_robbery:setblip', xPlayers[i], Stores[robb].position)
				end
			end

			TriggerClientEvent('tac:showNotification', source, _U('started_to_rob') .. store.nameofstore .. _U('do_not_move'))
			TriggerClientEvent('tac:showNotification', source, _U('alarm_triggered'))
			TriggerClientEvent('tac:showNotification', source, _U('hold_pos'))
			TriggerClientEvent('tac_vangelico_robbery:currentlyrobbing', source, robb)
            CancelEvent()
			Stores[robb].lastrobbed = os.time()
		else
			TriggerClientEvent('tac:showNotification', source, _U('robbery_already'))
		end
	end
end)

RegisterServerEvent('tac_vangelico_robbery:gioielli')
AddEventHandler('tac_vangelico_robbery:gioielli', function()

	local xPlayer = tac.GetPlayerFromId(source)

	xPlayer.addInventoryItem('jewels', math.random(Config.MinJewels, Config.MaxJewels))
end)

RegisterServerEvent('lester:vendita')
AddEventHandler('lester:vendita', function()

	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	local reward = math.floor(Config.PriceForOneJewel * Config.MaxJewelsSell)

	xPlayer.removeInventoryItem('jewels', Config.MaxJewelsSell)
	xPlayer.addMoney(reward)
end)

tac.RegisterServerCallback('tac_vangelico_robbery:conteggio', function(source, cb)
	local xPlayer = tac.GetPlayerFromId(source)

	cb(CopsConnected)
end)

