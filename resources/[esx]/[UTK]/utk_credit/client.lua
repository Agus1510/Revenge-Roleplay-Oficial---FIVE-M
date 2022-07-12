tac = nil

Enableshow = false
CloseForNow = false
Testvehicle = nil
local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
GeneratePlate = function() local generatedPlate local doBreak = false while true do Citizen.Wait(2) math.randomseed(GetGameTimer()) generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers)) tac.TriggerServerCallback('tac_vehicleshop:isPlateTaken', function (isPlateTaken) if not isPlateTaken then doBreak = true end end, generatedPlate) if doBreak then break end end return generatedPlate end
IsPlateTaken = function(plate) local callback = 'waiting' tac.TriggerServerCallback('utk_c:platecheck', function(isPlateTaken) callback = isPlateTaken end, plate) while type(callback) == 'string' do Citizen.Wait(0) end return callback end
GetRandomNumber = function(length) Citizen.Wait(1) math.randomseed(GetGameTimer()) if length > 0 then return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)] else return '' end end
GetRandomLetter = function(length) Citizen.Wait(1) math.randomseed(GetGameTimer()) if length > 0 then return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)] else return '' end end
Citizen.CreateThread(function() while tac == nil do TriggerEvent('tac:getSharedObject', function(obj) tac = obj end) end end)
RegisterNetEvent("utk_c:playerfound")
AddEventHandler("utk_c:playerfound", function()
    tac.TriggerServerCallback("utk_c:getcredit", function(output)
        Credit = tonumber(output)
        Enableshow = true
    end)
end)

RegisterNetEvent("utk_c:creditfeed")
AddEventHandler("utk_c:creditfeed", function(amount)
    Credit = amount
end)

Citizen.CreateThread(function() -- menu locations and markers
    while true do
        local coords = GetEntityCoords(PlayerPedId())

        for i = 1, #Config.Locations, 1 do
            local dst = GetDistanceBetweenCoords(coords, Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z, true)
            if dst <= Config.Locations[i].dst and not CloseForNow then
                DrawText3D(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z - 0.30, Config.Locations[i].text, 0.40)
                DrawMarker(1, Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z - 1, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 1.2, 236, 236, 80, 155, false, false, 2, false, 0, 0, 0, 0)
                if dst <= 1 and IsControlJustReleased(0, 38) then
                    CurrentLoc = vector3(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
                    _G[Config.Locations[i].func]()
                    CloseForNow = true
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function() -- onscreen credit
    while true do
        if Enableshow then
            if Credit ~= nil then
                ShowCreditScreen(Credit)
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function() -- menu proximity check
    while true do
        if MenuOpen then
            local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), CurrentLoc, true)

            if dst >= 1.5 then
                tac.UI.Menu.CloseAll()
                CloseForNow = false
                MenuOpen= false
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Testvehicle ~= nil then
            DisableControlAction(0, 75,  true)
            DisableControlAction(27, 75, true)
        end
        Citizen.Wait(10)
    end
end)

OpenExchangeMenu = function()
    MenuOpen = true
    tac.UI.Menu.CloseAll()
    tac.UI.Menu.Open("default", GetCurrentResourceName(), "exchange", {
        title = "Cambio de creditos",
        align = "top-left",
        elements = {
            {label = "25.000$ | 5 Creditos", value = 5, cash = 25000}, -- value is the credit cost | cash is amount players gets
            {label = "125.000$ | 25 Creditos", value = 25, cash = 125000},
            {label = "350.000$ | 50 Creditos", value = 50, cash = 250000},
            {label = "800.000$ | 100 Creditos", value = 100, cash = 500000},
            {label = "2.250.000$ | 250 Creditos", value = 250, cash = 2250000},
            {label = "3.500.000$ | 500 Creditos", value = 500, cash = 3500000},
        }
    }, function(data, menu)
        if data.current.value == 5 or data.current.value == 25 or data.current.value == 50 or data.current.value == 100 or data.current.value == 250 or data.current.value == 500 then
            local cash = data.current.cash
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                title = "Estas seguro?",
                align = "top-left",
                elements = {
                    {label = "Si", value = true},
                    {label = "No", value = false}
                }
            }, function(data2, menu2)
                if data2.current.value then
                    tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                        if tonumber(curamount) >= data.current.value then
                            tac.UI.Menu.CloseAll()
                            CloseForNow = false
                            newamount = curamount - data.current.value
                            TriggerServerEvent("utk_c:updatecredit", newamount, "exchange", cash, data.current.value)
                            TriggerServerEvent("utk_c:updatemoney", "add", cash)
                            exports["mythic_notify"]:SendAlert("success", data.current.value.." creditos cambiados por "..tac.Math.GroupDigits(cash).."$ .")
                        else
                            exports["mythic_notify"]:SendAlert("error", "No tienes suficientes creditos!")
                        end
                    end)
                elseif not data2.current.value then
                    menu2.close()
                    menu.open()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function (data, menu)
        menu.close()
        MenuOpen = false
        CloseForNow = false
    end)
end

