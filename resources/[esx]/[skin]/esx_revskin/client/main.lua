
local hasAlreadyEnteredMarker, hasPaid, currentActionData = false, false, {}
local lastZone, currentAction, currentActionMsg
tac = nil
local inMenu = false

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

function OpenShopMenu()
	hasPaid = false
	inMenu = true
	--
	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'requestOutfit', {
		title = _U('outfit_menu'),
		align = 'top-left',
		elements = {
			{label = _U('outfit'), value = 'outfit'},
			{label = _U('buy'), value = 'clothes'}
		}
	},
	function(data, menu)
		if data.current.value == 'outfit' then

			tac.TriggerServerCallback('tac_property:getPlayerDressing', function(dressing)

				if dressing and dressing[1] ~= nil then --TESTEAR

					tac.UI.Menu.CloseAll()
					tac.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'shop_enter_zone',
					{
						title = _U('outfit'),
						align = 'top-left',
						elements = {
							{label = _U('change_clothe'), value = 'change_cloth'},
							{label = _U('del_clothe'), value = 'del_cloth'},
						}
					},
					function(data, menu)
						if data.current.value == 'change_cloth' then
							tac.UI.Menu.CloseAll()
							tac.TriggerServerCallback('tac_property:getPlayerDressing', function(dressing)

								local elements = {}

								for i=1, #dressing, 1 do
									table.insert(elements, {label = dressing[i], value = i})
								end

								tac.UI.Menu.Open(
								'default', GetCurrentResourceName(), 'player_dressing',
								{
									title    = _U('choose_clothe'),
									align    = 'top-left',
									elements = elements,
								},
								function(data2, menu)

									tac.TriggerServerCallback('tac_np_skinshop:buyClothes', function(bought)
										if bought then
											--print('comprado debug')
											-----
											TriggerEvent('skinchanger:getSkin', function(skin)

												tac.TriggerServerCallback('tac_property:getPlayerOutfit', function(clothes)

													TriggerEvent('skinchanger:loadClothes', skin, clothes)
													TriggerEvent('tac_skin:setLastSkin', skin)

													TriggerEvent('skinchanger:getSkin', function(skin)
														TriggerServerEvent('tac_skin:save', skin)
													end)

												end, data2.current.value)

											end)
											hasPaid = true
											inMenu = false
											-----
										else
											inMenu = false
											tac.ShowNotification(_U('not_enough_money'))
										end
									end)
									menu.close()
								end,
								function(data2, menu)
									menu.close()
								end)

							end)
						else
							tac.UI.Menu.CloseAll()
							tac.TriggerServerCallback('tac_property:getPlayerDressing', function(dressing)
								local elements = {}

								for i=1, #dressing, 1 do
									table.insert(elements, {label = dressing[i], value = i})
								end

								tac.UI.Menu.Open(
								'default', GetCurrentResourceName(), 'remove_cloth',
								{
									title    = _U('which_delete'),
									align    = 'top-left',
									elements = elements,
								},
								function(data2, menu)
									menu.close()
									TriggerServerEvent('tac_property:removeOutfit', data2.current.value)
									tac.ShowNotification(_U('clothe_delete'))
									inMenu = false
								end,
								function(data2, menu)
									menu.close()
								end)
							end)
						end
					end,
					function(data, menu)
						tac.UI.Menu.CloseAll()
						CurrentAction = 'shop_menu'
					end)

				else
					tac.ShowNotification(_U('no_outfit'))
				end

			end)
		else
			menu.close()
			--hasPaid = false
			TriggerEvent('skinchanger:getSkin', function(skin)
				--print(json.encode(skin))
				TriggerServerEvent('tac_skin:save', skin)
			end)
			TriggerEvent("tac_np_skinshop:toggleMenu", "clotheshop")
		end
		currentAction     = 'shop_menu'
		--inMenu = false
		currentActionMsg  = _U('press_menu')
		currentActionData = {}
	end,
	function(data, menu)
		menu.close()

		currentAction     = 'shop_menu'
		--inMenu = false
		currentActionMsg  = _U('press_menu')
		currentActionData = {}
	end)
	--[[
	hasPaid = false
	TriggerEvent('skinchanger:getSkin', function(skin)
		--print(json.encode(skin))
		TriggerServerEvent('tac_skin:save', skin)
	end)
	TriggerEvent("tac_np_skinshop:toggleMenu", "clotheshop")
	--]]
