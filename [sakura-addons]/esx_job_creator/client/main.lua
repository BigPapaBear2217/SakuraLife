ESX = nil

local markers = {}
local activeMarkers = {}
openedMenu = nil
local areMarkersActive = false
local isProgressbarRunning = false

local markerBlips = {}

local markerPeds = {}

isOnDuty = true

function notifyClient(msg)
    ESX.ShowNotification(msg)
end

RegisterNetEvent("esx_job_creator:openGUI", function() 
    SetNuiFocus(true, true)
    SendNUIMessage({action = "show"})
end)

function askQuantity(title, type, min, max, cb)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), type, {
        title = title,
    }, function (data, menu)
        local quantity = tonumber(data.value)

        if quantity and (not max or quantity <= max) and quantity >= min then
            menu.close()

            cb(quantity)
        else
            notifyClient(getLocalizedText('invalid_quantity'))
        end
    end, function (data, menu)
        menu.close()
        cb(false)
    end)
end

function getRGBFromHex(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function getVehicleNameFromModel(vehicleModel)
    local displayName = GetDisplayNameFromVehicleModel(vehicleModel)
    local labelText = GetLabelText(displayName)

    return (labelText~="NULL" and labelText) or (displayName ~= "CARNOTFOUND" and displayName) or vehicleModel
end

local function saveCurrentSkin()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end

function setClothes(outfit, saveOutfit)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadClothes', skin, outfit)

        if(saveOutfit) then
            saveCurrentSkin()
        end
    end)

--[[
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerEvent('skinchanger:loadClothes', skin, outfit)
    end)
]]
end

local function toggleDuty(markerId)
    isOnDuty = not isOnDuty
    
    TriggerEvent('esx_job_creator:refreshMarkers')
end



local function interact(marker)
    local markerId = marker.id
    local markerType = marker.type

    openedMenu = markerId
    
    if(markerType == "stash") then
        openStash(markerId)
    elseif(markerType == "wardrobe") then
        openWardrobe()
    elseif(markerType == "boss") then
        openBoss(markerId)
    elseif(markerType == "garage") then
        openGarage(markerId)
    elseif(markerType == "shop") then
        openShop(markerId)
    elseif(markerType == "garage_buyable") then
        openGarageBuyable(markerId)
    elseif(markerType == "crafting_table") then
        openCraftingTable(markerId)
    elseif(markerType == "armory") then
        openArmory(markerId)
    elseif(markerType == "job_outfit") then
        openJobOutfit(markerId)
    elseif(markerType == "teleport") then
        openedMenu = nil
        teleportMarker(markerId)
    elseif(markerType == "safe") then
        openSafe(markerId)
    elseif(markerType == "market") then
        openMarket(markerId)
    elseif(markerType == "harvest") then
        openedMenu = nil
        harvestMarker(markerId)
    elseif(markerType == "weapon_upgrader") then
        openOwnedWeapons(markerId)
    elseif(markerType == "duty") then
        openedMenu = nil
        toggleDuty(markerId)
    elseif(markerType == "job_shop") then
        openJobShop(markerId)
    elseif(markerType == "process") then
        processMarker(markerId)
        openedMenu = nil
    elseif(markerType == "garage_owned") then
        openGarageOwned(markerId)
    end
end

