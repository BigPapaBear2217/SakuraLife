 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end) 


RegisterNetEvent('admin:godmode')
local godmode = false

AddEventHandler('admin:godmode', function()
	local playerPed = GetPlayerPed(-1)

	if not godmode then
	    godmode = true
	    print('on')
	elseif godmode then
	    godmode = false
	    print('off')
	end
end)

Citizen.CreateThread(function() --Godmode
	while true do
		Citizen.Wait(100)

		if godmode then
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
		elseif not godmode then 
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), true)
		end
	end
end)

 
RegisterNetEvent('admin:unsichtbar')
AddEventHandler('admin:unsichtbar', function()
	local entity = PlayerPedId()
	SetEntityLocallyInvisible(entity)
	SetEntityVisible(entity, false)
end)  

RegisterNetEvent('admin:hp')
AddEventHandler('admin:hp', function()
	local entity = PlayerPedId()
	SetEntityHealth(PlayerPedId(), 200)
end) 

RegisterNetEvent('admin:unsichtbar2')
AddEventHandler('admin:unsichtbar2', function()
	local entity = PlayerPedId()
	SetEntityLocallyInvisible(entity)
	SetEntityVisible(entity, true)
end)

RegisterNetEvent('ano:testmessage')
AddEventHandler('ano:testmessage', function()
	ESX.ShowNotification('HEY DIES IST EINE TESTNACHRICHT') 
	print('ok') 
end)


RegisterNetEvent('ano:drunk')
AddEventHandler('ano:drunk', function()
	print('check') 
end)

RegisterNetEvent('ano:drogen')
AddEventHandler('ano:drogen', function()
	print('check') 
end)


RegisterCommand('printcoord', function()
	ShowCoordinates()
end)
  
RegisterNetEvent('ano:testmessage11')
AddEventHandler('ano:testmessage11', function()
		local playerPed = PlayerPedId()
		local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
		local playerH = GetEntityHeading(playerPed)

		AddExplosion(playerX, playerY, playerZ, 'EXPLOSION_GAS_TANK', 250.0, true, false, 150.0) 
end)


