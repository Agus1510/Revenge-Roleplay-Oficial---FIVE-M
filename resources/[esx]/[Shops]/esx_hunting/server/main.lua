tac                = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac-qalle-hunting:reward')
AddEventHandler('tac-qalle-hunting:reward', function(Weight)
    local xPlayer = tac.GetPlayerFromId(source)

    if Weight >= 1 then
        xPlayer.addInventoryItem('meat', 1)
    elseif Weight >= 9 then
        xPlayer.addInventoryItem('meat', 2)
    elseif Weight >= 15 then
        xPlayer.addInventoryItem('meat', 3)
    end

    xPlayer.addInventoryItem('leather', math.random(1, 4))
        
end)

RegisterServerEvent('tac-qalle-hunting:sell')
AddEventHandler('tac-qalle-hunting:sell', function()
    local xPlayer = tac.GetPlayerFromId(source)

    local MeatPrice = 125
    local LeatherPrice = 25

    local MeatQuantity = xPlayer.getInventoryItem('meat').count
    local LeatherQuantity = xPlayer.getInventoryItem('leather').count

    if MeatQuantity > 0 or LeatherQuantity > 0 then
        xPlayer.addMoney(MeatQuantity * MeatPrice)
        xPlayer.addMoney(LeatherQuantity * LeatherPrice)

        xPlayer.removeInventoryItem('meat', MeatQuantity)
        xPlayer.removeInventoryItem('leather', LeatherQuantity)
        TriggerClientEvent('tac:showNotification', xPlayer.source, 'You sold ' .. LeatherQuantity + MeatQuantity .. ' and earned $' .. LeatherPrice * LeatherQuantity + MeatPrice * MeatQuantity)
    else
        TriggerClientEvent('tac:showNotification', xPlayer.source, 'You don\'t have any meat or leather')
    end
        
end)

function sendNotification(xsource, message, messageType, messageTimeout)
    TriggerClientEvent('notification', xsource, message)
end