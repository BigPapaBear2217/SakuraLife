local function checkIdentity()
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    local closestTarget, closestDist = ESX.Game.GetClosestPlayer(plyCoords)

    if(closestTarget ~= -1 and closestDist < 3.0) then
        if(config.useJSFourIdCard) then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestTarget), GetPlayerServerId(PlayerId()))
            ESX.UI.Menu.CloseAll()
        else
            TriggerServerEvent("esx_job_creator:actions:checkIdentity", GetPlayerServerId(closestTarget))
        end
    else
        notifyClient(getLocalizedText('actions:no_player_found'))
    end
end
RegisterNetEvent('esx_job_creator:actions:checkIdentity', checkIdentity)