

tac = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)




RegisterServerEvent("Farmcyc:recoleccion")
AddEventHandler("Farmcyc:recoleccion", function()

    local _source = source	
	local xPlayer = tac.GetPlayerFromId(_source)
	local recoleccionsuerte = math.random(1,100)
	local cangrejos = xPlayer.getInventoryItem('cangrejos').count	
	local camarones = xPlayer.getInventoryItem('camarones').count	

         if recoleccionsuerte < 50 then

         	   if xPlayer.getInventoryItem('cangrejos').count >= 20 then
         	TriggerClientEvent('tac:showNotification', source, '~r~No puedes llevar mas cangrejos')
else 

         	xPlayer.addInventoryItem("cangrejos", math.random(1,2)) 
         
              end

         elseif recoleccionsuerte > 51 then 
         	
         	if xPlayer.getInventoryItem('camarones').count >= 20 then
         	TriggerClientEvent('tac:showNotification', source, '~r~No puedes llevar mas camarones')
else 

            xPlayer.addInventoryItem("camarones", math.random(1,2)) 
        end

            end 
		
end)




tac.RegisterServerCallback('Farmcyc:empaquetado:cangrejos', function (source, cb)
	
	local _source = source
	
	local xPlayer  = tac.GetPlayerFromId(_source)
			
			if xPlayer.getInventoryItem('cajadecangrejos').count >= 4 then

			TriggerClientEvent('tac:showNotification', source, '~r~No puedes llevar mas cajas')

else

				if xPlayer.getInventoryItem('cangrejos').count >= 5 then


 
					xPlayer.removeInventoryItem('cangrejos', 4) 
					Citizen.Wait(1000)
					xPlayer.addInventoryItem('cajadecangrejos', 1) 

					cb(true)

				else
				TriggerClientEvent('tac:showNotification', source, '~r~No tienes cangrejos')
				cb(false)
				end
			
      		end

end)

tac.RegisterServerCallback('Farmcyc:empaquetado:camarones', function (source, cb)
	
	local _source = source
	
	local xPlayer  = tac.GetPlayerFromId(_source)
			
			if xPlayer.getInventoryItem('cajadecamarones').count >= 5 then

			TriggerClientEvent('tac:showNotification', source, '~r~No puedes llevar mas cajas')

else

				if xPlayer.getInventoryItem('camarones').count >= 4 then


 
					xPlayer.removeInventoryItem('camarones', 4) 
					Citizen.Wait(1000)
					xPlayer.addInventoryItem('cajadecamarones', 1) 

					cb(true)

				else
				TriggerClientEvent('tac:showNotification', source, '~r~No tienes camarones')
				cb(false)
				end
			
      		end

end)


RegisterNetEvent('Ventadecamarones')
AddEventHandler('Ventadecamarones', function()
	local _source = source 
    local xPlayer = tac.GetPlayerFromId(_source)
    local camarones = xPlayer.getInventoryItem('cajadecamarones').count
    local PrecioCamarones = Config.PCamaron
   

if camarones > 0 then


    xPlayer.removeInventoryItem('cajadecamarones', 1)
    xPlayer.addMoney(PrecioCamarones)
elseif camarones < 1 then
	TriggerClientEvent('tac:showNotification', source, '~r~No tienes camarones para vender')

end

end)



RegisterNetEvent('Ventadecangrejos')
AddEventHandler('Ventadecangrejos', function()
	local _source = source 
    local xPlayer = tac.GetPlayerFromId(_source)
    local cangrejos = xPlayer.getInventoryItem('cajadecangrejos').count
    local PrecioCangrejos = Config.PCangrejo

if cangrejos > 0 then


    xPlayer.removeInventoryItem('cajadecangrejos', 1)
    Citizen.Wait(500)
    xPlayer.addMoney(PrecioCangrejos)
elseif cangrejos < 1 then
	TriggerClientEvent('tac:showNotification', source, '~r~No tienes cangrejos para vender')

end

end)
