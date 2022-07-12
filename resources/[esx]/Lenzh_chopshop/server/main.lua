

tac = nil


TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

if GetCurrentResourceName() == 'Lenzh_chopshop' then

  print("\n###############################")
  print("\n".. GetCurrentResourceName() .. " Loaded ")
  print("\n###############################")

    tac.RegisterServerCallback('Lenzh_chopshop:anycops',function(source, cb)
        local anycops = 0
        local playerList = GetPlayers()
        for i=1, #playerList, 1 do
            local _source = playerList[i]
            local xPlayer = tac.GetPlayerFromId(_source)
            local playerjob = xPlayer.job.name
            if playerjob == 'police' then
                anycops = anycops + 1
            end
        end
        cb(anycops)
    end)

    RegisterServerEvent("lenzh_chopshop:rewards")
    AddEventHandler("lenzh_chopshop:rewards", function(rewards)
        --Rewards()
        local _source = source
        local xPlayer = tac.GetPlayerFromId(_source)
        if not xPlayer then return; end
        for k,v in pairs(Config.Items) do
            local randomCount = math.random(0, 3)
            if xPlayer.getInventoryItem(v).count >= xPlayer.getInventoryItem(v).limit then
                TriggerClientEvent('tac:showNotification', source, '~r~You cant carry anymore!')
            else
                xPlayer.addInventoryItem(v, randomCount)
            end
        end

    end)


    RegisterServerEvent('chopNotify')
    AddEventHandler('chopNotify', function()
        TriggerClientEvent("chopEnable", source)
    end)


    RegisterServerEvent('ChopInProgress')
    AddEventHandler('ChopInProgress', function()
        TriggerClientEvent("outlawChopNotify", -1, "")
    end)

    RegisterServerEvent('ChoppingInProgressPos')
    AddEventHandler('ChoppingInProgressPos', function(gx, gy, gz)
        TriggerClientEvent('Choplocation', -1, gx, gy, gz)
    end)


    RegisterServerEvent('lenzh_chopshop:sell')
    AddEventHandler('lenzh_chopshop:sell', function(itemName, amount)
        local xPlayer = tac.GetPlayerFromId(source)
        local price = Config.Itemsprice[itemName]
        local xItem = xPlayer.getInventoryItem(itemName)


        if xItem.count < amount then
            TriggerClientEvent('tac:showNotification', source, _U('not_enough'))
            return
        end

        price = tac.Math.Round(price * amount)

        if Config.GiveBlack then
            xPlayer.addAccountMoney('black_money', price)
        else
            xPlayer.addMoney(price)
        end

        xPlayer.removeInventoryItem(xItem.name, amount)

        TriggerClientEvent('tac:showNotification', source, _U('sold', amount, xItem.label, tac.Math.GroupDigits(price)))
    end)
else
    print("\n###############################")
    print("\n DO NOT RENAME MY CHOPSHOP FUCKERS... Change it ".. GetCurrentResourceName() .. " should be:\n".. 'Lenzh_chopshop')
    print("\n###############################")

end
