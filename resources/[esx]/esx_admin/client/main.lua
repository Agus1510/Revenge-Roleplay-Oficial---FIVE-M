tac = nil
local PlayerData, GUI, CurrentActionData = {}, {}, {}
GUI.Time = 0
local hasAlreadyEnteredMarker, BrinksSpawn = false, false
local lastZone, CurrentAction, CurrentActionMsg
local secondsRemaining = 0

-- SetMaxWantedLevel(5)
Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
	tac.TriggerServerCallback("tac_admin:getSteamId", function(steamId)
        SteamID = steamId
    end)
end)

function isSteamIdInList(psteamId)
    local steamIdIsFound = false

    for i=1, #Config.SteamID, 1 do
		if Config.SteamID[i] == psteamId then
			return true
		end
	end
	
    return false
end

function OpenAccountantActionsMenu()
	local elements = {
	{label = _U('Player'), 			value = 'customers'},
	{label = _U('Society'),			value = 'customers_entreprise'},
	{label = _U('BoxAdmin'), 		value = 'inventario admin'},
	{label = _U('AutoGive'), 		value = 'autogive'},
	{label = _U('CreateAlert'),   	value = 'Alert'},
	{label = _U('Brinks'),			value = 'brinks'},
	{label = _U('PickUp'),			value = 'pickup'},
--	{label = 'Spawn PNJ gang',		value = 'npc_gang'}
	}

	tac.UI.Menu.CloseAll()

	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'accountant_actions', {
			title    = _U('Menu'),
			elements = elements
		}, function(data, menu)

			if data.current.value == 'customers' then
				OpenCustomersMenu()
			end

			if data.current.value == 'customers_entreprise' then
				OpenCustomersEntreprise()
			end

			if data.current.value == 'Alert' then
				local elements = {
					{label = _U('AlertP'), 	value = 'police'},
					{label = _U('AlertG'), 	value = 'gang'},
					{label = _U('AlertPG'), value ='police_gang'}
					}
				
					tac.UI.Menu.CloseAll()
				
					tac.UI.Menu.Open('default', GetCurrentResourceName(), 'accountant_actions', {
							title    = _U('CreateAlert'),
							elements = elements
						}, function(data, menu)
							if data.current.value == 'police' then
								tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
										title = 'Alert Police'
									}, function(data2, menu)
				
										local text = tostring(data2.value)								
										menu.close()	
				
										TriggerServerEvent('tac_admin:policealert', text)
										tac.ShowNotification(_U('SendPolice') ..text.. _U('Send'))
									end, function(data2, menu)
										menu.close()
									end)			
							end 

							if data.current.value == 'gang' then
								tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
										title = _U('AlertG')
									}, function(data2, menu)

										local text = tostring(data2.value)								
										menu.close()	

										TriggerServerEvent('tac_admin:gangalert', text)
										tac.ShowNotification(_U('SendPolice') ..text.. _U('Send'))
									end, function(data2, menu)
										menu.close()
									end)						
							end 

							if data.current.value == 'police_gang' then
								tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
										title = _U('AlertPG')
									}, function(data2, menu)

										local text = tostring(data2.value)								
										menu.close()	

										TriggerServerEvent('tac_admin:gangalert', text)
										TriggerServerEvent('tac_admin:policealert', text)
										tac.ShowNotification(_U('SendPoliceGang') ..text.. _U('Send'))
									end, function(data2, menu)
										menu.close()
									end)						
							end 
						end, function(data, menu)
							menu.close()
						end)
			end

			if data.current.value == 'pickup' then
				tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
						title = _U('PickUp')
					}, function(data2, menu)

						local item = tostring(data2.value)								
						menu.close()	

						TriggerServerEvent('tac_admin:pickup', item)
						tac.ShowNotification('~b~Item : ~w~' .. item .. " posé au sol" )
					end, function(data2, menu)
						menu.close()
					end)
			end

			if data.current.value == 'brinks' then
				local elements = {
					{label = _U('brinks')		, value = 'no'},
					{label = _U('brinkspnj')	, value = 'NPCBrinks'}
					}
				
					tac.UI.Menu.CloseAll()
				
					tac.UI.Menu.Open('default', GetCurrentResourceName(), 'accountant_actions', {
							title    = _U('Menu'),
							elements = elements
						}, function(data, menu)

							if data.current.value == 'no' then
								local carid = GetHashKey('Stockade')
								local coords = GetEntityCoords(GetPlayerPed(-1))
								local playerPed = GetPlayerPed(-1)

								RequestModel(carid)
								while not HasModelLoaded(carid) do
									Citizen.Wait(0)
								end

								veh = CreateVehicle(carid,coords.x +16, coords.y+16, coords.z -1, 210, true, true)
								OpenDoors()
								SetVehicleNumberPlateText(veh, "STOCKADE")
								TriggerServerEvent('tac_admin:addInventoryItem', GetVehicleClass(veh), GetDisplayNameFromVehicleModel(GetEntityModel(veh)), GetVehicleNumberPlateText(veh), "pack_drugs", "1", "Mallette traçable")
								SpawnVehiclePolice()
								menu.close()
								Citizen.Wait(5000)
								SetVehicleExplodesOnHighExplosionDamage(veh, true)
								ExplodeVehicleInCutscene(veh, true)
								Citizen.Wait(5000)
								TriggerServerEvent('tac_admin:brinks_police')
								SetVehicleGravity(veh, true)							
							end 

							if data.current.value == 'NPCBrinks' then
								local elements = {
									{label = _U('Start') , value = 'start'},
									{label = _U('Stop'), value = 'stop'}
									}
								
									tac.UI.Menu.CloseAll()
								
									tac.UI.Menu.Open('default', GetCurrentResourceName(), 'accountant_actions', {
											title    = 'Brinks',
											elements = elements
										}, function(data, menu)

											if data.current.value == 'start' then
												TriggerEvent('tac_admin:going')
												TriggerServerEvent('tac_admin:callbrinks1')
												tac.ShowNotification('Spawn Brinks en cour')

											end

											if data.current.value == 'stop' then
												RemoveBlip(vehBlip)	
												tac.ShowNotification('Mission Fini')
												TriggerServerEvent('tac_admin:addInventoryItem', GetVehicleClass(plyCar), GetDisplayNameFromVehicleModel(GetEntityModel(plyCar)), GetVehicleNumberPlateText(plyCar), "pack_drugs", "-1", "Mallette traçable")						
												TaskGoToCoordAnyMeans(startped, 999,999,999, 5.0, 0, 0, 786603, 0xbf800000)           
											end			
										end, function(data, menu)
											menu.close()
										end)
							end
						end, function(data, menu)
							menu.close()
						end)
			end

			if data.current.value == 'coffre' then
				local elements = {
					{label = 'Poser dans le coffre', value = 'put_stock'},
					{label = 'Prendre dans le coffre', value = 'stocks'},
					{label = 'Poser arme dans le coffre', value = 'put_weapon'},
					{label = 'Prendre arme dans le coffre', value = 'get_weapon'},
					}
				
					tac.UI.Menu.CloseAll()
				
					tac.UI.Menu.Open('default', GetCurrentResourceName(), 'accountant_actions', {
							title    = 'Coffre',
							elements = elements
						}, function(data, menu)

							if data.current.value == 'put_stock' then
								OpenPutStocksMenu()		
							end 

							if data.current.value == 'stocks' then
								OpenStocksMenu()		
							end 

							if data.current.value == 'get_weapon' then
								OpenGetWeaponMenu()
							end
				
							if data.current.value == 'put_weapon' then
								OpenPutWeaponMenu()
							end
						end, function(data, menu)
							menu.close()
						end)
			end

			if data.current.value == 'autogive' then
				local elements = {
					{label = 'Avoir une arme', 		value = 'giveweapon'},
					{label = 'Avoir argent sale', 	value = 'giveblackmoney'},
					{label = 'Avoir argent propre', value = 'givemoney'},
					{label = 'Avoir item', 			value = 'giveitem'},
					}
				
					tac.UI.Menu.CloseAll()
				
					tac.UI.Menu.Open('default', GetCurrentResourceName(), 'accountant_actions', {
							title    = 'Auto Give',
							elements = elements
						}, function(data, menu)
							if data.current.value == 'giveweapon' then
								tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
										title = 'Arme'
									}, function(data2, menu)

										local text = tostring(data2.value)								
										menu.close()	

										TriggerServerEvent('tac_admin:giveweapon', text)
									end, function(data2, menu)
										menu.close()
									end)
							end 

							if data.current.value == 'giveblackmoney' then
								tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
										title = 'Argent Sale'
									}, function(data2, menu)

										local amount = tonumber(data2.value)								
										menu.close()	

										TriggerServerEvent('tac_admin:customerdirtDeposit', amount)
									end, function(data2, menu)
										menu.close()
									end)
							end 

							if data.current.value == 'givemoney' then
								tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
										title = 'Argent propre'
									}, function(data2, menu)

										local amount = tonumber(data2.value)								
										menu.close()	

										TriggerServerEvent('tac_admin:customerDeposit', amount)
									end, function(data2, menu)
										menu.close()
									end)
							end
				
							if data.current.value == 'giveitem' then
								tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
										title = 'Item'
									}, function(data2, menu)

										local item = tostring(data2.value)								
										menu.close()	

										TriggerServerEvent('tac_admin:additem', item)
									end, function(data2, menu)
										menu.close()
									end)
							end
						end, function(data, menu)
							menu.close()
						end)
			end

			if data.current.value == 'npc_gang' then

				local coords = GetEntityCoords(GetPlayerPed(-1))
				local model = "A_C_MtLion"
				local mathcord = math.random(1, 50)
				local mathcord2 = math.random(1, 50)

				RequestModel(model)

				while not HasModelLoaded(model)  do
				Citizen.Wait(0)
				end

				dmvmainped =  CreatePed(4, model, coords.x+ 10, coords.y+10, coords.z, 120,  false, true)
				SetPedFleeAttributes(dmvmainped, 0, 0)
				SetPedDropsWeaponsWhenDead(dmvmainped, false)
				SetPedDiesWhenInjured(dmvmainped, false)
				SetPedCombatAbility(dmvmainped, 100)
				SetPedArmour(playerPed, math.random(50, 100))
				SetPedCombatRange(dmvmainped, 0)
			end
		end, function(data, menu)
			menu.close()
		end)
