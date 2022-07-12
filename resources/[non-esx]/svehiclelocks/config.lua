-- [[ Version 1.0.4 ]] --

-- [[ Hope RP - connect 193.70.80.35:30120 ]] --
-- [[ Discord Shorty Ward - https://discord.gg/rH7fheS  ]] --

Config = {}

Config.Locale      = 'en'  -- [[ Local Language en by default                          ]] --
Config.notifca     = false -- [[ Show lock and unlock messages, false default          ]] --
Config.lockKey     = 303  -- [[ Key to Lock / Unlock Vehicle U by default             ]] --
Config.lockNPC     = false  -- [[ Lock all NPC cars True By Default                     ]] --
Config.defLock     = false -- [[ Default setting for Owned vehicles false by default   ]] --
Config.lChance     = 0   -- [[ Percent chance of vehicle being unlocked              ]] --
Config.rDist       = 10    -- [[ Distance for vehicles in area default 10              ]] --
Config.rentalPlate = 'RENT'-- [[ Rental Plate None Unique letters Default is RENT      ]] --

-- [[ Names of emergency jobs for emergency vehicle locks  ]] --
Config.emergencyJob = {
  "police",
  "bcso",
  "ambulance"
}

-- [[ Job name and Number Plate NOTE: this removes any numbers E.G PDM 477 will read PDM  ]] --
Config.JobsandPlates = {
  [1] = {job = 'cardealer',           plate = 'PDM'},
  [2] = {job = 'mecano',            plate = 'BENNY'}
}

-- [[ These vehicles will always be LOCKED and cannot be Unlocked   ]] --
Config.blacklistVehicles = {
  "T20",
  "RHINO"
}

-- [[ Vehicles wich will never be locked, great when using vehicles and no job or plate is Set  ]] --
Config.whitelistVehicles = {
  "burrito3",
  "boxville"
}
-- [[ Same as Job plates but any vehicles with this plate can remote lock/unlock by anyone, great for jobs like ESX-Moneylaundering etc   ]] --

Config.whitelistPlates = { 
  "WAL"
}
