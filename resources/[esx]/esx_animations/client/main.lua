local isDead = false
local inAnim = false
tac = nil

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('tac:onPlayerDeath', function(data) isDead = true end)

AddEventHandler('playerSpawned', function(spawn) isDead = false end)

function startAttitude(lib, anim)
	tac.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	tac.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function OpenAnimationsMenu()
	local elements = {}

	for i=1, #Config.Animations, 1 do
		table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
	end

	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'animations', {
		title    = 'Animaciones',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		OpenAnimationsSubMenu(data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenAnimationsSubMenu(menu)
	local title    = nil
	local elements = {}

	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name == menu then
			title = Config.Animations[i].label

			for j=1, #Config.Animations[i].items, 1 do
				table.insert(elements, {
					label = Config.Animations[i].items[j].label,
					type  = Config.Animations[i].items[j].type,
					value = Config.Animations[i].items[j].data
				})
			end

			break

		end
	end

	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'animations_sub', {
		title    = title,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local type = data.current.type
		local lib  = data.current.value.lib
		local anim = data.current.value.anim

		if type == 'scenario' then
			startScenario(anim)
		elseif type == 'attitude' then
			startAttitude(lib, anim)
		elseif type == 'anim' then
			startAnim(lib, anim)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 82) and IsInputDisabled(0) and not isDead then
			OpenAnimationsMenu()
		end

		if IsControlJustReleased(0, 73) and IsInputDisabled(0) and not isDead then
			ClearPedTasks(PlayerPedId())
		end

	end
end)