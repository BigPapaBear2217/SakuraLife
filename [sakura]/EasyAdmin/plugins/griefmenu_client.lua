
-- EasyAdmin Plugin Example, this allows injecting new UI Elements directly into EasyAdmin Menus, see NativeUILua Docs on Guides how to add new Items, below is an example code.

AddEventHandler("EasyAdmin:BuildPlayerOptions", function(playerId) -- BuildPlayerOptions is triggered after building options like kick, ban.. Passes a Player ServerId

	local thisGriefMenu = _menuPool:AddSubMenu(thisPlayer,"~g~Grief Menu~n~","",true) -- Submenus work, too!
	thisGriefMenu:SetMenuWidthOffset(menuWidth)

	if permissions["griefing.truck"] then
		local thisItem = NativeUI.CreateItem('"The Truck Punchline"',"")
		thisGriefMenu:AddItem(thisItem) -- Items dont require a trigger.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:griefmenu:TruckPunchline", playerId)
		end
	end

	if permissions["griefing.flashbang"] then
		local thisItem = NativeUI.CreateItem('Flashbang.',"")
		thisGriefMenu:AddItem(thisItem) -- Items dont require a trigger.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:griefmenu:Flashbang", playerId)
		end
	end

	if permissions["griefing.clowns"] then
		local thisItem = NativeUI.CreateItem('Clown Gang Attack.',"Attacks Player with a Van full of clowns.")
		thisGriefMenu:AddItem(thisItem) -- Items dont require a trigger.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:griefmenu:ClownAttack", playerId)
		end
	end

	if permissions["griefing.drug"] then
		local thisItem = NativeUI.CreateItem("Drug Player","")
		thisGriefMenu:AddItem(thisItem) -- Items dont require a trigger.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:griefmenu:DrugPlayer", playerId)
		end
	end

	if permissions["griefing.lag"] then
		local thisItem = NativeUI.CreateItem("~y~Lag Game","")
		thisGriefMenu:AddItem(thisItem) -- Items dont require a trigger.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:griefmenu:LagGame", playerId)
		end
	end

	if permissions["griefing.crash"] then
		local thisItem = NativeUI.CreateItem("~r~Crash Game","")
		thisGriefMenu:AddItem(thisItem) -- Items dont require a trigger.
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:griefmenu:CrashGame", playerId)
		end
	end
end)


AddEventHandler("EasyAdmin:BuildCachedOptions", function(playerId) -- Options for Cached Players, do note that these do not not support Player natives! They're cached BY EASYADMIN
end)

AddEventHandler("EasyAdmin:BuildServerManagementOptions", function() -- Options for the Server Management Submenu, passes nothing.
end)

AddEventHandler("EasyAdmin:BuildSettingsOptions", function() -- Options for the Settings Page, once again, passes nothing
end)

RegisterNetEvent("EasyAdmin:griefmenu:DrugPlayer")
AddEventHandler("EasyAdmin:griefmenu:DrugPlayer", function()

	local playerPed = PlayerPedId()
  
    RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
    while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
      Citizen.Wait(0)
    end    

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator3")
    SetPedMotionBlur(playerPed, true)
    SetPedIsDrunk(playerPed, true)
    AnimpostfxPlay("HeistCelebPass", 60000, true)
	SetPedMovementClipset(playerPed, "MOVE_M@DRUNK@VERYDRUNK", true)
    ShakeGameplayCam("DRUNK_SHAKE", 3.0)
	
    Citizen.Wait(60000)

    SetPedIsDrunk(playerPed, false)		
	SetPedMoveRateOverride(playerPed,1.0)
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(playerPed)
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)


end)

Citizen.CreateThread(function()
	RegisterNetEvent("EasyAdmin:griefmenu:TruckPunchline")
	AddEventHandler("EasyAdmin:griefmenu:TruckPunchline", function()

		local playerPed = PlayerPedId()
		local pCoords = GetEntityCoords(playerPed)
		local pRot = GetEntityRotation(playerPed)

		RequestModel("rubble")

		repeat
			Wait(10)
		until HasModelLoaded("rubble")

		FreezeEntityPosition(playerPed, true)
		if IsPedInAnyVehicle(playerPed, false) then
			FreezeEntityPosition(GetVehiclePedIsIn(playerPed, false), true)
		end

		local arrowSpawn = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.0)
		local vehSpawn = GetOffsetFromEntityInWorldCoords(playerPed, -10.0, 0.0, 0.0)

		local veh = CreateVehicle("rubble", vehSpawn, pRot.z-90, true, false)
		DisableVehicleWorldCollision(veh)
		SetEntityCoords(veh, vehSpawn, 0.0, 0.0, pRot.z-90.0, true)
		FreezeEntityPosition(veh, true)

		local i=1
		local loop = 0
		local draw=true
		repeat 
			i=i+1
			if i == 1 then
				draw = true
			elseif i == 80 then
				draw = false
			elseif i == 160 then
				draw = false
				loop=loop+1
				i=0
			end
			if draw then
				DrawMarker(21, arrowSpawn.x, arrowSpawn.y, arrowSpawn.z+0.5, 0.0, 0.0, 0.0, 		0.0, 270.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 160, false, true, 2)
			end

			Wait(0)
		until (loop == 3)


		FreezeEntityPosition(veh, false)
		SetEntityRotation(veh, 0.0, 0.0, pRot.z-90.0, 0, true)
		SetVehicleForwardSpeed(veh, 80.0)
		FreezeEntityPosition(playerPed, false)
		if IsPedInAnyVehicle(playerPed, false) then
			FreezeEntityPosition(GetVehiclePedIsIn(playerPed, false), false)
		end

		Wait(6000)
		SetEntityAsMissionEntity(veh, true,true)
		DeleteEntity(veh)
		FreezeEntityPosition(playerPed, false)
	end)

