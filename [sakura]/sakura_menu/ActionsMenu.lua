ESX = nil
local dasding = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
--Delete if Using bloodline-fraksys
RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
end)

RegisterNetEvent('esx:setGangrank')
AddEventHandler('esx:setGangrank', function(gangrank)
	ESX.PlayerData.gangrank = gangrank
end)
--Delete if Using bloodline-fraksys


--Delete if Using Jason_Level
RegisterNetEvent('esx:setLevel')
AddEventHandler('esx:setLevel', function(level)
	ESX.PlayerData.level = level
end)

RegisterNetEvent('esx:setRP')
AddEventHandler('esx:setRP', function(rp)
	ESX.PlayerData.rp = rp
end)
--Delete if Using Jason_Level

--[[ --Delete if Using Jason_GWD
RegisterNetEvent('esx:setGWD')
AddEventHandler('esx:setGWD', function(gwd)
	ESX.PlayerData.gwd = gwd
end)
--]] --Delete if Using Jason_GWD

--RMenu.Add('showcase', 'main', RageUI.CreateSubMenu(subMenu2, " ", "Gegenstand"))
--RMenu.Add('showcase2', 'main2', RageUI.CreateSubMenu(subMenu2, " ", "Waffe"))
--
--RMenu:Get('showcase', 'main').Sprite = {
--    Dictionary = "Custom_Menu_Head" or "WS_commonmenu",
--    Texture = "Custom_Menu_Head" or "interaction_bgd",
--    Color = {
--        R = R,
--        G = G,
--        B = B,
--        A = A
--    }
--}
--
--RMenu:Get('showcase2', 'main2').Sprite = {
--    Dictionary = "Custom_Menu_Head" or "WS_commonmenu",
--    Texture = "Custom_Menu_Head" or "interaction_bgd",
--    Color = {
--        R = R,
--        G = G,
--        B = B,
--        A = A
--    }
--}

--RMenu:Get('showcase', 'main'):DisplayGlare(false)
--RMenu:Get('showcase2', 'main2'):DisplayGlare(false)


--RegisterNetEvent('esx:opendingmenu')
--AddEventHandler('esx:opendingmenu', function(item)
--	--print(item.name)
--	--print(item.usable)
--	RageUI.Visible(RMenu:Get('showcase', 'main'), not RageUI.Visible(RMenu:Get('showcase', 'main')))
--	dasding = item
--end)
--
--RegisterNetEvent('esx:opendingmenu2')
--AddEventHandler('esx:opendingmenu2', function(item)
--	--print(item.name)
--	RageUI.Visible(RMenu:Get('showcase2', 'main2'), not RageUI.Visible(RMenu:Get('showcase2', 'main2')))
--	dasding = item
--end)
--
--	Citizen.CreateThread(function()
--		while (true) do
--			Citizen.Wait(1.0)
--			RageUI.IsVisible(RMenu:Get('showcase', 'main'), function()
--				RageUI.Button('Benutzen', nil, {  }, true, {
--                    onSelected = function()
--						if dasding.usable then
--							TriggerServerEvent('esx:useItem', dasding.name)
--						else
--							ESX.ShowNotification("Dieser Gegenstand ist nicht benutzbar")
--						end
--					end,
--				})
--				RageUI.Button('Geben', nil, {  }, true, {
--					onSelected = function()
--						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
--
--						if closestDistance ~= -1 and closestDistance <= 3 then
--							local closestPed = GetPlayerPed(closestPlayer)
--
--							if not IsPedSittingInAnyVehicle(closestPed) then
--								if dasding.count > 0 then
--									local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', "Menge", '', 8))
--									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', dasding.name, quantity)
--									RageUI.CloseAll()
--								else
--									ESX.ShowNotification("Falsche Menge")
--								end
--							else
--								ESX.ShowNotification("Im Fahrzeug kannst an niemanden der im Fahrzeug sitzt etwas geben")
--							end
--						else
--							ESX.ShowNotification("Keine Person in der Nähe")
--						end						
--					end,
--				})
--				RageUI.Button('Wegwerfen', nil, {  }, true, {
--					onSelected = function()
--						if dasding.canRemove then
--							if not IsPedSittingInAnyVehicle(plyPed) then
--								if dasding.count ~= nil and dasding.name ~= nil then
--									local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', "Menge", '', 8))
--									TriggerServerEvent('esx:removeInventoryItem', 'item_standard', dasding.name, quantity)
--									RageUI.CloseAll()
--								else
--									ESX.ShowNotification("Falsche Menge")
--								end
--							else
--								ESX.ShowNotification("Du kannst nichts wegwerfen wenn du in einem Fahrzeug bist")
--							end
--						else
--							ESX.ShowNotification("Dieser Gegenstand ist zu Wertvoll um weggeworfen zu werden")
--						end
--					end,
--				})
--			end)
--		end
--	end)
--
--	Citizen.CreateThread(function()
--		while (true) do
--			Citizen.Wait(1.0)
--			RageUI.IsVisible(RMenu:Get('showcase2', 'main2'), function()
--				RageUI.Button('Geben', nil, {  }, true, {
--					onSelected = function()
--						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
--
--						if closestDistance ~= -1 and closestDistance <= 3 then
--							local closestPed = GetPlayerPed(closestPlayer)
--
--							if not IsPedSittingInAnyVehicle(closestPed) then
--								local ammo = GetAmmoInPedWeapon(plyPed, dasding.hash)
--								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', dasding.name, ammo)
--								RageUI.CloseAll()
--							else
--								ESX.ShowNotification("Du kannst diese Waffe nicht im Auto weitergeben")
--							end
--						else
--							ESX.ShowNotification("Keine Person in der Nähe")
--						end					
--					end,
--				})
--				RageUI.Button('Wegwerfen', nil, {  }, true, {
--					onSelected = function()
--						if not IsPedSittingInAnyVehicle(plyPed) then
--							TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', dasding.name)
--							RageUI.CloseAll()
--						else
--							ESX.ShowNotification("Du kannst diese Waffe nicht im Fahrzeug wegwerfen")
--						end
--					end,
--				})
--			end)
--		end
--	end)

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

function CheckQuantity(number)
	number = tonumber(number)

	if type(number) == 'number' then
		number = ESX.Math.Round(number)

		if number > 0 then
			return true, number
		end
	end

	return false, number
end
