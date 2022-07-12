Config = {}
Config.Locale = 'en'

Config.DrawDistance = 100
Config.MenuMarker  = {Type = 1, r = 0, g = 255, b = 0, x = 1.5, y = 1.5, z = 1.0} -- Menu Marker | Green w/Standard Size
Config.DelMarker  = {Type = 1, r = 255, g = 0, b = 0, x = 5.0, y = 5.0, z = 1.0} -- Delete Marker | Red w/Large Size
Config.BlipVehicleSpawner = {Sprite = 479, Color = 2, Display = 2, Scale = 1.0}

Config.Zones = {
	VehicleSpawner1 = { -- Los Santos Docks
		Pos = vector3(244.62, -767.76, 29.76), -- Enter Marker
		Loc = vector3(240.03, -771.43, 29.74), -- Spawn Location
		Del = vector3(253.78, -769.39, 29.76), -- Delete Location
		Heading = 166.18
	},
	VehicleSpawner2 = { -- Sandy Shores U-Tool
		Pos = vector3(2691.2, 3461.7, 55.2), -- Enter Marker
		Loc = vector3(2683.3, 3456.7, 55.7), -- Spawn Location
		Del = vector3(2683.3, 3456.7, 54.7), -- Delete Location
		Heading = 248.53
	},
	VehicleSpawner3 = { -- Paleto Bay Reds
		Pos = vector3(-185.1, 6271.8, 30.5), -- Enter Marker
		Loc = vector3(-196.7, 6274.1, 31.5), -- Spawn Location
		Del = vector3(-196.7, 6274.1, 30.5), -- Delete Location
		Heading = 337.68
	}
}

Config.Vehicles = {
	{
		model = 'huraperfospy',
		label = 'Huracan performante'
	},
	{
		model = '458spc',
		label = 'Ferrari 458 speciale'
	},
	{
		model = '16challenger',
		label = 'Dodge challenger 2016'
	},
	{
		model = '720s',
		label = 'McLaren 720s'
	},
	{
		model = 'g500',
		label = 'Mercedes Benz g500'
	},
	{
		model = '2014rs5',
		label = 'Audi rs5'
	},
	{
		model = 'bmws',
		label = 'bmw 1000rr'
	},
	{
		model = 'e30c',
		label = 'bmw E30C'
	},
	{
		model = 'w221s65',
		label = 'Mercedes Benz s65'
	}
}
