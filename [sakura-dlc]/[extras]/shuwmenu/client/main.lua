ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(1)
        TriggerEvent('esx:getSharedObject', function(object)
            ESX = object
        end)
    end
end)


KIDU.Menus.MainMenu   = RageUI.CreateMenu("ShuwaMenü", "Sakura Roleplay", 20, 20)
KIDU.SubMenus.PedMenu = RageUI.CreateSubMenu(KIDU.Menus.MainMenu, "ShuwMenü", "Model Menü")
KIDU.SubMenus.CarMenu = RageUI.CreateSubMenu(KIDU.Menus.MainMenu, "ShuwMenü", "Fahrzeug Menü")

TriggerServerEvent('kidu:setIdentifier')

RegisterNetEvent('kidu:syncIdentifier')
AddEventHandler('kidu:syncIdentifier', function(identifier)
    KIDU.SetLicense(identifier)
end)

Citizen.CreateThread(function()
    while not KIDU.Array.HasValue(KIDU.WhitelistedIdentifiers, KIDU.Player.license) do
        Citizen.Wait(500)
        
        Keys.Register("G", "G", "[LARISSA] ShuwaMenü", function()
            if KIDU.Array.HasValue(KIDU.WhitelistedIdentifiers, KIDU.Player.license) then
                RageUI.Visible(KIDU.Menus.MainMenu, not RageUI.Visible(KIDU.Menus.MainMenu))
            end
            end)
    end
end)

function RageUI.PoolMenus:AdminMenu()
    KIDU.Menus.MainMenu:IsVisible(function(items) 
        items:AddButton("Model Menü", "Larissa will nur Spaß hier haben", { RightLabel = "→→→" }, function(onSelected)

        end, KIDU.SubMenus.PedMenu)
    end, function() end)

    KIDU.SubMenus.PedMenu:IsVisible(function(items)
        items:AddButton("In Ped verwandeln", "Dulli ist Fett!!", {}, function(onSelected)
            if onSelected then
                local reason = KeyboardInput('KORIOZ_BOX_AMOUNT', "reset, baby, squidward, spongi, gokumui, ig_bankman, trollface, squidgame", '', 25)

                if reason ~= nil then
                    pedy(reason)
                end
            end
        end)
    end, function()
        --Panel
    end)
end

function pedy(reason)
    if reason == "reset" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            local isMale = skin.sex == 0

            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end)
            end)

        end)
        return
    end

    local j1 = PlayerId()
    local p1 = GetHashKey(reason)

    RequestModel(p1)
        
    while not HasModelLoaded(p1) do
        Wait(100)
    end

    SetPlayerModel(j1, p1)
    SetModelAsNoLongerNeeded(p1)
end

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

--

