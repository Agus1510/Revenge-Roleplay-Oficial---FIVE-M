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

	Gaviria = {

    Blip = {
--      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_PISTOL',     price = 25000 },
      { name = 'WEAPON_compactrifle',     price = 200000 },
    },

	  AuthorizedVehicles = {
		  { name = 'bmci',   label = 'Bmw m5' },
	  },

    Cloakrooms = {
      { x = 1406.54, y = 1154.45, z = 113.44 },
    },

    Armories = {
      { x = 1407.26, y = 1141.67, z = 113.44 },
    },

    Vehicles = {
      {
        Spawner    = { x = 1407.96, y = 1116.31, z = 113.84 },
        SpawnPoint = { x = 1395.32, y = 1117.68, z = 113.84 },
        Heading    = 89.83,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 5000.40, y = 5496.1, z = 66.187 },
        SpawnPoint = { x = 5008.40, y = 705.56, z = 177.919 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 1400.49, y = 1118.36, z = 113.84 },
    },

    BossActions = {
      { x = 1407.7, y = 1138.01, z = 113.44 }
    },

  },

}