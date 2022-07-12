tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('rev_hud_ui:syncCarLights')
AddEventHandler('rev_hud_ui:syncCarLights', function(status)
	TriggerClientEvent('rev_hud_ui:syncCarLights', -1, source, status)
end)

TriggerEvent('es:addCommand', 'not', function()
end, {help = ''})


RegisterServerEvent('rev_hud_ui:admNotifyCheck')
AddEventHandler('rev_hud_ui:admNotifyCheck', function(args)
	local xPlayer = tac.GetPlayerFromId(source)
	if (xPlayer.getGroup() == 'admin') or (xPlayer.getGroup() == 'superadmin') then
		TriggerClientEvent('rev_hud_ui:admNotifyPrompt', source, args)
	end
end)

RegisterServerEvent('rev_hud_ui:adminNotifyAllPlayers')
AddEventHandler('rev_hud_ui:adminNotifyAllPlayers', function(args)

	local xPlayers = tac.GetPlayers()

	for i=1, #xPlayers, 1 do
		TriggerClientEvent('rev_hud_ui:admNotifyShow', xPlayers[i], args)
	end
	
end)