
local isLoadoutLoaded, isPaused, isPlayerSpawned, isDead = false, false, false, false
local lastLoadout, pickups = {}, {}

RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
	tac.PlayerLoaded = true
	tac.PlayerData = xPlayer

	if Config.EnableHud then
		for k,v in ipairs(xPlayer.accounts) do
			local accountTpl = '<div><img src="img/accounts/' .. v.name .. '.png"/>&nbsp;{{money}}</div>'

			tac.UI.HUD.RegisterElement('account_' .. v.name, k - 1, 0, accountTpl, {
				money = 0
			})

			tac.UI.HUD.UpdateElement('account_' .. v.name, {
				money = tac.Math.GroupDigits(v.money)
			})
		end

		local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

		if xPlayer.job.grade_label == '' then
			jobTpl = '<div>{{job_label}}</div>'
		end

		tac.UI.HUD.RegisterElement('job', #xPlayer.accounts, 0, jobTpl, {
			job_label   = '',
			grade_label = ''
		})

		tac.UI.HUD.UpdateElement('job', {
			job_label   = xPlayer.job.label,
			grade_label = xPlayer.job.grade_label
		})
	else
		TriggerEvent('es:setMoneyDisplay', 0.0)
	end
end)

RegisterNetEvent('tac:setMaxWeight')
AddEventHandler('tac:setMaxWeight', function(newMaxWeight)
	tac.PlayerData.maxWeight = newMaxWeight
end)

RegisterNetEvent('tac:createMissingPickups')
AddEventHandler('tac:createMissingPickups', function(missingPickups)
	for pickupId,v in pairs(missingPickups) do
		tac.Game.SpawnLocalObject('prop_money_bag_01', v.coords, function(obj)
			SetEntityAsMissionEntity(obj, true, false)
			PlaceObjectOnGroundProperly(obj)

			pickups[pickupId] = {
				id = pickupId,
				obj = obj,
				label = v.label,
				inRange = false,
				coords = v.coords
			}
		end)
	end
end)

AddEventHandler('playerSpawned', function()
	while not tac.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	-- Restore position
	if tac.PlayerData.lastPosition then
		SetEntityCoords(playerPed, tac.PlayerData.lastPosition.x, tac.PlayerData.lastPosition.y, tac.PlayerData.lastPosition.z)
	end

	TriggerEvent('tac:restoreLoadout') -- restore loadout

	isLoadoutLoaded, isPlayerSpawned, isDead = true, true, false

	if Config.EnablePvP then
		SetCanAttackFriendly(playerPed, true, false)
		NetworkSetFriendlyFireOption(true)
	end
end)

AddEventHandler('tac:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	isLoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not tac.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('tac:restoreLoadout')
end)