local function showMarker(marker)
    Citizen.CreateThread(function()
        local markerId = marker.id

        activeMarkers[markerId] = true

        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        local distance = GetDistanceBetweenCoords(
            plyCoords.x, plyCoords.y, plyCoords.z, 
            marker.coords.x, marker.coords.y, marker.coords.z, 
            true
        )

        Citizen.CreateThread(function()
            local markerType = marker.type
            
            local msg = getLocalizedText("interact")

            if(markerType == "stash") then
                msg = getLocalizedText("open_stash")
            elseif(markerType == "wardrobe") then
                msg = getLocalizedText("open_wardrobe")
            elseif(markerType == "boss") then
                msg = getLocalizedText("open_boss")
            elseif(markerType == "garage") then
                msg = getLocalizedText("open_garage")
            elseif(markerType == "shop") then
                msg = getLocalizedText("open_shop")
            elseif(markerType == "garage_buyable") then
                msg = getLocalizedText('open_garage')
            elseif(markerType == "crafting_table") then
                msg = getLocalizedText('open_crafting_table')
            elseif(markerType == "armory") then
                msg = getLocalizedText('open_armory')
            elseif(markerType == "job_outfit") then
                msg = getLocalizedText('open_job_outfit')
            elseif(markerType == "teleport") then
                msg = getLocalizedText('teleport')

                ESX.TriggerServerCallback('esx_job_creator:getMarkerLabel', function(teleportLabel)
                    if(teleportLabel ~= "Default") then
                        msg = getLocalizedText('teleport_to', teleportLabel)

                        label = teleportLabel
                    end
                end, markerId)

                Citizen.Wait(500)
            elseif(markerType == "safe") then
                msg = getLocalizedText('open_safe')
            elseif(markerType == "market") then
                msg = getLocalizedText('open_market')
            elseif(markerType == "harvest") then
                msg = getLocalizedText('harvest')
            elseif(markerType == "weapon_upgrader") then
                msg = getLocalizedText('open_weapon_upgrader')
            elseif(markerType == "duty") then
                if(isOnDuty) then
                    msg = getLocalizedText('go_off_duty')
                else
                    msg = getLocalizedText('go_on_duty')
                end
            elseif(markerType == "job_shop") then
                msg = getLocalizedText('open_job_shop')
            elseif(markerType == "process") then
                msg = getLocalizedText('process:press_to_process')
            elseif(markerType == "garage_owned") then
                msg = getLocalizedText('garage_owned:press_to_open')
            end

            while distance < config.markerDistance and activeMarkers[markerId] do
                Citizen.Wait(0)
                
                if(not config.use3Dtext) then
                    DrawMarker(marker.markerType, 
                        marker.coords.x, marker.coords.y, marker.coords.z, 
                        0.0, 0.0, 0.0, 
                        0.0, 0.0, 0.0, 
                        marker.scale.x + .0, marker.scale.y + .0, marker.scale.z + .0,
                        marker.color.r, marker.color.g, marker.color.b, marker.color.alpha, 
                        false, false, 2, false, nil, nil, false
                    )
                else
                    ESX.Game.Utils.DrawText3D(vector3(marker.coords.x, marker.coords.y, marker.coords.z + 1.0), marker.label, config.textSize, config.textFont)
                end
                
                if(distance <= marker.scale.x) then
                    if(not openedMenu and not isProgressbarRunning) then
                        ESX.ShowHelpNotification(msg, true)
                        
                        if(IsControlJustReleased(0, 38)) then
                            interact(marker)
                        end
                    end
                elseif(openedMenu == markerId) then
                    openedMenu = nil
                    ESX.UI.Menu.CloseAll()
                end
            end
        end)

        while distance < config.markerDistance and activeMarkers[markerId] do
            plyPed = PlayerPedId()
            plyCoords = GetEntityCoords(plyPed)

            distance = GetDistanceBetweenCoords(
                plyCoords.x, plyCoords.y, plyCoords.z, 
                marker.coords.x, marker.coords.y, marker.coords.z, 
                true
            ) 

            Citizen.Wait(500)
        end

        activeMarkers[markerId] = false
    end)
end

local function setPedImmutable(ped)
    SetPedRelationshipGroupHash(ped, GetHashKey("AMBIENT_GANG_FAMILY"))
    local plyRelationship = GetPedRelationshipGroupHash(PlayerPedId())

    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), plyRelationship)
    SetRelationshipBetweenGroups(1, plyRelationship, GetHashKey("AMBIENT_GANG_FAMILY"))

    SetEntityInvincible(ped)
    FreezeEntityPosition(ped, true)
    SetPedConfigFlag(ped, 24, true)
    SetPedConfigFlag(ped, 43, true)
    SetPedConfigFlag(ped, 122, true)
    SetPedConfigFlag(ped, 128, false)
    SetPedConfigFlag(ped, 188, true)
    DisablePedPainAudio(ped, true)
    SetCanAttackFriendly(ped, false, false)

    SetPedRagdollOnCollision(ped, false)
    SetRagdollBlockingFlags(ped, 1)
    SetEntityInvincible(ped, true)

    SetBlockingOfNonTemporaryEvents(ped, true)
end

local function spawnPed(markerData)
    markerPeds[markerData.id] = true

    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)

        local timeout = GetGameTimer() + 5000

        while not HasModelLoaded(markerData.ped.model) do
            Citizen.Wait(0)
            RequestModel(markerData.ped.model)

            if(GetGameTimer() > timeout) then
                return
            end
        end

        local ped = CreatePed(1, markerData.ped.model, markerData.coords.x, markerData.coords.y, markerData.coords.z, markerData.ped.heading + .0, false, false)

        markerPeds[markerData.id] = ped

        setPedImmutable(ped)

        local coords = vector3(markerData.coords.x, markerData.coords.y, markerData.coords.z)

        local distance = #(plyCoords - coords)
        
        while distance < 50.0 do
            plyCoords = GetEntityCoords(plyPed)
            distance = #(plyCoords - coords)

            Citizen.Wait(2000)
        end

        DeleteEntity(ped)

        markerPeds[markerData.id] = nil
    end)
end

