local isHarvesting = false

function harvestMarker(markerId)
    if(isHarvesting) then return end

    isHarvesting = true

    TriggerServerEvent('esx_job_creator:harvestMarkerId', markerId)
    
    if(not config.allowAfkFarming) then return end

    Citizen.CreateThread(function()
        local msg = getLocalizedText('harvest:press_to_stop')

        while isHarvesting do
            Citizen.Wait(0)

            ESX.ShowHelpNotification(msg, true, false)

            if(IsControlJustReleased(0, 38)) then
                isHarvesting = false
                
                notifyClient(getLocalizedText("harvest:you_will_stop_on_finish"))
            end
        end
    end)
end

local function finishedHarvesting(markerId, canContinue)
    if(isHarvesting and canContinue) then
        TriggerServerEvent('esx_job_creator:harvestMarkerId', markerId)
    elseif(not canContinue) then
        isHarvesting = false
    end
end

RegisterNetEvent("esx_job_creator:harvest:finishedHarvesting", finishedHarvesting)