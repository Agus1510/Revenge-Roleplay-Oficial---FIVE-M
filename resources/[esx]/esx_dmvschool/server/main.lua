tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

AddEventHandler('tac:playerLoaded', function(source)
	TriggerEvent('tac_license:getLicenses', source, function(licenses)
		TriggerClientEvent('tac_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('tac_dmvschool:addLicense')
AddEventHandler('tac_dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('tac_license:addLicense', _source, type, function()
		TriggerEvent('tac_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('tac_dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('tac_dmvschool:pay')
AddEventHandler('tac_dmvschool:pay', function(price)
	local _source = source
	local xPlayer = tac.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('tac:showNotification', _source, _U('you_paid', tac.Math.GroupDigits(price)))
end)