AddEventHandler('tac:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for k,v in ipairs(tac.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for k2,v2 in ipairs(v.components) do
			local componentHash = tac.GetWeaponComponent(weaponName, v2).hash

			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, v.ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

RegisterNetEvent('tac:setAccountMoney')
AddEventHandler('tac:setAccountMoney', function(account)
	for k,v in ipairs(tac.PlayerData.accounts) do
		if v.name == account.name then
			tac.PlayerData.accounts[k] = account
			break
		end
	end

	if Config.EnableHud then
		tac.UI.HUD.UpdateElement('account_' .. account.name, {
			money = tac.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	tac.PlayerData.money = money
end)

RegisterNetEvent('tac:addInventoryItem')
AddEventHandler('tac:addInventoryItem', function(item, count)
	for k,v in ipairs(tac.PlayerData.inventory) do
		if v.name == item.name then
			tac.PlayerData.inventory[k] = item
			break
		end
	end

	tac.UI.ShowInventoryItemNotification(true, item, count)

	if tac.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		tac.ShowInventory()
	end
end)

RegisterNetEvent('tac:removeInventoryItem')
AddEventHandler('tac:removeInventoryItem', function(item, count)
	for k,v in ipairs(tac.PlayerData.inventory) do
		if v.name == item.name then
			tac.PlayerData.inventory[k] = item
			break
		end
	end

	tac.UI.ShowInventoryItemNotification(false, item, count)

	if tac.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		tac.ShowInventory()
	end
end)

RegisterNetEvent('tac:setJob')
AddEventHandler('tac:setJob', function(job)
	tac.PlayerData.job = job
end)

RegisterNetEvent('tac:addWeapon')
AddEventHandler('tac:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
	--AddAmmoToPed(playerPed, weaponHash, ammo) possibly not needed
end)

RegisterNetEvent('tac:addWeaponComponent')
AddEventHandler('tac:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = tac.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('tac:setWeaponAmmo')
AddEventHandler('tac:setWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedAmmo(playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('tac:removeWeapon')
AddEventHandler('tac:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)

	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)


RegisterNetEvent('tac:removeWeaponComponent')
AddEventHandler('tac:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = tac.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

-- Commands
RegisterNetEvent('tac:teleport')
AddEventHandler('tac:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('tac:setJob')
AddEventHandler('tac:setJob', function(job)
	if Config.EnableHud then
		tac.UI.HUD.UpdateElement('job', {
			job_label   = job.label,
			grade_label = job.grade_label
		})
	end
end)

RegisterNetEvent('tac:loadIPL')
AddEventHandler('tac:loadIPL', function(name)
	Citizen.CreateThread(function()
		RequestIpl(name)
	end)
end)

RegisterNetEvent('tac:unloadIPL')
AddEventHandler('tac:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('tac:playAnim')
AddEventHandler('tac:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('tac:playEmote')
AddEventHandler('tac:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)

	end)
end)

RegisterNetEvent('tac:spawnVehicle')
AddEventHandler('tac:spawnVehicle', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	tac.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
	end)
end)

RegisterNetEvent('tac:spawnObject')
AddEventHandler('tac:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	tac.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('tac:pickup')
AddEventHandler('tac:pickup', function(id, label, player)
	local ped     = GetPlayerPed(GetPlayerFromServerId(player))
	local coords  = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local x, y, z = table.unpack(coords + forward * -2.0)

	tac.Game.SpawnLocalObject('prop_money_bag_01', {
		x = x,
		y = y,
		z = z - 2.0,
	}, function(obj)
		SetEntityAsMissionEntity(obj, true, false)
		PlaceObjectOnGroundProperly(obj)

		pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			inRange = false,
			coords = {x = x, y = y, z = z}
		}
	end)
end)

RegisterNetEvent('tac:removePickup')
AddEventHandler('tac:removePickup', function(id)
	tac.Game.DeleteObject(pickups[id].obj)
	pickups[id] = nil
end)

RegisterNetEvent('tac:pickupWeapon')
AddEventHandler('tac:pickupWeapon', function(weaponPickup, weaponName, ammo)
	local playerPed = PlayerPedId()
	local pickupCoords = GetOffsetFromEntityInWorldCoords(playerPed, 2.0, 0.0, 0.5)
	local weaponHash = GetHashKey(weaponPickup)

	CreateAmbientPickup(weaponHash, pickupCoords, 0, ammo, 1, false, true)
end)

RegisterNetEvent('tac:spawnPed')
AddEventHandler('tac:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('tac:deleteVehicle')
AddEventHandler('tac:deleteVehicle', function()
	local playerPed = PlayerPedId()
	local vehicle   = tac.Game.GetVehicleInDirection()

	if IsPedInAnyVehicle(playerPed, true) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	end

	if DoesEntityExist(vehicle) then
		tac.Game.DeleteVehicle(vehicle)
	end
end)

-- Pause menu disable HUD display
if Config.EnableHud then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(300)

			if IsPauseMenuActive() and not isPaused then
				isPaused = true
				TriggerEvent('es:setMoneyDisplay', 0.0)
				tac.UI.HUD.SetDisplay(0.0)
			elseif not IsPauseMenuActive() and isPaused then
				isPaused = false
				TriggerEvent('es:setMoneyDisplay', 1.0)
				tac.UI.HUD.SetDisplay(1.0)
			end
		end
	end)
end

-- Save loadout
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		local playerPed      = PlayerPedId()
		local loadout        = {}
		local loadoutChanged = false

		for k,v in ipairs(Config.Weapons) do
			local weaponName = v.name
			local weaponHash = GetHashKey(weaponName)
			local weaponComponents = {}

			if HasPedGotWeapon(playerPed, weaponHash, false) and weaponName ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)

				for k2,v2 in ipairs(v.components) do
					if HasPedGotWeaponComponent(playerPed, weaponHash, v2.hash) then
						table.insert(weaponComponents, v2.name)
					end
				end

				if not lastLoadout[weaponName] or lastLoadout[weaponName] ~= ammo then
					loadoutChanged = true
				end

				lastLoadout[weaponName] = ammo

				table.insert(loadout, {
					name = weaponName,
					ammo = ammo,
					label = v.label,
					components = weaponComponents
				})
			else
				if lastLoadout[weaponName] then
					loadoutChanged = true
				end

				lastLoadout[weaponName] = nil
			end
		end

		if loadoutChanged and isLoadoutLoaded then
			tac.PlayerData.loadout = loadout
			TriggerServerEvent('tac:updateLoadout', loadout)
		end
	end
end)

-- Menu interactions
--Citizen.CreateThread(function()
	--while true do
		--Citizen.Wait(0)

		--if IsControlJustReleased(0, 289) and IsInputDisabled(0) and not isDead and not tac.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			--tac.ShowInventory()
		--end
	--end
--end)

-- Disable wanted level
if Config.DisableWantedLevel then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			local playerId = PlayerId()
			if GetPlayerWantedLevel(playerId) ~= 0 then
				SetPlayerWantedLevel(playerId, 0, false)
				SetPlayerWantedLevelNow(playerId, false)
			end
		end
	end)
end

-- Pickups
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		
		-- if there's no nearby pickups we can wait a bit to save performance
		if next(pickups) == nil then
			Citizen.Wait(500)
		end

		for k,v in pairs(pickups) do
			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = tac.Game.GetClosestPlayer()

			if distance <= 5.0 then
				tac.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, v.label)
			end

			if (closestDistance == -1 or closestDistance > 3) and distance <= 1.0 and not v.inRange and IsPedOnFoot(playerPed) then
				TriggerServerEvent('tac:onPickup', v.id)
				PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
				v.inRange = true
			end
		end
	end
end)

-- Last position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()

		if tac.PlayerLoaded and isPlayerSpawned then
			local coords = GetEntityCoords(playerPed)

			if not IsEntityDead(playerPed) then
				tac.PlayerData.lastPosition = {x = coords.x, y = coords.y, z = coords.z}
			end
		end

		if IsEntityDead(playerPed) and isPlayerSpawned then
			isPlayerSpawned = false
		end
	end
end)
