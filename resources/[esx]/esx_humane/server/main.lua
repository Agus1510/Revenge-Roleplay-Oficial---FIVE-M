tac               = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterUsableItem('pendrive', function(source)
    local xPlayer = tac.GetPlayerFromId(source)
    local pendrive = xPlayer.getInventoryItem('pendrive')

    xPlayer.removeInventoryItem('pendrive', 1)
    TriggerClientEvent('tac_borrmaskin_humane:startpendrive', source)
end)
