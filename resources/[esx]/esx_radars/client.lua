--===============================================--===============================================
--= stationary radars based on  https://github.com/DreanorGTA5Mods/StationaryRadar           =
--===============================================--===============================================
tac              = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while tac == nil do
        TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('tac:playerLoaded')
AddEventHandler('tac:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('tac:setJob')
AddEventHandler('tac:setJob', function(job)
    PlayerData.job = job
end)

local radares = {
    {x = 379.68807983398, y = -1048.3527832031, z = 29.250692367554},
    {x = -253.10794067383, y = -630.20385742188, z = 33.002685546875},
	
}

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for k,v in pairs(radares) do
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player, true)
            if Vdist2(radares[k].x, radares[k].y, radares[k].z, coords["x"], coords["y"], coords["z"]) < 20 then
                if PlayerData.job ~= nil and not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
                    checkSpeed()
                end
            end
        end
    end
end)

function checkSpeed()
    local pP = GetPlayerPed(-1)
    local speed = GetEntitySpeed(pP)
    local vehicle = GetVehiclePedIsIn(pP, false)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local plate = GetVehicleNumberPlateText(vehicle)
    local maxspeed = 45
    local mphspeed = math.ceil(speed*2.236936)
	local fineamount = nil
	local finelevel = nil
	local truespeed = mphspeed
    if mphspeed > maxspeed and driver == pP then
        Citizen.Wait(250)
        TriggerServerEvent('fineAmount', mphspeed)
	if truespeed >= 50 and truespeed <= 60 then
	fineamount = Config.Fine
	finelevel = '10kmh por encima del limite'
	end
	if truespeed >= 60 and truespeed <= 70 then
	fineamount = Config.Fine2
	finelevel = '20kmh por encima del limite'
	end
	if truespeed >= 70 and truespeed <= 80 then
	fineamount = Config.Fine3
	finelevel = '30kmh por encima del limite'
	end
	if truespeed >= 80 and truespeed <= 500 then
	fineamount = Config.Fine4
	finelevel = '40kmh por encima del limite'
	end
        exports.pNotify:SetQueueMax("left", 1)
        exports.pNotify:SendNotification({
            text = "<h2><center>Radar</center></h2>" .. "</br>Se te multo por exceso de velocidad!</br>Plate Number: " .. plate .. "</br>Multa: $" .. fineamount .. "</br>Violacion: " .. finelevel .. "</br>Limite de veloidad: " .. maxspeed .. "</br>Tu velocidad: " ..mphspeed,
            type = "error",
            timeout = 9500,
            layout = "centerLeft",
            queue = "left"
        })
    end
end
