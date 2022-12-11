local annoucement_queue = {}

RegisterNetEvent('bloodline-announce:annouce')
AddEventHandler('bloodline-announce:annouce', function(message)
    table.insert(annoucement_queue, message)

    if #annoucement_queue <= 1 then
        --PlaySoundFrontend(-1, "Dropped", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 1)
        PlaySoundFrontend(-1, "Exit_Capture_Zone", "DLC_Apartments_Drop_Zone_Sounds", 50)
        pushAnnoucement()
    end
end)

function pushAnnoucement()
    local message = annoucement_queue[1]

    SendNUIMessage({
        action = 'annouce',
        message = message
    })

    Citizen.Wait(10000)
    SendNUIMessage({ action = 'close' })
    table.remove(annoucement_queue, 1)

    if #annoucement_queue > 0 then
        Citizen.SetTimeout(1000, function()
            pushAnnoucement()
        end)
    end
end