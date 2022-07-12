tac = nil

local players = {}

TriggerEvent('tac:getSharedObject', function(obj)
	tac = obj
end)

if Config.MaxInService ~= -1 then
	TriggerEvent('tac_service:activateService', 'gouvernor', Config.MaxInService)
end

TriggerEvent('tac_society:registerSociety', 'gouvernor', 'Gouvernement', 'society_gouvernor', 'society_gouvernor', 'society_gouvernor', {type = 'public'})
-----------------------------------------------------

RegisterServerEvent("tac_gouverneur:addPlayer")
AddEventHandler("tac_gouverneur:addPlayer", function(jobName)
	local _source = source
	players[_source] = jobName
end)

RegisterServerEvent("tac_gouverneur:sendSonnette")
AddEventHandler("tac_gouverneur:sendSonnette", function()
	local _source = source
	for i,k in pairs(players) do
		if(k~=nil) then
			if(k == "gouvernor") then
				TriggerClientEvent("tac_gouverneur:sendRequest", i, GetPlayerName(_source), _source)
			end
		end
	end

end)

RegisterServerEvent("tac_gouverneur:sendStatusToPoeple")
AddEventHandler("tac_gouverneur:sendStatusToPoeple", function(id, status)
	TriggerClientEvent("tac_gouverneur:sendStatus", id, status)
end)

-------------------------------------------------------

TriggerEvent('tac_rvphone:registerNumber', 'gouvernor', _U('client'), true, true)

AddEventHandler('tac_rvphone:ready', function()

	TriggerEvent('tac_rvphone:registerCallback', function(source, rvphoneNumber, message, anon)

		local xPlayer  = tac.GetPlayerFromId(source)
		local xPlayers = tac.GetPlayers()
		local job      = 'Citoyen'

		if rvphoneNumber == "gouvernor" then

			for i=1, #xPlayers, 1 do

				local xPlayer2 = tac.GetPlayerFromId(xPlayers[i])
				
				if xPlayer2.job.name == 'gouvernor' and xPlayer2.job.grade_name == 'boss' then
					TriggerClientEvent('tac_rvphone:onMessage', xPlayer2.source, xPlayer.get('rvphoneNumber'), message, xPlayer.get('coords'), anon, job, false)
				end
			end

		end
		
	end)

end)

RegisterServerEvent('tac_gouverneur:giveWeapon')
AddEventHandler('tac_gouverneur:giveWeapon', function(weapon, ammo)
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('tac_gouverneur:removeWeapon')
AddEventHandler('tac_gouverneur:removeWeapon', function(weapon)
	local xPlayer = tac.GetPlayerFromId(source)
	xPlayer.removeWeapon(weapon)
end)

TriggerEvent('tac_rvphone:registerCallback', function(source, rvphoneNumber, message, anon)

	local xPlayer  = tac.GetPlayerFromId(source)
	local xPlayers = tac.GetPlayers()

	if rvphoneNumber == 'gouvernor' then
		for i=1, #xPlayers, 1 do

			local xPlayer2 = tac.GetPlayerFromId(xPlayers[i])
			
			if xPlayer2.job.name == 'gouvernor' and xPlayer2.job.grade_name == 'boss' then
				TriggerClientEvent('tac_rvphone:onMessage', xPlayer2.source, xPlayer.get('rvphoneNumber'), message, xPlayer.get('coords'), anon, 'player')
			end
		end
	end
	
end)