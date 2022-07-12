Config = {}

-- Change menu alignment
Config.MenuAlign = "top-left"

-- Change items that can be sold at the pawnshop, the number behind = is the price
Config.PawnshopItems = {
	dia_box = 100000,
	gold_bar = 25000,
	phone = 5000,
	gps = 3000,
	oldring = 500,
	glassbottle = 20,
	wallet = 1000,
	oldshoe = 15,
	plastic = 5,
	electronics = 500,
	rubber = 100,
	oldring = 500,
	cartire = 600,
	oldring = 500,
	metalscrap = 50,
}

Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.PawnshopLocation =  {x = 182.07, y = -1319.06, z = 29.32}

-- Pawnshop blip
Config.PawnshopBlipText = "Tienda de empeños"
Config.PawnshopBlipColor = 5
Config.PawnshopBlipSprite = 272

-- Opening hours
Config.EnableOpeningHours = true -- Enable opening hours? If disabled you can always open the pawnshop.
Config.OpenHour = 9 -- From what hour should the pawnshop be open?
Config.CloseHour = 18 -- From what hour should the pawnshop be closed?