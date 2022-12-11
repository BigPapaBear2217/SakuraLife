-- [[ Utils ]]
RegisterNUICallback("refresh-jobs", function(data, cb)    
    TriggerServerEvent('esx_job_creator:refresh_esx_jobs')
end)

RegisterNUICallback("get-current-coords", function(data, cb)
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed) - vector3(0.0, 0.0, 1.0)

    local plyHeading = string.format("%.2f", GetEntityHeading(plyPed))

    local newCoords = stripCoords(plyCoords)
    
    cb({coords = newCoords, heading = plyHeading})
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false)
end)

--[[ Ranks stuff ]] 
RegisterNUICallback("create-new-rank", function(data, cb)
    local jobName = data.jobName
    local rankName = data.rankName
    local rankLabel = data.rankLabel
    local rankGrade = data.rankGrade
    local rankSalary = data.rankSalary

    ESX.TriggerServerCallback('esx_job_creator:createRank', function(data)
        cb(data)
    end, jobName, rankName, rankLabel, rankGrade, rankSalary)
end)

RegisterNUICallback("update-rank", function(data, cb)
    ESX.TriggerServerCallback('esx_job_creator:updateRank', function(data)
        cb(data)
    end, data)
end)

RegisterNUICallback("delete-rank", function(data, cb)
    local rankId = data.rankId

    ESX.TriggerServerCallback('esx_job_creator:deleteRank', function(data)
        cb(data)
    end, rankId)
end)

RegisterNUICallback("retrieve-job-ranks", function(data, cb)
    local jobName = data.jobName
    ESX.TriggerServerCallback('esx_job_creator:retrieveJobRanks', function(ranks)
        cb(ranks)
    end, jobName)
end)

-- [[ Jobs stuff ]]
RegisterNUICallback("create-new-job", function(data, cb)
    if(data) then
        ESX.TriggerServerCallback('esx_job_creator:createNewJob', function(data)
            cb(data)
        end, data.jobName, data.jobLabel)
    end
end)

RegisterNUICallback("update-job", function(data, cb)
    local oldJobName = data.oldJobName
    local newJobName = data.jobName
    local label = data.jobLabel
    local whitelisted = data.whitelisted

    local actions = {
        enableBilling = data.enableBilling,
        canRob = data.canRob,
        canHandcuff = data.canHandcuff,
        canLockpickCars = data.canLockpickCars,
        canWashVehicles = data.canWashVehicles,
        canRepairVehicles = data.canRepairVehicles,
        canImpoundVehicles = data.canImpoundVehicles,
        canCheckIdentity = data.canCheckIdentity,
        canCheckVehicleOwner = data.canCheckVehicleOwner,
        canCheckDrivingLicense = data.canCheckDrivingLicense,
        canCheckWeaponLicense = data.canCheckWeaponLicense
    }
    
    ESX.TriggerServerCallback('esx_job_creator:updateJob', function(data)
        cb(data)
    end, oldJobName, newJobName, label, whitelisted, actions)
end)

RegisterNUICallback("delete-job", function(data, cb)
    local jobName = data.jobName

    if(jobName) then
        ESX.TriggerServerCallback('esx_job_creator:deleteJob', function(data)
            cb(data)
        end, jobName)
    end
end)

RegisterNUICallback("get-jobs-data", function(data, cb)
    ESX.TriggerServerCallback('esx_job_creator:getJobsData', function(jobsData)
        cb(jobsData)
    end)
end)

-- [[ Markers Stuff ]]
RegisterNUICallback("retrieve-job-markers", function(data, cb)
    local jobName = data.jobName

    if(jobName) then
        ESX.TriggerServerCallback('esx_job_creator:getMarkersFromJobName', function(markers)
            cb(json.encode(markers))
        end, jobName)
    end
end)

RegisterNUICallback("create-marker", function(data, cb)
    if(data) then
        local jobName = data.jobName
        local label = data.label
        local type = data.markerType
        local coords = {x = tonumber(data.markerCoordsX), y = tonumber(data.markerCoordsY), z = tonumber(data.markerCoordsZ)}
        local minGrade = tonumber(data.markerMinGrade)

        ESX.TriggerServerCallback('esx_job_creator:createMarker', function(data)
            cb(data)
        end, jobName, label, type, coords, minGrade)
    end
end)

RegisterNUICallback("create-public-marker", function(data, cb)
    if(data) then
        local jobName = "public_marker"
        local minGrade = 0
        local label = data.label
        local type = data.markerType
        local coords = {x = tonumber(data.markerCoordsX), y = tonumber(data.markerCoordsY), z = tonumber(data.markerCoordsZ)}

        ESX.TriggerServerCallback('esx_job_creator:createMarker', function(data)
            cb(data)
        end, jobName, label, type, coords, minGrade)
    end
end)

RegisterNUICallback("update-marker", function(data, cb)
    if(data) then
        local markerId = data.markerId

        ESX.TriggerServerCallback('esx_job_creator:updateMarker', function(data)
            cb(data)
        end, markerId, data)
    end
end)

RegisterNUICallback("update-marker-data", function(data, cb)    
    local markerId = data.markerId
    local markerData = data.markerData

    ESX.TriggerServerCallback('esx_job_creator:updateMarkerData', function(data)
        cb(data)
    end, markerId, markerData)
end)

RegisterNUICallback("delete-marker", function(data, cb)
    local markerId = data.markerId
    ESX.TriggerServerCallback('esx_job_creator:deleteMarker', function(data)
        cb(data)
    end, markerId)
end)


-- [[ Stash stuff ]]
RegisterNUICallback("delete-stash-inventory", function(data, cb)    
    local markerId = data.markerId

    ESX.TriggerServerCallback('esx_job_creator:deleteStashInventory', function(data)
        cb(data)
    end, markerId)
end)

-- [[ Armory Stuff ]]
RegisterNUICallback('delete-armory-inventory', function(data, cb)
    local markerId = data.markerId

    ESX.TriggerServerCallback('esx_job_creator:deleteArmoryInventory', function(data)
        cb(data)
    end, markerId)
end)

-- [[ Job outfit stuff ]]
RegisterNUICallback('get-current-outfit', function(data, cb)
    TriggerEvent('skinchanger:getSkin', function(skin)
        cb(skin)
    end)
end)

-- [[ Garage stuff ]]
RegisterNUICallback('get-vehicle-label', function(data, cb)
    cb(getVehicleNameFromModel(data.vehicleModel))
end)