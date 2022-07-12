tac               = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function LoadLicenses (source)
  TriggerEvent('tac_license:getLicenses', source, function (licenses)
    TriggerClientEvent('tac_weashop:loadLicenses', source, licenses)
  end)
end

if Config.EnableLicense == true then
  AddEventHandler('tac:playerLoaded', function (source)
    LoadLicenses(source)
  end)
end

RegisterServerEvent('tac_weashop:buyLicense')
AddEventHandler('tac_weashop:buyLicense', function (price, wtype)
  local _source = source
  local xPlayer = tac.GetPlayerFromId(source)

  if xPlayer.get('money') >= price then
    xPlayer.removeMoney(price)
    TriggerEvent('tac_license:addLicense', _source, wtype, function ()
      LoadLicenses(_source)
    end)
  else
    TriggerClientEvent('tac:showNotification', _source, _U('not_enough'))
  end
end)

RegisterServerEvent('tac_weashop:buyItem')
AddEventHandler('tac_weashop:buyItem', function(itemName, price, zone)

  local _source = source
  local xPlayer  = tac.GetPlayerFromId(source)
  local account = xPlayer.getAccount('black_money')

  if zone=="BlackWeashop" then
    if account.money >= price then

    xPlayer.removeAccountMoney('black_money', price)
    xPlayer.addWeapon(itemName, 150)
    TriggerClientEvent('tac:showNotification', _source, _U('buy') .. tac.GetWeaponLabel(itemName))

  else
    TriggerClientEvent('tac:showNotification', _source, _U('not_enough_black'))
  end

  else if xPlayer.get('money') >= price then

    xPlayer.removeMoney(price)
    xPlayer.addWeapon(itemName, 150)

    TriggerClientEvent('tac:showNotification', _source, _U('buy') .. tac.GetWeaponLabel(itemName))

  else
    TriggerClientEvent('tac:showNotification', _source, _U('not_enough'))
  end
  end

end)