OpenBlackMarket = function()
    MenuOpen = true
    tac.UI.Menu.CloseAll()

    tac.UI.Menu.Open("default", GetCurrentResourceName(), "wep-shop", {
        title = "Mercado negro",
        align = "top-left",
        elements = {
            {label = "Chaleco antibalas", value = "bulletproof", price = 250},
            {label = "Ganzuas", value = "lockpick", price = 5}, -- label is menu option | value is weapon code | price is credit cost
            {label = "Hacker Laptop", value = "laptop_h", price = 10}
        }
    }, function(data, menu)
        local selection = data.current

        if selection.value == "plaka" then
            local carlist = nil

            tac.TriggerServerCallback("utk_c:getVehList", function(result)
                if result ~= nil then
                    carlist = result
                    tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                        if tonumber(curamount) >= 20 then
                            local thetable = {}
                            local temp = {}
                            local carhash
                            local name

                            for i = 1, #carlist, 1 do
                                carhash = json.decode(carlist[i].vehicle)
                                if GetDisplayNameFromVehicleModel(carhash.model) ~= "CARNOTFOUND" then
                                    name = GetDisplayNameFromVehicleModel(carhash.model)
                                else
                                    name = GetVehicleName(carhash.model)
                                end

                                temp = {label = name.." | "..carlist[i].plate, value = carlist[i].plate}
                                table.insert(thetable, temp)
                            end
                            tac.UI.Menu.Open("default", GetCurrentResourceName(), "platelist", {
                                title = "Owned Vehicles",
                                align = "top-left",
                                elements = thetable
                            }, function(data2, menu2)
                                if data2.current.value ~= nil then
                                    local oldplate = data2.current.value

                                    tac.UI.Menu.Open("dialog", GetCurrentResourceName(), "plate", {
                                        title = "New Plate"
                                    }, function(data3, menu3)
                                        local newplate = nil
                                        local newamount = nil

                                        if tostring(data3.value):len() <= 8 and tostring(data3.value):len() >= 4 then
                                            newplate = tostring(data3.value)
                                            tac.TriggerServerCallback("utk_c:platecheck", function(oc)
                                                if not oc then
                                                    newamount = curamount - 20
                                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                                    TriggerServerEvent("utk_c:changePlate", oldplate, newplate)
                                                    TriggerServerEvent("utk_c:savecustomlog", "__"..oldplate.."__ plakalı aracın plakası __"..string.upper(newplate).."__ plakasına değiştirildi.", "Plaka Değiştirme")
                                                    tac.UI.Menu.CloseAll()
                                                    FreezeEntityPosition(PlayerPedId(), false)
                                                    CloseForNow = false
                                                    exports["mythic_notify"]:SendAlert("success", "Tu placa nueva es: "..string.upper(newplate).." .")
                                                else
                                                    exports["mythic_notify"]:SendAlert("error", "Esta placa ya esta en uso!")
                                                    tac.UI.Menu.CloseAll()
                                                    CloseForNow = false
                                                end
                                            end, string.upper(data3.value))
                                        else
                                            exports["mythic_notify"]:SendAlert("error", "Los numeros deben ser entre 4 y 8.")
                                        end
                                    end, function(data3, menu3)
                                        menu3.close()
                                    end)
                                end
                            end, function(data2, menu2)
                                menu2.close()
                            end)
                        else
                            exports["mythic_notify"]:SendAlert("error", "No tienes suficientes creditos!")
                        end
                    end)
                else
                    exports["mythic_notify"]:SendAlert("error", "No tienes ningun vehiculo!")
                end
            end)
        else
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                title = "Onaylıyor musunuz?",
                align = "top-left",
                elements = {
                    {label = "Si", value = "evet"},
                    {label = "No", value = "hayır"}
                }
            }, function(data2, menu2)
                if data2.current.value == "evet" then
                    tac.TriggerServerCallback("utk_c:getcredit", function(result)
                        if tonumber(result) >= selection.price then
                            newamount = result - selection.price
                            TriggerServerEvent("utk_c:updatecredit", newamount, nil, nil, nil)
                            TriggerServerEvent("utk_c:giveitem", selection.value, selection.label, selection.price, newamount)
                            exports["mythic_notify"]:SendAlert("success", selection.label.." itemini "..selection.price.." Compraste con bitcoin.")
                            menu2.close()
                        else
                            exports["mythic_notify"]:SendAlert("error", "No tienes suficientes bitcoin!")
                            menu2.close()
                        end
                    end)
                elseif data2.current.value == "hayır" then
                    menu2.close()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

