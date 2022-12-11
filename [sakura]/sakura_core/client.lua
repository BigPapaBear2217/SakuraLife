Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)


BlacklistedWeapons = { 
    "WEAPON_SNIPERRIFLE", 
    "WEAPON_PUMPSHOTGUN", 
    --"WEAPON_ASSAULTRIFLE", 
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		
        for k,v in ipairs(BlacklistedWeapons) do
			Citizen.Wait(1)

            SetWeaponDamageModifierThisFrame(GetHashKey(v), 0.0)

            if HasPedGotWeapon(PlayerPedId(),GetHashKey(v),false) == 1 then
				RemoveWeaponFromPed(PlayerPedId(),GetHashKey(v))
			end
		end
	end
end)

local specStretch = false
--[[Citizen.CreateThread(function()
    if GetIsWidescreen() == false then
        notifyStretched()
        Citizen.Wait(30000)
        
        specStretch = true
        kickStretch()
    end
end)]]

function notifyStretched()
    if GetIsWidescreen() == false then
        TriggerEvent('ot-notify:notify', "", "Anti-Stretched", "Bitte deaktiviere deinen Strech-Screen und verwende 16:9!")
        TriggerEvent('ot-notify:notify', "", "Anti-Stretched", "Falls nicht, wirst du innerhalb von 30 Sekunden gekickt.")
    end
end

function kickStretch()
    --[[if GetIsWidescreen() == false then
        TriggerServerEvent('kidu:notify')
    end]]
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if GetIsWidescreen() == false and specStretch then
            TriggerServerEvent('kidu:notify')
        end
    end
end)

--Logo on screen
AddEventHandler('onClientMapStart', function()
    Citizen.CreateThread(function()
        TriggerEvent(Triggers.displayLogoTrigger, true)
    end)
end)

--fix clear
--[[RegisterNetEvent('shesh')
AddEventHandler('shesh', function()
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)]]



RegisterNetEvent('fixv')
AddEventHandler('fixv', function()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		TriggerEvent('ot-notify:notify', "#bb0000", "SakuraLife-Core", "Dein Fahrzeug wurde repariert!")
	else
		TriggerEvent('ot-notify:notify', "#bb0000", "SakuraLife-Core", "Du musst in einem Fahrzeug sitzen um es zu reparieren!")
	end
end)

RegisterNetEvent('clearv')
AddEventHandler('clearv', function()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDirtLevel(vehicle, 0)
        TriggerEvent('ot-notify:notify', "#bb0000", "SakuraLife-Core", "Dein Fahrzeug wurde gesäubert!")
	else
        TriggerEvent('ot-notify:notify', "#bb0000", "SakuraLife-Core", "Du musst in einem Fahrzeug sitzen um es zu säubern!")
	end
end)
--fix clear


--Shuff
local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		disableSeatShuffle(false)
		Citizen.Wait(5000)
		disableSeatShuffle(true)
	else
		CancelEvent()
	end
end)

RegisterCommand("gangster", function(source, args, raw) --change command here
    ESX.TriggerServerCallback("SakuraLife:fetchUserRank", function(playerRank)
        if playerRank ~= "superadmin" then
            return
        end

        if args[1] == "default" then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                local isMale = skin.sex == 0


                TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                        TriggerEvent('esx:restoreLoadout')
             
                
                end)
                end)
                end)
        end

        local j1 = PlayerId()
        local p1 = GetHashKey(args[1])

        RequestModel(p1)
            
        while not HasModelLoaded(p1) do
            Wait(100)
        end

        SetPlayerModel(j1, p1)
        SetModelAsNoLongerNeeded(p1)
    end)
end, false) --False, allow everyone to run it

RegisterCommand("shuff", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false) --False, allow everyone to run it

RegisterCommand("tc", function(source, args, raw) --change command here
    ESX.TriggerServerCallback("SakuraLife:fetchUserRank", function(playerRank)
        if playerRank ~= "user" then
            TriggerServerEvent('ot-notify:tc', "TeamChat", table.concat(args, ' '))
        end
    end)
end, false) --False, allow everyone to run it


