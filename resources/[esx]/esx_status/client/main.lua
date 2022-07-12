tac = nil
local Status, isPaused = {}, false

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

function GetStatusData(minimal)
	local status = {}

	for i=1, #Status, 1 do
		if minimal then
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				percent = (Status[i].val / Config.StatusMax) * 100
			})
		else
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				color   = Status[i].color,
				visible = Status[i].visible(Status[i]),
				max     = Status[i].max,
				percent = (Status[i].val / Config.StatusMax) * 100
			})
		end
	end

	return status
end

AddEventHandler('tac_status:registerStatus', function(name, default, color, visible, tickCallback)
	local status = CreateStatus(name, default, color, visible, tickCallback)
	table.insert(Status, status)
end)

AddEventHandler('tac_status:unregisterStatus', function(name)
	for k,v in ipairs(Status) do
		if v.name == name then
			table.remove(Status, k)
			break
		end
	end
end)

RegisterNetEvent('tac_status:load')
AddEventHandler('tac_status:load', function(status)
	for i=1, #Status, 1 do
		for j=1, #status, 1 do
			if Status[i].name == status[j].name then
				Status[i].set(status[j].val)
			end
		end
	end

	Citizen.CreateThread(function()
		while true do
			for i=1, #Status, 1 do
				Status[i].onTick()
			end

			SendNUIMessage({
				update = true,
				status = GetStatusData()
			})

			TriggerEvent('tac_status:onTick', GetStatusData(true))
			Citizen.Wait(Config.TickTime)
		end
	end)
end)

RegisterNetEvent('tac_status:set')
AddEventHandler('tac_status:set', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end

	SendNUIMessage({
		update = true,
		status = GetStatusData()
	})

	TriggerServerEvent('tac_status:update', GetStatusData(true))
end)

RegisterNetEvent('tac_status:add')
AddEventHandler('tac_status:add', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end

	SendNUIMessage({
		update = true,
		status = GetStatusData()
	})

	TriggerServerEvent('tac_status:update', GetStatusData(true))
end)

RegisterNetEvent('tac_status:remove')
AddEventHandler('tac_status:remove', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end

	SendNUIMessage({
		update = true,
		status = GetStatusData()
	})

	TriggerServerEvent('tac_status:update', GetStatusData(true))
end)

AddEventHandler('tac_status:getStatus', function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)

AddEventHandler('tac_status:setDisplay', function(val)
	SendNUIMessage({
		setDisplay = true,
		display    = val
	})
end)

-- Pause menu disable hud display
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not isPaused then
			isPaused = true
			TriggerEvent('tac_status:setDisplay', 0.0)
		elseif not IsPauseMenuActive() and isPaused then
			isPaused = false 
			TriggerEvent('tac_status:setDisplay', 0.5)
		end
	end
end)

-- Loaded event
Citizen.CreateThread(function()
	TriggerEvent('tac_status:loaded')
end)

-- Update server
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.UpdateInterval)

		TriggerServerEvent('tac_status:update', GetStatusData(true))
	end
end)