end

function openDialog()
	--inMenu = true
	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
		title = _U('valid_this_purchase'),
		align = 'top-left',
		elements = {
			{label = _U('no'), value = 'no'},
			{label = _U('yes', tac.Math.GroupDigits(Config.Price)), value = 'yes'}
	}}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			tac.TriggerServerCallback('tac_np_skinshop:buyClothes', function(bought)
				if bought then

					TriggerEvent('skinchanger:getSkin', function(skin)
						--print(json.encode(skin))
						TriggerServerEvent('tac_skin:save', skin)
					end)

					hasPaid = true

					tac.TriggerServerCallback('tac_np_skinshop:checkPropertyDataStore', function(foundStore)
						if foundStore then
							tac.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing', {
								title = _U('save_in_dressing'),
								align = 'top-left',
								elements = {
									{label = _U('no'),  value = 'no'},
									{label = _U('yes2'), value = 'yes'}
							}}, function(data2, menu2)
								menu2.close()

								if data2.current.value == 'yes' then
									tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
										title = _U('name_outfit')
									}, function(data3, menu3)
										menu3.close()

										TriggerEvent('skinchanger:getSkin', function(skin)
											TriggerServerEvent('tac_np_skinshop:saveOutfit', data3.value, skin)
											tac.ShowNotification(_U('saved_outfit'))
										end)
									end, function(data3, menu3)
										menu3.close()
										inMenu = false
									end)
								end
							end)
						end
					end)

				else
					tac.TriggerServerCallback('tac_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					inMenu = false
					tac.ShowNotification(_U('not_enough_money'))
				end
			end)
		elseif data.current.value == 'no' then
			inMenu = false
			tac.TriggerServerCallback('tac_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		currentAction     = 'shop_menu'
		--inMenu = false
		currentActionMsg  = _U('press_menu')
		currentActionData = {}
	end, function(data, menu)
		menu.close()

		currentAction     = 'shop_menu'
		--inMenu = false
		currentActionMsg  = _U('press_menu')
		currentActionData = {}
	end)
end

RegisterNUICallback("endDialog", function(data)
	--print(data)
	TriggerEvent("tac_np_skinshop:toggleMenu")
	if data == "clothes" then
		openDialog()
	else
		TriggerEvent("tac_newaccessories:endDialog")
	end
end)

AddEventHandler('tac_np_skinshop:hasEnteredMarker', function(zone)
	currentAction     = 'shop_menu'
	currentActionMsg  = _U('press_menu')
	currentActionData = {}
end)

AddEventHandler('tac_np_skinshop:hasExitedMarker', function(zone)
	tac.UI.Menu.CloseAll()
	currentAction = nil
	inMenu = false

	if not hasPaid then
		TriggerEvent('tac_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Shops) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite (blip, 73)
		SetBlipColour (blip, 47)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('clothes'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Enter / Exit marker events & draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, isInMarker, currentZone, letSleep = GetEntityCoords(PlayerPedId()), false, nil, true

		for k,v in pairs(Config.Shops) do
			local distance = #(playerCoords - v)

			if distance < Config.DrawDistance then
				letSleep = false
				DrawMarker(Config.MarkerType, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)

				if distance < Config.MarkerSize.x then
					isInMarker, currentZone = true, k
				end
			end
		end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker, lastZone = true, currentZone
			TriggerEvent('tac_np_skinshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('tac_np_skinshop:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if currentAction and not inMenu then
			tac.ShowHelpNotification(currentActionMsg)

			if IsControlJustReleased(0, 38) then
				if currentAction == 'shop_menu' then
					OpenShopMenu()
				end

				currentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