local Playersss = {}
RegisterCommand("support", function(source, args, raw) --change command here
    dos(source, args)
end, false) --False, allow everyone to run it

RegisterCommand("assist", function(source, args, raw) --change command here
    dos(source, args)
end, false) --False, allow everyone to run it

RegisterCommand("calladmin", function(source, args, raw) --change command here
    dos(source, args)
end, false) --False, allow everyone to run it

RegisterCommand("help", function(source, args, raw) --change command here
    dos(source, args)
end, false) --False, allow everyone to run it

function dos(source, args) 
    if not Playersss[source] then
        Playersss[source] = '1'
        if args[1] == nil then
            TriggerEvent('ot-notify:notify', "#bb0000", "Support Anfrage", "Bitte verwende: /support GRUND")
        else
            TriggerServerEvent('ot-notify:support', table.concat(args, ' '))
        end   
        Wait(60000)
        Playersss[source] = nil
    else
        TriggerEvent('ot-notify:notify', "#bb0000", "Support Anfrage", "Bitte warte eine Minute bevor du eine Support Anfrage erneut stellst!")
    end 
end

--TPM
local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end
end)

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

--[[Citizen.CreateThread(function()
    blip = AddBlipForCoord(-1386.93, -588.19, 30.32)

    SetBlipSprite(blip, 614)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 48)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cube")
    EndTextCommandSetBlipName(blip)
end)]]

--[[Citizen.CreateThread(function()
    blip = AddBlipForCoord(-1194.07, -1728.48, 4.44)

    SetBlipSprite(blip, 523)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.4)
    SetBlipColour(blip, 48)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Import Händler")
    EndTextCommandSetBlipName(blip)
end)]]

Citizen.CreateThread(function()
    blip = AddBlipForCoord(129.246,-1299.363,29.501)

    SetBlipSprite(blip, 121)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 27)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Unicorn")
    EndTextCommandSetBlipName(blip)
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("SakuraLife:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

            if waypointCoords["x"] ~= nil then
                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end

                TriggerEvent("ot-notify:notify", "#db2a91", "SakuraLife-Core", "Du wurdest zu deinem Wegpunkt teleportiert.")
            else
                TriggerEvent("ot-notify:notify", "#db2a91", "SakuraLife-Core", "Du musst einen Wegpunkt setzen bevor du dich teleportieren kannst!")
            end
        else
            TriggerEvent("ot-notify:notify", "#db2a91", "SakuraLife-Core", "Dazu hast du keine Rechte!")
        end
    end)
end
--TPM

RegisterNetEvent(Triggers.displayLogoTrigger)
AddEventHandler(Triggers.displayLogoTrigger, function(value)
    SendNUIMessage({
      type = "logo",
      display = value
    })
end)

--Anti Waffenschlag
Citizen.CreateThread(function()
    Citizen.Wait(0)
    if IsPedArmed(GetPlayerPed(-1), 6) then
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
    end
end)

--Hud Title/Color | Hide GTAV Hud's
Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO', 'SakuraLife ROLEPLAY')

    while true do 
        Citizen.Wait(0)
        HideHudComponentThisFrame(3) -- CASH
        HideHudComponentThisFrame(4) -- MP CASH
        HideHudComponentThisFrame(2) -- weapon icon
        HideHudComponentThisFrame(9) -- STREET NAME
        HideHudComponentThisFrame(7) -- Area NAME
        HideHudComponentThisFrame(8) -- Vehicle Class
        HideHudComponentThisFrame(6) -- Vehicle Name
    end
end)

--Hud Title
function AddTextEntry(key, value)
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

