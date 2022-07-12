tac						= nil


TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)


RegisterServerEvent('tac_worek:closest')
AddEventHandler('tac_worek:closest', function()
    local name = GetPlayerName(najblizszy)
    TriggerClientEvent('tac_worek:nalozNa', najblizszy)
end)

RegisterServerEvent('tac_worek:sendclosest')
AddEventHandler('tac_worek:sendclosest', function(closestPlayer)
    najblizszy = closestPlayer
end)

RegisterServerEvent('tac_worek:zdejmij')
AddEventHandler('tac_worek:zdejmij', function()
    TriggerClientEvent('tac_worek:zdejmijc', najblizszy)
end)

tac.RegisterUsableItem('headbag', function(source)
    local _source = source
    local xPlayer = tac.GetPlayerFromId(_source)
    TriggerClientEvent('tac_worek:naloz', _source)
    TriggerEvent('tac_worek:debugger', source)
end)