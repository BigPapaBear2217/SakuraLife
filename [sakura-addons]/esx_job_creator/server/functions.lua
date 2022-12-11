-- Key = jobName, value is a table of ([markerId] = true)
local jobsMarkersIDs = {}

-- Key = markerId, value = markerData
fullMarkerData = {}

-- key = markerId, value = job name
local jobNamesFromRankId = {}

local jobAllowedActions = {}

--[[ Utils ]]
function log(playerId, title, description, type, logType)
    if(config.isDiscordLogActive) then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local identifier = xPlayer.identifier
        local jobName = xPlayer.job.name
        local jobGrade = xPlayer.job.grade

        local color = nil

        if(type == "info") then
            color = 1752220
        elseif(type == "error") then
            color = 15548997
        elseif(type == "success") then
            color = 5763719
        end

        local webhook = config.specificWebhooks[logType] or config.discordWebhook

        PerformHttpRequest(webhook, nil, "POST", json.encode({
            username = GetCurrentResourceName(),
            embeds = {
                {
                    title = title,
                    description = getLocalizedText('log_generic', 
                        GetPlayerName(playerId),
                        identifier,
                        jobName,
                        jobGrade,
                        description
                    ),
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    color = color
                }
            }
        }), {
            ['Content-Type'] = 'application/json'
        })
    end
end

function isAllowed(playerId)
    return IsPlayerAceAllowed(playerId, config.acePermission)
end

function isAllowedToUseMarker(playerId, markerId)
    if(fullMarkerData[markerId].jobName == "public_marker") then
        return true
    end
    
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local jobName = xPlayer.job.name
    local jobGrade = xPlayer.job.grade
    
    return (
        (fullMarkerData[markerId].jobName == jobName)
        and 
        (fullMarkerData[markerId].minGrade <= jobGrade) 
    )
end

function canUseMarkerWithLog(playerId, markerId)
    if(not isAllowedToUseMarker(playerId, markerId)) then
        log(playerId,
            getLocalizedText('log_not_allowed_marker'),
            getLocalizedText('log_not_allowed_marker_description',
                markerId
            ),
            'error'
        )

        return false
    else
        return true
    end
end

function isCloseToMarker(playerId, markerId)
    local plyPed = GetPlayerPed(playerId)

    local plyCoords = GetEntityCoords(plyPed)
    local markerCoords = vector3(fullMarkerData[markerId].coords.x, fullMarkerData[markerId].coords.y, fullMarkerData[markerId].coords.z)

    local distance = #(plyCoords - markerCoords)

    if(distance < fullMarkerData[markerId].scale.x + 2.0 or distance < fullMarkerData[markerId].scale.y + 2.0) then
        return true
    else
        return false
    end
end

function getJobNameFromRankId(rankId, cb)
    if(jobNamesFromRankId[rankId]) then
        cb(jobNamesFromRankId[rankId])
    else
        MySQL.Async.fetchScalar('SELECT job_name FROM job_grades WHERE id=@id', {
            ["@id"] = rankId
        }, function(jobName)
            jobNamesFromRankId[rankId] = jobName
            
            cb(jobName)
        end)
    end
end

function getJobGradeFromRankId(rankId, cb)
    MySQL.Async.fetchScalar('SELECT grade FROM job_grades WHERE id=@id', {
        ["@id"] = rankId
    }, function(jobGrade)
        cb(jobGrade)
    end)
end

function stripCoords(oldCoords)
    local x, y, z = table.unpack(oldCoords)

    if (not x or not y or not z) then
        x, y, z = oldCoords.x, oldCoords.y, oldCoords.z
    end

    local newCoords = {
        x = tonumber(ESX.Math.Round(x, 2)),
        y = tonumber(ESX.Math.Round(y, 2)),
        z = tonumber(ESX.Math.Round(z, 2))
    }

    return newCoords
end

function canPlayerCarry(playerId, itemName, itemCount)

    if (config.canAlwaysCarryItem) then
        return true
    end

    local canCarry = false
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if (xPlayer.canCarryItem) then
        canCarry = xPlayer.canCarryItem(itemName, itemCount)
    else
        local item = xPlayer.getInventoryItem(itemName)
        canCarry = (item.limit == -1) or ((item.count + itemCount) <= item.limit)
    end

    return canCarry
end