--Hud Title/Color
Citizen.CreateThread(function()
    while true do
        SetDiscordAppId(855074464874364958)
        
        SetDiscordRichPresenceAsset('blutlinie')     
        SetDiscordRichPresenceAssetText('connect play.SakuraLife.cc')
        
        ---SetDiscordRichPresenceAssetSmall('logo')
        ---SetDiscordRichPresenceAssetSmallText('discord.gg/bl-rp')
        
        SetDiscordRichPresenceAction(0, "FiveM", "fivem://connect/play.SakuraLife.cc")
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.com/invite/bl-rp")
        
        ESX.TriggerServerCallback('SakuraLife:getPlayers', function(count)
            Citizen.Wait(100)
            SetRichPresence(GetPlayerName(PlayerId()) .. " | " .. count .. "/512" .. " | ID: " .. GetPlayerServerId(PlayerId()))
        end)
        
        --SetRichPresence(string.format("%s | %s/%s", GetPlayerName(PlayerId()), onlinePlayers, "512"))
        Citizen.Wait(60000)
	end
end)

--Open Player Inventory
function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}

		table.insert(elements, {label = "--- Waffen ---"})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = "Konfisziert ".. ESX.GetWeaponLabel(data.weapons[i].name) .. " mit "..  data.weapons[i].ammo .." Schuss",
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = "--- Inventar ---"})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = "Konfeziere " .. data.inventory[i].count .. "x " .. data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = "Durchsuchen",
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('SakuraLife:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

--Confiscate Trigger
RegisterNetEvent(Triggers.durchsuchenTrigger)
AddEventHandler(Triggers.durchsuchenTrigger, function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local closestPed = GetPlayerPed(closestPlayer)
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		if IsEntityPlayingAnim(closestPed, "anim@move_m@prisoner_cuffed", "idle", 49) then
            OpenBodySearchMenu(closestPlayer)
			TriggerEvent(Triggers.notificationTrigger, "#db2a91", "SakuraLife", 'Du durchsuchst die Person vor dir')
            print(closestPlayer)
		else
			TriggerEvent(Triggers.notificationTrigger, "#db2a91", "SakuraLife", 'Die Person vor dir ist nicht Gefesselt.')
		end
	else
		TriggerEvent(Triggers.notificationTrigger, "#db2a91", "SakuraLife", 'Es ist keine Person vor dir.')
	end
end)

--Handsup
local handsUp = false
local pointing = false	
Citizen.CreateThread(function()
    local animDictionary = "missminuteman_1ig_2"
    
	
    while not HasAnimDictLoaded(animDictionary) do
        RequestAnimDict(animDictionary)
		Citizen.Wait(100)
	end
    
	while true do
        local playerPed = GetPlayerPed(-1)
        
		if IsControlJustPressed(1, 74) then
            if not IsPedInAnyVehicle(playerPed, false) then
                if not handsUp then
                    TaskPlayAnim(playerPed, animDictionary, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                    handsUp = true
                else
                    handsUp = false
                    ClearPedTasks(playerPed)
                end
            end
        end

        Citizen.Wait(0)
    end
end)

--DV
RegisterCommand('dvr', function(source, args)
    ESX.TriggerServerCallback("SakuraLife:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" then
            if args[1] and tonumber(args[1]) then
                args[1] = tonumber(args[1]) + 0.01

                local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(PlayerPedId()), args[1])
        
                for k,entity in ipairs(vehicles) do
                    local attempt = 0
        
                    while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
                        Citizen.Wait(100)
                        NetworkRequestControlOfEntity(entity)
                        attempt = attempt + 1
                    end
        
                    if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
                        ESX.Game.DeleteVehicle(entity)
                    end
                end
            else
                print('nö')
            end
        end
    end)
end)

RegisterNetEvent('SakuraLife-core:pedChecked')
AddEventHandler("SakuraLife-core:pedChecked", function()
    local pedIsAllowed = true
end)

RegisterNetEvent('SakuraLife-core:spielerMenu')
AddEventHandler("SakuraLife-core:spielerMenu", function()
    local players = 0
    local cops    = 0
    local medics  = 0
    local frak  = 0

    ESX.TriggerServerCallback("SakuraLife:getCops", function(amount)
        cops = amount
    end)
    
    ESX.TriggerServerCallback("SakuraLife:getGangMembers", function(amount)
        frak = amount
    end)
    
    ESX.TriggerServerCallback("SakuraLife:getMedics", function(amount)
        medics = amount
    end)
    
    ESX.TriggerServerCallback("SakuraLife:getFib", function(amount)
        fibler = amount
    end)
    
    ESX.TriggerServerCallback("SakuraLife:getPlayers", function(amount)
        players = amount
    end)
    
    Citizen.Wait(500)

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spielermenü', {
        title    = 'Spieler-Anzahl: ' .. players,
        align    = 'top-left',
        elements = {
            {label = "Polizisten: " .. cops, value = "pd"},
            {label = "Mediziner: " .. medics, value = "md"},
            {label = "Deine Fraktion: " .. frak, value = "fib"},
        }
    }, function(data, menu)

    end, function(data, menu)
        menu.close()
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 57) then
            TriggerEvent('SakuraLife-core:spielerMenu')
        end
    end
