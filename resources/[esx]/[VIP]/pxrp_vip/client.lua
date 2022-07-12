tac = nil
local PlayerLoaded = false
vip = false

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end

	PlayerLoaded = true
	tac.PlayerData = tac.GetPlayerData()
end)

RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
	tac.PlayerData = xPlayer
	PlayerLoaded = true
end)

AddEventHandler('playerSpawned', function()
	vip = false
	tac.TriggerServerCallback('pxrp_vip:getVIPStatus', function(vip)
		if vip then
			while not PlayerLoaded do
				Citizen.Wait(1000)
			end

	tac.ShowNotification("Status VIP: Activo")
		end
	end)
end)

function addVIPStatus()
	TriggerServerEvent('pxrp_vip:setVIPStatus', true)
	vip = true
end

function removeVIPStatus()
	TriggerServerEvent('pxrp_vip:setVIPStatus', false)
	vip = false
end

RegisterNetEvent('pxrp_vip:addVIPStatus')
AddEventHandler('pxrp_vip:addVIPStatus', function()
	addVIPStatus()
end)

RegisterNetEvent('pxrp_vip:removeVIPStatus')
AddEventHandler('pxrp_vip:removeVIPStatus', function()
	removeVIPStatus()
end)
