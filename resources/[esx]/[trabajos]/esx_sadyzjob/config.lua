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
      { name = 'WEAPON_PISTOL',     price = 25000 },
      { name = 'WEAPON_gusenberg',     price = 180000 },
    },

	  AuthorizedVehicles = {
		  { name = 'bbentayga',   label = 'Bentley bentayga' },
	  },

    Cloakrooms = {
      { x = 9.283, y = 528.914, z = 169.635 },
    },

    Armories = {
      { x = -807.82, y = 180.87, z = 71.15 },
    },

    Vehicles = {
      {
        Spawner    = { x = -809.94, y = 188.03, z = 71.48 },
        SpawnPoint = { x = -819.7, y = 184.1, z = 72.14 },
        Heading    = 119.18,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 5620.312, y = 535.667, z = 0.627 },
        SpawnPoint = { x = 3.40, y = 525.56, z = 0.919 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = -812.02, y = 187.31, z = 71.47 },
    },

    BossActions = {
      { x = -804.55, y = 176.96, z = 71.83 }
    },

  },

}