local function activateMarkers()
    if areMarkersActive then
        return
    else
        areMarkersActive = true
    end
    
    Citizen.CreateThread(function() 
        while true do
            local plyPed = PlayerPedId()
            local plyPos = GetEntityCoords(plyPed)

            for k, marker in pairs(markers) do
                if(marker.coords and type(marker.coords) ~= "table") then
                    marker.coords = json.decode(marker.coords)
                end

                local distance = GetDistanceBetweenCoords(plyPos, marker.coords.x, marker.coords.y, marker.coords.z, true)

                if(distance < 50.0 and (marker.ped and marker.ped.model) and not markerPeds[marker.id]) then
                    spawnPed(marker)
                end
                
                if(distance < config.markerDistance + .0) then
                    if(not activeMarkers[marker.id]) then
                        showMarker(marker)
                    end
                end
            end

            Citizen.Wait(2000)
        end
    end)
end

local function getMarkers(cb)
    ESX.TriggerServerCallback('esx_job_creator:getMarkers', function(markersData)
        for k, blip in pairs(markerBlips) do
            if(DoesBlipExist(blip)) then
                RemoveBlip(blip)
            end
        end

        for markerId, markerData in pairs(markersData) do
            local isThisMarkerEnabled = isOnDuty or markerData.type == "duty" or markerData.jobName == "public_marker"

            if(not isThisMarkerEnabled) then
                markersData[markerId] = nil
            end
            
            if(markerData.blip.spriteId and isThisMarkerEnabled) then
                local coords = markerData.coords
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

                SetBlipSprite(blip, markerData.blip.spriteId)
                SetBlipDisplay(blip, 4)
                SetBlipAsShortRange(blip, true)
                SetBlipColour(blip, markerData.blip.color)
                SetBlipScale(blip, markerData.blip.scale + .0)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(markerData.label)
                EndTextCommandSetBlipName(blip)

                table.insert(markerBlips, blip)
            end
        end
        cb(markersData)
    end)
end

function stripCoords(oldCoords)
    local x, y, z = table.unpack(oldCoords)

    if(not x or not y or not z) then
        x, y, z = oldCoords.x, oldCoords.y, oldCoords.z
    end

    local newCoords = {
        x = tonumber(ESX.Math.Round(x, 2)),
        y = tonumber(ESX.Math.Round(y, 2)),
        z = tonumber(ESX.Math.Round(z, 2))
    }

    return newCoords
end

RegisterNetEvent('esx_job_creator:refreshMarkers')
AddEventHandler('esx_job_creator:refreshMarkers', function() 
    getMarkers(function(markersData)
        markers = markersData
        activeMarkers = {}

        for markerId, ped in pairs(markerPeds) do
            if(DoesEntityExist(ped)) then
                DeleteEntity(ped)
            end
        end

        markerPeds = {}

        openedMenu = nil
        areMarkersActive = false

        ESX.UI.Menu.CloseAll()
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    getMarkers(function(markersData) 
        markers = markersData
        activateMarkers()
    end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    TriggerEvent('esx_job_creator:refreshMarkers')
end)

function startProgressBar(time, text)
    Citizen.CreateThread(function()     
        isProgressbarRunning = true
    
        SendNUIMessage({action = "progressBar", time = time, text = text})
    
        Citizen.Wait(time)
    
        isProgressbarRunning = false
    end)
end
RegisterNetEvent('esx_job_creator:startProgressBar', startProgressBar)

local function playAnimation(animationData)
    local plyPed = PlayerPedId()

    if(animationData.type == "scenario") then
        TaskStartScenarioInPlace(plyPed, animationData.scenarioName, 0, true)

        Citizen.Wait(animationData.scenarioDuration * 1000)

        ClearPedTasks(plyPed)

        local plyCoords = GetEntityCoords(plyPed)

        ClearAreaOfObjects(plyCoords, 2.0, 0)
    elseif(animationData.type == "animation") then
        while not HasAnimDictLoaded(animationData.animDict) do
            RequestAnimDict(animationData.animDict)
            Citizen.Wait(0)
        end

        local duration = animationData.animDuration * 1000

        TaskPlayAnim(plyPed, animationData.animDict, animationData.animName, 4.0, 4.0, duration, 1, 1.0, 0, 0, 0)

        Citizen.Wait(duration)

        ClearPedTasks(plyPed)
    end
end
RegisterNetEvent('esx_job_creator:playAnimation', playAnimation)

RegisterNetEvent('esx_job_creator:esx:ready', function()
    getMarkers(function(markersData) 
        markers = markersData
        activateMarkers()
    end)
end)

RegisterNetEvent('esx_job_creator:notAllowed')
AddEventHandler('esx_job_creator:notAllowed', function(acePermission, license, steamId)
    SendNUIMessage({
        action = "notAllowed",
        license = license,
        steamId = steamId,
        acePermission = acePermission,
    })
    
    SetNuiFocus(true, true)
end)

-- Setup ESX on script start
Citizen.CreateThread(setupESX)