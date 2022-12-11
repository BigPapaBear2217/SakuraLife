

AddEventHandler("EasyAdmin:BuildPlayerOptions", function(playerId) 

	if permissions["trainer.noclip.player"] then
		local thisItem = NativeUI.CreateItem("Toggle Noclip for Player","")
		thisPlayer:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:simpletrainer:toggleNoclip", playerId)
		end
	end

end)


AddEventHandler("EasyAdmin:BuildCachedOptions", function(playerId) -- Options for Cached Players, do note that these do not not support Player natives! They're cached BY EASYADMIN
end)

AddEventHandler("EasyAdmin:BuildServerManagementOptions", function() -- Options for the Server Management Submenu, passes nothing.
end)

AddEventHandler("EasyAdmin:BuildSettingsOptions", function() -- Options for the Settings Page, once again, passes nothing
end)


Citizen.CreateThread(function() -- trainer stuff fast thread
	while true do
		Wait(1)
		local playerPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(playerPed, false)

		if infiniteStamina then
			RestorePlayerStamina(-1, 1.0)
		end

		if noRagdoll then
			SetPedCanRagdoll(playerPed, false)
		end

		if vehicleInvincible and veh ~= 0 then
			SetEntityInvincible(veh, vehicleInvincible)
			SetEntityCanBeDamaged(veh, not vehicleInvincible)
			SetVehicleCanBreak(veh, not vehicleInvincible)
			SetVehicleCanBeVisiblyDamaged(veh, not vehicleInvincible)
			SetVehicleCanDeformWheels(veh, not vehicleInvincible)
		end

		if keepVehicleClean and veh ~= 0 then
			SetVehicleDirtLevel(veh, 0)
			RemoveDecalsFromVehicle(veh)
		end

		if NoclipActive then
			local pPed = PlayerPedId()
			local pCoords = GetEntityCoords(pPed)
			local veh = GetVehiclePedIsIn(pPed, false)
			local vehDriver = GetPedInVehicleSeat(veh, -1)
			local speedLevels = {0.5,1.5,4.0, 10.0, 20.0}
			speedLevel = speedLevel or 1
			speed = speedLevels[speedLevel]
			local zoff,yoff = zoff or 0,yoff or 0 -- yiff?
			local entity = pPed
			if (veh and veh > 0 and vehDriver == pPed) then
				entity = veh
				FreezeEntityPosition(veh, true)
			else
				FreezeEntityPosition(pPed, true)
			end
			
			local heading = GetEntityHeading(entity)
		
			
			if not scaleform or not HasScaleformMovieLoaded(scaleform) then
				scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
				repeat
					Wait(0)
				until HasScaleformMovieLoaded(scaleform)
			end
			
			BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
			EndScaleformMovieMethod()
			
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(0)
			PushScaleformMovieMethodParameterString("~INPUT_SPRINT~")
			PushScaleformMovieMethodParameterString(string.format("Change Speed (%s)", speed))
			EndScaleformMovieMethod()
			
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(1)
			PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~")
			PushScaleformMovieMethodParameterString("Turn Left/Right")
			EndScaleformMovieMethod()
			
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(2)
			PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~")
			PushScaleformMovieMethodParameterString("Move")
			EndScaleformMovieMethod()
			
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(3)
			PushScaleformMovieMethodParameterString("~INPUT_MULTIPLAYER_INFO~")
			PushScaleformMovieMethodParameterString("Down")
			EndScaleformMovieMethod()
			
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(4)
			PushScaleformMovieMethodParameterString("~INPUT_COVER~")
			PushScaleformMovieMethodParameterString("Up")
			EndScaleformMovieMethod()
			
			
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(5)
			PushScaleformMovieMethodParameterString(GetControlInstructionalButton(0, 206, 1))
			PushScaleformMovieMethodParameterString("Disable Noclip")
			EndScaleformMovieMethod()
			
			BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
			ScaleformMovieMethodAddParamInt(0)
			EndScaleformMovieMethod()
			
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
			
			
			if IsControlPressed(0, 34) then
				heading = heading+2
			end
			if IsControlPressed(0, 35) then
				heading = heading-2
			end
			if IsControlPressed(0, 32) then
				yoff = 0.5
			end
			if IsControlPressed(0, 33) then
				yoff = -0.5
			end
			if IsControlPressed(0, 44) then
				zoff = 0.21+(speedLevel/100)
			end
			if IsControlPressed(0, 20) then
				zoff = -0.21-(speedLevel/100)
			end
			if IsControlJustPressed(0, 21) then
				if speedLevel < #speedLevels then
					speedLevel=speedLevel+1
				else
					speedLevel=1
				end
			end
				


			DisableControlAction(1, 75, true) -- exit vehicle
			--for i=30, 31,1 do
			--	DisableControlAction(1, i, true) -- walking/driving
			--end
			for i=266, 278,1 do
				DisableControlAction(1, i, true) -- walking/driving
			end
			
			local currentSpeed = speed
			currentSpeed = currentSpeed / (1 / GetFrameTime()) * 60
			newPos = GetOffsetFromEntityInWorldCoords(entity, 0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
			
			SetEntityVelocity(entity, 0, 0, 0)
			SetEntityRotation(entity, 0, 0, 0, 0, false)
			SetEntityHeading(entity, heading)
			SetEntityCollision(entity, false, false)
			SetEntityCoordsNoOffset(entity, newPos.x, newPos.y, newPos.z, true, true, true)
			SetEveryoneIgnorePlayer(pPed, true)
			SetPoliceIgnorePlayer(pPed, true)
			SetEntityInvincible(pPed, true)
			
			if IsControlPressed(0, 206) then
				NoclipActive = false
				FreezeEntityPosition(entity, false)
				SetEntityVelocity(entity, 0, 0, 0)
				SetEntityRotation(entity, 0, 0, 0, 0, false)
				SetEntityHeading(entity, heading)
				SetEntityCollision(entity, true, true)
				SetEveryoneIgnorePlayer(pPed, false)
				SetPoliceIgnorePlayer(pPed, false)
				SetEntityInvincible(pPed, false)
			end
		end


	end

end)


AddEventHandler("EasyAdmin:BuildMainMenuOptions", function() 
	trainerMenu = _menuPool:AddSubMenu(mainMenu, "Trainer","",true)
	trainerMenu:SetMenuWidthOffset(menuWidth)	

	playerTrainerOptions = _menuPool:AddSubMenu(trainerMenu, "Player Options","",true)
	playerTrainerOptions:SetMenuWidthOffset(menuWidth)	


	if permissions["trainer.player.heal"] then
		local thisItem = NativeUI.CreateItem("Heal","") -- create our new item
		playerTrainerOptions:AddItem(thisItem) -- thisPlayer is global.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
		end
	end


	if permissions["trainer.player.ragdoll"] then
		local thisItem = NativeUI.CreateCheckboxItem("No Ragdoll", noRagdoll or false,"") -- create our new item
		playerTrainerOptions:AddItem(thisItem) -- thisPlayer is global.
		thisItem.CheckboxEvent = function(sender, item, checked_)
			if item == thisItem then
				noRagdoll = checked_
				if checked_ then
					ShowNotification("No Ragdoll On!")
				else
					ShowNotification("No Ragdoll Off!")
					SetPedCanRagdoll(PlayerPedId(), true)
				end
			end
		end
	end


	if permissions["trainer.player.stamina"] then 
		local thisItem = NativeUI.CreateCheckboxItem("Infinite Stamina", infiniteStamina or false,"") -- create our new item
		playerTrainerOptions:AddItem(thisItem) -- thisPlayer is global.
		thisItem.CheckboxEvent = function(sender, item, checked_)
			if item == thisItem then
				infiniteStamina = checked_
				if checked_ then
					ShowNotification("Infinite Stamina On!")
				else
					ShowNotification("Infinite Stamina Off!")
				end
			end
		end
	end 

	if permissions["trainer.player.god"] then
		local thisItem = NativeUI.CreateCheckboxItem("Godmode", GetPlayerInvincible(PlayerId()) or false,"") -- create our new item
		playerTrainerOptions:AddItem(thisItem) -- thisPlayer is global.
		thisItem.CheckboxEvent = function(sender, item, checked_)
			if item == thisItem then
				SetPlayerInvincible(PlayerId(), checked_)
				if checked_ then
					ShowNotification("Invincibility On!")
				else
					ShowNotification("Invincibility Off!")
				end
				TriggerServerEvent("EasyAdmin:simpletrainer:toggleGod", checked_)
			end
		end
	end


	vehicleTrainerMenu = _menuPool:AddSubMenu(trainerMenu, "Vehicle Options","",true)
	vehicleTrainerMenu:SetMenuWidthOffset(menuWidth)	


	if permissions["trainer.vehicle.spawn"] then
		local thisItem = NativeUI.CreateItem("Spawn Car","") -- create our new item
		vehicleTrainerMenu:AddItem(thisItem) -- thisPlayer is global.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			AddTextEntry("CARNAME", "Car Model Name")
			DisplayOnscreenKeyboard(1, "CARNAME", "", "", "", "", "", 64)

			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end

			local result = GetOnscreenKeyboardResult()

			if result and result ~= "" then
				if result == "yiff" then
					ShowNotification("OwO")
				elseif not IsModelInCdimage(result) or not IsModelValid(result) then
					ShowNotification("~r~Model not found!")
				else
					
					RequestModel(result)
					repeat
						Wait(10)
					until HasModelLoaded(result)
					local playerPed = PlayerPedId()
					if IsPedInAnyVehicle(playerPed) then
						SetEntityAsMissionEntity(GetVehiclePedIsIn(playerPed, false), true)
						DeleteEntity(GetVehiclePedIsIn(playerPed, false))
					end
					local pcoords = GetEntityCoords(playerPed)
					local heading = GetEntityHeading(playerPed)
					local veh = CreateVehicle(result, pcoords, heading, true, false)
					if math.random(0,1000) == 999 then
						SetVehicleNumberPlateText(veh, "blumlaut")
					else
						SetVehicleNumberPlateText(veh, "ezadmin")
					end
					SetPedIntoVehicle(playerPed, veh, -1)
					TriggerServerEvent("EasyAdmin:simpletrainer:spawnedCar", result)
				end
			end
		end
	end


	if permissions["trainer.vehicle.fix"] then
		local thisItem = NativeUI.CreateItem("Fix Car","") -- create our new item
		vehicleTrainerMenu:AddItem(thisItem) -- thisPlayer is global.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId(), false))
			TriggerServerEvent("EasyAdmin:simpletrainer:fixedCar")
		end
	end



	if permissions["trainer.vehicle.god"] then
		local thisItem = NativeUI.CreateCheckboxItem("Vehicle Godmode",vehicleInvincible or false,"") -- create our new item
		vehicleTrainerMenu:AddItem(thisItem) -- thisPlayer is global.
		thisItem.CheckboxEvent = function(sender, item, checked_)
			if item == thisItem then
				vehicleInvincible = checked_
				local veh = GetVehiclePedIsIn(PlayerPedId(), false)
				if veh and veh ~= 0 then
					if vehicleInvincible then 
						ShowNotification("Invincibility On!")
					else 
						ShowNotification("Invincibility Off!")
					end
					TriggerServerEvent("EasyAdmin:simpletrainer:toggleCarGod", vehicleInvincible)
					SetEntityInvincible(veh, vehicleInvincible)
					SetEntityCanBeDamaged(veh, not vehicleInvincible)
					SetVehicleCanBreak(veh, not vehicleInvincible)
					SetVehicleCanBeVisiblyDamaged(veh, not vehicleInvincible)
					SetVehicleCanDeformWheels(veh, not vehicleInvincible)
				end
			end
		end
	end

	if permissions["trainer.vehicle.clean"] then
		local thisItem = NativeUI.CreateCheckboxItem("Keep Vehicle Clean",keepVehicleClean or false,"") -- create our new item
		vehicleTrainerMenu:AddItem(thisItem) -- thisPlayer is global.
		thisItem.CheckboxEvent = function(sender, item, checked_)
			if item == thisItem then
				keepVehicleClean = checked_
			end
		end

		local thisItem = NativeUI.CreateItem("Clean Vehicle","") -- create our new item
		vehicleTrainerMenu:AddItem(thisItem) -- thisPlayer is global.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			SetVehicleDirtLevel(veh, 0)
			RemoveDecalsFromVehicle(veh)
		end
	end

	
	if permissions["trainer.vehicle.plate"] then
		local thisItem = NativeUI.CreateItem("Change License Plate Text","") -- create our new item
		vehicleTrainerMenu:AddItem(thisItem) -- thisPlayer is global.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			AddTextEntry("CARNAME", "Plate Text")
			DisplayOnscreenKeyboard(1, "CARNAME", "", "", "", "", "", 8)

			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end

			local result = GetOnscreenKeyboardResult()

			if result then
				SetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false), result)
			end
		end
	end

	if permissions["trainer.vehicle.delete"] then
		local thisItem = NativeUI.CreateItem("~r~Delete Vehicle~s~","") -- create our new item
		vehicleTrainerMenu:AddItem(thisItem) -- thisPlayer is global.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			local playerPed = PlayerPedId()
			if IsPedInAnyVehicle(playerPed) then
				SetEntityAsMissionEntity(GetVehiclePedIsIn(playerPed, false), true)
				DeleteEntity(GetVehiclePedIsIn(playerPed, false))
			end
		end
	end

	if permissions["trainer.noclip.self"] then
		local thisItem = NativeUI.CreateItem("Toggle Noclip","")
		trainerMenu:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:simpletrainer:toggleNoclip")
		end
	end

end)

RegisterNetEvent("EasyAdmin:simpletrainer:toggleNoclip")
AddEventHandler("EasyAdmin:simpletrainer:toggleNoclip", function(toggle)
	if toggle == nil then toggle = not NoclipActive end
	if toggle == true then
		NoclipActive = true
	elseif toggle == false then
		NoclipActive = false
		local pPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(pPed, false)
		local vehDriver = GetPedInVehicleSeat(veh, -1)
		local entity = pPed
		if (veh and veh > 0 and vehDriver == pPed) then
			entity = veh
		end
		FreezeEntityPosition(entity, false)
		SetEntityVelocity(entity, 0, 0, 0)
		SetEntityRotation(entity, 0, 0, 0, 0, false)
		SetEntityHeading(entity, heading)
		SetEntityCollision(entity, true, true)
		SetEveryoneIgnorePlayer(pPed, false)
		SetPoliceIgnorePlayer(pPed, false)
		SetEntityInvincible(pPed, false)
	end
end)