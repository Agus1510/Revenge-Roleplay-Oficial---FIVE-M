tac               = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

local cooldown = 0
local cooldowntime = 600 * 6000

function Timer()
	cooldown = 1
	Citizen.Wait(cooldowntime)
	cooldown = 0
end

RegisterServerEvent('tac_yate:robbery')
AddEventHandler('tac_yate:robbery', function(text)
	local _source  = source
	local xPlayer  = tac.GetPlayerFromId(_source)
	local xPlayers = tac.GetPlayers()
	local police = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			police = police+1
		end
	end
		if police > Config.LSPD-1 and cooldown == 0 then
			TriggerClientEvent("tac_yate:start", source)
			TriggerClientEvent("tac_yate:true", source)
			TriggerClientEvent("tac_yate:notification", source, _U('robbery_started'))
			LSPD()
			Citizen.Wait(1000)
			Timer()
		end

		if cooldown == 1 then
			TriggerClientEvent("tac_yate:notification", source, _U('robbed_recent'))
		end

		if police < Config.LSPD then
			TriggerClientEvent("tac_yate:notification", source, _U('police'))
		end
end)

RegisterServerEvent('tac_yate:reward')
AddEventHandler('tac_yate:reward', function()
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)
	
	xPlayer.addMoney(math.random(Config.MinReward,Config.MaxReward))
end)

function LSPD()
	local _source = source
	local xPlayers = tac.GetPlayers()

	for i=1, #xPlayers, 1 do
		xPlayer = tac.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent("tac_yate:notify", -1)
		end
	end
end
