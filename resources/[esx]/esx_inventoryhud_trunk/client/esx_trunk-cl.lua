tac = nil
local GUI = {}
local PlayerData = {}
local lastVehicle = nil
local lastOpen = false
GUI.Time = 0
local vehiclePlate = {}
local arrayWeight = Config.localWeight
local CloseToVehicle = false
local entityWorld = nil
local globalplate = nil
local lastChecked = 0

Citizen.CreateThread(
  function()
    while tac == nil do
      TriggerEvent(
        "tac:getSharedObject",
        function(obj)
          tac = obj
        end
      )
      Citizen.Wait(0)
    end
  end
)

RegisterNetEvent("tac:playerLoaded")
AddEventHandler(
  "tac:playerLoaded",
  function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent("tac_trunk_inventory:getOwnedVehicule")
    lastChecked = GetGameTimer()
  end
)

AddEventHandler(
  "onResourceStart",
  function()
    PlayerData = xPlayer
    TriggerServerEvent("tac_trunk_inventory:getOwnedVehicule")
    lastChecked = GetGameTimer()
  end
)

RegisterNetEvent("tac:setJob")
AddEventHandler(
  "tac:setJob",
  function(job)
    PlayerData.job = job
  end
)

RegisterNetEvent("tac_trunk_inventory:setOwnedVehicule")
AddEventHandler(
  "tac_trunk_inventory:setOwnedVehicule",
  function(vehicle)
    vehiclePlate = vehicle
    --print("vehiclePlate: ", tac.DumpTable(vehiclePlate))
  end
)

function getItemyWeight(item)
  local weight = 0
  local itemWeight = 0
  if item ~= nil then
    itemWeight = Config.DefaultWeight
    if arrayWeight[item] ~= nil then
      itemWeight = arrayWeight[item]
    end
  end
  return itemWeight
end

function VehicleInFront()
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
  local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
  local a, b, c, d, result = GetRaycastResult(rayHandle)
  return result
end

function openmenuvehicle()
  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)
  local vehicle = VehicleInFront()
  globalplate = GetVehicleNumberPlateText(vehicle)

  if not IsPedInAnyVehicle(playerPed) then
    myVeh = false
    local thisVeh = VehicleInFront()
    PlayerData = tac.GetPlayerData()

    for i = 1, #vehiclePlate do
      local vPlate = all_trim(vehiclePlate[i].plate)
      local vFront = all_trim(GetVehicleNumberPlateText(thisVeh))
      --print('vPlate: ',vPlate)
      --print('vFront: ',vFront)
      --if vehiclePlate[i].plate == GetVehicleNumberPlateText(vehFront) then
      if vPlate == vFront then
        myVeh = true
      elseif lastChecked < GetGameTimer() - 60000 then
        TriggerServerEvent("tac_trunk_inventory:getOwnedVehicule")
        lastChecked = GetGameTimer()
        Wait(2000)
        for i = 1, #vehiclePlate do
          local vPlate = all_trim(vehiclePlate[i].plate)
          local vFront = all_trim(GetVehicleNumberPlateText(thisVeh))
          if vPlate == vFront then
            myVeh = true
          end
        end
      end
    end

    if not Config.CheckOwnership or (Config.AllowPolice and PlayerData.job.name == "police") or (Config.CheckOwnership and myVeh) then
      if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
        CloseToVehicle = true
        local vehFront = VehicleInFront()
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)

        if vehFront > 0 and closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) then
          lastVehicle = vehFront
          local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
          local locked = GetVehicleDoorLockStatus(closecar)
          local class = GetVehicleClass(vehFront)
          tac.UI.Menu.CloseAll()

          if tac.UI.Menu.IsOpen("default", GetCurrentResourceName(), "inventory") then
            SetVehicleDoorShut(vehFront, 5, false)
          else
            if locked == 1 or class == 15 or class == 16 or class == 14 then
              SetVehicleDoorOpen(vehFront, 5, false, false)
              tac.UI.Menu.CloseAll()

              if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
                CloseToVehicle = true
                OpenCoffreInventoryMenu(GetVehicleNumberPlateText(vehFront), Config.VehicleLimit[class], myVeh)
              end
            else
              exports.pNotify:SendNotification(
                {
                  text = _U("trunk_closed"),
                  type = "error",
                  timeout = 3000,
                  layout = "bottomCenter",
                  queue = "trunk"
                }
              )
            end
          end
        else
          exports.pNotify:SendNotification(
            {
              text = _U("no_veh_nearby"),
              type = "error",
              timeout = 3000,
              layout = "bottomCenter",
              queue = "trunk"
            }
          )
        end
        lastOpen = true
        GUI.Time = GetGameTimer()
      end
    else
      -- Not their vehicle
      exports.pNotify:SendNotification(
        {
          text = _U("nacho_veh"),
          type = "error",
          timeout = 3000,
          layout = "bottomCenter",
          queue = "trunk"
        }
      )
    end
  end
end
local count = 0

-- Key controls
Citizen.CreateThread(
  function()
    while true do
      Wait(0)
      if IsControlJustReleased(0, Config.OpenKey) and (GetGameTimer() - GUI.Time) > 1000 then
        openmenuvehicle()
        GUI.Time = GetGameTimer()
      end
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      Wait(0)
      local pos = GetEntityCoords(GetPlayerPed(-1))
      if CloseToVehicle then
        local vehicle = GetClosestVehicle(pos["x"], pos["y"], pos["z"], 2.0, 0, 70)
        if DoesEntityExist(vehicle) then
          CloseToVehicle = true
        else
          CloseToVehicle = false
          lastOpen = false
          tac.UI.Menu.CloseAll()
          SetVehicleDoorShut(lastVehicle, 5, false)
        end
      end
    end
  end
)

RegisterNetEvent("tac:playerLoaded")
AddEventHandler(
  "tac:playerLoaded",
  function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent("tac_trunk_inventory:getOwnedVehicule")
    lastChecked = GetGameTimer()
  end
)

function OpenCoffreInventoryMenu(plate, max, myVeh)
  tac.TriggerServerCallback(
    "tac_trunk:getInventoryV",
    function(inventory)
      text = _U("trunk_info", plate, (inventory.weight / 1000), (max / 1000))
      data = {plate = plate, max = max, myVeh = myVeh, text = text}
      TriggerEvent("tac_inventoryhud:openTrunkInventory", data, inventory.blackMoney, inventory.items, inventory.weapons)
    end,
    plate
  )
end

function all_trim(s)
  if s then
    return s:match "^%s*(.*)":match "(.-)%s*$"
  else
    return "noTagProvided"
  end
end

function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end