OpenMarket = function()
    --MenuOpen = true
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    tac.UI.Menu.CloseAll()
    tac.UI.Menu.Open("default", GetCurrentResourceName(), "vehicle-shop", {
        title = "Concesionario con creditos",
        align = "top-left",
        elements = {
            {label = "Categoria 300 Creditos", value = "300"}, -- These are categories, VALUE is the credit cost
            {label = "Categoria 500 Creditos", value = "500"},
            {label = "Categoria 700 Creditos", value = "700"},
            {label = "Categoria 900 Creditos", value = "900"},
            {label = "Categoria 1100 Creditos", value = "1100"},
            {label = "Categoria 1500 Creditos", value = "1500"},
            {label = "Categoria 2500 Credit Volatus Helicopter", value = "2500"}, -- This is a single vehicle for example
            {label = "200 Cambiar placa", value = "200"} -- This is plate change
        }
    }, function(data, menu)
        if data.current.value == "300" then
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "30-shop", {
                title = "50 Creditos",
                align = "top-left",
                elements = {
                    {label = "Focus Rs", value = "focusrs"}, -- label is menu name | value is spawn name DON'T FORGET TO CHANGE THESE TO YOUR LIKING, YOU CAN PUT ADD-ON CARS
                    {label = "Audi s1", value = "s1"},
                    {label = "Volkswagen amarok", value = "amarok"},
                    {label = "Dodge Challanger", value = "16challenger"}
                }
            }, function(data2, menu2)
                if data2.current.value == "focusrs" or data2.current.value == "s1" or data2.current.value == "amarok" or data2.current.value == "16challenger" then
                    local notify = data2.current.label
                    local spawnname = data2.current.value

                    tac.Game.SpawnLocalVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                        Testvehicle = vehicle
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        FreezeEntityPosition(vehicle, true)
                    end)
                    tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                        title = "Estas seguro?",
                        align = "top-left",
                        elements = {
                            {label = "Si", value = true},
                            {label = "No", value = false}
                        }
                    }, function(data3, menu3)
                        if data3.current.value then
                            tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                                if tonumber(curamount) >= 300 then
                                    tac.Game.DeleteVehicle(Testvehicle)
                                    Testvehicle = nil
                                    newamount = curamount - 300
                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                    tac.Game.SpawnVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                        local newPlate = GeneratePlate()
                                        SetVehicleNumberPlateTextIndex(vehicle, Config.platecolor)
                                        SetVehicleColours(vehicle, Config.vehcolor, Config.vehcolor)
                                        local vehicleProps = tac.Game.GetVehicleProperties(vehicle)

                                        vehicleProps.plate = newPlate
                                        SetVehicleNumberPlateText(vehicle, newPlate)
                                        TriggerServerEvent('utk_c:registervehicle', vehicleProps, notify, 300)
                                        exports['mythic_notify']:SendAlert("success", "Usaste 300 creditos en "..notify.." !")
                                    end)
                                    tac.UI.Menu.CloseAll()
                                    CloseForNow = false
                                    FreezeEntityPosition(playerPed, false)
                                else
                                    exports['mythic_notify']:SendAlert("error", "No tienes suficientes creditos!")
                                end
                            end)
                        elseif not data3.current.value then
                            SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                            tac.Game.DeleteVehicle(Testvehicle)
                            Testvehicle = nil
                            menu3.close()
                            menu2.open()
                        end
                    end, function(data3, menu3)
                        SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                        tac.Game.DeleteVehicle(Testvehicle)
                        Testvehicle = nil
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == "500" then
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "500-shop", {
                title = "500 Creditos",
                align = "top-left",
                elements = {
                    {label = "Audi rs5", value = "2014rs5"},
                    {label = "Nissan silvia s15", value = "s15"},
					{label = "BMW m3 f80", value = "m3f80"},
					{label = "Ford mustang", value = "fmgt"},
                    {label = "Bmw X6M", value = "x6m"}
                }
            }, function(data2, menu2)
                if data2.current.value == "2014rs5" or data2.current.value == "s15" or data2.current.value == "m3f80" or data2.current.value == "fmgt" or data2.current.value == "x6m" then
                    local notify = data2.current.label
                    local spawnname = data2.current.value

                    tac.Game.SpawnLocalVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                        Testvehicle = vehicle
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        FreezeEntityPosition(vehicle, true)
                    end)
                    tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                        title = "Estas seguro?",
                        align = "top-left",
                        elements = {
                            {label = "Si", value = true},
                            {label = "No", value = false}
                        }
                    }, function(data3, menu3)
                        if data3.current.value then
                            tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                                if tonumber(curamount) >= 500 then
                                    tac.Game.DeleteVehicle(Testvehicle)
                                    Testvehicle = nil
                                    newamount = curamount - 500
                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                    tac.Game.SpawnVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function (vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                        local newPlate = GeneratePlate()
                                        SetVehicleNumberPlateTextIndex(vehicle, 2)
                                        SetVehicleColours(vehicle, 53, 53)
                                        local vehicleProps = tac.Game.GetVehicleProperties(vehicle)

                                        vehicleProps.plate = newPlate
                                        SetVehicleNumberPlateText(vehicle, newPlate)
                                        TriggerServerEvent('utk_c:registervehicle', vehicleProps, notify, 500)
                                        exports['mythic_notify']:SendAlert("success", "Gastaste 500 creditos en "..notify.." !")
                                    end)
                                    tac.UI.Menu.CloseAll()
                                    CloseForNow = false
                                    FreezeEntityPosition(playerPed, false)
                                else
                                    exports['mythic_notify']:SendAlert("error", "No tienes suficientes creditos!")
                                end
                            end)
                        elseif not data3.current.value then
                            SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                            tac.Game.DeleteVehicle(Testvehicle)
                            Testvehicle = nil
                            menu3.close()
                            menu2.open()
                        end
                    end, function(data3, menu3)
                        SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                        tac.Game.DeleteVehicle(Testvehicle)
                        Testvehicle = nil
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == "700" then
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "700-shop", {
                title = "700 Creditos",
                align = "top-left",
                elements = {
                    {label = "Mercedes G65", value = "g65amg"},
                    {label = "Lamborghini diablo", value = "bullet"},
                    {label = "Maserati gran turismo", value = "mgrantur2010"},
					{label = "BMW 1000rr", value = "bmws"},
                }
            }, function(data2, menu2)
                if data2.current.value == "g65amg" or data2.current.value == "bullet" or data2.current.value == "mgrantur2010" or data2.current.value == "bmws" then
                    local notify = data2.current.label
                    local spawnname = data2.current.value

                    tac.Game.SpawnLocalVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                        Testvehicle = vehicle
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        FreezeEntityPosition(vehicle, true)
                    end)
                    tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                        title = "Estas seguro?",
                        align = "top-left",
                        elements = {
                            {label = "Si", value = true},
                            {label = "No", value = false}
                        }
                    }, function(data3, menu3)
                        if data3.current.value then
                            tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                                if tonumber(curamount) >= 700 then
                                    tac.Game.DeleteVehicle(Testvehicle)
                                    Testvehicle = nil
                                    newamount = curamount - 700
                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                    tac.Game.SpawnVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function (vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                        local newPlate = GeneratePlate()
                                        SetVehicleNumberPlateTextIndex(vehicle, 2)
                                        SetVehicleColours(vehicle, 53, 53)
                                        local vehicleProps = tac.Game.GetVehicleProperties(vehicle)

                                        vehicleProps.plate = newPlate
                                        SetVehicleNumberPlateText(vehicle, newPlate)
                                        TriggerServerEvent('utk_c:registervehicle', vehicleProps, notify, 700)
                                        exports['mythic_notify']:SendAlert("success", "Gastaste 700 creditos en "..notify.." !")
                                    end)
                                    tac.UI.Menu.CloseAll()
                                    CloseForNow = false
                                    FreezeEntityPosition(playerPed, false)
                                else
                                    exports['mythic_notify']:SendAlert("error", "No tienes suficientes creditos!")
                                end
                            end)
                        elseif not data3.current.value then
                            SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                            tac.Game.DeleteVehicle(Testvehicle)
                            Testvehicle = nil
                            menu3.close()
                            menu2.open()
                        end
                    end, function(data3, menu3)
                        SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                        tac.Game.DeleteVehicle(Testvehicle)
                        Testvehicle = nil
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == "900" then
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "900-shop", {
                title = "900 Creditos",
                align = "top-left",
                elements = {
                    {label = "Porsche 911 speedster", value = "str20"},
                    {label = "Ferrari California", value = "fc15"},
                    {label = "Ferrari 360 Modena", value = "modena"},
                    {label = "Lamborghini Gallardo", values = "gallardo"}
                }
            }, function(data2, menu2)
                if data2.current.value == "str20" or data2.current.value == "fc15" or data2.current.value == "modena" or data2.current.value == "gallardo" then
                    local notify = data2.current.label
                    local spawnname = data2.current.value

                    tac.Game.SpawnLocalVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                        Testvehicle = vehicle
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        FreezeEntityPosition(vehicle, true)
                    end)
                    tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                        title = "Estas seguro?",
                        align = "top-left",
                        elements = {
                            {label = "Si", value = true},
                            {label = "No", value = false}
                        }
                    }, function(data3, menu3)
                        if data3.current.value then
                            tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                                if tonumber(curamount) >= 900 then
                                    tac.Game.DeleteVehicle(Testvehicle)
                                    Testvehicle = nil
                                    newamount = curamount - 900
                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                    tac.Game.SpawnVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function (vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                        local newPlate = GeneratePlate()
                                        SetVehicleNumberPlateTextIndex(vehicle, 2)
                                        SetVehicleColours(vehicle, 53, 53)
                                        local vehicleProps = tac.Game.GetVehicleProperties(vehicle)

                                        vehicleProps.plate = newPlate
                                        SetVehicleNumberPlateText(vehicle, newPlate)
                                        TriggerServerEvent('utk_c:registervehicle', vehicleProps, notify, 900)
                                        exports['mythic_notify']:SendAlert("success", "Gastaste 900 creditos en "..notify.." !")
                                    end)
                                    tac.UI.Menu.CloseAll()
                                    CloseForNow = false
                                    FreezeEntityPosition(playerPed, false)
                                else
                                    exports['mythic_notify']:SendAlert("error", "No tienes suficientes creditos!")
                                end
                            end)
                        elseif not data3.current.value then
                            SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                            tac.Game.DeleteVehicle(Testvehicle)
                            Testvehicle = nil
                            menu3.close()
                            menu2.open()
                        end
                    end, function(data3, menu3)
                        SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                        tac.Game.DeleteVehicle(Testvehicle)
                        Testvehicle = nil
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == "1100" then
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "1100-shop", {
                title = "1100 Creditos",
                align = "top-left",
                elements = {
                    {label = "Porsche Macan 2019", value = "pm19"},
                    {label = "Lamborghini Huracan", value = "lp610"},
                }
            }, function(data2, menu2)
                if data2.current.value == "pm19" or data2.current.value == "lp610" then
                    local notify = data2.current.label
                    local spawnname = data2.current.value

                    tac.Game.SpawnLocalVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                        Testvehicle = vehicle
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        FreezeEntityPosition(vehicle, true)
                    end)
                    tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                        title = "Estas seguro?",
                        align = "top-left",
                        elements = {
                            {label = "Si", value = true},
                            {label = "No", value = false}
                        }
                    }, function(data3, menu3)
                        if data3.current.value then
                            tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                                if tonumber(curamount) >= 1100 then
                                    tac.Game.DeleteVehicle(Testvehicle)
                                    Testvehicle = nil
                                    newamount = curamount - 1100
                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                    tac.Game.SpawnVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function (vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                        local newPlate = GeneratePlate()
                                        SetVehicleNumberPlateTextIndex(vehicle, 2)
                                        SetVehicleColours(vehicle, 53, 53)
                                        local vehicleProps = tac.Game.GetVehicleProperties(vehicle)

                                        vehicleProps.plate = newPlate
                                        SetVehicleNumberPlateText(vehicle, newPlate)
                                        TriggerServerEvent('utk_c:registervehicle', vehicleProps, notify, 1100)
                                        exports['mythic_notify']:SendAlert("success", "Gastaste 1100 creditos en "..notify.." !")
                                    end)
                                    tac.UI.Menu.CloseAll()
                                    CloseForNow = false
                                    FreezeEntityPosition(playerPed, false)
                                else
                                    exports['mythic_notify']:SendAlert("error", "No tienes suficientes creditos!")
                                end
                            end)
                        elseif not data3.current.value then
                            SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                            tac.Game.DeleteVehicle(Testvehicle)
                            Testvehicle = nil
                            menu3.close()
                            menu2.open()
                        end
                    end, function(data3, menu3)
                        SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                        tac.Game.DeleteVehicle(Testvehicle)
                        Testvehicle = nil
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == "1500" then
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "1500-shop", {
                title = "1500 Creditos",
                align = "top-left",
                elements = {
                    {label = "Rolls Royce Ghost", value = "ghostswb1"},
                    {label = "Aston Martin Vantage", value = "vantage"},
                    {label = "Ferrari 458 speciale", value = "458spc"},
                    {label = "Lamborghini Gallardo superleggera", value = "lp570"},
					{label = "Mclaren 720s", value = "720s"},
                    {label = "Mercedes Benz g500 square", value = "g500"}
                }
            }, function(data2, menu2)
                if data2.current.value == "ghostswb1" or data2.current.value == "vantage" or data2.current.value == "458spc" or data2.current.value == "lp570" or data2.current.value == "720s" or data2.current.value == "g500" then
                    local notify = data2.current.label
                    local spawnname = data2.current.value

                    tac.Game.SpawnLocalVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                        Testvehicle = vehicle
                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        FreezeEntityPosition(vehicle, true)
                    end)
                    tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                        title = "Estas seguro?",
                        align = "top-left",
                        elements = {
                            {label = "Si", value = true},
                            {label = "No", value = false}
                        }
                    }, function(data3, menu3)
                        if data3.current.value then
                            tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                                if tonumber(curamount) >= 1500 then
                                    tac.Game.DeleteVehicle(Testvehicle)
                                    Testvehicle = nil
                                    newamount = curamount - 1500
                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                    tac.Game.SpawnVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function (vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                        local newPlate = GeneratePlate()
                                        SetVehicleNumberPlateTextIndex(vehicle, 2)
                                        SetVehicleColours(vehicle, 53, 53)
                                        local vehicleProps = tac.Game.GetVehicleProperties(vehicle)

                                        vehicleProps.plate = newPlate
                                        SetVehicleNumberPlateText(vehicle, newPlate)
                                        TriggerServerEvent('utk_c:registervehicle', vehicleProps, notify, 1500)
                                        exports['mythic_notify']:SendAlert("success", "Gastaste 1500 creditos en "..notify.." !")
                                    end)
                                    tac.UI.Menu.CloseAll()
                                    CloseForNow = false
                                    FreezeEntityPosition(playerPed, false)
                                else
                                    exports['mythic_notify']:SendAlert("error", "No tienes suficientes creditos!")
                                end
                            end)
                        elseif not data3.current.value then
                            SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                            tac.Game.DeleteVehicle(Testvehicle)
                            Testvehicle = nil
                            menu3.close()
                            menu2.open()
                        end
                    end, function(data3, menu3)
                        SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                        tac.Game.DeleteVehicle(Testvehicle)
                        Testvehicle = nil
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == "2500" then
            local notify = "Helicoptero Volatus"
            local spawnname = "volatus"

            tac.Game.SpawnLocalVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function(vehicle)
                Testvehicle = vehicle
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                FreezeEntityPosition(vehicle, true)
            end)
            tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure", {
                title = "Estas seguro?",
                align = "top-left",
                elements = {
                    {label = "Si", value = true},
                    {label = "No", value = false}
                }
            }, function(data3, menu3)
                if data3.current.value then
                    tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                        if tonumber(curamount) >= 2500 then
                            tac.Game.DeleteVehicle(Testvehicle)
                            Testvehicle = nil
                            newamount = curamount - 2500
                            TriggerServerEvent("utk_c:updatecredit", newamount)
                            tac.Game.SpawnVehicle(spawnname, Config.Locations[2].spawnloc, Config.Locations[2].heading, function (vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = GeneratePlate()
                                SetVehicleNumberPlateTextIndex(vehicle, 2)
                                SetVehicleColours(vehicle, 53, 53)
                                local vehicleProps = tac.Game.GetVehicleProperties(vehicle)

                                vehicleProps.plate = newPlate
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                TriggerServerEvent('utk_c:registervehicle', vehicleProps, notify, 2500)
                                exports['mythic_notify']:SendAlert("success", "Gastaste 2500 creditos en "..notify.." !")
                            end)
                            tac.UI.Menu.CloseAll()
                            CloseForNow = false
                            FreezeEntityPosition(playerPed, false)
                        else
                            exports['mythic_notify']:SendAlert("error", "No tienes suficientes creditos!")
                        end
                    end)
                elseif not data3.current.value then
                    SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                    tac.Game.DeleteVehicle(Testvehicle)
                    Testvehicle = nil
                    menu3.close()
                    menu.open()
                end
            end, function(data3, menu3)
                SetEntityCoords(playerPed, Config.Locations[2].x, Config.Locations[2].y, Config.Locations[2].z - 1, 0.0, 0.0, 0.0, false)
                tac.Game.DeleteVehicle(Testvehicle)
                Testvehicle = nil
                menu3.close()
            end)
        elseif data.current.value == "200" then
            local carlist = nil

            tac.TriggerServerCallback("utk_c:getVehList", function(result)
                if result ~= nil then
                    carlist = result
                    tac.TriggerServerCallback("utk_c:getcredit", function(curamount)
                        if tonumber(curamount) >= 200 then
                            local thetable = {}
                            local temp = {}
                            local carhash
                            local name

                            for i = 1, #carlist, 1 do
                                carhash = json.decode(carlist[i].vehicle)
                                if GetDisplayNameFromVehicleModel(carhash.model) ~= "CARNOTFOUND" then
                                    name = GetDisplayNameFromVehicleModel(carhash.model)
                                else
                                    name = GetVehicleName(carhash.model)
                                end

                                temp = {label = name.." | "..carlist[i].plate, value = carlist[i].plate}
                                table.insert(thetable, temp)
                            end
                            tac.UI.Menu.Open("default", GetCurrentResourceName(), "platelist", {
                                title = "Owned Vehicles",
                                align = "top-left",
                                elements = thetable
                            }, function(data2, menu2)
                                if data2.current.value ~= nil then
                                    local oldplate = data2.current.value

                                    tac.UI.Menu.Open("dialog", GetCurrentResourceName(), "plate", {
                                        title = "New Plate"
                                    }, function(data3, menu3)
                                        local newplate = nil
                                        local newamount = nil

                                        if tostring(data3.value):len() <= 8 and tostring(data3.value):len() >= 4 then
                                            newplate = tostring(data3.value)
                                            tac.TriggerServerCallback("utk_c:platecheck", function(oc)
                                                if not oc then
                                                    newamount = curamount - 200
                                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                                    TriggerServerEvent("utk_c:changePlate", oldplate, newplate)
                                                    TriggerServerEvent("utk_c:savecustomlog", "__"..oldplate.."__ cambio a __"..string.upper(newplate).."__ plate.", "Plate Change")
                                                    tac.UI.Menu.CloseAll()
                                                    FreezeEntityPosition(PlayerPedId(), false)
                                                    CloseForNow = false
                                                    exports["mythic_notify"]:SendAlert("success", "Tu nueva placa es: "..string.upper(newplate).." .")
                                                else
                                                    exports["mythic_notify"]:SendAlert("error", "Esta placa ya esta usada!")
                                                    tac.UI.Menu.CloseAll()
                                                    CloseForNow = false
                                                end
                                            end, string.upper(data3.value))
                                        else
                                            exports["mythic_notify"]:SendAlert("error", "Los numeros tienen que ser entre 4 y 8.")
                                        end
                                    end, function(data3, menu3)
                                        menu3.close()
                                    end)
                                end
                            end, function(data2, menu2)
                                menu2.close()
                            end)
                        else
                            exports["mythic_notify"]:SendAlert("error", "No tienes suficientes creditos!")
                        end
                    end)
                else
                    exports["mythic_notify"]:SendAlert("error", "No tienes ningun vehiculo!")
                end
            end)
        end
    end, function(data, menu)
        FreezeEntityPosition(playerPed, false)
        MenuOpen = false
        menu.close()
        CloseForNow = false
    end)
