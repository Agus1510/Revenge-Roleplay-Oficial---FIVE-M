tac = nil

TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)

function AddLicense(target, type, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function RemoveLicense(target, type, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function GetLicense(type, cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
		['@type'] = type
	}, function(result)
		local data = {
			type  = type,
			label = result[1].label
		}

		cb(data)
	end)
end

function GetLicenses(target, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
		['@owner'] = identifier
	}, function(result)
		local licenses   = {}
		local asyncTasks = {}

		for i=1, #result, 1 do

			local scope = function(type)
				table.insert(asyncTasks, function(cb)
					MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
						['@type'] = type
					}, function(result2)
						table.insert(licenses, {
							type  = type,
							label = result2[1].label
						})

						cb()
					end)
				end)
			end

			scope(result[i].type)

		end

		Async.parallel(asyncTasks, function(results)
			cb(licenses)
		end)

	end)
end

function CheckLicense(target, type, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

function GetLicensesList(cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses', {
		['@type'] = type
	}, function(result)
		local licenses = {}

		for i=1, #result, 1 do
			table.insert(licenses, {
				type  = result[i].type,
				label = result[i].label
			})
		end

		cb(licenses)
	end)
end

RegisterNetEvent('tac_license:addLicense')
AddEventHandler('tac_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('tac_license:removeLicense')
AddEventHandler('tac_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('tac_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('tac_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('tac_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('tac_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

tac.RegisterServerCallback('tac_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

tac.RegisterServerCallback('tac_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

tac.RegisterServerCallback('tac_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

tac.RegisterServerCallback('tac_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)