AddEventHandler("EasyAdmin:BuildPlayerOptions", function(playerId) -- BuildPlayerOptions is triggered after building options like kick, ban.. Passes a Player ServerId
	
	-- comment this out if you want to see it in action
	if not ESX then return end

	local playerInfos
	local playerLicenses
	if isAdmin then -- you can also check if a user has a specific Permission.
		local thisESXMenu = _menuPool:AddSubMenu(thisPlayer,"~b~[ESX]~s~ Optionen aufrufen","",true) -- Submenus work, too!
		local trollESXMenu = _menuPool:AddSubMenu(thisPlayer,"~b~[TROLLING]~s~ Optionen aufrufen","",true)
		thisESXMenu:SetMenuWidthOffset(menuWidth)
		trollESXMenu:SetMenuWidthOffset(menuWidth)

		ESX.TriggerServerCallback('esx:getOtherPlayerData', function(player)
			playerInfos = player	
		end, playerId)

		if permissions["esx.license"] then
			ESX.TriggerServerCallback('esx_license:getLicenses', function(licenses)
				playerLicenses = licenses
			end, playerId)

			local attempt=0
			repeat 
				Wait(0)
				attempt=attempt+1
				if attempt>=500 then -- we didnt get our licenses within 500 ticks, abort.
					playerLicenses={}
					attempt = nil
				end
			until playerLicenses
		else
			playerLicenses = {}
		end

		local attempt=0
		repeat
			Wait(0)
			attempt=attempt+1
			if attempt>=3000 then
				ShowNotification("ESX Plugin: ~r~Failed to get Player Info, please contact support @ discord.gg/GugyRU8")
				break
			end
		until playerInfos

		local accountsText = "Accounts:\n"

		
		local haveMoneyAccount = false
		for i, account in pairs(playerInfos.accounts) do
			accountsText=accountsText..""..account.name..":€"..account.money.."\n"
			if account.name == "money" then
				haveMoneyAccount = true
			end 
		end
 
		if not haveMoneyAccount then
			if playerInfos.money then
				table.insert(playerInfos.accounts, {name = "money", money=playerInfos.money})
			end
		end

		if permissions["esx.money"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~s~ ~b~Bank/~r~Schwarzgeld ~g~hinzufügen/~r~entfernen",accountsText) -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				AddTextEntry("ESX_ADDACCOUNTMONEY_ACCOUNT", "bank / black_money eingeben!")
				DisplayOnscreenKeyboard(1, "ESX_ADDACCOUNTMONEY_ACCOUNT", "", "", "", "", "", 64)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
		
				local result = GetOnscreenKeyboardResult()
		
				if result and result ~= "" then
					AddTextEntry("ESX_ADDACCOUNTMONEY", "Anzahl zum hinzufügen/entfernen eingeben")
					DisplayOnscreenKeyboard(1, "ESX_ADDACCOUNTMONEY", "", "", "", "", "", 16)
		
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
			
					local result2 = GetOnscreenKeyboardResult()
					if result2 and result2 ~= "" then
						TriggerServerEvent("EasyAdmin:esx:addAccountMoney", playerId, result,tonumber(result2))
					end
				end
			end


			local thisItem = NativeUI.CreateItem("~b~[ESX]~b~ Bargeld ~g~hinzufügen~w~/~r~entfernen",accountsText) -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				AddTextEntry("ESX_ADDACCOUNTMONEY", "Anzahl eingeben")
				DisplayOnscreenKeyboard(1, "ESX_ADDACCOUNTMONEY", "", "", "", "", "", 16)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
		
				local result = GetOnscreenKeyboardResult()
		
				if result and result ~= "" and tonumber(result) then
					TriggerServerEvent("EasyAdmin:esx:addMoney", playerId, tonumber(result))
				end
			end
		end


		if permissions["esx.items"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~b~ Gegenstand ~g~hinzufügen/~r~entfernen","") -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				AddTextEntry("ESX_ADDINVENTORYITEM", "Item Spawnnamen angeben!")
				DisplayOnscreenKeyboard(1, "ESX_ADDINVENTORYITEM", "", "", "", "", "", 64)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
		
				local result = GetOnscreenKeyboardResult()
		
				if result and result ~= "" then
					DisplayOnscreenKeyboard(1, "ESX_ADDACCOUNTMONEY", "", "", "", "", "", 64)
		
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
			
					local result2 = GetOnscreenKeyboardResult()
					if result2 and result2 ~= "" and tonumber(result2) then
						TriggerServerEvent("EasyAdmin:esx:addInventoryItem", playerId, result, tonumber(result2))
					end
				end
			end
		end


		if permissions["esx.setjob"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~b~ Job setzen","Derzeitiger Job:\nname: "..playerInfos.job.name.."\ngrade: "..playerInfos.job.grade) -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				AddTextEntry("ESX_SETJOB", "Job Name angeben!")
				DisplayOnscreenKeyboard(1, "ESX_SETJOB", "", "", "", "", "", 64)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
		
				local result = GetOnscreenKeyboardResult()
		
				if result and result ~= "" then
					AddTextEntry("ESX_SETJOBRANK", "Rang angeben")
					DisplayOnscreenKeyboard(1, "ESX_SETJOBRANK", "", "", "", "", "", 64)
		
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
			
					local result2 = GetOnscreenKeyboardResult()
					if result2 and result2 ~= "" then
						TriggerServerEvent("EasyAdmin:esx:SetJob", playerId, result, result2)
					end
				end
			end
		end

		
		if permissions["esx.license"] then
			local licenses = "Derzeitige Lizenzen:\n"
	
			for i, license in pairs(playerLicenses) do
				licenses=licenses..""..license.label.." ("..license.type..")\n"
			end
			local thisItem = NativeUI.CreateItem("~b~[ESX]~b~ Lizenz ~g~hinzufügen/~r~nehmen",licenses) -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				AddTextEntry("ESX_ADDLICENSE", "Lizenz Namen")
				DisplayOnscreenKeyboard(1, "ESX_ADDLICENSE", "", "", "", "", "", 64)

				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
		
				local result = GetOnscreenKeyboardResult()
		
				if result and result ~= "" then
					TriggerServerEvent("EasyAdmin:esx:toggleLicense", playerId, result)
				end
			end
		end

		if permissions["esx.revive"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~s~ ~g~Spieler wiederbeleben","") -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:esx:RevivePlayer", playerId)
			end
		end

		if permissions["esx.cuff"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~b~ Handfesseln ~r~festbringen/~g~ablegen","") -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:esx:HandcuffPlayer", playerId)
			end
		end 

		if permissions["esx.godmode"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~y~ GodMode setzen/entfernen~s~","") -- create our new item
			trollESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:esx:GodMode", playerId)
			end
		end 

		if permissions["esx.ben"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~y~ Fake-Explode ~s~","") -- create our new item
			trollESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:esx:exp", playerId)
			end
		end

		if permissions["esx.invisible"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~y~ Unsichtbarkeit setzen~s~","") -- create our new item
			trollESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:esx:uns", playerId)
			end
		end

		if permissions["esx.visible"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~y~ Sichtbarkeit setzen ~s~","") -- create our new item
			trollESXMenu:AddItem(thisItem) -- thisPlayer is global. 
			thisItem.Activated = function(ParentMenu,SelectedItem) 
				TriggerServerEvent("EasyAdmin:esx:sich", playerId)
			end
		end

		if permissions["esx.alkohol"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~y~ Alkoholisieren~s~","") -- create our new item
			trollESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:alkoholisieren", playerId)
			end
		end

		if permissions["esx.drogen"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~y~ High stellen~s~","") -- create our new item
			trollESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:high", playerId) 
			end
		end
 
		if permissions["esx.hp"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~p~ Lebengspunkte 100% ~s~","") -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:hp", playerId) 
			end
		end

		if permissions["esx.armor"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~p~ 100% Rüstung ~s~","") -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:armor", playerId)  
			end
		end

		if permissions["esx.test"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~b~ Test-Nachricht ~s~","") -- create our new item
			trollESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:esx:test", playerId)
			end
		end

		if permissions["esx.resetskin"] then
			local thisItem = NativeUI.CreateItem("~b~[ESX]~y~ Kleidungsladen öffnen~s~","") -- create our new item
			thisESXMenu:AddItem(thisItem) -- thisPlayer is global.
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:esx:ResetSkin", playerId)
			end
		end


		
		local thisPlayerDataMenu = _menuPool:AddSubMenu(thisESXMenu,"~b~[ESX]~y~ Inventar anschauen/Durchsuchen","",true) -- Submenus work, too!
		thisPlayerDataMenu:SetMenuWidthOffset(menuWidth)

		local thisItem = NativeUI.CreateItem("~r~Steam64ID", playerInfos.identifier) 
		thisPlayerDataMenu:AddItem(thisItem)

		local thisItem = NativeUI.CreateItem("~g~--Guthaben--~s~", "") 
		thisPlayerDataMenu:AddItem(thisItem)

		for i, item in pairs(playerInfos.accounts) do
			local thisItem = NativeUI.CreateItem(item.name, "")
			thisItem:RightLabel(item.money)
			thisPlayerDataMenu:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				if not permissions["esx.money"] then return end
				AddTextEntry("ESX_SETACCOUNTMONEY", "Betrag zum hinzufügen eingeben.")
				DisplayOnscreenKeyboard(1, "ESX_SETACCOUNTMONEY", "", "", "", "", "", 16)
	
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
		
				local result = GetOnscreenKeyboardResult()
				if result and result ~= "" and tonumber(result) then
					TriggerServerEvent("EasyAdmin:esx:setAccountMoney", playerId, item.name,tonumber(result))
					thisItem:RightLabel(result)
				end
			end
		end
 

		if #playerInfos.loadout > 0 then
			local thisItem = NativeUI.CreateItem("~r~--Schusswaffen--~s~", "") 
			thisPlayerDataMenu:AddItem(thisItem)

			for i, item in pairs(playerInfos.loadout) do
				local thisItem = NativeUI.CreateItem(item.name, "")
				thisItem:RightLabel(item.ammo)
				thisPlayerDataMenu:AddItem(thisItem)
			end
		end
		
		if playerLicenses and #playerLicenses > 0 then
			local thisItem = NativeUI.CreateItem("~r~--Führerschein--~s~", "") 
			thisPlayerDataMenu:AddItem(thisItem)

			for i,license in pairs(playerLicenses) do
				local thisItem = NativeUI.CreateItem(license.label, "")
				thisPlayerDataMenu:AddItem(thisItem)
			end
		end

		local thisItem = NativeUI.CreateItem("~r~--Inventar--~s~", "") 
		thisPlayerDataMenu:AddItem(thisItem)
		

		for i, item in pairs(playerInfos.inventory) do
			if (ea_esx_hidenoitems == true and item.count ~= 0) or (ea_esx_hidenoitems == false) then
				local thisItem = NativeUI.CreateItem(item.name, "")
				thisItem:RightLabel(item.count)
				thisPlayerDataMenu:AddItem(thisItem)
				thisItem.Activated = function(ParentMenu,SelectedItem)
					if not permissions["esx.items"] then return end
					AddTextEntry("ESX_SETITEMAMOUNT", "Betrag zum hinzufügen des Gegenstandes eintragen.")
					DisplayOnscreenKeyboard(1, "ESX_SETITEMAMOUNT", "", "", "", "", "", 16)
		
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
			
					local result = GetOnscreenKeyboardResult()
					if result and result ~= "" and tonumber(result) then
						TriggerServerEvent("EasyAdmin:esx:setInventoryItem", playerId, item.name,tonumber(result))
						thisItem:RightLabel(result)
					end
				end
			end
		end
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:MouseControlsEnabled(false)
	end
end)


AddEventHandler("EasyAdmin:BuildCachedOptions", function(playerId) -- Options for Cached Players, do note that these do not not support Player natives! They're cached BY EASYADMIN
	
end)

AddEventHandler("EasyAdmin:BuildServerManagementOptions", function() -- Options for the Server Management Submenu, passes nothing.

end)

AddEventHandler("EasyAdmin:BuildSettingsOptions", function() -- Options for the Settings Page, once again, passes nothing

	local thisItem = NativeUI.CreateListItem("~b~[ESX]~r~ Sollte auf true sein! Bei Fragen: Bei PL melden.", {"true", "false"}, 1, "Gegenstände, wovon der Spieler 0 hat werden trotzdem angezeigt.")
	settingsMenu:AddItem(thisItem)
	settingsMenu.OnListChange = function(sender, item, index)
			if item == thisItem then
					local i = item:IndexToItem(index)
					if i == "true" then
						ea_esx_hidenoitems = true
					else
						ea_esx_hidenoitems = false
					end
					SetResourceKvp("ea_esx_hidenoitems", i)
			end
	end

end)

if not GetResourceKvpString("ea_esx_hidenoitems") then
	SetResourceKvp("ea_esx_hidenoitems", "true")
	ea_esx_hidenoitems = true
else 
	ea_esx_hidenoitems = GetResourceKvpString("ea_esx_hidenoitems")
	if ea_esx_hidenoitems == "true" then
		ea_esx_hidenoitems=true
	else
		ea_esx_hidenoitems=false
	end
end 