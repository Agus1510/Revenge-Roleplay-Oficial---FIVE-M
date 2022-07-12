tac = nil
local Jobs = {}
local RegisteredSocieties = {}

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

AddEventHandler('tac_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('tac_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('tac_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('tac_society:withdrawMoney')
AddEventHandler('tac_society:withdrawMoney', function(society, amount)
	local xPlayer = tac.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = tac.Math.Round(tonumber(amount))

	if xPlayer.job.name == society.name then
		TriggerEvent('tac_addonaccount:getSharedAccount', society.account, function(account)
			if amount > 0 and account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addMoney(amount)

				xPlayer.showNotification(_U('have_withdrawn', tac.Math.GroupDigits(amount)))
			else
				xPlayer.showNotification(_U('invalid_amount'))
			end
		end)
	else
		print(('tac_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_society:depositMoney')
AddEventHandler('tac_society:depositMoney', function(society, amount)
	local xPlayer = tac.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = tac.Math.Round(tonumber(amount))

	if xPlayer.job.name == society.name then
		if amount > 0 and xPlayer.getMoney() >= amount then
			TriggerEvent('tac_addonaccount:getSharedAccount', society.account, function(account)
				xPlayer.removeMoney(amount)
				account.addMoney(amount)
			end)

			xPlayer.showNotification(_U('have_deposited', tac.Math.GroupDigits(amount)))
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		print(('tac_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_society:washMoney')
AddEventHandler('tac_society:washMoney', function(society, amount)
	local xPlayer = tac.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = tac.Math.Round(tonumber(amount))

	if xPlayer.job.name == society then
		if amount and amount > 0 and account.money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)

			MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
				['@identifier'] = xPlayer.identifier,
				['@society']    = society,
				['@amount']     = amount
			}, function(rowsChanged)
				xPlayer.showNotification(_U('you_have', tac.Math.GroupDigits(amount)))
			end)
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		print(('tac_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('tac_society:putVehicleInGarage')
AddEventHandler('tac_society:putVehicleInGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('tac_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('tac_society:removeVehicleFromGarage')
AddEventHandler('tac_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('tac_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

tac.RegisterServerCallback('tac_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('tac_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

tac.RegisterServerCallback('tac_society:getEmployees', function(source, cb, society)
	if Config.EnabletacIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					job = {
						name        = results[i].job,
						label       = Jobs[results[i].job].label,
						grade       = results[i].job_grade,
						grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
						grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					job = {
						name        = result[i].job,
						label       = Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

tac.RegisterServerCallback('tac_society:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

tac.RegisterServerCallback('tac_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = tac.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = tac.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				xTarget.showNotification(_U('you_have_been_hired', job))
			elseif type == 'promote' then
				xTarget.showNotification(_U('you_have_been_promoted'))
			elseif type == 'fire' then
				xTarget.showNotification(_U('you_have_been_fired', xTarget.getJob().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('tac_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

tac.RegisterServerCallback('tac_society:setJobSalary', function(source, cb, job, grade, salary)
	local xPlayer = tac.GetPlayerFromId(source)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = tac.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xTarget = tac.GetPlayerFromId(xPlayers[i])

					if xTarget.job.name == job and xTarget.job.grade == grade then
						xTarget.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('tac_society: %s attempted to setJobSalary over config limit!'):format(xPlayer.identifier))
			cb()
		end
	else
		print(('tac_society: %s attempted to setJobSalary'):format(xPlayer.identifier))
		cb()
	end
end)

tac.RegisterServerCallback('tac_society:getOnlinePlayers', function(source, cb)
	local xPlayers = tac.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = tac.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

tac.RegisterServerCallback('tac_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)

	TriggerEvent('tac_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

tac.RegisterServerCallback('tac_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = tac.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('tac_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function WashMoneyCRON(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM society_moneywash', {}, function(result)
		for i=1, #result, 1 do
			local society = GetSociety(result[i].society)
			local xPlayer = tac.GetPlayerFromIdentifier(result[i].identifier)

			-- add society money
			TriggerEvent('tac_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)
			end)

			-- send notification if player is online
			if xPlayer then
				xPlayer.showNotification(_U('you_have_laundered', tac.Math.GroupDigits(result[i].amount)))
			end

			MySQL.Async.execute('DELETE FROM society_moneywash WHERE id = @id', {
				['@id'] = result[i].id
			})
		end
	end)
end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRON)
