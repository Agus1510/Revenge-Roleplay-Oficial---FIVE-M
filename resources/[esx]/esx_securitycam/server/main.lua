tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_securitycam:unhackanimserver')
AddEventHandler('tac_securitycam:unhackanimserver', function()
	local _source = source
	TriggerClientEvent('tac_securitycam:unhackanim', _source)
end)

RegisterServerEvent('tac_securitycam:setBankHackedState')
AddEventHandler('tac_securitycam:setBankHackedState', function(state)
	print(('tac_securitycam: %s has set the bank cameras to %s!'):format(GetPlayerIdentifiers(source)[1], state))
	TriggerClientEvent('tac_securitycam:setBankHackedState', -1, state)
end)

RegisterServerEvent('tac_securitycam:setPoliceHackedState')
AddEventHandler('tac_securitycam:setPoliceHackedState', function(state)
	print(('tac_securitycam: %s has set the police cameras to %s!'):format(GetPlayerIdentifiers(source)[1], state))
	TriggerClientEvent('tac_securitycam:setPoliceHackedState', -1, state)
end)