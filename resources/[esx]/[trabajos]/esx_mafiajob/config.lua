Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.MafiaStations = {

  Mafia = {

    Blip = {
--      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_ASSAULTSMG',       price = 190000 },
      { name = 'WEAPON_PISTOL',         price = 70000 },
    },

	  AuthorizedVehicles = {
		  { name = 'ram2500',  label = ' Ram 2500' },
		  { name = 'bme6tun',  label = ' Bmw serie 5' },

	  },

    Cloakrooms = {
      { x = 9.283, y = 528.914, z = 169.635 },
    },

    Armories = {
      { x = 1.550, y = 527.397, z = 169.617 },
    },

    Vehicles = {
      {
        Spawner    = { x = 13.40, y = 549.1, z = 175.187 },
        SpawnPoint = { x = 8.237, y = 556.963, z = 175.266 },
        Heading    = 90.0,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 2000.312, y = 535.667, z = 0.627 },
        SpawnPoint = { x = 3.40, y = 525.56, z = 0.919 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 22.74, y = 545.9, z = 175.027 },
      { x = 21.35, y = 543.3, z = 175.027 },
    },

    BossActions = {
      { x = 4.113, y = 526.897, z = 173.628 }
    },

  },

}