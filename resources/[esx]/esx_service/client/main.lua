tac = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('tac_service:notifyAllInService')
AddEventHandler('tac_service:notifyAllInService', function(notification, target)
	target = GetPlayerFromServerId(target)
	if target == PlayerId() then return end

	local targetPed = GetPlayerPed(target)
	local mugshot, mugshotStr = tac.Game.GetPedMugshot(targetPed)

	tac.ShowAdvancedNotification(notification.title, notification.subject, notification.msg, mugshotStr, notification.iconType)
	UnregisterPedheadshot(mugshot)
end)