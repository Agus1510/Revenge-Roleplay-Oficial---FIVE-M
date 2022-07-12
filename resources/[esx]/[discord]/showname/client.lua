Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		players = {}
		for i = 0, 256 do
			if NetworkIsPlayerActive( i ) then
				table.insert( players, i )
			end
		end
		SetRichPresence(GetPlayerName(PlayerId()) .. " - ".. #players .. "/65")
	end
end)