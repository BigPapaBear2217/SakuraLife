config = config or {}

config.unemployedJob = "unemployed" -- If a job get deleted, players that had that job will be this new job
config.unemployedGrade = 0 -- grade players will be after their job get deleted

config.acePermission = "jobcreator" -- Example in server.cfg: add_ace group.admin jobcreator allow 

-- Enable or not discord logging (you need to create a webhook on one channel)
config.isDiscordLogActive = false

-- This is the default webhook, so if you want only 1 channel you can set its webhook here (always use this, there are other logs than markers only)
config.discordWebhook = nil

--[[
    Here you can define specific webhooks if you want to separate all logs in different channels
    If a log type it's not defined here, the log will use config.discordWebhook
    Replace nil with your webhook between double quotes

    example: "https://discord.com/api/YOUR_WEBHOOK"
]]
config.specificWebhooks = {
    ['armory'] = nil,
    ['boss'] = nil,
    ['crafting_table'] = nil,
    ['harvest'] = nil,
    ['job_outfit'] = nil,
    ['job_shop'] = nil,
    ['market'] = nil,
    ['permanent_garage'] = nil,
    ['safe'] = nil,
    ['shop'] = nil,
    ['stash'] = nil,
    ['teleport'] = nil,
    ['wardrobe'] = nil,
    ['weapon_upgrader'] = nil,
    ['process'] = nil,
}

config.handcuffRequireItem = false
config.handcuffsItemName = "handcuffs"

config.lockpickCarRequireItem = false
config.lockpickItemName = "lockpick"
config.lockpickRemoveOnUse = false

config.robbableAccounts = {'money', 'black_money'} -- Accounts that will be robbable when searching a player

config.canAlwaysCarryItem = false -- Bypass the inventory weight checks

config.depositableInSafeAccounts = {'money', 'black_money'} -- Accounts that will be depositable in a safe

--[[
    If you have an old version of ESX, cash will not be an account. 
    If you don't see cash depositable but you want it to be depositable, set config.enableCashInSafesOldESX = true
]]
config.enableCashInSafesOldESX = true

config.repairVehicleRequireItem = false
config.repairVehicleItemName = "fixkit"
config.repairVehicleRemoveOnUse = false

config.washVehicleRequireItem = false
config.washVehicleItemName = "sponge"
config.washVehicleRemoveOnUse = false

-- Enable or not outfits of property datastore in wardrobe marker
config.enablePropertyOutfits = true