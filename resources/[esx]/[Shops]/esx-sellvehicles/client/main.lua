tac = nil

PlayerData = {}

Citizen.CreateThread(function()
    while tac == nil do
        Citizen.Wait(10)

        TriggerEvent("tac:getSharedObject", function(response)
            tac = response
        end)
    end

    if tac.IsPlayerLoaded() then
		PlayerData = tac.GetPlayerData()

		RemoveVehicles()

		Citizen.Wait(500)

		LoadSellPlace()

		SpawnVehicles()
    end
end)

RegisterNetEvent("tac:playerLoaded")
AddEventHandler("tac:playerLoaded", function(response)
	PlayerData = response
	
	LoadSellPlace()

	SpawnVehicles()
end)

RegisterNetEvent("tac-qalle-sellvehicles:refreshVehicles")
AddEventHandler("tac-qalle-sellvehicles:refreshVehicles", function()
	RemoveVehicles()

	Citizen.Wait(500)

	SpawnVehicles()
end)

function LoadSellPlace()
	Citizen.CreateThread(function()

		local SellPos = Config.SellPosition

		local Blip = AddBlipForCoord(SellPos["x"], SellPos["y"], SellPos["z"])
		SetBlipSprite (Blip, 147)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 0.8)
		SetBlipColour (Blip, 52)
		SetBlipAsShortRange(Blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Used Cars")
		EndTextCommandSetBlipName(Blip)

		while true do
			local sleepThread = 500

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, SellPos["x"], SellPos["y"], SellPos["z"], true)

			if dstCheck <= 10.0 then
				sleepThread = 5

				if dstCheck <= 4.2 then
					tac.Game.Utils.DrawText3D(SellPos, "[E] Abrir menu", 0.4)
					if IsControlJustPressed(0, 38) then
						if IsPedInAnyVehicle(ped, false) then
							OpenSellMenu(GetVehiclePedIsUsing(ped))
						else
							tac.ShowNotification("Debes estar dentro de un ~g~vehiculo")
						end
					end
				end
			end

			for i = 1, #Config.VehiclePositions, 1 do
				if Config.VehiclePositions[i]["entityId"] ~= nil then
					local pedCoords = GetEntityCoords(ped)
					local vehCoords = GetEntityCoords(Config.VehiclePositions[i]["entityId"])

					local dstCheck = GetDistanceBetweenCoords(pedCoords, vehCoords, true)

					if dstCheck <= 2.0 then
						sleepThread = 5

						tac.Game.Utils.DrawText3D(vehCoords, "[E] " .. Config.VehiclePositions[i]["price"] .. ":-", 0.4)

						if IsControlJustPressed(0, 38) then
							if IsPedInVehicle(ped, Config.VehiclePositions[i]["entityId"], false) then
								OpenSellMenu(Config.VehiclePositions[i]["entityId"], Config.VehiclePositions[i]["price"], true, Config.VehiclePositions[i]["owner"])
							else
								tac.ShowNotification("Debes estar dentro de un ~g~vehiculo~s~!")
							end
						end
					end
				end
			end

			Citizen.Wait(sleepThread)
		end
	end)
end

function OpenSellMenu(veh, price, buyVehicle, owner)
	local elements = {}

	if not buyVehicle then
		if price ~= nil then
			table.insert(elements, { ["label"] = "Cambiar precio - " .. price .. " :-", ["value"] = "price" })
			table.insert(elements, { ["label"] = "Poner a la venta", ["value"] = "sell" })
		else
			table.insert(elements, { ["label"] = "Establecer precio- :-", ["value"] = "price" })
		end
	else
		table.insert(elements, { ["label"] = "comprar " .. price .. " - :-", ["value"] = "buy" })

		if owner then
			table.insert(elements, { ["label"] = "Remover vehiculo", ["value"] = "remove" })
		end
	end

	tac.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Menu de vehiculo",
			align    = 'top-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

		if action == "price" then
			tac.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_veh_price',
				{
					title = "Precio de vehiculo"
				},
			function(data2, menu2)

				local vehPrice = tonumber(data2.value)

				menu2.close()
				menu.close()

				OpenSellMenu(veh, vehPrice)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "sell" then
			local vehProps = tac.Game.GetVehicleProperties(veh)

			tac.TriggerServerCallback("tac-qalle-sellvehicles:isVehicleValid", function(valid)

				if valid then
					DeleteVehicle(veh)
					tac.ShowNotification("Pusiste el ~g~vehiculo~s~ a la ventana - " .. price .. " :-")
					menu.close()
				else
					tac.ShowNotification("Debe ser ~r~tu~s~ ~g~vehiculo!~s~ / it's ~r~already~s~ " .. #Config.VehiclePositions .. " vehicles for sale!")
				end
	
			end, vehProps, price)
		elseif action == "buy" then
			tac.TriggerServerCallback("tac-qalle-sellvehicles:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					DeleteVehicle(veh)
					tac.ShowNotification("~g~Compraste~s~ el vehiculo por " .. price .. " :-")
					menu.close()
				else
					tac.ShowNotification("~r~No~s~ tienes suficiente dinero " .. price - totalMoney .. " :-")
				end
			end, tac.Game.GetVehicleProperties(veh), price)
		elseif action == "remove" then
			tac.TriggerServerCallback("tac-qalle-sellvehicles:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					DeleteVehicle(veh)
					tac.ShowNotification("~g~Removiste~s~ el vehiculo")
					menu.close()
				end
			end, tac.Game.GetVehicleProperties(veh), 0)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

function RemoveVehicles()
	local VehPos = Config.VehiclePositions

	for i = 1, #VehPos, 1 do
		local veh, distance = tac.Game.GetClosestVehicle(VehPos[i])

		if DoesEntityExist(veh) and distance <= 1.0 then
			DeleteEntity(veh)
		end
	end
end

function SpawnVehicles()
	local VehPos = Config.VehiclePositions

	tac.TriggerServerCallback("tac-qalle-sellvehicles:retrieveVehicles", function(vehicles)
		for i = 1, #vehicles, 1 do

			local vehicleProps = vehicles[i]["vehProps"]

			LoadModel(vehicleProps["model"])

			VehPos[i]["entityId"] = CreateVehicle(vehicleProps["model"], VehPos[i]["x"], VehPos[i]["y"], VehPos[i]["z"] - 0.975, VehPos[i]["h"], false)
			VehPos[i]["price"] = vehicles[i]["price"]
			VehPos[i]["owner"] = vehicles[i]["owner"]

			tac.Game.SetVehicleProperties(VehPos[i]["entityId"], vehicleProps)

			FreezeEntityPosition(VehPos[i]["entityId"], true)

			SetEntityAsMissionEntity(VehPos[i]["entityId"], true, true)
			SetModelAsNoLongerNeeded(vehicleProps["model"])
		end
	end)

end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)

		Citizen.Wait(1)
	end
end
