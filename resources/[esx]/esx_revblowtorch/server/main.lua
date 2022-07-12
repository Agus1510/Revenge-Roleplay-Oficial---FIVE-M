tac               = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterUsableItem('blowtorch', function(source)
    local xPlayer = tac.GetPlayerFromId(source)
    local blowtorch = xPlayer.getInventoryItem('blowtorch')

    xPlayer.removeInventoryItem('blowtorch', 1)
    TriggerClientEvent('tac_blowtorch:startblowtorch', source)
end)