end

function OpenStocksMenu()

	tac.TriggerServerCallback('tac_admin:getStockItems', function(items)

		print(json.encode(items))

		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

	  tac.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
	      title    = 'Coffre Admin',
	      elements = elements
	    }, function(data, menu)

	    	local itemName = data.current.value

				tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
						title = 'Quantité'
					}, function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							tac.ShowNotification('Quantité invalide')
						else
							menu2.close()
							menu.close()
				    		OpenStocksMenu()

							TriggerServerEvent('tac_admin:getStockItem', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
	    end, function(data, menu)
	    	menu.close()
	    end)
	end)
end

function OpenPutStocksMenu()

	tac.TriggerServerCallback('tac_admin:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end

	  tac.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
	      title    = 'Coffre Admin',
	      elements = elements
	    }, function(data, menu)

	    	local itemName = data.current.value

				tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
						title = 'Quantité'
					}, function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							tac.ShowNotification('Quantité invalide')
						else
							menu2.close()
							menu.close()
				    		OpenPutStocksMenu()

							TriggerServerEvent('tac_admin:putStockItems', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
	    end, function(data, menu)
	    	menu.close()
	    end)
	end)
end

function OpenGetWeaponMenu()

	tac.TriggerServerCallback('tac_admin:getArmoryWeapons', function(weapons)

		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. tac.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
			end
		end

		tac.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
				title    = "Déposer une arme",
				align    = 'top-left',
				elements = elements,
			}, function(data, menu)

				menu.close()

				tac.TriggerServerCallback('tac_admin:removeArmoryWeapon', function()
					OpenGetWeaponMenu()
				end, data.current.value)
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function OpenPutWeaponMenu()

	local elements   = {}
	local playerPed  = GetPlayerPed(-1)
	local weaponList = tac.GetWeaponList()

	for i=1, #weaponList, 1 do

		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end
	end

	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
			title    = "Prend une arme",
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			
			menu.close()

			tac.TriggerServerCallback('tac_admin:addArmoryWeapon', function()
				OpenPutWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
end

function SpawnVehiclePolice()

	local police = GetHashKey('police')
	local coords = GetEntityCoords(GetPlayerPed(-1))
	local playerPed = GetPlayerPed(-1)
	
	RequestModel(police)
	while not HasModelLoaded(police) do
		Citizen.Wait(0)
	end

	vehpolice = CreateVehicle(police,coords.x +18, coords.y+18, coords.z -1, 210, true, true)
	vehpolice = CreateVehicle(police,coords.x +14, coords.y+14, coords.z -1, 210, true, true)
end 

function OpenDoors ()

	-- Ouvre toute les portes
	SetVehicleDoorOpen(veh, 0, false, false)
	SetVehicleDoorOpen(veh, 1, false, false)
	SetVehicleDoorOpen(veh, 2, false, false)
	SetVehicleDoorOpen(veh, 3, false, false)
	SetVehicleDoorOpen(veh, 4, false, false)
	SetVehicleDoorOpen(veh, 5, false, false)
	SetVehicleDoorOpen(veh, 6, false, false)
	SetVehicleDoorOpen(veh, 7, false, false)
	-- Deverouille le vehicule
	SetVehicleDoorsLocked(veh, 1)
	SetVehicleDoorsLockedForAllPlayers(veh, false)
	-- Demarre le moteur 
	SetVehicleEngineOn(veh,  true,  true)
	-- Acive Alarme vehicule
	SetVehicleAlarm(veh, true)
	StartVehicleAlarm(veh)
end

function StartFire()
	local Coords = GetEntityCoords(GetPlayerPed(-1))
	StartScriptFire(Coords.x+15, Coords.y+15, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x+16, Coords.y+16, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x+17, Coords.y+17, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x+18, Coords.y+18, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x+19, Coords.y+19, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x+10, Coords.y+20, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x+21, Coords.y+21, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x+22, Coords.y+21, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x-23, Coords.y+23, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x-24, Coords.y+24, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x-25, Coords.y+25, Coords.z-1, 25, 0)
	StartScriptFire(Coords.x-26, Coords.y+26, Coords.z-1, 25, 0)
end

function SpawnPedBrinks ()

	local model 	= "S_M_Y_BLACKOPS_01"
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

		RequestModel(model)

		while not HasModelLoaded(model)  do
		Citizen.Wait(0)
		end

	ped =	CreatePed(5,  model,  coords.x +11, coords.y+11,  coords.z ,  0.0,  false,  false)
	ped =	CreatePed(5,  model,  coords.x +12, coords.y+12,  coords.z ,  0.0,  false,  false)
	ped = 	CreatePed(5,  model,  coords.x +10, coords.y+5,  coords.z ,  0.0,  false,  false)

	StartScriptFire(coords.x +11, coords.y+11, coords.z-1, 25, 0)
	StartScriptFire(coords.x +12, coords.y+12, coords.z-1, 25, 0)
	StartScriptFire(coords.x +10, coords.y+5, coords.z-1, 25, 0)

end

function OpenCustomersEntreprise()

	tac.TriggerServerCallback('tac_accountantjob:getCustomers', function(customers, account)

		local elements = {
			head = { 'Entreprise', _U('balance'), _U('actions')},
			rows = {}
		}

		for i=1, #customers, 1 do
			table.insert(elements.rows, {
				data = customers[i],
				cols = {
					customers[i].society.label,	
					customers[i].account,
					'{{' .. _U('deposit') .. '|deposit}} {{' .. _U('withdraw') .. '|withdraw}}'
				}
			})
		end

		tac.UI.Menu.Open('list', GetCurrentResourceName(), 'customers',
			elements,
			function(data, menu)

				local customer = data.data

				if data.value == 'deposit' then

					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_deposit_amount', {
							title = _U('amount')
						}, function(data2, menu)

							local amount = tonumber(data2.value)

							if amount == nil then
								tac.ShowNotification(_U('invalid_amount'))
							else
								
								menu.close()	

								TriggerServerEvent('tac_accountantjob:customerDeposit', customer.society.account, amount)
							end
						end, function(data2, menu)
							menu.close()
						end)
				end

				if data.value == 'withdraw' then

					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
							title = _U('amount')
						}, function(data2, menu)

							local amount = tonumber(data2.value)

							if amount == nil then
								tac.ShowNotification(_U('invalid_amount'))
							else
								
								menu.close()	

								TriggerServerEvent('tac_accountantjob:customerWithdraw', customer.society.account, amount)
							end
						end, function(data2, menu)
							menu.close()
						end)
				end
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function OpenCustomersMenu()

	tac.TriggerServerCallback('tac_admin:getCustomers', function(customers, account)

		local elements = {
			head = {'SteamID','Joueurs','Grade','Job', 'Job_grade', 'Telefono','Efectivo', 'Banco', 'Dinero sucio', 'Inventario',"Item", "Status"},
			rows = {}
		}

		for i=1, #customers, 1 do
			table.insert(elements.rows, {
				data = customers[i],
				cols = {
					customers[i].identifier,
					customers[i].name,
					customers[i].group,
					customers[i].job,
					customers[i].grade,
					customers[i].phone,
					'{{' .. customers[i].money .. '|deposit}}',
					'{{' .. customers[i].accounts .. '|depositaccount}}',
					'{{' .. customers[i].dirtmoney .. '|depositdirt}}',
					'{{ check inventaire |CheckInventaire}}',
					'{{ Item |additem}}',
					'{{ Status |addstatus}}',
				}
			})
		end

		tac.UI.Menu.Open('list', GetCurrentResourceName(), 'customers',
			elements,
			function(data, menu)

				local customer = data.data

				if data.value == 'deposit' then

					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_deposit_amount', {
							title = _U('amount')
						}, function(data2, menu)

							local amount = tonumber(data2.value)

							if amount == nil then
								tac.ShowNotification(_U('invalid_amount'))
							else
								
								menu.close()	

								TriggerServerEvent('tac_admin:customerDeposit', customer.name, amount)

								OpenCustomersMenu()
							end
						end, function(data2, menu)
							menu.close()
							OpenCustomersMenu()
						end)
				end

				if data.value == 'depositaccount' then

					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
							title = _U('amount')
						}, function(data2, menu)

							local amount = tonumber(data2.value)

							if amount == nil then
								tac.ShowNotification(_U('invalid_amount'))
							else
								
								menu.close()	

								TriggerServerEvent('tac_admin:customeraccount', customer.name, amount)

								OpenCustomersMenu()
							end
						end, function(data2, menu)
							menu.close()
							OpenCustomersMenu()
						end)
				end

				if data.value == 'depositdirt' then

					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_deposit_amount', {
							title = _U('amount')
						}, function(data2, menu)

							local amount = tonumber(data2.value)

							if amount == nil then
								tac.ShowNotification(_U('invalid_amount'))
							else
								
								menu.close()	

								TriggerServerEvent('tac_admin:customerdirtDeposit', customer.name, amount)

								OpenCustomersMenu()
							end
						end, function(data2, menu)
							menu.close()
							OpenCustomersMenu()
						end)
				end

				if data.value == 'dirtwithdraw' then

					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
							title = _U('amount')
						}, function(data2, menu)

							local amount = tonumber(data2.value)

							if amount == nil then
								tac.ShowNotification(_U('invalid_amount'))
							else
								
								menu.close()	

								TriggerServerEvent('tac_admin:customerdirtWithdraw', customer.name, amount)

								OpenCustomersMenu()
							end
						end, function(data2, menu)
							menu.close()
							OpenCustomersMenu()
						end)
				end

				if data.value == 'CheckInventaire' then
					menu.close()
					OpenCustomersInventaire()
				end

				if data.value == 'additem' then
					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
							title = _U('GiveOneItem')
						}, function(data2, menu)

							local item = tostring(data2.value)								
							menu.close()	

							TriggerServerEvent('tac_admin:additem', customer.name, item)
						end, function(data2, menu)
							menu.close()
							OpenCustomersMenu()
						end)
				end

				if data.value == 'addstatus' then
					menu.close()

					tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'customer_withdraw_amount', {
							title = 'status'
						}, function(data2, menu)

							local amount = tostring(data2.value)								
							menu.close()	

							TriggerServerEvent('tac_admin:addstatus', customer.name, amount)
						end, function(data2, menu)
							menu.close()
							OpenCustomersMenu()
						end)
				end
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function OpenCustomersInventaire()

	tac.TriggerServerCallback('tac_policejob:getOtherPlayerData', function(data)
		local elements = {}

		table.insert(elements, {label = _U('Weapon'), value = nil})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label          = _U('confisq') .. tac.GetWeaponLabel(data.weapons[i].name),
				value          = data.weapons[i].name,
				itemType       = 'item_weapon',
				amount         = data.ammo,
			})
		end

		table.insert(elements, {label =_U'inventory', value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label          = _U('confisq') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
					value          = data.inventory[i].name,
					itemType       = 'item_standard',
					amount         = data.inventory[i].count,
				})
			end
		end
		
		tac.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
				title    = _U('invetor'),
				align    = 'top-left',
				elements = elements,
			}, function(data, menu)

				local itemType = data.current.itemType
				local itemName = data.current.value
				local amount   = data.current.amount

				if data.current.value ~= nil then

					TriggerServerEvent('tac_admin:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

					OpenBodySearchMenu(player)
				end
			end, function(data, menu)
				menu.close()
			end)
	end, GetPlayerServerId(player))
