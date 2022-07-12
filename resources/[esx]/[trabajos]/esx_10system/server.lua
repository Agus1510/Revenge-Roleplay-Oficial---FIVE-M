TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

local officers = {}

RegisterServerEvent('tac_10system:SendStatus')
AddEventHandler('tac_10system:SendStatus', function(code)
    local identifier = GetPlayerIdentifiers(source)[1]
    local callsign = getSign(identifier)
    local name = getName(identifier)
    addToOfficers(identifier, callsign, name, code)
    
    TriggerClientEvent('tac_10system:clearSystem', -1)
    for k in pairs(officers) do
        local text
        local stringified = false
        for i,v in ipairs(Config.TenCodes) do
            if v.code == officers[k].code then
                text = v.codeText
                stringified = true
            end
        end
        if not stringified then text = officers[k].code end
        msg = string.format("~b~Oficial: ~w~%s ~y~- ~w~%s  ~y~Estado: ~w~%s", officers[k].name, officers[k].callsign, text)
        if officers[k].code == '7' then 

        elseif string.sub(officers[k].callsign, 1, 4) == 'Echo' then
            msg = string.format("~r~SAME: ~w~%s ~y~- ~w~%s  ~y~Estado: ~w~%s", officers[k].name, officers[k].callsign, text)
            TriggerClientEvent('tac_10system:UpdateMessages', -1, msg, k)
        else
            TriggerClientEvent('tac_10system:UpdateMessages', -1, msg, k)
        end
    end
end)

function getSign(identifier)
    local callsign = ''
	local result = MySQL.Sync.fetchAll("SELECT * FROM 10system WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local sqlResult = result[1]
        callsign = sqlResult['callsign']
	end
    return callsign
end

function getName(identifier)
    local name = ''
	local result = MySQL.Sync.fetchAll("SELECT * FROM 10system WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local sqlResult = result[1]
        name = sqlResult['name']
    end
    return name
end

function addToOfficers(identifier, callsign, name, code)
    officers[identifier] = {callsign = callsign,name = name,code = code}
end

RegisterServerEvent('tac_10system:getSign')
AddEventHandler('tac_10system:getSign', function()
    local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM 10system WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local sqlResult = result[1]
        callsign = sqlResult['callsign']
        name = sqlResult['name']
	end
end)

AddEventHandler('tac:playerDropped', function(source)
    local source = source
    local identifier = GetPlayerIdentifiers(source)[1]
    for k in pairs(officers) do
        if k == identifier then
            officers[identifier].code = '7'
        end
    end
  end)

RegisterServerEvent('tac_10system:setPolice')
AddEventHandler('tac_10system:setPolice', function(switchDuty)

    local _source = source
    local xPlayer = tac.GetPlayerFromId(_source)
    local grade = xPlayer.job.grade
    if switchDuty then
        xPlayer.setJob('police', grade)
        TriggerClientEvent('tac:showNotification', _source, 'Estas en servicio')
    else
        xPlayer.setJob('offpolice', grade)
        TriggerClientEvent('tac:showNotification', _source, 'Estas fuera de servicio')
    end

end)

RegisterServerEvent('tac_10system:setAmbulance')
AddEventHandler('tac_10system:setAmbulance', function(switchDuty)

    local _source = source
    local xPlayer = tac.GetPlayerFromId(_source)
    local grade = xPlayer.job.grade
    if switchDuty then
        xPlayer.setJob('ambulance', grade)
        TriggerClientEvent('tac:showNotification', _source, 'Estas en servicio')
    else
        xPlayer.setJob('offambulance', grade)
        TriggerClientEvent('tac:showNotification', _source, 'Estas fuera de servicio')
    end

end)