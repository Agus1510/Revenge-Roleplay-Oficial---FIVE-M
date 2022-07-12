tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

TriggerEvent('tac_phone:registerNumber', 'banker', _('phone_receive'), false, false)
TriggerEvent('tac_society:registerSociety', 'banker', _U('phone_label'), 'society_banker', 'society_banker', 'society_banker', {type = 'public'})

RegisterServerEvent('tac_bankerjob:customerDeposit')
AddEventHandler('tac_bankerjob:customerDeposit', function (target, amount)
	local xPlayer = tac.GetPlayerFromId(target)

	TriggerEvent('tac_addonaccount:getSharedAccount', 'society_banker', function (account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)

			TriggerEvent('tac_addonaccount:getAccount', 'bank_savings', xPlayer.identifier, function (account)
				account.addMoney(amount)
			end)
		else
			TriggerClientEvent('tac:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('tac_bankerjob:customerWithdraw')
AddEventHandler('tac_bankerjob:customerWithdraw', function (target, amount)
	local xPlayer = tac.GetPlayerFromId(target)

	TriggerEvent('tac_addonaccount:getAccount', 'bank_savings', xPlayer.identifier, function (account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)

			TriggerEvent('tac_addonaccount:getSharedAccount', 'society_banker', function (account)
				account.addMoney(amount)
			end)
		else
			TriggerClientEvent('tac:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

tac.RegisterServerCallback('tac_bankerjob:getCustomers', function (source, cb)
	local xPlayers  = tac.GetPlayers()
	local customers = {}

	for i=1, #xPlayers do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])

		TriggerEvent('tac_addonaccount:getAccount', 'bank_savings', xPlayer.identifier, function(account)
			table.insert(customers, {
				source      = xPlayer.source,
				name        = xPlayer.name,
				bankSavings = account.money
			})
		end)
	end

	cb(customers)
end)

function CalculateBankSavings(d, h, m)
	local asyncTasks = {}

	MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
		['@account_name'] = 'bank_savings'
	}, function(result)
		local bankInterests = 0

		for i=1, #result, 1 do
			local xPlayer = tac.GetPlayerFromIdentifier(result[i].owner)

			if xPlayer then
				TriggerEvent('tac_addonaccount:getAccount', 'bank_savings', xPlayer.identifier, function(account)
					local interests = math.floor(account.money / 100 * Config.BankSavingPercentage)
					bankInterests   = bankInterests + interests

					table.insert(asyncTasks, function(cb)
						account.addMoney(interests)
					end)
				end)
			else
				local interests = math.floor(result[i].money / 100 * Config.BankSavingPercentage)
				local newMoney  = result[i].money + interests
				bankInterests = bankInterests + interests

				local scope = function(newMoney, owner)
					table.insert(asyncTasks, function(cb)
						MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE owner = @owner AND account_name = @account_name', {
							['@money']        = newMoney,
							['@owner']        = owner,
							['@account_name'] = 'bank_savings',
						}, function(rowsChanged)
							cb()
						end)
					end)
				end

				scope(newMoney, result[i].owner)
			end
		end

		TriggerEvent('tac_addonaccount:getSharedAccount', 'society_banker', function(account)
			account.addMoney(bankInterests)
		end)

		Async.parallelLimit(asyncTasks, 5, function(results)
			print('[BANK] Calculated interests')
		end)
	end)
end

TriggerEvent('cron:runAt', 22, 0, CalculateBankSavings)