end

------------------------------------------------------------------
------------------------------------------------------------------

RegisterNetEvent('tac_admin:going')
AddEventHandler('tac_admin:going', function(pos)
    local counter = 1

    AddRelationshipGroup('StartGroup1')

    while counter > 0 do
        if counter == 3 then
             model          = "Granger"
             nombre = 8
		elseif counter == 2 then
            model           = "Stockade"
            nombre = 4
        elseif counter == 1 then
             model          = "Stockade"
             nombre = 8
        end
        counter = counter - 1
		Wait(20000)
        CreateEscorte()
    end
end)
 
function CreateEscorte()
	local essence       = math.random(80, 100)
    RandomPed  			= Config.Peds[GetRandomIntInRange(1,  #Config.Peds)]
    Weapon      		= -270015777
    seat       			=  -1
 
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end

	RequestModel(RandomPed)
	while not HasModelLoaded(RandomPed) do
		Citizen.Wait(1)
	end

	plyCar      =   CreateVehicle(model,-89.747467041016,  -672.94866943359, 35.340305328369,175, true, false)
	startped    =   CreatePedInsideVehicle(plyCar, 4, RandomPed, -1, true, false)
	SetPedRelationshipGroupHash(startped, 'StartGroup1')

			nombre = nombre - 1

	while nombre > 0 do
		nombre = nombre - 1
		seat = seat + 1
		Wait(50)
		CreatePed()
	end
	
	BrinksSpawn = true
	SetVehicleOnGroundProperly(plyCar)
	TriggerEvent("advancedFuel:setEssence", essence , GetVehicleNumberPlateText(plyCar), GetDisplayNameFromVehicleModel(GetEntityModel(plyCar)))
	SetModelAsNoLongerNeeded(plyCar)
	SetVehicleColours(plyCar, math.random(0 , 5) , math.random(0 , 4) )
	SetVehicleWindowTint(plyCar, 1)
	SetVehicleModKit(plyCar, 0)
	SetVehicleWindowTint(plyCar, 1)
	ToggleVehicleMod(plyCar, 18, true)
	SetVehicleMod(plyCar, 11,  math.random(0,3))
	SetVehicleMod(plyCar, 46, 5)
	SetPedDropsWeaponsWhenDead(startped, false)
	GiveWeaponToPed(startped, Weapon, 2800, false, true)
	SetCurrentPedWeapon(startped, Weapon,true) 
	TriggerServerEvent('tac_admin:addInventoryItem', GetVehicleClass(plyCar), GetDisplayNameFromVehicleModel(GetEntityModel(plyCar)), GetVehicleNumberPlateText(plyCar), "pack_drugs", "1", "Mallette traçable")						
	TaskVehicleDriveWander(startped, plyCar, 220.0, 131)

end

function CreatePed()

	pedBrinks  =   CreatePedInsideVehicle(plyCar, 4, RandomPed, seat, true, false)
	SetPedDropsWeaponsWhenDead(pedBrinks, false)
	GiveWeaponToPed(pedBrinks, Weapon, 2800, false, true)
	SetCurrentPedWeapon(pedBrinks, Weapon,true)
	SetPedRelationshipGroupHash(pedBrinks, 'StartGroup1')
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if BrinksSpawn then
			local x,y,z = GetEntityCoords(plyCar)            
			vehBlip = AddBlipForEntity(plyCar)
			SetBlipSprite (vehBlip, 67)
	  		SetBlipDisplay(vehBlip, 4)
			SetBlipScale  (vehBlip, 0.8)
			SetBlipColour(vehBlip,69)
			BrinksSpawn = false
		end 
    end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

	--	if isSteamIdInList(SteamID) then
		if IsControlPressed(0, 197) and IsControlJustReleased(0, 173) then
				OpenAccountantActionsMenu()
		end	
	--	end
	end
end)