end

OpenWepShop = function() -- This is a bit complicated because I had something different in my mind while creating this menu. If you need a clean item or weapons menu come Discord.
    MenuOpen = true
    tac.UI.Menu.CloseAll()
    local playerPed = PlayerPedId()

    tac.UI.Menu.Open("default", GetCurrentResourceName(), "wep-shop", {
        title = "Armeria (Creditos)",
        align = "top-left",
        elements = {
            {label = "50 Creditos | Desert Eagle .50", value = "weapon_pistol50", price = 50, method = 1, notify = "Desert Eagle .50"}, -- label is menu option | value is weapon code | price is credit cost
            {label = "100 Creditos | Golden Revolver", value = "weapon_doubleaction", price = 50, method = 1, notify = "Golden Revolver"},
            {label = "140 Creditos | Micro SMG", value = "weapon_microsmg", price = 140, method = 1, notify = "Micro SMG"},
            {label = "200 Creditos | Assault Rifle", value = "weapon_assaultrifle", price = 200, method = 1, notify = "Assault Rifle"},
            {label = "400 Creditos | Sniper Rifle", value = "weapon_sniperrifle", price = 400, method = 1, notify = "Sniper Rifle"},
            {label = "10 Creditos | Platinium Plating ", value = "platin50", check = {"weapon_pistol50"}, price = 10, method = 2, notify = "Pintura de platino"}, -- This is an item example | you can sell any item in this shop if you want
            {label = "10 Creditos | Gold Plating", value = "yusuf", check = {"weapon_microsmg", "weapon_assaultrifle"}, price = 10, method = 2, notify = "Pintura dorada"}, -- checks are item checks, if the player don't own the weapon he/she cannot buy the item
            {label = "5 Creditos | 500 Bullets", value =  500, price = 5, method = 3, notify = "500 Bullets"}, -- Has to hold a weapon while buying (AMMO)
            {label = "1 Creditos | 100 Bullets", value = 100, price = 1, method = 3, notify = "100 Bullets"}
        }
    }, function(data, menu)
        if data.current.value == "weapon_pistol50" or data.current.value == "platin50" or data.current.value == "yusuf" or data.current.value == "weapon_doubleaction" or data.current.value == "weapon_microsmg" or data.current.value == "weapon_assaultrifle" or data.current.value == "weapon_sniperrifle" then
            local choice = data.current

            tac.UI.Menu.Open("default", GetCurrentResourceName(), "areyousure2", {
                title = "Estas seguro? | "..tostring(choice.price).." Credit",
                align = "top-left",
                elements = {
                    {label = "Si", value = true},
                    {label = "No", value = false}
                }
            }, function(data2, menu2)
                if data2.current.value then
                    if choice.method == 1 then
                        if not HasPedGotWeapon(playerPed, GetHashKey(choice.value), false) then
                            tac.TriggerServerCallback("utk_c:getcredit", function(output)
                                if tonumber(output) >= choice.price then
                                    newamount = tonumber(output) - choice.price
                                    TriggerServerEvent("utk_c:updatecredit", newamount)
                                    TriggerServerEvent("utk_c:savecustomlog", "**"..choice.notify.."** item has been bought for **"..choice.price.."** Credit.", "Market Usage")
                                    GiveWeaponToPed(playerPed, GetHashKey(choice.value), 500, false, false)
                                    exports["mythic_notify"]:SendAlert("success", tostring(choice.price).." Gastaste los creditos en "..choice.notify..".")
                                    menu2.close()
                                    menu.open()
                                else
                                    exports["mythic_notify"]:SendAlert("error", "No tienes suficientes creditos.")
                                    menu2.close()
                                    menu.open()
                                end
                            end)
                        else
                            exports["mythic_notify"]:SendAlert("error", "Ya tienes "..choice.notify..".")
                            menu2.close()
                            menu.open()
                        end
                    elseif choice.method == 2 then
                        local control = 0
                        local hasitem
                        tac.TriggerServerCallback("utk_c:checkitem", function(output)
                            hasitem = output
                            if not hasitem then
                                for i = 1, #choice.check, 1 do
                                    if HasPedGotWeapon(playerPed, GetHashKey(choice.check[i]), false) then
                                        tac.TriggerServerCallback("utk_c:getcredit", function(output)
                                            if tonumber(output) >= choice.price then
                                                newamount = tonumber(output) - choice.price
                                                TriggerServerEvent("utk_c:updatecredit", newamount)
                                                TriggerServerEvent("utk_c:giveitem", choice.value)
                                                TriggerServerEvent("utk_c:savecustomlog", "**"..choice.notify.."** item has been bought for **"..choice.price.."** Credit.", "Market Usage")
                                                exports["mythic_notify"]:SendAlert("success", tostring(choice.price).." Gastaste creditos en "..choice.notify..".")
                                                exports["mythic_notify"]:SendAlert("success", "To plate, hold your weapon while using the item.")
                                                menu2.close()
                                            else
                                                exports["mythic_notify"]:SendAlert("error", "No tienes suficientes creditos.")
                                                menu2.close()
                                            end
                                        end)
                                        break
                                    else
                                        control = control + 1
                                        if control == 2 and choice.value == "yusuf" then
                                            exports["mythic_notify"]:SendAlert("error", "No tienes un arma que se pueda pintar .")
                                            menu2.close()
                                            break
                                        elseif control == 1 and choice.value == "platin50" then
                                            exports["mythic_notify"]:SendAlert("error", "No tienes un arma que se pueda pintar.")
                                            menu2.close()
                                            break
                                        end
                                    end
                                end
                            elseif hasitem then
                                exports["mythic_notify"]:SendAlert("error", "Ya tienes "..choice.notify..".")
                                menu2.close()
                            end
                        end, choice.value)
                    end
                else
                    menu2.close()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 500 or data.current.value == 100 then
            local choice = data.current

            if choice.method == 3 then
                tac.UI.Menu.Open("default", GetCurrentResourceName(), "ammo-shop", {
                    title = "Elegir arma| "..choice.value.."  Ammo",
                    align = "top-left",
                    elements = {
                        {label = "Desert Eagle .50", value = "weapon_pistol50"}, -- you can add other weapons here
                        {label = "Golden Revolver", value = "weapon_doubleaction"},
                        {label = "Micro SMG", value = "weapon_microsmg"},
                        {label = "Assault Rifle", value = "weapon_assaultrifle"},
                        {label = "Sniper Rifle", value = "weapon_sniperrifle"}
                    }
                }, function(data2, menu2)
                    if data2.current.value == "weapon_pistol50" or data2.current.value == "weapon_doubleaction" or data2.current.value == "weapon_microsmg" or data2.current.value == "weapon_assaultrifle" or data2.current.value == "weapon_sniperrifle" then
                        local choice2 = data2.current

                        if HasPedGotWeapon(playerPed, GetHashKey(choice2.value), false) then
                            local a, max = GetMaxAmmo(playerPed, GetHashKey(choice2.value))
                            if max > (GetAmmoInPedWeapon(playerPed, GetHashKey(choice2.value)) + choice.value) then
                                tac.TriggerServerCallback("utk_c:getcredit", function(output)
                                    if tonumber(output) >= choice.price then
                                        newamount = tonumber(output) - choice.price
                                        TriggerServerEvent("utk_c:updatecredit", newamount)
                                        TriggerServerEvent("utk_c:savecustomlog", "**"..choice.notify.. "** ammo, has been bought for**"..choice2.label.."** weapon for **"..choice.price.."** Credit.", "Market Usage")
                                        AddAmmoToPed(playerPed, GetHashKey(choice2.value), choice.value)
                                        exports["mythic_notify"]:SendAlert("success", "Compraste "..choice.value.." Por "..choice2.label..".")
                                    else
                                        exports["mythic_notify"]:SendAlert("error", "No tienes suficientes creditos.")
                                    end
                                end)
                            else
                                exports["mythic_notify"]:SendAlert("error", "No tienes suficiente espacio para esta cantidad de balas.")
                            end
                        else
                            exports["mythic_notify"]:SendAlert("error", "No tienes "..choice2.label..".")
                        end
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end
        end
    end, function(data, menu)
        menu.close()
        MenuOpen = false
        CloseForNow = false
    end)
end

function GetCredit()
    local amount = 0

    tac.TriggerServerCallback("utk_c:getcredit", function(output)
        amount = tonumber(output)
    end)
    return amount
end

RegisterCommand(Config.showcommand, function()
    if Enableshow then
        Enableshow = false
    elseif not Enableshow then
        Enableshow = true
    end
end)

-- tac_vehicleshop functions --

function GetVehicleName(hash)
    if Vehicles[tostring(hash)] ~= nil then
        return Vehicles[tostring(hash)]
    else
        return "Vehiculo sin registrar"
    end
end

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		tac.Game.DeleteVehicle(vehicle)
		if LastVehiclesHash ~= nil then
			SetModelAsNoLongerNeeded(LastVehiclesHash)
			LastVehiclesHash = nil
		end
		table.remove(LastVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)

			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 33, true) -- S
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 35, true) -- D
			DisableControlAction(0, 176, true) -- Enter
			DisableControlAction(0, 177, true) -- Backspace
		end
	end
end
-------------------------------
function ShowCreditScreen(number)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextFont(7)
    SetTextEntry("STRING")
    AddTextComponentString(Config.logo..math.floor(number))
    DrawText(0.16, 0.95)
end

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 5000
	DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100)
end

Citizen.CreateThread(function()
    Citizen.Wait(10000)
    TriggerServerEvent("utk_c:checkplayer")
    for i = 1, #Config.Locations, 1 do
        if not DoesBlipExist(Config.Locations[i].blip) then
            Config.Locations[i].blip = AddBlipForCoord(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
            SetBlipSprite(Config.Locations[i].blip, Config.Locations[i].bliptype)
            SetBlipColour(Config.Locations[i].blip, Config.Locations[i].blipcolor)
            SetBlipScale(Config.Locations[i].blip, 1.5)
            BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString(Config.Locations[i].blipname)
	        EndTextCommandSetBlipName(Config.Locations[i].blip)
            SetBlipAsShortRange(Config.Locations[i].blip, true)
        end
    end
end)