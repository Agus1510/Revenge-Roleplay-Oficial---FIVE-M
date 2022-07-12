AddEventHandler('revengeanticheat:getSharedObject', function(cb)
    cb(TAC)
end)

function getSharedObject()
    return TAC
end

RegisterNetEvent('revengeanticheat:triggerClientCallback')
AddEventHandler('revengeanticheat:triggerClientCallback', function(name, requestId, ...)
    TAC.TriggerClientCallback(name, function(...)
        TriggerServerEvent('revengeanticheat:clientCallback', requestId, ...)
    end, ...)
end)

RegisterNetEvent('revengeanticheat:triggerClientEvent')
AddEventHandler('revengeanticheat:triggerClientEvent', function(name, ...)
    TAC.TriggerClientEvent(name, ...)
end)