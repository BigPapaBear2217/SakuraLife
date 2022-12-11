local isProcessing = false

function processMarker(markerId)
    if(isProcessing) then return end

    isProcessing = true

    TriggerServerEvent('esx_job_creator:process:startProcessing', markerId)

    Citizen.CreateThread(function()
        local msg = getLocalizedText('process:press_to_stop')

        while isProcessing do
            Citizen.Wait(0)

            ESX.ShowHelpNotification(msg, true, false)

            if(IsControlJustReleased(0, 38)) then
                isProcessing = false
                
                notifyClient(getLocalizedText("process:you_will_stop_on_finish"))
            end
        end
    end)
end

local function finishedProcessing(markerId, canContinue)
    if(isProcessing and canContinue) then
        TriggerServerEvent('esx_job_creator:process:startProcessing', markerId)
    elseif(not canContinue) then
        isProcessing = false
    end
end

RegisterNetEvent("esx_job_creator:process:finishedProcessing", finishedProcessing)