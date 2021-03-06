tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('matriarch_simcards:useSimCard')
AddEventHandler('matriarch_simcards:useSimCard', function(args)
    local _source = source
    local rawNumber = args[1]
    local xPlayer = tac.GetPlayerFromId(_source)
    local numFirstThree = string.sub(rawNumber, 1, 3)
    local numLastFour = string.sub(rawNumber, 4, 7)
    local numFinal = numFirstThree .. '-' .. numLastFour
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE phone_number = @phone_number", {['@phone_number'] = numFinal})
    if result[1] ~= nil then
        TriggerClientEvent('tac:showNotification', _source, '~r~That number is already in use')
    else       
        TriggerClientEvent('matriarch_simcards:startNumChange', _source, numFinal)
    end     
end)

RegisterServerEvent('matriarch_simcards:changeNumber')
AddEventHandler('matriarch_simcards:changeNumber', function(newNum)
    local _source = source
    local xPlayer = tac.GetPlayerFromId(_source)               
    MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@phone_number'] = newNum
    })
    xPlayer.removeInventoryItem('sim_card', 1)
    TriggerClientEvent('matriarch_simcards:success', _source, newNum)
end)