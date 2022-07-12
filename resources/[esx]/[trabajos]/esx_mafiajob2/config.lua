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

  MafiaVMA = {

    Blip = {
--      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_PISTOL',     price = 25000 },
      { name = 'WEAPON_sawnoffshotgun',      price = 100000 },
    },

	  AuthorizedVehicles = {
		  { name = 'm6gc',   label = 'Bmw m6' },
	  },

    Cloakrooms = {
      { x = 958.84, y = 456.77, z = 125.19 },
    },

    Armories = {
      { x = 960.05, y = 453.79, z = 125.23 },
    },

    Vehicles = {
      {
        Spawner    = { x = 956.64, y = 454.85, z = 116.67 },
        SpawnPoint = { x = 951.07, y = 431.22, z = 120.22 },
        Heading    = 66.12,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 1300.40, y = 5496.1, z = 0.187 },
        SpawnPoint = { x = 5008.40, y = 705.56, z = 177.919 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 970.8, y = 447.79, z = 120.22 },
      { x = 958.51, y = 450.35, z = 116.67 },
    },

    BossActions = {
      { x = 957.07, y = 448.83, z = 125.23 }
    },

  },

}