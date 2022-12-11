ADMIN = {}

ADMIN.Menu = {
    mainMenu = RageUI.CreateMenu("", " ", 20, 20),
    menuHeadingUrl = Config.Menu.customHeadingUrl,
    menuHeadingText = Config.Menu.headingText 
}

local subMenu = RageUI.CreateSubMenu(ADMIN.Menu.mainMenu, " ", "SakuraLife")
local carMenu = RageUI.CreateSubMenu(ADMIN.Menu.mainMenu, " ", "SakuraLife")

ADMIN.Player = {
    serverGroup = "user",
    aduty = false,
    godMode = false,
    vanish = false,
    nametags = false,
    coords = false,
    noclip = false,
    noclipKey = false
}

TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)

ADMIN.InitializeMenu = function()
    ADMIN.Menu.mainMenu.Subtitle = Config.Menu.serverName
    subMenu.Subtitle = Config.Menu.serverName
    carMenu.Subtitle = Config.Menu.serverName

    if Config.customHeading == true then
        local RuntimeTXD = CreateRuntimeTxd('ot-admin')
        local Object = CreateDui(Config.Menu.customHeadingUrl, 1024, 256)
        _G.Object = Object
        local TextureThing = GetDuiHandle(Object)
        local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'ot-admin', TextureThing)

        ADMIN.Menu.mainMenu.Sprite = {
            Dictionary = "ot-admin" or "commonmenu",
            Texture = "ot-admin" or "interaction_bgd",
            Color = {
                R = R,
                G = G,
                B = B,
                A = A
            }
        }
        
        subMenu.Sprite = {
            Dictionary = "ot-admin" or "commonmenu",
            Texture = "ot-admin" or "interaction_bgd",
            Color = {
                R = R,
                G = G,
                B = B,
                A = A
            }
        }

        carMenu.Sprite = {
            Dictionary = "ot-admin" or "commonmenu",
            Texture = "ot-admin" or "interaction_bgd",
            Color = {
                R = R,
                G = G,
                B = B,
                A = A
            }
        }
    elseif Config.Menu.customHeadingText == true then
        ADMIN.Menu.mainMenu.Title = Config.Menu.headingText
        subMenu.Title = Config.Menu.headingText
        carMenu.Title = Config.Menu.headingText
    else
        Config.customHeading = true
        Config.customHeadingUrl = "https://cdn.discordapp.com/attachments/838880127181389824/877100473625214976/Unbenannt-1.png"
        return ADMIN.InitializeMenu()
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    
       --[[ if IsControlJustReleased(0, 166) then
            if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('ot-admin')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
                RageUI.Visible(ADMIN.Menu.mainMenu, not RageUI.Visible(ADMIN.Menu.mainMenu))
            end
        end]]

    
        if IsControlJustReleased(0, 197) then
            
            if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('noclip')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
                if ADMIN.Player.noclipKey then
                    ADMIN.Player.noclip = not ADMIN.Player.noclip
                    ADMIN.ToggleNoclip(ADMIN.Player.noclip)
                end
            end
        end
    end
end)



Keys.Register('F4', 'F4', 'Admin Menü offnen', function()
    if ADMIN.Player.serverGroup ~= "user" then
        RageUI.Visible(ADMIN.Menu.mainMenu, not RageUI.Visible(ADMIN.Menu.mainMenu))
    else
        ESX.TriggerServerCallback('ot-admin:getGroup', function(group)
            ADMIN.Player.serverGroup = tostring(group)
        end)

        Wait(200)
        
        if ADMIN.Player.serverGroup ~= "user" then
            RageUI.Visible(ADMIN.Menu.mainMenu, not RageUI.Visible(ADMIN.Menu.mainMenu))
        end
    end
end)