function checkAllowedActions(jobName, cb)
    if(jobAllowedActions[jobName]) then
        cb(jobAllowedActions[jobName])
    else
        MySQL.Async.fetchAll('SELECT * FROM jobs WHERE name=@jobName LIMIT 1', {
            ["@jobName"] = jobName
        }, function(result)
            if(result[1]) then
                local data = {
                    enableBilling = result[1].enable_billing == 1,
                    canRob = result[1].can_rob == 1,
                    canHandcuff = result[1].can_handcuff == 1,
                    canLockpickCars = result[1].can_lockpick_cars == 1,
                    canWashVehicles = result[1].can_wash_vehicles == 1,
                    canRepairVehicles = result[1].can_repair_vehicles == 1,
                    canImpoundVehicles = result[1].can_impound_vehicles == 1,
                    canCheckIdentity = result[1].can_check_identity == 1,
                    canCheckVehicleOwner = result[1].can_check_vehicle_owner == 1,
                    canCheckDrivingLicense = result[1].can_check_driving_license == 1,
                    canCheckWeaponLicense = result[1].can_check_weapon_license == 1,
                }

                jobAllowedActions[jobName] = data

                cb(data)
            else
                cb({})
            end
        end)
    end
end

function payInSomeWay(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if (xPlayer.getMoney() >= amount) then
        xPlayer.removeMoney(amount)
        return true
    else
        local bank = xPlayer.getAccount('bank')

        if (bank.money >= amount) then
            xPlayer.removeAccountMoney('bank', amount)
            return true
        else
            return false
        end
    end

    return false
end

function arePlayersClose(playerId, targetId, maxDistance)
    local plyPed = GetPlayerPed(playerId)
    local targetPed = GetPlayerPed(targetId)

    if (plyPed and plyPed > 0 and targetPed and targetPed > 0) then

        local plyCoords = GetEntityCoords(plyPed)
        local targetCoords = GetEntityCoords(targetPed)

        return #(plyCoords - targetCoords) < maxDistance
    else
        return false
    end
end

function notify(playerId, message)
    if (playerId) then
        TriggerClientEvent('esx:showNotification', playerId, message)
    end
end

function progressBar(playerId, time, text)
    TriggerClientEvent('esx_job_creator:startProgressBar', playerId, time, text)
end

--[[ Ranks stuff ]]
function createRank(playerId, cb, jobName, rankName, rankLabel, rankGrade, rankSalary)
    if(isAllowed(playerId)) then
        if (jobName and rankName and rankLabel and rankGrade and rankSalary) then
            MySQL.Async.insert(
                'INSERT INTO job_grades(job_name, name, label, grade, salary, skin_male, skin_female) VALUES (@jobName, @rankName, @rankLabel, @rankGrade, @rankSalary, "{}", "{}");',
                {
                    ['@jobName'] = jobName,
                    ['@rankName'] = rankName,
                    ['@rankLabel'] = rankLabel,
                    ['@rankGrade'] = rankGrade,
                    ['@rankSalary'] = rankSalary
                }, function(jobGradeId)
                    if (jobGradeId > 0) then
                        jobNamesFromRankId[jobGradeId] = jobName
                        
                        local cbData = {
                            isSuccessful = true,
                            message = "Successful"
                        }

                        cb(cbData)
                    else
                        local cbData = {
                            isSuccessful = false,
                            message = "Couldn't create rank (database error)"
                        }

                        cb(cbData)
                    end
                end)
        else
            local cbData = {
                isSuccessful = false,
                message = "Couldn't create rank, argument missing"
            }
            cb(cbData)
        end
    else
        local cbData = {
            isSuccessful = false,
            message = "Couldn't create rank (not allowed)"
        }
        cb(cbData)
    end
end

function updateRank(playerId, cb, data)
    if(isAllowed(playerId)) then
        if (data) then
            MySQL.Async.execute(
                'UPDATE job_grades SET name=@rankName, grade=@rankGrade, label=@rankLabel, salary=@rankSalary WHERE id=@rankId',
                {
                    ['@rankId'] = data.rankId,
                    ['@rankGrade'] = data.rankGrade,
                    ['@rankLabel'] = data.rankLabel,
                    ['@rankSalary'] = data.rankSalary,
                    ['@rankName'] = data.rankName
                }, function(affectedRows)
                    if (affectedRows > 0) then
                        local cbData = {
                            isSuccessful = true,
                            message = "Successful"
                        }
                        cb(cbData)
                    else
                        local cbData = {
                            isSuccessful = false,
                            message = "Couldn't update the rank"
                        }
                        cb(cbData)
                    end
                end)
        else
            local cbData = {
                isSuccessful = false,
                message = "Couldn't update rank, data is missing"
            }
            cb(cbData)
        end
    else
        local cbData = {
            isSuccessful = false,
            message = "Couldn't update rank (not allowed)"
        }
        cb(cbData)
    end
end

function deleteRank(playerId, cb, rankId)
    if(isAllowed(playerId)) then
        if (rankId) then
            getJobNameFromRankId(rankId, function(jobName)
                getJobGradeFromRankId(rankId, function(jobGrade)

                    MySQL.Async.execute('DELETE FROM `job_grades` WHERE id=@rankId', {
                        ['@rankId'] = rankId
                    }, function(affectedRows)
                        if (affectedRows > 0) then
                            jobNamesFromRankId[rankId] = nil

                            -- Sets grade to 0 to all user with that job
                            MySQL.Async.execute('UPDATE `users` SET job_grade=0 WHERE job=@jobName AND job_grade=@jobGrade',
                                {
                                    ['@jobName'] = jobName,
                                    ['@jobGrade'] = jobGrade
                                }, function(affectedRows)
                                    local cbData = {
                                        isSuccessful = true,
                                        message = "Successful"
                                    }
                                    cb(cbData)
                                end)
                        else
                            local cbData = {
                                isSuccessful = false,
                                message = "Couldn't delete rank id: " .. rankId
                            }
                            cb(cbData)
                        end
                    end)
                end)
            end)
        else
            local cbData = {
                isSuccessful = false,
                message = "Empty rank id"
            }
            cb(cbData)
        end
    else
        local cbData = {
            isSuccessful = false,
            message = "Not allowed"
        }
        cb(cbData)
    end
end

-- Deletes all grades from job_grades of a job name
function deleteGradesOfJob(jobName)
    MySQL.Async.execute('DELETE FROM job_grades WHERE job_name=@jobName', {
        ['@jobName'] = jobName
    }, function(affectedRows)
        if(affectedRows > 0) then
            for rankId, currentJobName in pairs(jobNamesFromRankId) do
                if(jobName == currentJobName) then
                    jobNamesFromRankId[rankId] = nil
                end
            end
        end
    end)
end

-- Returns all ranks of jobName
function retrieveJobRanks(jobName, cb)
    MySQL.Async.fetchAll(
        'SELECT id, grade, name, label, salary FROM `job_grades` WHERE job_name=@jobName ORDER BY grade ASC', {
            ['@jobName'] = jobName
        }, function(ranks)
            cb(ranks)
        end)
end

--[[ Jobs stuff ]]
function registerSocieties()
    retrieveJobsData(function(jobs)

        print()
        for jobName, data in pairs(jobs) do
            local msg = "^6[%s]^7 Creating society ^5%s^7 (id: ^5%s^7) with ^5%d^7 grades"
            
            print(format(msg, GetCurrentResourceName(), data.label, data.name, #data.ranks))

            createSociety(jobName, data.label)
        end
        print()
    end)
end

local function createAddonAccount(jobName, jobLabel, societyName)
    MySQL.Async.fetchScalar("SELECT 1 FROM `addon_account` WHERE BINARY(name)=@societyName", {
        ['@societyName'] = societyName
    }, function(doesAlreadyExists)
        if(doesAlreadyExists) then return end

        MySQL.Async.execute('INSERT INTO `addon_account`(name, label, shared) VALUES (@societyName, @jobLabel, 1) ON DUPLICATE KEY UPDATE name=@societyName', {
            ['@societyName'] = societyName,
            ['@jobLabel'] = jobLabel
        }, function(affectedRows)
            if (affectedRows > 0) then
                local msg = "^6[%s]^7 Created ^5%s^7 in ^8'addon_account'^7"
                print(format(msg, GetCurrentResourceName(), jobName))
    
                MySQL.Async.fetchScalar('SELECT 1 FROM addon_account_data WHERE account_name=@societyName', {
                    ['@societyName'] = societyName
                }, function(doesAlreadyExists)
                    if(doesAlreadyExists) then
                        TriggerEvent('esx_addonaccount:refreshAccounts')
                        return 
                    end

                    MySQL.Async.execute(
                    'INSERT INTO `addon_account_data`(account_name, money, owner) VALUES (@societyName, 0, NULL) ON DUPLICATE KEY UPDATE account_name=@societyName', {
                        ['@societyName'] = societyName
                    }, function(affectedRows)
                        if (affectedRows > 0) then
                            local msg = "^6[%s]^7 Created ^5%s^7 in ^8'addon_account_data'^7"

                            print(format(msg, GetCurrentResourceName(), jobName))
                        end

                        TriggerEvent('esx_addonaccount:refreshAccounts')
                    end)
                end)
            end
        end)
    end)
end

local function createDatastore(jobName, jobLabel, societyName)
    MySQL.Async.fetchScalar('SELECT 1 FROM datastore WHERE BINARY(name)=@societyName', {
        ['@societyName'] = societyName
    }, function(doesAlreadyExists)
        if(doesAlreadyExists) then return end

        MySQL.Async.execute('INSERT INTO `datastore`(name, label, shared) VALUES (@societyName, @jobLabel, 1) ON DUPLICATE KEY UPDATE name=@societyName', {
            ['@societyName'] = societyName,
            ['@jobLabel'] = jobLabel
        }, function(affectedRows)
            if (affectedRows > 0) then
                local msg = "^6[%s]^7 Created ^5%s^7 in ^3'datastore'^7"
    
                print(format(msg, GetCurrentResourceName(), jobName))
    
                MySQL.Async.fetchScalar('SELECT 1 FROM datastore_data WHERE BINARY(name)=@societyName', {
                    ['@societyName'] = societyName
                }, function(doesAlreadyExists)
                    if (doesAlreadyExists) then return end
                    
                    MySQL.Async.execute('INSERT INTO `datastore_data`(name, owner, data) VALUES (@societyName, NULL, "{}") ON DUPLICATE KEY UPDATE name=@societyName', {
                            ['@societyName'] = societyName
                    }, function(affectedRows)
                        if (affectedRows > 0) then
                            local msg = "^6[%s]^7 Created ^5%s^7 in ^3'datastore_data'^7"

                            print(format(msg, GetCurrentResourceName(), jobName))
                        end
                    end)
                end)
            end
        end)
    end)
end

local function createAddonInventory(jobName, jobLabel, societyName)
    MySQL.Async.fetchScalar("SELECT 1 FROM addon_inventory WHERE BINARY(name)=@societyName", {
        ['@societyName'] = societyName
    }, function(doesAlreadyExists) 
        if(doesAlreadyExists) then return end

        MySQL.Async.execute('INSERT INTO `addon_inventory`(name, label, shared) VALUES (@societyName, @jobLabel, 1) ON DUPLICATE KEY UPDATE name=@societyName', {
            ['@societyName'] = societyName,
            ['@jobLabel'] = jobLabel
        }, function(affectedRows)
            if (affectedRows > 0) then
                local msg = "^6[%s]^7 Created ^5%s^7 in ^2'addon_inventory'^7"
    
                print(format(msg, GetCurrentResourceName(), jobName))
            end
        end)
    end)
end

local function registerSociety(jobName, jobLabel, societyName, attemptsCount)
    attemptsCount = attemptsCount or 1

    MySQL.Async.fetchScalar('SELECT shared FROM addon_account WHERE name=@societyName', {
        ['@societyName'] = societyName
    }, function(isShared)
        if (isShared == 1) then
            TriggerEvent('esx_society:registerSociety', jobName, jobLabel, societyName, societyName, societyName, {
                type = 'public'
            })

            Citizen.Wait(2000)

            TriggerEvent('esx_society:getSociety', jobName, function(society)
                if(society) then                    
                    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
                        if(not account) then
                            MySQL.Async.fetchAll("SELECT * FROM addon_account WHERE name=@societyName", {
                                ["@societyName"] = societyName
                            }, function(results)
                                if(results[1]) then
                                    if(results[1].name ~= societyName or results[1].shared == 0) then
                                        print()

                                        local msg = "^6[%s]^1 Found ^5%s^1 in database table 'addon_account' but couldn't register it^7"
                                        print(format(msg, GetCurrentResourceName(), jobName))
                                        
                                        local msg = "^6[%s]^1 Database values: name = %s, label = %s, shared = %d^7"
                                        print(format(msg, GetCurrentResourceName(), results[1].name, results[1].label, results[1].shared))
                                    end
                                else
                                    local msg = "^6[%s]^1 Couldn't find ^5%s^1 in database table 'addon_account'^7"
                                    
                                    print(format(msg, GetCurrentResourceName(), societyName))
                                end

                                if(attemptsCount < 3) then
                                    Citizen.Wait(2000)
                                    registerSociety(jobName, jobLabel, societyName, attemptsCount + 1)
                                end
                            end)
                        end
                    end)
                    
                    TriggerEvent('esx_datastore:getSharedDataStore', societyName, function(datastore)
                        if(not datastore) then
                            MySQL.Async.fetchAll("SELECT * FROM datastore WHERE name=@societyName", {
                                ["@societyName"] = societyName
                            }, function(results)
                                if(results[1]) then
                                    if(results[1].name ~= societyName or results[1].shared == 0) then
                                        print()
                                        
                                        local msg = "^6[%s]^1 Found ^5%s^1 in database table 'datastore' but couldn't register it^7"
                                        print(format(msg, GetCurrentResourceName(), jobName))
                                        
                                        local msg = "^6[%s]^1 Database values: name = %s, label = %s, shared = %d^7"
                                        print(format(msg, GetCurrentResourceName(), results[1].name, results[1].label, results[1].shared))
                                    end
                                else
                                    local msg = "^6[%s]^1 Couldn't find ^5%s^1 in database table 'datastore'^7"
                                    
                                    print(format(msg, GetCurrentResourceName(), societyName))
                                end

                                if(attemptsCount < 3) then
                                    Citizen.Wait(2000)
                                    registerSociety(jobName, jobLabel, societyName, attemptsCount + 1)
                                end
                            end)
                        end
                    end)
                end
            end)
        end
    end)
end

function createSociety(jobName, jobLabel)
    local societyName = "society_" .. jobName

    createAddonAccount(jobName, jobLabel, societyName)
    createAddonInventory(jobName, jobLabel, societyName)
    createDatastore(jobName, jobLabel, societyName)

    registerSociety(jobName, jobLabel, societyName)
end

function createJob(jobName, jobLabel, cb)
    MySQL.Async.execute('INSERT INTO jobs(name, label) VALUES (@jobName, @jobLabel)', {
        ['@jobName'] = jobName,
        ['@jobLabel'] = jobLabel
    }, function(affectedRows)
        if (affectedRows > 0) then
            createSociety(jobName, jobLabel)
            local cbData = {
                isSuccessful = true,
                message = "Successful"
            }
            cb(cbData)
        else
            local cbData = {
                isSuccessful = false,
                message = "Couldn't create the job"
            }
            cb(cbData)
        end
    end)
end

local function updateRanksJobName(oldJobName, newJobName)
    MySQL.Async.execute("UPDATE job_grades SET job_name=@newJobName WHERE job_name=@oldJobName", {
        ['@oldJobName'] = oldJobName,
        ['@newJobName'] = newJobName,
    })
end

local function updateMarkersJobName(oldJobName, newJobName)
    MySQL.Async.execute("UPDATE jobs_data SET job_name=@newJobName WHERE job_name=@oldJobName", {
        ['@oldJobName'] = oldJobName,
        ['@newJobName'] = newJobName,
    })
end

function updateJob(oldJobName, newJobName, newJobLabel, whitelisted, actions, cb)
    if (oldJobName and newJobName and newJobLabel) then

        jobAllowedActions[newJobName] = actions

        -- Refresh allowed actions to players
        for k, playerId in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            
            if(xPlayer.job.name == oldJobName) then
                TriggerClientEvent('esx_job_creator:checkAllowedActions', playerId)
            end
        end

        MySQL.Async.execute([[
                UPDATE `jobs` 
                SET `label`=@newJobLabel,
                `name`=@newJobName,
                `enable_billing`=@enableBilling,
                `can_rob`=@canRob,
                `can_handcuff`=@canHandcuff,
                `whitelisted`=@whitelisted,
                `can_lockpick_cars`=@canLockpickCars,
                `can_wash_vehicles`=@canWashVehicles,
                `can_repair_vehicles`=@canRepairVehicles,
                `can_impound_vehicles`=@canImpoundVehicles,
                `can_check_identity`=@canCheckIdentity,
                `can_check_vehicle_owner`=@canCheckVehicleOwner,
                `can_check_driving_license`=@canCheckDrivingLicense,
                `can_check_weapon_license`=@canCheckWeaponLicense

                WHERE `name`=@oldJobName
            ]], {
            ['@newJobName'] = newJobName,
            ['@newJobLabel'] = newJobLabel,
            ['@oldJobName'] = oldJobName,
            ['@enableBilling'] = actions.enableBilling,
            ['@canRob'] = actions.canRob,
            ['@canHandcuff'] = actions.canHandcuff,
            ['@whitelisted'] = whitelisted,
            ['@canLockpickCars'] = actions.canLockpickCars,
            ['@canWashVehicles'] = actions.canWashVehicles,
            ['@canRepairVehicles'] = actions.canRepairVehicles,
            ['@canImpoundVehicles'] = actions.canImpoundVehicles,
            ['@canCheckIdentity'] = actions.canCheckIdentity,
            ['@canCheckVehicleOwner'] = actions.canCheckVehicleOwner,
            ['@canCheckDrivingLicense'] = actions.canCheckDrivingLicense,
            ['@canCheckWeaponLicense'] = actions.canCheckWeaponLicense,
        }, function(affectedRows)
            if (affectedRows > 0) then

                if(oldJobName ~= newJobName) then
                    updateRanksJobName(oldJobName, newJobName)
                    updateMarkersJobName(oldJobName, newJobName)
                end

                local cbData = {
                    isSuccessful = true,
                    message = "Successful"
                }
                cb(cbData)
            else
                local cbData = {
                    isSuccessful = false,
                    message = "Couldn't update the job"
                }
                cb(cbData)
            end
        end)
    else
        local cbData = {
            isSuccessful = false,
            message = "Couldn't update the job, argument missing"
        }
        cb(cbData)
    end
end

-- Players will be unemployed
function removeJobFromPlayers(jobName)
    MySQL.Async.execute('UPDATE users SET job=@unemployedJob, job_grade=@unemployedGrade WHERE job=@jobName', {
        ['@jobName'] = jobName,
        ["@unemployedJob"] = config.unemployedJob,
        ["@unemployedGrade"] = config.unemployedGrade
    }, nil)
end

function deleteJob(jobName, cb)
    MySQL.Async.execute('DELETE FROM jobs WHERE name=@jobName', {
        ['@jobName'] = jobName
    }, function(affectedRows)
        if (affectedRows > 0) then
            local cbData = {
                isSuccessful = true,
                message = "Successful"
            }
            cb(cbData)

            removeJobFromPlayers(jobName)
            deleteGradesOfJob(jobName)
            deleteJobMarkers(jobName)
        else
            local cbData = {
                isSuccessful = false,
                message = "Couldn't delete this job"
            }
            cb(cbData)
        end
    end)
end

function retrieveJobsData(cb)
    MySQL.Async.fetchAll('SELECT * FROM jobs ORDER BY label', {}, function(jobs)
        if (jobs) then
            local jobsData = {}
            local completed = 0

            for k, job in pairs(jobs) do
                jobsData[job.name] = {
                    name = job.name,
                    label = job.label,
                    
                    enableBilling = job.enable_billing,
                    canRob = job.can_rob,
                    canHandcuff = job.can_handcuff,
                    whitelisted = job.whitelisted,
                    canLockpickCars = job.can_lockpick_cars,
                    canWashVehicles = job.can_wash_vehicles,
                    canRepairVehicles = job.can_repair_vehicles,
                    canImpoundVehicles = job.can_impound_vehicles,
                    canCheckIdentity = job.can_check_identity,
                    canCheckVehicleOwner = job.can_check_vehicle_owner,
                    canCheckDrivingLicense = job.can_check_driving_license,
                    canCheckWeaponLicense = job.can_check_weapon_license,

                    ranks = {}
                }

                retrieveJobRanks(job.name, function(ranks)
                    if (ranks) then
                        jobsData[job.name].ranks = ranks

                        completed = completed + 1

                        if (completed >= #jobs) then
                            cb(jobsData)
                        end
                    end
                end)
            end
        else
            cb(false)
        end
    end)
end

--[[ Markers stuff ]]
function createNewMarker(jobName, label, type, coords, minGrade, cb)
    local coords = stripCoords(coords)

    MySQL.Async.insert(
        'INSERT INTO jobs_data(job_name, type, coords, min_grade, label) VALUES (@jobName, @type, @coords, @minGrade, @label);',
        {
            ['@jobName'] = jobName,
            ['@type'] = type,
            ["@coords"] = json.encode(coords),
            ["@minGrade"] = minGrade,
            ["@label"] = label
        }, function(markerId)
            if (markerId > 0) then
                jobsMarkersIDs[jobName] = jobsMarkersIDs[jobName] or {}
                jobsMarkersIDs[jobName][markerId] = true

                fullMarkerData[markerId] = {
                    jobName = jobName,
                    label = label,
                    type = type,
                    coords = coords,
                    minGrade = minGrade,
                    data = {},
                    id = markerId,
                    color = {
                        r = 255,
                        g = 255,
                        b = 0,
                        alpha = 50
                    },

                    scale = {
                        x = 1.5,
                        y = 1.5,
                        z = 0.5
                    },

                    blip = {

                    },

                    markerType = 1,
                }

                makeAllJobPlayersRefreshMarkers(jobName, function()
                    local cbData = {
                        isSuccessful = true,
                        message = "Successful",
                        markerId = markerId
                    }

                    cb(cbData)
                end)
            else
                local cbData = {
                    isSuccessful = false,
                    message = "Couldn't create the marker"
                }
                cb(cbData)
            end
        end)
end

function getMarkersFromJobName(jobName)
    if(not jobsMarkersIDs[jobName]) then
        return {}
    else
        local markers = {}

        for markerId, _ in pairs(jobsMarkersIDs[jobName]) do
            markers[markerId] = fullMarkerData[markerId]
        end

        return markers
    end
end

function getPublicMarkers()
    return getMarkersFromJobName('public_marker')
end

function getAllMarkers()
    MySQL.Async.fetchAll('SELECT * FROM jobs_data', {}, 
        function(markersData)
            for k, markerData in pairs(markersData) do
                local markerId = markerData.id
                local jobName = markerData.job_name

                fullMarkerData[markerId] = {
                    id = markerId,

                    label = markerData.label,

                    coords = json.decode(markerData.coords),

                    minGrade = markerData.min_grade,

                    blip = {
                        spriteId = markerData.blip_id,
                        color = markerData.blip_color,
                        scale = markerData.blip_scale,
                    },
                    
                    type = markerData.type,
                    jobName = jobName,
                    data = json.decode(markerData.data),
                    markerType = markerData.marker_type,

                    scale = {
                        x = markerData.marker_scale_x,
                        y = markerData.marker_scale_y,
                        z = markerData.marker_scale_z,
                    },
                    
                    color = {
                        r = markerData.marker_color_red,
                        g = markerData.marker_color_green,
                        b = markerData.marker_color_blue,
                        alpha = markerData.marker_color_alpha,
                    },

                    ped = {
                        model = markerData.ped,
                        heading = markerData.ped_heading,
                    }
                }

                jobsMarkersIDs[jobName] = jobsMarkersIDs[jobName] or {}

                jobsMarkersIDs[jobName][markerId] = true
            end
        end
    )
end

function getMarkersMinGrade(jobName, jobGrade, cb)
    local jobMarkers = getMarkersFromJobName(jobName)
    local publicMarkers = getPublicMarkers()

    for markerId, markerData in pairs(jobMarkers) do
        if(jobGrade < markerData.minGrade) then
            jobMarkers[markerId] = nil
        end
    end
    
    for markerId, markerData in pairs(publicMarkers) do
        jobMarkers[markerId] = markerData
    end

    cb(jobMarkers)
end

function makeAllJobPlayersRefreshMarkers(jobName, cb)
    if(jobName == "public_marker") then
        TriggerClientEvent('esx_job_creator:refreshMarkers', -1)
    else
        for _, playerId in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
    
            if (xPlayer.job.name == jobName) then
                TriggerClientEvent('esx_job_creator:refreshMarkers', playerId)
            end
        end
    end

    if (cb) then
        cb()
    end
end

function deleteMarker(markerId, cb)
    local jobName = fullMarkerData[markerId].jobName

    if (jobName) then
        MySQL.Async.execute('DELETE FROM jobs_data WHERE id=@markerId', {
            ['@markerId'] = markerId
        }, function(affectedRows)
            if (affectedRows > 0) then
                jobsMarkersIDs[jobName][markerId] = nil
                fullMarkerData[markerId] = nil
                
                makeAllJobPlayersRefreshMarkers(jobName)

                local cbData = {
                    isSuccessful = true,
                    message = "Successful"
                }

                cb(cbData)
            else
                local cbData = {
                    isSuccessful = false,
                    message = "Couldn't delete the marker"
                }

                cb(cbData)
            end
        end)
    else
        local cbData = {
            isSuccessful = false,
            message = "Couldn't delete the marker (no job name in marker id data)"
        }

        cb(cbData)
    end
end

function updateMarker(playerId, cb, markerId, newMarkerData)
    local coords = stripCoords(newMarkerData.coords)
    
    MySQL.Async.execute([[
            UPDATE jobs_data SET 
            coords=@coords,

            min_grade=@minGrade,

            label=@label,

            blip_id=@blipSpriteId,
            blip_color=@blipColor,
            blip_scale=@blipScale,

            marker_type=@markerType,

            marker_scale_x=@scaleX,
            marker_scale_y=@scaleY,
            marker_scale_z=@scaleZ,

            marker_color_red=@red,
            marker_color_green=@green,
            marker_color_blue=@blue,

            marker_color_alpha=@alpha,

            ped=@ped,
            ped_heading=@ped_heading

            WHERE id=@markerId
        ]], {
        ['@markerId'] = markerId,
        ['@coords'] = json.encode(coords),
        ['@minGrade'] = newMarkerData.minGrade,
        ['@label'] = newMarkerData.label,

        ['@blipSpriteId'] = newMarkerData.blip.spriteId,
        ['@blipColor'] = newMarkerData.blip.color,
        ['@blipScale'] = newMarkerData.blip.scale,

        ['@markerType'] = newMarkerData.markerType,

        ['@scaleX'] = newMarkerData.scale.x,
        ['@scaleY'] = newMarkerData.scale.y,
        ['@scaleZ'] = newMarkerData.scale.z,

        ['@red'] = newMarkerData.color.r,
        ['@green'] = newMarkerData.color.g,
        ['@blue'] = newMarkerData.color.b,
        ['@alpha'] = newMarkerData.color.alpha,

        ['@ped'] = newMarkerData.ped.model,
        ['@ped_heading'] = newMarkerData.ped.heading,
    }, function(affectedRows)
        if (affectedRows > 0) then
            local markerData = fullMarkerData[markerId].data
            local markerType = fullMarkerData[markerId].type
            local markerJobName = fullMarkerData[markerId].jobName
            
            fullMarkerData[markerId] = {
                id = markerId,
                label = newMarkerData.label,
                coords = coords,
                minGrade = newMarkerData.minGrade,
                blip = newMarkerData.blip,
                color = newMarkerData.color,
                scale = newMarkerData.scale,
                markerType = newMarkerData.markerType,
                ped = newMarkerData.ped,
                data = markerData,
                type = markerType,
                jobName = markerJobName
            }

            makeAllJobPlayersRefreshMarkers(fullMarkerData[markerId].jobName, function()
                local cbData = {
                    isSuccessful = true,
                    message = "Successful"
                }

                cb(cbData)
            end)
        else
            local cbData = {
                isSuccessful = false,
                message = "Couldn't update the marker"
            }
            cb(cbData)
        end
    end)
end

function updateMarkerData(markerId, data, cb)
    MySQL.Async.execute('UPDATE jobs_data SET data=@data WHERE id=@markerId', {
        ['@markerId'] = markerId,
        ["@data"] = json.encode(data)
    }, function(affectedRows)
        if (affectedRows > 0) then
            fullMarkerData[markerId].data = data

            makeAllJobPlayersRefreshMarkers(fullMarkerData[markerId].jobName, function()
                local cbData = {
                    isSuccessful = true,
                    message = "Successful"
                }

                cb(cbData)
            end)
        else
            local cbData = {
                isSuccessful = false,
                message = "Couldn't update marker data"
            }
            cb(cbData)
        end
    end)
end

function deleteJobMarkers(jobName)
    MySQL.Async.execute('DELETE FROM jobs_data WHERE job_name=@jobName', {
        ['@jobName'] = jobName
    }, function(affectedRows)
        if(affectedRows > 0) then
            for markerId, v in pairs(jobsMarkersIDs) do
                fullMarkerData[markerId] = nil
            end

            jobsMarkersIDs[jobName] = {}
        end
    end)
end

function getMarkerLabel(playerId, cb, markerId)
    cb(fullMarkerData[markerId].label)
end

function playAnimation(playerId, animations)
    if(animations) then
        local randomAnimation = animations[math.random(1, #animations)]

        if(randomAnimation) then
            TriggerClientEvent('esx_job_creator:playAnimation', playerId, randomAnimation)
        end
    end
end

function getSellableStuff(playerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local sellableStuff = {}

    for k, itemData in pairs(xPlayer.getInventory()) do
        if(itemData.count > 0) then
            table.insert(sellableStuff, {
                label = getLocalizedText('job_shop:item', itemData.count, itemData.label),
                value = itemData.name,
                count = itemData.count,
                type = "item_standard"
            })
        end
    end

    for k, weaponData in pairs(xPlayer.getLoadout()) do
        table.insert(sellableStuff, {
            label = weaponData.label,
            value = weaponData.name,
            count = 1,
            type = "item_weapon"
        })
    end

    cb(sellableStuff)
end