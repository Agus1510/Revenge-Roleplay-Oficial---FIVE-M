tac = nil

local dumpsterItems = {
    [1] = {chance = 2, id = 'glassbottle', name = 'Botella de vidrio', quantity = math.random(1,3), limit = 10},
    [2] = {chance = 4, id = 'wallet', name = 'Billetera', quantity = 1, limit = 4},
    [3] = {chance = 2, id = 'oldshoe', name = 'Zapato viejo', quantity = 1, limit = 10},
    [4] = {chance = 2, id = 'mouldybread', name = 'Pan viejo', quantity = 1, limit = 10},
    [5] = {chance = 3, id = 'plastic', name = 'Plastic', quantity = math.random(1,8), limit = 0},
    [7] = {chance = 8, id = 'electronics', name = 'Electronicos', quantity = math.random(1,2), limit = 0},
    [10] = {chance = 2, id = 'deadbatteries', name = 'Baterias muertas', quantity = 1, limit = 10},
    [11] = {chance = 4, id = 'cellphone', name = 'Telefono', quantity = 1, limit = 0},
    [12] = {chance = 3, id = 'rubber', name = 'Goma', quantity = math.random(1,3), limit = 0},
    [13] = {chance = 2, id = 'brokenfishingrod', name = 'Caña de pescar rota', quantity = 1, limit = 10},
    [14] = {chance = 7, id = 'cartire', name = 'Cubierta de auto usada', quantity = 1, limit = 4},
    [15] = {chance = 8, id = 'oldring', name = 'Anillo viejo', quantity = 1, limit = 10},
    [17] = {chance = 2, id = 'expiredburger', name = 'Hamburguesa vieja', quantity = 1, limit = 10}
   }

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

tac.RegisterUsableItem('wallet', function(source) --Hammer high time to unlock but 100% call cops
    local source = tonumber(source)
    local xPlayer = tac.GetPlayerFromId(source)
    local cash = math.random(20, 120)
    local chance = math.random(1,2)

    if chance == 2 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontras $' .. cash .. ' Adentro de la billetera'})
        xPlayer.addMoney(cash)
        local cardChance = math.random(1, 40)
        if cardChance == 20 then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontraste una tarjeta verde adentro de la billetera'})
            xPlayer.addInventoryItem('green-keycard', 1)
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'La billetera estaba vacia'})
    end

    xPlayer.removeInventoryItem('wallet', 1)
end)

RegisterServerEvent('onyx:startDumpsterTimer')
AddEventHandler('onyx:startDumpsterTimer', function(dumpster)
    startTimer(source, dumpster)
end)

RegisterServerEvent('onyx:giveDumpsterReward')
AddEventHandler('onyx:giveDumpsterReward', function()
    local source = tonumber(source)
    local item = {}
    local xPlayer = tac.GetPlayerFromId(source)
    local gotID = {}
    local rolls = math.random(1, 2)
    local foundItem = false

    for i = 1, rolls do
        item = dumpsterItems[math.random(1, #dumpsterItems)]
        if math.random(1, 10) >= item.chance then
            if item.isWeapon and not gotID[item.id] then
                if item.limit > 0 then
                    local count = xPlayer.getInventoryItem(item.id).count
                    if count >= item.limit then
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontraste ' .. item.name .. ' pero no puedes llevar mas de este item'})
                    else
                        gotID[item.id] = true
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontraste ' .. item.name})
                        foundItem = true
                        xPlayer.addWeapon(item.id, 50)
                    end
                else
                    gotID[item.id] = true
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontraste ' .. item.name})
                    foundItem = true
                    xPlayer.addWeapon(item.id, 50)
                end
            elseif not gotID[item.id] then
                if item.limit > 0 then
                    local count = xPlayer.getInventoryItem(item.id).count
                    if count >= item.limit then
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontraste ' .. item.quantity .. 'x ' .. item.name .. ' pero no pueds llevar mas de este item'})
                    else
                        gotID[item.id] = true
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontraste ' .. item.quantity .. 'x ' .. item.name})
                        xPlayer.addInventoryItem(item.id, item.quantity)
                        foundItem = true
                    end
                else
                    gotID[item.id] = true
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Encontraste ' .. item.quantity .. 'x ' .. item.name})
                    xPlayer.addInventoryItem(item.id, item.quantity)
                    foundItem = true
                end
            end
        end
        if i == rolls and not gotID[item.id] and not foundItem then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No encontraste nada'})
        end
    end
end)

function startTimer(id, object)
    local timer = 10 * 60000

    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            TriggerClientEvent('onyx:removeDumpster', id, object)
        end
    end
end