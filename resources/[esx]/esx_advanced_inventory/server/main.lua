tac = nil

local arrayWeight = Config.localWeight

TriggerEvent('tac:getSharedObject', function(obj) 
  tac = obj
end)

AddEventHandler('onMySQLReady', function ()
  if Config.WeightSqlBased == true then
    MySQL.Async.fetchAll(
      'SELECT * FROM item_weight',
      {},
      function(result)
        for i=1, #result, 1 do
          arrayWeight[result[i].item] = result[i].weight
        end
  
      end
    )
  end
end)

-- Return the sum of all item in pPlayer inventory
function getInventoryWeight(pPlayer)
  local weight = 0
  local itemWeight = 0

  if #pPlayer.inventory > 0 then
	  for i=1, #pPlayer.inventory, 1 do
	    if pPlayer.inventory[i] ~= nil then
	      itemWeight = Config.DefaultWeight
	      if arrayWeight[pPlayer.inventory[i].name] ~= nil then
	        itemWeight = arrayWeight[pPlayer.inventory[i].name]
	      end
	      weight = weight + (itemWeight * pPlayer.inventory[i].count)
	    end
	  end
  end

  return weight
end

-- Get user speed
-- https://runtime.fivem.net/doc/reference.html#_0x6DB47AA77FD94E09
function getUserSpeed(weight)
  local speed = 1.49

  if weight > Config.Limit / 2 then
  	speed = 1.49 * (weight / Config.Limit)
  end

  if speed < 1.0 then
  	speed = 1.0
  end

  if speed > 1.49 then
  	speed = 1.0
  end

  return speed
end

RegisterServerEvent('tac:onAddInventoryItem')
AddEventHandler('tac:onAddInventoryItem', function(source, item, count)
  local source_ = source
  local xPlayer = tac.GetPlayerFromId(source_)
  local currentInventoryWeight = getInventoryWeight(xPlayer)

  if Config.userSpeed == true then
    local speed = getUserSpeed(currentInventoryWeight)
    TriggerClientEvent('tac_advanced_inventory:speed', source_, speed)
  end

  if currentInventoryWeight > Config.Limit then
    local xPlayer = tac.GetPlayerFromId(source_)
    local itemWeight = Config.DefaultWeight

    -- Get weight if it exists of current item
    if arrayWeight[item.name] then
      itemWeight = arrayWeight[item.name]
    end
    local qty = 0
    local weightTooMuch = 0
    weightTooMuch = currentInventoryWeight - Config.Limit
    qty = math.floor(weightTooMuch / itemWeight) + 1

    -- Should be false all the time. But can be true on fresh install
    if qty > count then
      qty = count
    end
    tac.CreatePickup('item_standard', item.name, qty, item.label, source_)
    TriggerClientEvent('tac:showNotification', source_, 'Vous avez fait ~r~tomber~s~ ' .. item.label .. ' x' .. qty)
    xPlayer.removeInventoryItem(item.name, qty)
  end
end)

RegisterServerEvent('tac:onRemoveInventoryItem')
AddEventHandler('tac:onRemoveInventoryItem', function(source, item, count)
    if Config.userSpeed == true then
      local source_ = tac.GetPlayerFromId(source)
      local xPlayer = tac.GetPlayerFromId(source_)
      local currentInventoryWeight = getInventoryWeight(xPlayer)
      local speed = getUserSpeed(currentInventoryWeight)
      TriggerClientEvent('tac_advanced_inventory:speed', source_, speed)
    end
end)

RegisterServerEvent('tac_advanced_inventory:initSpeed')
AddEventHandler('tac_advanced_inventory:initSpeed', function(source)
    if Config.userSpeed == true then
      local source_ = tac.GetPlayerFromId(source)
      local xPlayer = tac.GetPlayerFromId(source_)
      local currentInventoryWeight = getInventoryWeight(xPlayer)
      local speed = getUserSpeed(currentInventoryWeight)
      TriggerClientEvent('tac_advanced_inventory:speed', source_, speed)
    end
end)


-- WIP: Someone to contribute ? Extend user max weight when skin having a bag ?

--	-- skin based solution (Config.BagIsSkin = true)

		--RegisterServerEvent('tac_skin:save')
		--AddEventHandler('tac_skin:save', function(skin)
		--	-- TODO: If skin, increase player max weight
		-- 	-- 		Do not forget to bind on tac:onRemoveInventoryItem when removing the bag.
		--end)


--	-- item bag based solution (Config.BagIsSkin = false)

		-- tac:onAddInventoryItem if item = bag
		-- tac:onRemoveInventoryItem if item = bag


-- TDB: If player throw, sell, give is bag (item or skin), need algo to throw randomly items ?
