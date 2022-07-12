local tac = nil
local timePlay = {}
local NewPlayers = {}

-- tac
TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

AddEventHandler('tac:playerLoaded', function(source)

    local _source = source
    local identifier = GetPlayerIdentifier(_source)
    timePlay[identifier] = {source = _source, joinTime = os.time(), timePlay = 0}
    MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", { ["@identifier"] = identifier }, function(result)

        if result then

            local timePlayP = result[1].timePlay
            timePlay[identifier].timePlay = timePlayP
            
            if timePlayP < Config.newbieTime then

                NewPlayers[identifier] = {source = _source}

            end
            TriggerClientEvent('timeplay:set_tags', -1, NewPlayers)

        end

    end)

end)

AddEventHandler('playerDropped', function()
	
	local _source = source
        if _source ~= nil then
            local identifier = GetPlayerIdentifier(_source)

            if timePlay[identifier] ~= nil then

                local leaveTime = os.time()
                local saveTime = leaveTime - timePlay[identifier].joinTime

                MySQL.Async.execute('UPDATE users SET timePlay = timePlay + @timePlay WHERE identifier=@identifier', 
                {
                    ['@identifier'] = identifier,
                    ['@timePlay'] = saveTime
                    
                }, function()

                    timePlay[identifier] = nil
                    NewPlayers[identifier] = nil
                    TriggerClientEvent('timeplay:set_tags', -1, NewPlayers)

                end)

            end

        end

end)