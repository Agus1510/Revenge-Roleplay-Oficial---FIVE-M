tac = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end

	while tac.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	tac.PlayerData = tac.GetPlayerData()
end)

RegisterNetEvent("r3_notifications:client:sendNotification")
AddEventHandler("r3_notifications:client:sendNotification", function(msg, style, duration)
	TriggerServerEvent("r3_notifications:server:sendNotification", msg, style, duration)
end)

function clientSendNotification(msg, style, duration)
	TriggerServerEvent("r3_notifications:server:sendNotification", msg, style, duration)
end