 
local tac	 = nil

-- tac
Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end

	while tac.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	tac.PlayerData = tac.GetPlayerData()
end)



RegisterCommand('not', function(source, args, rawCommand)
	TriggerServerEvent('rev_hud_ui:admNotifyCheck', args)
end)

RegisterNetEvent('rev_hud_ui:admNotifyPrompt')
AddEventHandler('rev_hud_ui:admNotifyPrompt', function (args)

	local type = args[1]
	local title
	local msg

	if (type == 'normal') or (type == 'red') or (type == 'rainbow') then
		
		title = KeyboardInput(_U('notify_title'), '', 30)

		if title ~= nil then
			msg = KeyboardInput(_U('notify_msg'), '', 300)
		else
			title = _U('notify_notification')
		end

		if msg ~= nil then 
			TriggerServerEvent('rev_hud_ui:adminNotifyAllPlayers', {title, msg, type})
		else
			TriggerEvent('chatMessage', '[ERROR]', {255,0,0}, 'NO MESSAGE' )
		end

	else
		TriggerEvent('chatMessage', '[ERROR]', {255,0,0}, '/not [normal|red|rainbow]' )
	end

end)

RegisterNetEvent('rev_hud_ui:admNotifyShow')
AddEventHandler('rev_hud_ui:admNotifyShow', function (args)
	local title = args[1]
	local message = args[2]
	local type = args[3]

	SendNUIMessage({ action = 'sendNotification', title = title, message = message, type = type })
end)





function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end