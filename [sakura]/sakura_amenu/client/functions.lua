--NoClip
local noClipEnabled = false
local freecamVeh = 0
ADMIN.ToggleNoclip = function(enabled)
    noClipEnabled = enabled
    local ped = PlayerPedId()
    SetEntityVisible(ped, not enabled)

    if ADMIN.Player.godMode == false then
        SetPlayerInvincible(ped, noClipEnabled)
        SetEntityInvincible(ped, noClipEnabled)
    end

    FreezeEntityPosition(ped, enabled)
    
    if enabled then
        freecamVeh = GetVehiclePedIsIn(ped, false)
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "noclip", "**Aktiviert** :white_check_mark:")
        
        if freecamVeh > 0 then
            NetworkSetEntityInvisibleToNetwork(freecamVeh, true)
            SetEntityCollision(freecamVeh, false, false)
        end
    else
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "noclip", "**Deaktiviert** :x:")
    end

    local function enableNoClip()
        lastTpCoords = GetEntityCoords(ped)

        SetFreecamActive(true)
        StartFreecamThread()

        Citizen.CreateThread(function()
            while IsFreecamActive() do
                SetEntityLocallyInvisible(ped)
                if freecamVeh > 0 then
                    if DoesEntityExist(freecamVeh) then
                        SetEntityLocallyInvisible(freecamVeh)
                    else
                        freecamVeh = 0
                    end
                end
                Wait(0)
            end
            
            if not DoesEntityExist(freecamVeh) then
                freecamVeh = 0
            end

            if freecamVeh > 0 then
                local coords = GetEntityCoords(ped)
                NetworkSetEntityInvisibleToNetwork(freecamVeh, false)
                SetEntityCollision(freecamVeh, true, true)
                SetEntityCoords(freecamVeh, coords[1], coords[2], coords[3])
                SetPedIntoVehicle(ped, freecamVeh, -1)
                freecamVeh = 0
            end
        end)
    end

    local function disableNoClip()
        SetFreecamActive(false)
        SetGameplayCamRelativeHeading(0)
    end

    if not IsFreecamActive() and enabled then
        enableNoClip()
    end

    if IsFreecamActive() and not enabled then
        disableNoClip()
    end
end


ADMIN.ToggleGodMode = function(enabled) 
end

ADMIN.ToggleVanish = function(enabled) 
    if enabled then
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "vanish", "**Aktiviert** :white_check_mark:")
    else
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "vanish", "**Deaktiviert** :x:")
    end

    SetEntityVisible(GetPlayerPed(-1), enabled, enabled)
end

ADMIN.ToggleAduty = function(enabled)
    local playerPed = PlayerPedId()
    local isGodMode = false

    if enabled then
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "aduty", "**Aktiviert** :white_check_mark:")
    else
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "aduty", "**Deaktiviert** :x:")
    end
    
    if enabled then
        TriggerEvent('skinchanger:getSkin', function(skin)
            ESX.TriggerServerCallback("ot-admin:getGroup", function(group)
                for k, v in pairs(Config.AdminDuty) do
                    print(k)
                    if k == group then
                        if skin.sex == 0 then
                            TriggerEvent("skinchanger:loadClothes", skin, v.male)
                        else
                            TriggerEvent("skinchanger:loadClothes", skin, v.female)
                        end
                    end
                end
            end)
        end)
    else 
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
end

local function SetGodMode(isGodMode)
    if enable then
        TriggerEvent("ot-notify:notify", "#ff0000", "Aktiviert", 'God Mode wurde aktiviert')
            SetEntityInvincible(GetPlayerPed(-1), true)
            SetPlayerInvincible(PlayerId(), true)
            SetPedCanRagdoll(GetPlayerPed(-1), false)
            ClearPedBloodDamage(GetPlayerPed(-1))
            ResetPedVisibleDamage(GetPlayerPed(-1))
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
            SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
            SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
            SetEntityCanBeDamaged(GetPlayerPed(-1), false)
    else
        TriggerEvent("ot-notify:notify", "#ff0000", "Deaktiviert", 'God Mode wurde deaktiviert')
            SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
            SetEntityCanBeDamaged(GetPlayerPed(-1), true)
    end
end

ADMIN.ToggleCoords = function(enabled) 
    if enabled then
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "coords", "**Aktiviert** :white_check_mark:")
    else
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "coords", "**Deaktiviert** :x:")
    end

    Citizen.CreateThread(function()
        while ADMIN.Player.coords do
            Citizen.Wait(0)
            
            plyPed = GetPlayerPed(-1)
            local plyCoords = GetEntityCoords(plyPed, false)
            
            roundx = tonumber(string.format("%.2f", plyCoords.x))
            roundy = tonumber(string.format("%.2f", plyCoords.y))
            roundz = tonumber(string.format("%.2f", plyCoords.z))
            roundheading = tonumber(string.format("%.2f", GetEntityHeading(plyPed)))
            
            Text('~r~X~s~: ' .. roundx .. ' ~r~Y~s~: ' .. roundy .. ' ~r~Z~s~: ' .. roundz .. ' ~r~Angle~s~: ' .. roundheading)
        end
    end)
end

local visibleNametags = {}
ADMIN.ToggleNametags = function(enabled) 
    if enabled then
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "nametags", "**Aktiviert** :white_check_mark:")
    else
        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "nametags", "**Deaktiviert** :x:")
    end

    if not enabled then
        for k, v in pairs(visibleNametags) do
            RemoveMpGamerTag(v)
            visibleNametags[k] = nil
        end
    end
    
    Citizen.CreateThread(function()
        while ADMIN.Player.nametags do
            Citizen.Wait(0)
            
            plyPed = GetPlayerPed(-1)
            for k, v in ipairs(ESX.Game.GetPlayers()) do
                local otherPed = GetPlayerPed(v)

                --if otherPed ~= plyPed then
                if #(GetEntityCoords(plyPed, false) - GetEntityCoords(otherPed, false)) < 1000.0 then
                    visibleNametags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
                else
                    RemoveMpGamerTag(visibleNametags[v])
                    visibleNametags[v] = nil
                end
            end
        end
    end)
end

function Text(text)
	SetTextColour(255, 255, 255, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(5, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.00, 0.00)
end

--[[Citizen.CreateThread(function()
    while ADMIN.Player do
        Citizen.Wait(0)
    end
end)

--Old NoClip
ADMIN.ToggleNoClip = function(enabled)
    ADMIN.Player.noclip = enabled

    while ADMIN.Player.noclip do
        Citizen.Wait(0)

        if IsControlPressed(1, 209) then
            clipSpeed = clipSpeed + 2.5
        end

        local plyCoords = GetEntityCoords(plyPed, false)
        local camCoords = getCamDirection()
        SetEntityVelocity(plyPed, 0.00, 0.00, 0.00)

        if IsControlPressed(0, 32) then
            plyCoords = plyCoords + (clipSpeed * camCoords)
        end

        if IsControlPressed(0, 269) then
            plyCoords = plyCoords - (clipSpeed * camCoords)
        end

        SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)
    end
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
    local pitch = GetGameplayCamRelativePitch()
    local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
    local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

    if len ~= 0 then
        coords = coords / len
    end

    return coords
end--]]