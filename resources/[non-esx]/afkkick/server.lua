RegisterServerEvent("kickForBeingAnAFKDouchebag")
AddEventHandler("kickForBeingAnAFKDouchebag", function()
	DropPlayer(source, "Estuviste afk mucho tiempo.")
end)