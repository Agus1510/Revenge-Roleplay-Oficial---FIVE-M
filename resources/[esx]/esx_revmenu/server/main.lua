tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

RegisterServerEvent('tac_aiomenu:givePhoneNumber')
AddEventHandler('tac_aiomenu:givePhoneNumber', function(ID, targetID)
    local identifier = tac.GetPlayerFromId(ID).identifier
    local _source 	 = tac.GetPlayerFromId(targetID).source
    
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
    {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] ~= nil then
            local data = {
                phoneNumber = result[1]['phone_number'],
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname']
            }

            TriggerClientEvent('tac_aiomenu:givePhoneNumber', _source, data) 
        else
            local data = {
                phoneNumber = 'nil',
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname'],
            }

            TriggerClientEvent('tac_aiomenu:givePhoneNumber', _source, data) 
        end
    end)     
end)

RegisterServerEvent('tac_aiomenu:showID')
AddEventHandler('tac_aiomenu:showID', function(ID, targetID)
    local identifier = tac.GetPlayerFromId(ID).identifier
    local _source 	 = tac.GetPlayerFromId(targetID).source
    local sexVariable = 'Male'
    
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
    {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] ~= nil then
            if result[1]['sex'] == 'f' then
                sexVariable = 'Female'
            end

            local data = {
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname'],
                dob = result[1]['dateofbirth'],
                sex = sexVariable,
                height = result[1]['height'] .. ' Inches'
            }

            TriggerClientEvent('tac_aiomenu:showID', _source, data) 
        else
            local data = {
                name = 'Nil',
                dob = 'Nil',
                sex = 'Nil',
                height = 'Nil'
            }

            TriggerClientEvent('tac_aiomenu:showID', _source, data)
        end
    end)     
end)