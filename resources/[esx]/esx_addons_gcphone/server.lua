
tac                       = nil
local PhoneNumbers        = {}

-- PhoneNumbers = {
--   ambulance = {
--     type  = "ambulance",
--     sources = {
--        ['1'] = true
--     }
--   }
-- }

TriggerEvent('tac:getSharedObject', function(obj)
  tac = obj
end)

function notifyAlertSMS (number, alert, listSrc)
  if PhoneNumbers[number] ~= nil then
  local mess = 'From #' .. alert.numero  .. ' : ' .. alert.message

	if alert.coords ~= nil then
    --mess = mess .. ' GPS: ' .. alert.coords.x .. ', ' .. alert.coords.y 
    mess = mess .. ''

	end
    for k, _ in pairs(listSrc) do
      getPhoneNumber(tonumber(k), function (n)
        if n ~= nil then
          
          TriggerEvent('rvphone:_internalAddMessage', number, n, 'From #' .. alert.numero  .. ' : ' .. alert.message, 0, function (smsMess)
            TriggerClientEvent("rvphone:receiveMessage", tonumber(k), smsMess)
            TriggerEvent('rvphone:_internalAddMessage', number, n, 'GPS: ' .. alert.coords.x .. ', ' .. alert.coords.y, 0, function (smsMess)
            TriggerClientEvent("rvphone:receiveMessage", tonumber(k), smsMess)
          end)
          end)
        end
      end)
    end
  end
end

AddEventHandler('tac_rvphone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
  print('==== Enregistrement du telephone ' .. number .. ' => ' .. type)
	local hideNumber    = hideNumber    or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type          = type,
    sources       = {},
    alerts        = {}
	}
end)


AddEventHandler('tac:setJob', function(source, job, lastJob)
  if PhoneNumbers[lastJob.name] ~= nil then
    TriggerEvent('tac_addons_rvphone:removeSource', lastJob.name, source)
  end

  if PhoneNumbers[job.name] ~= nil then
    TriggerEvent('tac_addons_rvphone:addSource', job.name, source)
  end
end)

AddEventHandler('tac_addons_rvphone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('tac_addons_rvphone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('rvphone:sendMessage')
AddEventHandler('rvphone:sendMessage', function(number, message)
    local sourcePlayer = tonumber(source)
    if PhoneNumbers[number] ~= nil then
      getPhoneNumber(source, function (phone) 
        notifyAlertSMS(number, {
          message = message,
          numero = phone,
        }, PhoneNumbers[number].sources)
      end)
    end
end)

RegisterServerEvent('tac_addons_rvphone:startCall')
AddEventHandler('tac_addons_rvphone:startCall', function (number, message, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
      }, PhoneNumbers[number].sources)
    end)
  else
    print('Appels sur un service non enregistre => numero : ' .. number)
  end
end)


AddEventHandler('tac:playerLoaded', function(source)

  local xPlayer = tac.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)

    local phoneNumber = result[1].phone_number
    xPlayer.set('phoneNumber', phoneNumber)

    if PhoneNumbers[xPlayer.job.name] ~= nil then
      TriggerEvent('tac_addons_rvphone:addSource', xPlayer.job.name, source)
    end
  end)

end)


AddEventHandler('tac:playerDropped', function(source)
  local source = source
  local xPlayer = tac.GetPlayerFromId(source)
  if PhoneNumbers[xPlayer.job.name] ~= nil then
    TriggerEvent('tac_addons_rvphone:removeSource', xPlayer.job.name, source)
  end
end)


function getPhoneNumber (source, callback) 
  local xPlayer = tac.GetPlayerFromId(source)
  if xPlayer == nil then
    callback(nil)
  end
  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)
    callback(result[1].phone_number)
  end)
end



RegisterServerEvent('tac_rvphone:send')
AddEventHandler('tac_rvphone:send', function(number, message, _, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
      }, PhoneNumbers[number].sources)
    end)
  else
    -- print('tac_rvphone:send | Appels sur un service non enregistre => numero : ' .. number)
  end
end)