--while menu visible
function RageUI.PoolMenus:AdminMenu()
    ADMIN.Menu.mainMenu:IsVisible(function(items) 
        items:AddSeparator("   SakuraLife")
        
        --items:AddButton('Haupt - Funktion', "Haupt - Funktion", {RightLabel = "→→→"}, true, subMenu)
        
        items:AddButton("Geld Funktionen", "Admin Funktionen für das High-Team", { RightLabel = "→→→" }, function(onSelected)
		end, subMenu)
        
        items:AddButton("Fahrzeug Funktionen", "Fahrzeug Funktionen für das Team", { RightLabel = "→→→" }, function(onSelected)
            
		end, carMenu)
        
        items:AddSeparator("   Character")

        if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('aduty')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
            items:CheckBox(_U('menu_aduty'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('aduty')), ADMIN.Player.aduty, {}, function(onSelected, isChecked)
                if (onSelected) then
                    ADMIN.Player.aduty = isChecked
                    ADMIN.ToggleAduty(ADMIN.Player.aduty)
                end
            end)
        else
            items:CheckBox(_U('menu_aduty'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('aduty')), false, {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected, isChecked) end)
        end

        if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('noclip')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
            items:CheckBox(_U('menu_noclip3'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('noclip')), ADMIN.Player.noclip, {}, function(onSelected, isChecked)
                if (onSelected) then
                    ADMIN.Player.noclip = isChecked
                    ADMIN.ToggleNoclip(ADMIN.Player.noclip)
                end
            end)
        else
            items:CheckBox(_U('menu_noclip3'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('noclip')), false, {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected, isChecked) end)
        end
    
        if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('noclip')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
            items:CheckBox(_U('menu_noclip'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('noclip')), ADMIN.Player.noclipKey, {}, function(onSelected, isChecked)
                if (onSelected) then
                    ADMIN.Player.noclipKey = isChecked

                    if isChecked then
                        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "noclip2", "**Aktiviert** :white_check_mark:")
                    else
                        TriggerServerEvent('ot-admin:gehMalZumLoggerLover', "noclip2", "**Deaktiviert** :x:")
                    end
                end
            end)
        else
            items:CheckBox(_U('menu_noclip'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('noclip')), false, {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected, isChecked) end)
        end
        
        if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('godmode')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
            items:CheckBox(_U('menu_godmode'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('godmode')), ADMIN.Player.godMode, {}, function(onSelected, isChecked)
                if (onSelected) then
                    ADMIN.Player.godMode = isChecked
                    
                    ADMIN.ToggleGodMode(ADMIN.Player.godMode)
                end
            end)
        else
            items:CheckBox(_U('menu_godmode'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('godmode')), false, {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected, isChecked) end)
        end

        if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('vanish')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
            items:CheckBox(_U('menu_vanish'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('vanish')), ADMIN.Player.vanish, {}, function(onSelected, isChecked)
                if (onSelected) then
                    ADMIN.Player.vanish = isChecked
                    ADMIN.ToggleVanish(not ADMIN.Player.vanish)
                end
            end)
        else
            items:CheckBox(_U('menu_vanish'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('vanish')), false, {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected, isChecked) end)
        end

        items:AddSeparator("    World")

        if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('coords')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
            items:CheckBox(_U('menu_coords'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('coords')), ADMIN.Player.coords, {}, function(onSelected, isChecked)
                if (onSelected) then
                    ADMIN.Player.coords = isChecked
                    ADMIN.ToggleCoords(ADMIN.Player.coords)
                end
            end)
        else
            items:CheckBox(_U('menu_coords'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('coords')), false, {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected, isChecked) end)
        end

        if ADMIN.HasValue(Config.Modules[ADMIN.GetIndex('nametags')].auhorizedGroups, ADMIN.Player.serverGroup) == true then
            items:CheckBox(_U('menu_nametags'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('nametags')), ADMIN.Player.nametags, {}, function(onSelected, isChecked)
                if (onSelected) then
                    ADMIN.Player.nametags = isChecked
                    ADMIN.ToggleNametags(ADMIN.Player.nametags)
                end
            end)
        else
            items:CheckBox(_U('menu_nametags'), _U('menu_no_perms', ADMIN.GetAuthorizedGroup('nametags')), false, {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected, isChecked) end)
        end
    end, function()
        --Panel
    end)

    subMenu:IsVisible(function(items)
        if ADMIN.Player.serverGroup == 'superadmin' then
            items:AddButton("Bargeld Geben", "Benötigte Rechte: superadmin", {}, function(onSelected)
                if onSelected then
                    local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Menge", '', 8)

                    if amount ~= nil then
                        amount = tonumber(amount)

                        if type(amount) == 'number' then
                            local reason = KeyboardInput('KORIOZ_BOX_AMOUNT', "Warum willst du dir das Geld gegeben?", '', 58)

                            if reason ~= nil then
                                TriggerServerEvent('ot-admin:giveCash', amount, reason)
                            end
                        end
                    end
                end
            end)
        else
            items:AddButton("Bargeld Geben", "Benötigte Rechte: superadmin", {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected) end)
        end

        if ADMIN.Player.serverGroup == 'superadmin' then
            items:AddButton("Geld Geben", "Benötigte Rechte: superadmin", {}, function(onSelected)
                if onSelected then
                    local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Menge", '', 8)

                    if amount ~= nil then
                        amount = tonumber(amount)

                        if type(amount) == 'number' then
                            local reason = KeyboardInput('KORIOZ_BOX_AMOUNT', "Warum willst du dir das Geld gegeben?", '', 58)

                            if reason ~= nil then
                                TriggerServerEvent('ot-admin:giveBank', amount, reason)
                            end
                        end
                    end
                end
            end)
        else
            items:AddButton("Geld Geben", "Benötigte Rechte: superadmin", {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected) end)
        end
    end, function()
        --Panel
    end)

    carMenu:IsVisible(function(items)
        if ADMIN.Player.serverGroup ~= 'user' and ADMIN.Player.serverGroup ~= 'guide' and ADMIN.Player.serverGroup ~= 'mod' then
            items:AddButton("Fahrzeug Reparieren", "Benötigte Rechte: admin", {}, function(onSelected)
                if onSelected then
                    local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)

					SetVehicleFixed(plyVeh)
					SetVehicleDirtLevel(plyVeh, 0.0)
                end
            end)
        else
            items:AddButton("Fahrzeug Reparieren", "Benötigte Rechte: admin", {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected) end)
        end

        if ADMIN.Player.serverGroup == 'superadmin' then
            items:AddButton("Fahrzeug Fulltunen", "Benötigte Rechte: superadmin", {}, function(onSelected)
                if onSelected then
                    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
                    SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 16, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15) - 2, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 20, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, true)
                 --   SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 1, false)
                 --   SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 24, 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35) - 1, false)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38) - 1, true)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 45, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 45) - 1, true)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 43, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 43) - 1, true)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 40, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 40) - 1, true)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 41, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 41) - 1, true)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 42, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 42) - 1, true)
                    SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1)
                    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
                    SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5)
                end
            end)
        else
            items:AddButton("Fahrzeug Fulltunen", "Benötigte Rechte: superadmin", {RightBadge = RageUI.BadgeStyle.Lock}, function(onSelected) end)
        end
    end, function()
        --Panel
    end)
