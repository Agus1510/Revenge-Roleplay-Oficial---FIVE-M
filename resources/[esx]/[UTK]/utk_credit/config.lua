Config = {}
Config.logs = true -- DON'T SET FALSE OR IT WILL BREAK!
Config.dcname = "Credit Logger" -- logger name
Config.http = "" -- webhook url
Config.avatar = "" -- avatar url

Config.logo = "🟡 " -- logo on screen
Config.showcommand = "c-show" -- command to close on screen amount
Config.adminadd = "c-add" -- admin command to give coin
Config.adminremove = "c-remove" -- admin command to remove coin
Config.admincheck = "c-search" -- admin command to check coin amount of a player
Config.PlateNumbers = 4 -- number of plate numbers || Plakadaki rakam sayısı
Config.PlateLetters = 2 -- number of plate letters (max is 8 combined with both PlateNumbers and PlateLetters)
Config.platecolor = 2 -- plate type (0 = blue/white, 1 = yellow/black, 2 = yellow/blue, 3 = blue/white2, 4 = blue/white3, 5 = old)
Config.vehcolor = 0 -- vehicle color || This sets the vehicle color of the new vehicle, if you don't want a sepcific one search for "SetVehicleColours" function in client.lua and delete all
Config.Locations = { -- Locations and their functions
    {
        enableblip = true,
        blip,
        blipname = "Casa de cambio",
        bliptype = 500,
        blipcolor = 5,
        x = 253.40, y = 220.57, z = 106.29,
        dst = 23,
        text = "[~g~E~w~] ~r~Cambiar~w~ Creditos",
        func = "OpenExchangeMenu" -- Menu function
    },

    {
        enableblip = true,
        blip,
        blipname = "Concesionario (Creditos)",
        bliptype = 225,
        blipcolor = 5,
        x = -1165.68, y = -1708.63, z = 4.26,
        dst = 10,
        text = "[~g~E~w~] ~r~Creditos~w~ Concesionario",
        func = "OpenMarket",
        spawnloc = vector3(-1164.82, -1743.1, 3.47), -- vehicle spawn loc
        heading = 218.16 -- vehicle heading
    },

    {
        enableblip = true,
        blip,
        blipname = "Armeria (Creditos)",
        bliptype = 470,
        blipcolor = 5,
        x = -1305.64, y = -394.02, z = 36.70,
        dst = 10,
        text = "[~g~E~w~] ~r~Bitcoin~w~ Tienda de armas",
        func = "OpenWepShop"
    },
    {
        enableblip = false,
        blip,
        blipname = "Items (Creditos)",
        bliptype = 486,
        blipcolor = 5,
        x = 244.95, y = 369.66, z = 105.34,
        dst = 23,
        text = "[~g~E~w~] Black Market",
        func = "OpenBlackMarket"
    },
}