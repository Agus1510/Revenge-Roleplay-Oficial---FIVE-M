local Charset = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

tac.GetRandomString = function(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return tac.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

tac.GetConfig = function()
	return Config
end

tac.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)
	local weapons = tac.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			return i, weapons[i]
		end
	end
end

tac.GetWeaponList = function()
	return Config.Weapons
end

tac.GetWeaponLabel = function(weaponName)
	weaponName = string.upper(weaponName)
	local weapons = tac.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			return weapons[i].label
		end
	end
end

tac.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = tac.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			for j=1, #weapons[i].components, 1 do
				if weapons[i].components[j].name == weaponComponent then
					return weapons[i].components[j]
				end
			end
		end
	end
end

tac.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. tac.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

tac.Round = function(value, numDecimalPlaces)
	return tac.Math.Round(value, numDecimalPlaces)
end