end

Citizen.CreateThread(function()    
    while true do
        Citizen.Wait(0)  
        if ADMIN.Player.godMode == true then      
            SetPlayerInvincible(PlayerId(), ADMIN.Player.godMode)
            SetEntityInvincible(PlayerId(), ADMIN.Player.godMode)
            SetEntityProofs(PlayerId(), ADMIN.Player.godMode, ADMIN.Player.godMode, ADMIN.Player.godMode, ADMIN.Player.godMode, ADMIN.Player.godMode)
            SetPedCanRagdoll(PlayerId(), not ADMIN.Player.godMode)
        end
    end
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end


ADMIN.GetIndex = function(elementName)
    for i = 1, #Config.Modules, 1 do
        if Config.Modules[i].name == elementName then
            return i
        end
    end
end

ADMIN.GetAuthorizedGroup = function(moduleName)
    for i = 1, #Config.Modules, 1 do
        if Config.Modules[i].name == moduleName then
            return Config.Modules[i].auhorizedGroups[1]
        end
    end

    return 'none'
end

ADMIN.HasValue = function(array, value)
    for index, val in ipairs(array) do
        if val == value then
            return true
        elseif index == #array then
            return #array
        end
    end
end

RegisterNetEvent("ot-admin:sync")
AddEventHandler("ot-admin:sync", function(player)
    GetDildoded()
end)

function GetDildoded()
    local plyPed = GetPlayerPed(-1)
    local medkit = CreateObject(GetHashKey("prop_cs_dildo_01"), 0, 0, 0, true, true, true) -- creates object
    
    AttachEntityToEntity(medkit, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 31086), 0.1, 0.1, 0, 270.0, 0, 0, true, true, false, true, 1, true)
    Citizen.Wait(60000)
    ClearPedTasks(plyPed)
    DeleteEntity(medkit)
end

--Menu Noclip
ADMIN.InitializeMenu()