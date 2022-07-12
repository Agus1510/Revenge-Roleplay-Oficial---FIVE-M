petrolCanPrice = 1

lang = "en"
-- lang = "fr"

settings = {}
settings["en"] = {
	openMenu = "Presiona ~g~E~w~ para abrir el menu.",
	electricError = "~r~ Tienes un vehiculo electrico.",
	fuelError = "~r~No estas en el lugar correcto.",
	buyFuel = "Comprar gasolina",
	liters = "Litros",
	percent = "Porcentaje",
	confirm = "Confirmar",
	fuelStation = "YPF",
	boatFuelStation = "Gasolinera | Botes",
	avionFuelStation = "Gasolinera | Aviones ",
	heliFuelStation = "Gasolinera | Helicopteros",
	getJerryCan = "Presiona ~g~E~w~ para comprar un bidon ("..petrolCanPrice.."$)",
	refeel = "Presiona ~g~E~w~ para cargar combustible.",
	YouHaveBought = "Ya tienes suficiente ",
	fuel = " Litros de gasolina",
	price = "Precio"
}

--settings["fr"] = {
--	openMenu = "Appuyez sur ~g~E~w~ pour ouvrir le menu.",
--	electricError = "~r~Vous avez une voiture électrique.",
--	fuelError = "~r~Vous n'êtes pas au bon endroit.",
--	buyFuel = "acheter de l'essence",
--	liters = "litres",
--	percent = "pourcent",
--	confirm = "Valider",
--	fuelStation = "Station essence",
--	boatFuelStation = "Station d'essence | Bateau",
--	avionFuelStation = "Station d'essence | Avions",
--	heliFuelStation = "Station d'essence | Hélicoptères",
--	getJerryCan = "Appuyez sur ~g~E~w~ pour acheter un bidon d'essence ("..petrolCanPrice.."$)",
--	refeel = "Appuyez sur ~g~E~w~ pour remplir votre voiture d'essence.",
--	YouHaveBought = "Vous avez acheté ",
--	fuel = " litres d'essence",
--	price = "prix"
--}


showBar = false
showText = false


hud_form = 1 -- 1 : Vertical | 2 = Horizontal
hud_x = 0.175 
hud_y = 0.885

text_x = 0.2575
text_y = 0.975


electricityPrice = 1 -- NOT RANOMED !!

randomPrice = true --Random the price of each stations
price = 75 --If random price is on False, set the price here for 1 liter