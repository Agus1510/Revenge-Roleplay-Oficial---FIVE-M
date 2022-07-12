tac          = nil
local IsDead = false
local IsAnimated = false
local IsAlreadyDrunk = false
local DrunkLevel     = -1

Citizen.CreateThread(function()
	while tac == nil do
		TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('tac_basicneeds:resetStatus', function()
	TriggerEvent('tac_status:set', 'hunger', 500000)
	TriggerEvent('tac_status:set', 'thirst', 500000)
end)

RegisterNetEvent('tac_basicneeds:healPlayer')
AddEventHandler('tac_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('tac_status:set', 'hunger', 1000000)
	TriggerEvent('tac_status:set', 'thirst', 1000000)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('tac:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('tac_basicneeds:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('tac_status:loaded', function(status)

	TriggerEvent('tac_status:registerStatus', 'hunger', 1000000, '#FFFF00', function(status) -- #CFAD0F -- Amarelo
		return false
	end, function(status)
		status.remove(100)
	end)

	TriggerEvent('tac_status:registerStatus', 'thirst', 1000000, '#0099FF', function(status) -- #0C98F1 -- Azul
		return false
	end, function(status)
		status.remove(75)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('tac_status:getStatus', 'hunger', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('tac_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			if health ~= prevHealth then
				SetEntityHealth(playerPed, health)
			end
		end
	end)
end)

AddEventHandler('tac_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('tac_basicneeds:onEat')
AddEventHandler('tac_basicneeds:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.11, 0.045, 0.02, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)
RegisterNetEvent('tac_basicneeds:onEatChocolate')
AddEventHandler('tac_basicneeds:onEatChocolate', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_choc_ego'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.035, 0.009, -30.0, -240.0, -120.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onEatCupCake')
AddEventHandler('tac_basicneeds:onEatCupCake', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'ng_proc_food_ornge1a'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.045, 0.06, 45.0, 175.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onEatChips')
AddEventHandler('tac_basicneeds:onEatChips', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'v_ret_ml_chips4'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onEatSandwich')
AddEventHandler('tac_basicneeds:onEatSandwich', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_sandwich_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.03, -240.0, -180.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrink')
AddEventHandler('tac_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkCocaCola')
AddEventHandler('tac_basicneeds:onDrinkCocaCola', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ecola_can' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkIceTea')
AddEventHandler('tac_basicneeds:onDrinkIceTea', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_can_01' --ng_proc_sodacan_01b
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkCoffe')
AddEventHandler('tac_basicneeds:onDrinkCoffe', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_fib_coffee'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.01, -0.03, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Bar drinks
RegisterNetEvent('tac_basicneeds:onDrinkBeer')
AddEventHandler('tac_basicneeds:onDrinkBeer', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_amb_beer_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkWine')
AddEventHandler('tac_basicneeds:onDrinkWine', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_wine_bot_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkVodka')
AddEventHandler('tac_basicneeds:onDrinkVodka', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_vodka_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkWhisky')
AddEventHandler('tac_basicneeds:onDrinkWhisky', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_whiskey_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.2, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkTequila')
AddEventHandler('tac_basicneeds:onDrinkTequila', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_tequila_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkMilk')
AddEventHandler('tac_basicneeds:onDrinkMilk', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_milk_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, -0.009, -0.03, -0.1, -90.0, 270.0, -90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Disco
RegisterNetEvent('tac_basicneeds:onDrinkGin')
AddEventHandler('tac_basicneeds:onDrinkGin', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_rum_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkAbsinthe')
AddEventHandler('tac_basicneeds:onDrinkAbsinthe', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_bottle_cognac'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'mamb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('tac_basicneeds:onDrinkChampagne')
AddEventHandler('tac_basicneeds:onDrinkChampagne', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_wine_white'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			tac.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Cigarett 
RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('tac_cigarett:startSmoke')
AddEventHandler('tac_cigarett:startSmoke', function(source)
	SmokeAnimation()
end)

function SmokeAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)               
	end)
end

-- Optionalneeds
function Drunk(level, start)
  
  Citizen.CreateThread(function()
     local playerPed = GetPlayerPed(-1)
     if start then
      DoScreenFadeOut(800)
      Wait(1000)
    end
     if level == 0 then
       RequestAnimSet("move_m@drunk@slightlydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
      end
       SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
     elseif level == 1 then
       RequestAnimSet("move_m@drunk@moderatedrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(0)
      end
       SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
     elseif level == 2 then
       RequestAnimSet("move_m@drunk@verydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(0)
      end
       SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
     end
     SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedIsDrunk(playerPed, true)
     if start then
      DoScreenFadeIn(800)
    end
   end)
 end
 function Reality()
   Citizen.CreateThread(function()
     local playerPed = GetPlayerPed(-1)
     DoScreenFadeOut(800)
    Wait(1000)
     ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    SetPedIsDrunk(playerPed, false)
    SetPedMotionBlur(playerPed, false)
     DoScreenFadeIn(800)
   end)
 end
 AddEventHandler('tac_status:loaded', function(status)
   TriggerEvent('tac_status:registerStatus', 'drunk', 0, '#8F15A5', --roxo
    function(status)
      if status.val > 0 then
        return true
      else
        return false
      end
    end,
    function(status)
      status.remove(1500)
    end
  )
 	Citizen.CreateThread(function()
 		while true do
 			Wait(1000)
 			TriggerEvent('tac_status:getStatus', 'drunk', function(status)
				
				if status.val > 0 then
					
          local start = true
           if IsAlreadyDrunk then
            start = false
          end
           local level = 0
           if status.val <= 250000 then
            level = 0
          elseif status.val <= 500000 then
            level = 1
          else
            level = 2
          end
           if level ~= DrunkLevel then
            Drunk(level, start)
          end
           IsAlreadyDrunk = true
          DrunkLevel     = level
				end
 				if status.val == 0 then
          
          if IsAlreadyDrunk then
            Reality()
          end
           IsAlreadyDrunk = false
          DrunkLevel     = -1
 				end
 			end)
 		end
 	end)
 end)
 RegisterNetEvent('tac_optionalneeds:onDrink')
AddEventHandler('tac_optionalneeds:onDrink', function()
  
  local playerPed = GetPlayerPed(-1)
  
  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
  Citizen.Wait(1000)
  ClearPedTasksImmediately(playerPed)
 end) 
