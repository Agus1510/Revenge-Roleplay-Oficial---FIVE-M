tac = nil
local connectedPlayers = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterServerCallback('tac_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)

AddEventHandler('tac:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('tac_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('tac:playerLoaded', function(playerId, xPlayer)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('tac:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('tac_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		UpdatePing()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].ping = GetPlayerPing(playerId)
	connectedPlayers[playerId].id = playerId
	connectedPlayers[playerId].name = Sanitize(xPlayer.getName())
	connectedPlayers[playerId].job = xPlayer.job.name

	if update then
		TriggerClientEvent('tac_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	end

	if xPlayer.getGroup() == 'user' then
		Citizen.CreateThread(function()
			Citizen.Wait(3000)
			TriggerClientEvent('tac_scoreboard:toggleID', playerId, false)
		end)
	end
end

function AddPlayersToScoreboard()
	local players = tac.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = tac.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
	end

	TriggerClientEvent('tac_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end

function UpdatePing()
	for k,v in pairs(connectedPlayers) do
		v.ping = GetPlayerPing(k)
	end

	TriggerClientEvent('tac_scoreboard:updatePing', -1, connectedPlayers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

TriggerEvent('es:addGroupCommand', 'screfresh', 'admin', function(source, args, user)
	AddPlayersToScoreboard()
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Refresh tac_scoreboard names!'})

TriggerEvent('es:addGroupCommand', 'sctoggle', 'admin', function(source, args, user)
	TriggerClientEvent('tac_scoreboard:toggleID', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Toggle ID column on the scoreboard!'})