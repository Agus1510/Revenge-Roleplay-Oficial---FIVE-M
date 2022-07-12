tac                = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('sendChatMessage')
AddEventHandler('sendChatMessage', function(message)
    TriggerClientEvent('chatMessage', -1, '', {255,255,255}, message)
end)