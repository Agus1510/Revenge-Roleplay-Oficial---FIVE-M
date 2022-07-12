tac = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_hospital:price')
AddEventHandler('tac_hospital:price', function()
  	local _source = source	
	local xPlayer = tac.GetPlayerFromId(_source)
	local price = 250
	
	if(xPlayer.getMoney() >= price) then
		xPlayer.removeMoney((price))
		TriggerClientEvent("pNotify:SetQueueMax", -1, "lmao", 10)
        TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "<b style = 'color:white'> Precio: " .. "$" .. price .. "</b>",
            type = "success",
            queue = "lmao",
            timeout = 10000,
            layout = "centerLeft"
        })
	else
		TriggerClientEvent('tac:showNotification', _source, "No tienes suficiente dinero")
		TriggerClientEvent("pNotify:SetQueueMax", -1, "lmao", 10)
        TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "<b style = 'color:red'>No tienes suficiente dinero " .. "$" .. price .. "</b>",
            type = "error",
            queue = "lmao",
            timeout = 10000,
            layout = "centerLeft"
        })
	end
end)