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

	Bloods = {

    Blip = {
--      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_PISTOL',     price = 25000 },
      { name = 'WEAPON_minismg',     price = 150000 },
    },

	  AuthorizedVehicles = {
		  { name = 'e63amg',   label = 'Mercedes Benz AMG' },
	  },

    Cloakrooms = {
      { x = -9.55, y = -1434.96, z = 30.1 },
    },

    Armories = {
      { x = -11.8, y = -1435.23, z = 30.1 },
    },

    Vehicles = {
      {
        Spawner    = { x = -25.06, y = -1435.64, z = 29.65 },
        SpawnPoint = { x = -25.05, y = -1442.94, z = 29.65 },
        Heading    = 179.29,
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
      { x = -25.77, y = -1427.95, z = 29.66 },
    },

    BossActions = {
      { x = -17.78, y = -1438.88, z =30.1 }
    },

  },

}