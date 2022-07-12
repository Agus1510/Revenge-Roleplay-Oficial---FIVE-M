Config                            = {}
Config.DrawDistance               = 100
Config.MarkerColor                = {r = 120, g = 120, b = 240}
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.ResellPercentage           = 50

Config.Locale                     = 'en'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {

	ShopEntering = {
		Pos   = vector3(-1166.33, -1708.87, 3.46),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	ShopInside = {
		Pos     = vector3(-1169.72, -1716.5, 3.56),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = -20.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(-1163.88, -1728.36, 3.47),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 330.0,
		Type    = -1
	},

	BossActions = {
		Pos   = vector3(-1178.86, -1700.7, 3.56),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	GiveBackVehicle = {
		Pos   = vector3(-1168.4, -1741.59, 3.45),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = (Config.EnablePlayerManagement and 1 or -1)
	},

	ResellVehicle = {
		Pos   = vector3(-1198.26, -1721.35, 3.45),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}

}
