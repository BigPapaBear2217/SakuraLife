RegisterNetEvent("SendAlert")
AddEventHandler("SendAlert", function(msg, msg2)
    SendNUIMessage({
        type    = "alert",
        enable  = true,
        issuer  = msg,
        message = msg2,
        volume  = Config.EAS.Volume
    })
end)

RegisterNetEvent("alert:Send")
AddEventHandler("alert:Send", function(msg)
    DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 600)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    
    if (GetOnscreenKeyboardResult()) then
        local msg2 = GetOnscreenKeyboardResult()
        TriggerServerEvent("alert:sv", "LSPD", "PURGE AB JETZT FFA!")
        SendAlert("LSPD", "PURGE AB JETZT FFA!")
    end
end)


RegisterNetEvent("alert:test")
AddEventHandler("alert:test", function()
    local playerPed = PlayerPedId()

    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)