end)

RegisterNetEvent("EasyAdmin:griefmenu:ClownAttack")
AddEventHandler("EasyAdmin:griefmenu:ClownAttack", function()

	local playerPed = PlayerPedId()
	local pCoords = GetEntityCoords(playerPed)

	RequestModel("speedo2")

	repeat
		Wait(10)
	until HasModelLoaded("speedo2")

	RequestModel("s_m_y_clown_01")

	repeat
		Wait(10)
	until HasModelLoaded("s_m_y_clown_01")

	repeat
		found, SpawnCoords = FindSpawnPointInDirection(pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, 100.0)
		Wait(100)
	until found

	local veh = CreateVehicle("speedo2", SpawnCoords, 0, true, false)
	SetVehicleModKit(veh, 0)
	SetVehicleMod(veh, 11, 4, false)
	SetVehicleMod(veh, 12, 4, false)
	SetVehicleMod(veh, 13, 4, false)
	ToggleVehicleMod(veh, 18, true)

	AddRelationshipGroup("CLOWNS")
	AddRelationshipGroup("ASSASINTARGET")
	SetPedRelationshipGroupHash(playerPed, "ASSASINTARGET")
	SetRelationshipBetweenGroups(5, "CLOWNS", "ASSASINTARGET")
	SetRelationshipBetweenGroups(0, "CLOWNS", "CLOWNS")
	local peds = {}
	for i=-1, 4 do
		local ped = CreatePedInsideVehicle(veh,"WHATEVER", "s_m_y_clown_01", i, true, false)
		table.insert(peds, ped)
		GiveWeaponToPed(ped, "weapon_microsmg", 999, false, true)
		SetPedRelationshipGroupDefaultHash(ped, "CLOWNS")
		SetPedRelationshipGroupHash(ped, "CLOWNS")
		SetPedCombatAbility(ped, 2)
		SetPedCombatMovement(ped, 3)
		SetPedCombatRange(ped, 2)
		SetPedCombatAttributes(ped, 46, true)
		SetPedCombatAttributes(ped, 2, true)
		SetPedCombatAttributes(ped, 3, false)
		TaskCombatPed(ped, playerPed, veh, 0.0)
	end

	local allPedsDead
	repeat 
		Wait(100)
		local alivePeds = {}
		for i, ped in pairs(peds) do
			if not IsPedDeadOrDying(ped, true) then
				table.insert(alivePeds,ped)
			end
		end
		if #alivePeds == 0 then
			allPedsDead = true
		end
	until (IsPedDeadOrDying(PlayerPedId(), true) or allPedsDead)

	for i, ped in pairs(peds) do
		if not IsPedDeadOrDying(ped, true) then
			ClearPedTasks(ped)
			TaskVehicleDriveWander(ped, veh, 60.0, 524860)
			SetPedAsNoLongerNeeded(ped)
		else
			SetPedAsNoLongerNeeded(ped)
		end
		SetVehicleAsNoLongerNeeded(veh)
		SetModelAsNoLongerNeeded("speedo2")
		SetModelAsNoLongerNeeded("s_m_y_clown_01")
	end

end)

RegisterNetEvent("EasyAdmin:griefmenu:Flashbang")
AddEventHandler("EasyAdmin:griefmenu:Flashbang", function()
	SetTimecycleModifier("BarryFadeOut"); 
	SetTimecycleModifierStrength(1.0)
	intensity = 1.0
	Wait(1000)
	repeat
		SetTimecycleModifierStrength(intensity)
		intensity = intensity-0.01
		Wait(50)
	until intensity <= 0.1
	
	ClearTimecycleModifier()

end)



RegisterNetEvent("EasyAdmin:griefmenu:CrashGame")
AddEventHandler("EasyAdmin:griefmenu:CrashGame", function()
	--rip, someone doesnt like us.
	repeat
		
	until false
end)

Citizen.CreateThread(function()
	stopGrief = false
	griefRunning = false
	RegisterNetEvent("EasyAdmin:griefmenu:LagGame")
	AddEventHandler("EasyAdmin:griefmenu:LagGame", function()
		--rip, someone doesnt like us.
		if griefRunning then
			stopGrief = true
			griefRunning = false
			return
		elseif stopGrief then
			stopGrief = false
		end
		griefRunning = true
		repeat
			for i=1,100000 do
				GetPlayerPed(PlayerId())
			end
		Wait(0)
		until stopGrief
	end)
end)