Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableSocietyOwnedVehicles = false
Config.MaxInService               = -1
Config.Locale                     = 'es'

Config.TheLostMCStations = {

  TheLostMC = {

    AuthorizedWeapons = {
      { name = 'WEAPON_PISTOL',     price = 60000 },
      { name = 'WEAPON_ASSAULTSMG',       price = 150000 },
      { name = 'WEAPON_SWITCHBLADE',      price = 5000 },
	  { name = 'WEAPON_POOLCUE',          price = 1000 },  
    },

	AuthorizedVehicles = {
	  { name = 'zombieb',         label = 'Bobber' },
	  { name = 'wolfsbane',        label = 'Wolfsbane' },
	  { name = 'GBurrito',       label = 'Gang Burrito' },	  
	  },

    Armories = {
      { x = 986.77, y = -92.75, z = 74.85},
    },

    Vehicles = {
      {
        Spawner    = { x = 969.87, y = -113.54, z = 74.35 },
        SpawnPoint = { x = 967.89, y = -127.17, z = 74.37 },
        Heading    = 147.03,
      }
    },

    VehicleDeleters = {
      { x = 965.03, y = -118.7, z = 74.35 },
    },

    BossActions = {
      { x = 977.03, y = -103.92, z = 74.85 },
    },
	
  },
  
}
