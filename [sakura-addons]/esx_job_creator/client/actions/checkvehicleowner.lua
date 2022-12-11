local timeToCheck = 6000

local objName = "prop_cs_tablet"

local animDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local animName = "base"

local function checkVehicleOwner()
    local plyPed = PlayerPedId()

    local plyCoords = GetEntityCoords(plyPed)

    local closestVeh, closestDist = ESX.Game.GetClosestVehicle(plyCoords)

    if(closestDist < 3.0) then
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
            RequestAnimDict(animDict)
        end
    
        while not HasModelLoaded(objName) do
            Citizen.Wait(0)
            RequestModel(objName)
        end
    
        local obj = CreateObject(objName, 0.0, 0.0, 0.0, true, true, false)
        local boneIndex = GetPedBoneIndex(plyPed, 60309)
    
        SetCurrentPedWeapon(plyPed, "WEAPON_UNARMED", true)
    
        AttachEntityToEntity(obj, plyPed, boneIndex, vector3(0.03, 0.002, 0.0), vector3(10.0, 160.0, 0.0), true, false, false, false, 2, true)
    
        SetModelAsNoLongerNeeded(objName)
    
        TaskPlayAnim(plyPed, animDict, animName, 4.0, -4.0, timeToCheck, 16, 0, false, false, false)
    
        Citizen.Wait(timeToCheck)
    
        DeleteObject(obj)
        
        local plate = GetVehicleNumberPlateText(closestVeh)
        
        TriggerServerEvent('esx_job_creator:actions:getVehicleOwner', plate)
    else
        notifyClient(getLocalizedText("actions:checkVehicleOwner:car_not_found"))
    end
end
RegisterNetEvent('esx_job_creator:actions:checkVehicleOwner', checkVehicleOwner)