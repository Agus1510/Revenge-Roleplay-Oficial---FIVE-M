-- Density values from 0.0 to 1.0.
-- From 0.0 to 1.0:
trafficDensity = 0.0
pedDensity = 0.5
Citizen.CreateThread(function()
	while true do
	    SetVehicleDensityMultiplierThisFrame(trafficDensity)
	    SetPedDensityMultiplierThisFrame(pedDensity)
	    SetRandomVehicleDensityMultiplierThisFrame(trafficDensity)
	    SetParkedVehicleDensityMultiplierThisFrame(trafficDensity)
	    SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity)
	    
	Citizen.Wait(0)
	end
end)