end)

RegisterNetEvent('SakuraLife-core:pedMenu')
AddEventHandler("SakuraLife-core:pedMenu", function()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tiermenu', {
            title    = 'Tiermenu',
            align    = 'top-left',
            elements = {
                --[[{label = "skeleton", value = "skeleton"},
                {label = "chucky", value = "chucky"},
                {label = "Husky", value = "a_c_husky"},]]
                {label = "Zurückverwandeln", value = "default"},
                {label = "Wildschwein", value = "a_c_boar"},
                {label = "Katze 1", value = "a_c_cat_01"},
                {label = "Huhn", value = "a_c_chickenhawk"},
                {label = "Affe", value = "a_c_chimp"},
                --{label = "Chop", value = "a_c_chop"},
                {label = "Kormoran", value = "a_c_cormorant"},
                {label = "Kuh", value = "a_c_cow"},
                {label = "Kojote", value = "a_c_coyote"},
                {label = "Krähe", value = "a_c_crow"},
                {label = "Hirsch", value = "a_c_deer"},
                {label = "Delfin", value = "a_c_dolphin"},
                {label = "Fisch", value = "a_c_fish"},
                {label = "Henne", value = "a_c_hen"},
                {label = "Buckel", value = "a_c_humpback"},
                {label = "Killer Wal", value = "a_c_killerwhale"},
                --{label = "Löwe", value = "a_c_mtlion"},
                {label = "Schwein", value = "a_c_pig"},
                {label = "Taube", value = "a_c_pigeon"},
                {label = "Pudel", value = "a_c_poodle"},
                {label = "Mops", value = "a_c_pug"},
                {label = "Hase 1", value = "a_c_rabbit_01"},
                {label = "Ratte", value = "a_c_rat"},
                --{label = "Retriever", value = "a_c_retriever"},
                {label = "Rhesus", value = "a_c_rhesus"},
                --{label = "Rottweiler", value = "a_c_rottweiler"},
                {label = "Möwe", value = "a_c_seagull"},
                --{label = "Shepherd", value = "a_c_shepherd"}
            }
        }, function(data, menu)
            tiermenu(data.current.value)
        end, function(data, menu)
            menu.close()
        end)
end)

function tiermenu(animal)
    if animal == "default" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            local isMale = skin.sex == 0


            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end)
            end)
        end)
    end

    local model = GetHashKey(animal)
	local player = PlayerId()
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    SetPlayerModel(player, model)
    SetModelAsNoLongerNeeded(model)
end

--Commands
RegisterCommand("id", function(source, args, rawCommand)
    local playerPed = GetPlayerPed(-1)
	TriggerEvent("ot-notify:notify", "#db2a91", "Support", "Deine Support ID: " .. GetPlayerServerId(PlayerId()))
end)

RegisterCommand("ids", function(source, args, rawCommand)
	local playerPed = GetPlayerPed(-1)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 4.0 then
		TriggerEvent("ot-notify:notify", "#db2a91", 'SakuraLife', "Spieler ID in deiner Nähe: " .. GetPlayerServerId(closestPlayer))
	else
		TriggerEvent("ot-notify:notify", "#db2a91", 'SakuraLife', "Derzeitig sind keine Spieler in deiner nähe.")
	end
end)

--pointer
local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)