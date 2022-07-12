tac               = nil
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterNetEvent("tac_miner:givestone")
AddEventHandler("tac_miner:givestone", function(item, count)
    local _source = source
    local xPlayer  = tac.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('stones').count < 40 then
                xPlayer.addInventoryItem('stones', 5)
                TriggerClientEvent('tac:showNotification', source, 'Recibiste ~b~piedras.')
            end
        end
    end)

    
RegisterNetEvent("tac_miner:washing")
AddEventHandler("tac_miner:washing", function(item, count)
    local _source = source
    local xPlayer  = tac.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('stones').count > 9 then
                TriggerClientEvent("tac_miner:washing", source)
                Citizen.Wait(15900)
                xPlayer.addInventoryItem('washedstones', 10)
                xPlayer.removeInventoryItem("stones", 10)
            elseif xPlayer.getInventoryItem('stones').count < 10 then
                TriggerClientEvent('tac:showNotification', source, 'No tienes ~b~piedras.')
            end
        end
    end)

RegisterNetEvent("tac_miner:remelting")
AddEventHandler("tac_miner:remelting", function(item, count)
    local _source = source
    local xPlayer  = tac.GetPlayerFromId(_source)
    local randomChance = math.random(1, 100)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('washedstones').count > 9 then
                TriggerClientEvent("tac_miner:remelting", source)
                Citizen.Wait(15900)
                if randomChance < 10 then
                    xPlayer.addInventoryItem("diamond", 1)
                    xPlayer.removeInventoryItem("washedstones", 10)
                    TriggerClientEvent('tac:showNotification', _source, 'Obtienes ~b~1 diamamte ~w~por 10 piedras lavadas.')
                elseif randomChance > 9 and randomChance < 25 then
                    xPlayer.addInventoryItem("gold", 5)
                    xPlayer.removeInventoryItem("washedstones", 10)
                    TriggerClientEvent('tac:showNotification', _source, 'Obtienes ~y~5 de oro ~w~por 10 piedras lavadas.')
                elseif randomChance > 24 and randomChance < 50 then
                    xPlayer.addInventoryItem("iron", 10)
                    xPlayer.removeInventoryItem("washedstones", 10)
                    TriggerClientEvent('tac:showNotification', _source, 'Obtuviste ~w~10 de metal por 10 piedras lavadas.')
                elseif randomChance > 49 then
                    xPlayer.addInventoryItem("copper", 20)
                    xPlayer.removeInventoryItem("washedstones", 10)
                    TriggerClientEvent('tac:showNotification', _source, 'Obtuviste ~o~20 de cobre ~w~por 10 piedras lavadas.')
                end
            elseif xPlayer.getInventoryItem('stones').count < 10 then
                TriggerClientEvent('tac:showNotification', source, 'No tienes ~b~piedras.')
            end
        end
    end)

RegisterNetEvent("tac_miner:selldiamond")
AddEventHandler("tac_miner:selldiamond", function(item, count)
    local _source = source
    local xPlayer  = tac.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('diamond').count > 0 then
                local pieniadze = Config.DiamondPrice
                xPlayer.removeInventoryItem('diamond', 1)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('tac:showNotification', source, 'Vendiste ~b~1 diamante.')
            elseif xPlayer.getInventoryItem('diamond').count < 1 then
                TriggerClientEvent('tac:showNotification', source, 'No tienes ~b~diamantes.')
            end
        end
    end)

RegisterNetEvent("tac_miner:sellgold")
AddEventHandler("tac_miner:sellgold", function(item, count)
    local _source = source
    local xPlayer  = tac.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('gold').count > 4 then
                local pieniadze = Config.GoldPrice
                xPlayer.removeInventoryItem('gold', 5)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('tac:showNotification', source, 'Vendiste ~y~5 de oro.')
            elseif xPlayer.getInventoryItem('gold').count < 5 then
                TriggerClientEvent('tac:showNotification', source, 'No tienes ~b~oro')
            end
        end
    end)

RegisterNetEvent("tac_miner:selliron")
AddEventHandler("tac_miner:selliron", function(item, count)
    local _source = source
    local xPlayer  = tac.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('iron').count > 9 then
                local pieniadze = Config.IronPrice
                xPlayer.removeInventoryItem('iron', 10)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('tac:showNotification', source, 'Vendiste ~w~10 de metal.')
            elseif xPlayer.getInventoryItem('iron').count < 10 then
                TriggerClientEvent('tac:showNotification', source, 'No tienes ~b~metal.')
            end
        end
    end)

RegisterNetEvent("tac_miner:sellcopper")
AddEventHandler("tac_miner:sellcopper", function(item, count)
    local _source = source
    local xPlayer  = tac.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('copper').count > 19 then
                local pieniadze = Config.CopperPrice
                xPlayer.removeInventoryItem('copper', 20)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('tac:showNotification', source, 'Vendiste ~o~20 de cobre.')
            elseif xPlayer.getInventoryItem('copper').count < 20 then
                TriggerClientEvent('tac:showNotification', source, 'No tienes ~b~cobre.')
            end
        end
    end)
