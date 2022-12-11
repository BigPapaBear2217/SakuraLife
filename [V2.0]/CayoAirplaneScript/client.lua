local DepartureWaitingTime = 90000
local LsToCayo = {
	spawn = {x=-1625.5147705078,y=-3098.7373046875,z=13.944752693176,h=0.0},
	runaway1 = {x=-1573.2882080078,y=-3006.8564453125,z=13.988744735718},
	runaway2 = {x=-1478.9229736328,y=-3061.1530761719,z=13.945302963257},
	runaway3 = {x=-1102.6927490234,y=-3278.5666503906,z=13.969525337219},
	
	waitingZone = {x=6894.5751953125,y=-3078.2177734375,z=500.9924926758},
	
	coords1 = {x=5639.75390625,y=-4067.2653808594,z=209.5955657959},
	
	prepiste = {x=4652.326171875,y=-4434.9467773438,z=48.496124267578},
	ralenti1 = {x=4392.8046875,y=-4531.3842773438,z=14.1824145317078},

	startPiste = {x=4265.1352539062,y=-4577.9541015625,z=4.1786708831787},
	endPiste = {x=4024.3188476562,y=-4666.203125,z=4.1806936264038},
	
	postpos= {x=3443.3332519531,y=-4875.0,z=324.49307250977},
	planeModel = "nimbus",
	seatpos = 6,
	seatfree = 7
}


local CayoToLs = {
	spawn = {x=4483.6806640625,y=-4457.1806640625,z=4.2489228248596,h=203.0},
	runaway1 = {x=4491.8325195312,y=-4479.1772460938,z=4.2097730636597},
	runaway2 = {x=4417.517578125,y=-4522.4619140625,z=4.1856665611267},
	runaway3 = {x=4100.3232421875,y=-4638.4995117188,z=9.1777400970459},


	waitingZone = {x=1962.4291992188,y=-5950.462890625,z=500.978515625},
	
	coords1 = {x=-2354.5300292969,y=-4128.8217773438,z=292.24523925781},
	
	prepiste = {x=-1839.1975097656,y=-3088.154296875,z=41.114265441895},
	ralenti1 = {x=-1692.2683105469,y=-2830.8784179688,z=24.21459197998},

	startPiste = {x=-1630.8223876953,y=-2720.9140625,z=13.94464969635},
	endPiste = {x=-1505.4873046875,y=-2503.9028320312,z=13.944483757019},
	
	postpos= {x=-873.75518798828,y=-1385.5537109375,z=327.68463134766},
	planeModel = "nimbus",
	seatpos = 6,
	seatfree = 7
}

-- Citizen.CreateThread(function()
	-- for k,v in pairs(CayoToLs) do
		-- print("k : "..tostring(k).." v: "..tostring(v))
		-- if k ~= "planeModel" and k ~= "seatpos" and k ~= "seatfree" then
		-- local blip = AddBlipForCoord(v.x, v.y, v.z-1.0)
		-- SetBlipSprite(blip, 1)
		-- SetBlipDisplay(blip, 4)
		-- SetBlipScale(blip, 0.9)
		-- SetBlipColour(blip, 1)
		-- SetBlipAsShortRange(blip, true)
		-- BeginTextCommandSetBlipName("STRING")
		-- AddTextComponentString(tostring(k))
		-- EndTextCommandSetBlipName(blip)
		-- end
	-- end
-- end)

-- Citizen.CreateThread(function()
	-- for k,v in pairs(LsToCayo) do
		-- print("k : "..tostring(k).." v: "..tostring(v))
		-- if k ~= "planeModel" and k ~= "seatpos" and k ~= "seatfree" then
		-- local blip = AddBlipForCoord(v.x, v.y, v.z-1.0)
		-- SetBlipSprite(blip, 1)
		-- SetBlipDisplay(blip, 4)
		-- SetBlipScale(blip, 0.9)
		-- SetBlipColour(blip, 2)
		-- SetBlipAsShortRange(blip, true)
		-- BeginTextCommandSetBlipName("STRING")
		-- AddTextComponentString(tostring(k))
		-- EndTextCommandSetBlipName(blip)
		-- end
	-- end
-- end)

RegisterCommand("GoToCayo", function(source, args, fullCommand)
    -- MenuV:OpenMenu(menu)
	-- TriggerEvent("CayoPlane2:GeneratePlane")
	-- TriggerServerEvent("CayoPlane2:APlayerAskForAplane","CayoToLs")
	TriggerServerEvent("CayoPlane2:APlayerAskForAplane","LsToCayo")
end, false)

RegisterCommand("GoToLS", function(source, args, fullCommand)
    -- MenuV:OpenMenu(menu)
	-- TriggerEvent("CayoPlane2:GeneratePlane")
	TriggerServerEvent("CayoPlane2:APlayerAskForAplane","CayoToLs")
	-- TriggerServerEvent("CayoPlane2:APlayerAskForAplane","LsToCayo")
end, false)




function loadPedAndPlane(plane)
	-- print("loadPedAndPlane")
	RequestModel(GetHashKey(plane))
	cpt = 0 
	timeout = true
    while not HasModelLoaded(GetHashKey(plane)) and timeout do
        Wait(1000)
		RequestModel(GetHashKey(plane))
		cpt = cpt + 1
		if cpt > 50 then timeout = false end
    end
	
	-- print("cuban800 loaded")
	
	RequestModel(GetHashKey("s_m_m_pilot_01"))
	cpt = 0 
	timeout = true
    while not HasModelLoaded(GetHashKey("s_m_m_pilot_01")) and timeout do
        Wait(1000)
		RequestModel(GetHashKey("s_m_m_pilot_01"))
		cpt = cpt + 1
		if cpt > 50 then timeout = false end
    end
	-- print("pilot loaded")
end

function reqControl(veh)
	NetworkRequestControlOfEntity(veh)
	cpt = 0
	-- print("Request control : "..tostring(NetworkHasControlOfEntity(veh)))
	while not (NetworkHasControlOfEntity(veh)) do -- pas le control cpt inf a 50
		Wait(0)
		--print("Request control : "..tostring(NetworkHasControlOfEntity(veh)))
		NetworkRequestControlOfEntity(veh)
		cpt = cpt +1
		if cpt > 50 then
		break;
		end
	end
	-- print("Request control : "..tostring(NetworkHasControlOfEntity(veh)))
end

getTrafficAnswerded = false
traffic = 0

RegisterNetEvent("CayoPlane2:SendRouteCurrentTrafic")
AddEventHandler('CayoPlane2:SendRouteCurrentTrafic', function(nb)
	-- print("received traffic")
	getTrafficAnswerded = true
	traffic = nb
end)

RegisterNetEvent("CayoPlane2:ReqcontrolEvent")
AddEventHandler('CayoPlane2:ReqcontrolEvent', function(ent)
	Citizen.CreateThread(function()
		reqControl(ent)
	end)
end)

RegisterNetEvent("CayoPlane2:CreatePlane")
AddEventHandler('CayoPlane2:CreatePlane', function(loc)
	Citizen.CreateThread(function()
		
		if loc == "LsToCayo" then
		d = LsToCayo
		else
		d = CayoToLs
		end
		DoScreenFadeOut(50)
		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end
		loadPedAndPlane(d.planeModel)
		SetEntityCoords(PlayerPedId(),d.spawn.x,d.spawn.y,d.spawn.z)
		Wait(300)
		local plane = CreateVehicle(GetHashKey(d.planeModel),d.spawn.x,d.spawn.y,d.spawn.z,d.spawn.h,true,true)
		local pilot = CreatePedInsideVehicle(plane,5,GetHashKey("s_m_m_pilot_01"),-1,true,true)
		SetEntityInvincible(pilot,true)
		SetEntityAsMissionEntity(plane,true,true)
		SetVehicleEngineOn(plane, true, true, true)
		SetEntityProofs(plane, true, true, true, true, true, true, true, false)
		SetVehicleHasBeenOwnedByPlayer(plane, true)
		
		-- print("plane created : "..tostring(plane).." at coords : "..tostring(randX).." "..tostring(randY).." ped : "..tostring(pilot))
		SetBlockingOfNonTemporaryEvents(pilot, true)
		
		SetPedIntoVehicle(PlayerPedId(),plane,d.seatpos)
		SetVehicleDoorsLockedForAllPlayers(plane,true)
		SetVehicleDoorsLocked(plane, 2)
		SetVehicleDoorsLocked(plane, 4)
		DoScreenFadeIn(250)
		local curCreatedTime = GetGameTimer() --10000
		local waiting = true
		while waiting do
			Wait(50)
			curTime = GetGameTimer()
			-- print("waiting : "..tostring(DepartureWaitingTime-(curTime - curCreatedTime)))
			if (curTime - curCreatedTime) > DepartureWaitingTime then
				waiting = false
			end
		end
		TriggerServerEvent("CayoPlane2:PlaneDeparture",loc)
		
		
		
		TaskVehicleDriveToCoord(pilot, plane, d.runaway1.x, d.runaway1.y, d.runaway1.z, 7.0, 0, GetEntityModel(plane), 786603, 2.0)
		local runAway1Achieved = false
		while not runAway1Achieved do
			Wait(250)
			--print("Vdist1 : "..tostring(Vdist(GetEntityCoords(plane),vector3(planeData.prepos1.x,planeData.prepos1.y,planeData.prepos1.z))))
			if Vdist(GetEntityCoords(plane),vector3(d.runaway1.x, d.runaway1.y, d.runaway1.z)) < 15.0 then
				runAway1Achieved = true
			end
		end
		
		-- print("RunAway1 done")
		
		TaskVehicleDriveToCoord(pilot, plane, d.runaway2.x, d.runaway2.y, d.runaway2.z, 7.0, 0, GetEntityModel(plane), 786603, 2.0)
		local runAway2Achieved = false
		while not runAway2Achieved do
			Wait(250)
			--print("Vdist1 : "..tostring(Vdist(GetEntityCoords(plane),vector3(planeData.prepos1.x,planeData.prepos1.y,planeData.prepos1.z))))
			if Vdist(GetEntityCoords(plane),vector3(d.runaway2.x, d.runaway2.y, d.runaway2.z)) < 15.0 then
				runAway2Achieved = true
			end
		end
		
		-- print("RunAway2 done")
		
		TaskVehicleDriveToCoord(pilot, plane, d.runaway3.x, d.runaway3.y, d.runaway3.z, 8.0, 0, GetEntityModel(plane), 786603, 2.0)
		local runAway3Achieved = false
		local cptVitesse = 0 
		while not runAway3Achieved do
			
			cptVitesse = cptVitesse + 3
			TaskVehicleDriveToCoord(pilot, plane, d.runaway3.x, d.runaway3.y, d.runaway3.z, 9.0+cptVitesse, 0, GetEntityModel(plane), 786603, 2.0)
			Wait(750)
			-- print("Vdist1 : "..tostring(Vdist(GetEntityCoords(plane),vector3(d.runaway3.x, d.runaway3.y, d.runaway3.z))).." speed: "..tostring(9.0+cptVitesse))
			if Vdist(GetEntityCoords(plane),vector3(d.runaway3.x, d.runaway3.y, d.runaway3.z)) < 35.0 then
				runAway3Achieved = true
			end
		end
		
		-- print("RunAway3 done")
		TaskPlaneMission(pilot, plane, 0, 0, d.waitingZone.x,	d.waitingZone.y,	d.waitingZone.z, 6, GetVehicleModelMaxSpeed(GetHashKey(d.planeModel)),0,d.waitingZone.h,1000.0,150.0)
		SetPedKeepTask(pilot, true)
		Wait(3000)
		ControlLandingGear(plane, 1)
		
		TriggerServerEvent("CayoPlane2:PlaneNoMoreWaiting",loc)
		
		
		
		TriggerServerEvent("CayoPlane2:GeneratePlaneOnRoute",loc)
		Wait(250)
		TriggerServerEvent("CayoPlane2:GetPlaneOnRoute")
		getTrafficAnswerded = false
		while not getTrafficAnswerded do
			Wait(10)
		end
		-- print("Current Trafic : "..traffic)
		Wait(250)
		
		
		
		
		
		local prepos1Achieved = false
		while not prepos1Achieved do
			Wait(250)
			--print("Vdist1 : "..tostring(Vdist(GetEntityCoords(plane),vector3(planeData.prepos1.x,planeData.prepos1.y,planeData.prepos1.z))))
			if Vdist(GetEntityCoords(plane),vector3(d.waitingZone.x,d.waitingZone.y,d.waitingZone.z)) < 140.0 then
				prepos1Achieved = true
			end
		end
		
		waitingTime = ((traffic-1)*2) * 15000
		Wait(waitingTime)
		-- print("Waiting Zone Finish: ")
		
		TaskPlaneMission(pilot, plane, 0, 0, d.coords1.x,d.coords1.y,d.coords1.z, 6, GetVehicleModelMaxSpeed(GetHashKey(d.planeModel)),0,d.coords1.h,5.0,40.0)
		local prepos2Achieved = false
		while not prepos2Achieved do
			Wait(250)
			--print("Vdist1 : "..tostring(Vdist(GetEntityCoords(plane),vector3(planeData.prepos1.x,planeData.prepos1.y,planeData.prepos1.z))))
			if Vdist(GetEntityCoords(plane),vector3(d.coords1.x,d.coords1.y,d.coords1.z)) < 140.0 then
				prepos2Achieved = true
			end
		end
		-- print("Coords1 Finish")
		
		
		TaskVehicleDriveToCoord(pilot, plane, d.prepiste.x,d.prepiste.y,d.prepiste.z, 50.0, 0, GetEntityModel(plane), 786603, 15.0)
		local preposAchieved = false
		while not preposAchieved do
			Wait(250)
			--print("Vdist2 : "..tostring(Vdist(GetEntityCoords(plane),vector3(planeData.prepos2.x,planeData.prepos2.y,planeData.prepos2.z))))
			if Vdist(GetEntityCoords(plane),vector3(d.prepiste.x,d.prepiste.y,d.prepiste.z)) < 140.0 then
				preposAchieved = true
			end
		end
		-- print("Approch Finish")
		
		TaskVehicleDriveToCoord(pilot, plane, d.ralenti1.x,d.ralenti1.y,d.ralenti1.z, 50.0, 0, GetEntityModel(plane), 786603, 15.0)
		prepos2Achieved = false
		local cptVitesse = 0
		local lastKnownSpeed = 0
		while not prepos2Achieved do
			Wait(1000)
			cptVitesse = cptVitesse + 3
			TaskVehicleDriveToCoord(pilot, plane, d.ralenti1.x,d.ralenti1.y,d.ralenti1.z, (30.0-cptVitesse)+20.0, 0, GetEntityModel(plane), 786603, 15.0)
			lastKnownSpeed = (30.0-cptVitesse)+20.0
			-- print("Vdist2 : "..tostring(Vdist(GetEntityCoords(plane),vector3(d.ralenti1.x,d.ralenti1.y,d.ralenti1.z))).." speed:"..tostring((30.0-cptVitesse)+20.0))
			if Vdist(GetEntityCoords(plane),vector3(d.ralenti1.x,d.ralenti1.y,d.ralenti1.z)) < 140.0 then
				prepos2Achieved = true
			end
		end
		-- print("Ralenti Finish")
		TaskPlaneLand(pilot,plane,d.startPiste.x,d.startPiste.y,d.startPiste.z,d.endPiste.x,d.endPiste.y,d.endPiste.z)
		SetPedKeepTask(pilot)
		while IsEntityInAir(plane) do
			Wait(5)
		end
		TaskVehicleTempAction(pilot, plane, 27, -1)
		Wait(3500)
		TaskVehicleTempAction(pilot, plane, 6, 2000)
		SetEntityVelocity(plane,0.0,0.0,0.0)
		FreezeEntityPosition(plane,true)
		SetVehicleHandbrake(plane, true)
		Wait(2000)
		
		local lstPlayer = {}
		
		
		
		
		for i=0,5 do
		local curPlayer = GetPedInVehicleSeat(plane,i)
		-- print("i : "..tostring(i).." curPlayer: "..tostring(curPlayer))
		if curPlayer ~= 0 then
			
			-- local pid = NetworkGetPlayerIndexFromPed(curPlayer)
			local pid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(curPlayer))
			-- print("pid : "..tostring(pid).." curPlayer: "..tostring(curPlayer))
			lstPlayer[#lstPlayer+1] = pid
			end
		end
		local entId = NetworkGetNetworkIdFromEntity(plane)
		-- print("plane id : "..tostring(entId))
		TriggerServerEvent("CayoPlane2:GetOut",lstPlayer,entId,loc)
		
		-- TriggerServerEvent("CayoPlane2:GetOut",lstPlayer,NetworkGetNetworkIdFromEntity(plane))
		-- for i=0,6 do
			-- local curPlayer = GetPedInVehicleSeat(plane,i)
			-- if curPlayer ~= 0 then
				-- local pid = NetworkGetPlayerIndexFromPed(curPlayer)
				-- lstPlayer[#lstPlayer+1] = pid
			-- end
		-- end
		-- NetworkGetPlayerIndexFromPed
		Wait(4000)
		TaskLeaveVehicle(PlayerPedId(), plane, 0)
		-- WriteSubtitle("Votre voiture vous attends. C'était un voyage agréable en votre compagnie. Passez un bon séjour !",5500)
		-- Wait(5500)
		if loc == "CayoToLs" then
			while IsPedInAnyVehicle(PlayerPedId()) do
				Wait(200)
			end
			Wait(100)
			DoScreenFadeOut(250)
			while not IsScreenFadedOut() do
				Citizen.Wait(0)
			end
			Wait(500)
			SetEntityAsNoLongerNeeded(pilot)
			SetEntityAsNoLongerNeeded(plane)
			TriggerEvent("CayoPlane2:ReqcontrolEvent",pilot)
			TriggerEvent("CayoPlane2:ReqcontrolEvent",plane)
			DeleteEntity(plane)
			DeleteEntity(pilot)
			Wait(1000)
			SetEntityCoords(PlayerPedId(),Config.TPout.x,Config.TPout.y,Config.TPout.z)
			DoScreenFadeIn(250)
			TriggerServerEvent("CayoPlane2:PlaneLandOnRoute",loc)
			
			
			
			
		else
			SetVehicleDoorsLocked(plane, 2)
			SetEntityAsNoLongerNeeded(pilot)
			SetEntityAsNoLongerNeeded(plane)
			Wait(1000)
			SetVehicleDoorsShut(plane,false)
			SetVehicleDoorShut(plane,1,false)
			Wait(15000)
			TriggerServerEvent("CayoPlane2:PlaneLandOnRoute",loc)
			FreezeEntityPosition(plane,false)
			TaskPlaneMission(pilot, plane, 0, 0, d.postpos.x,	d.postpos.y,	d.postpos.z, 6, GetVehicleModelMaxSpeed(GetHashKey(d.planeModel))/3,0,0.0,5.0,40.0)
			Wait(10000)
			TriggerEvent("CayoPlane2:ReqcontrolEvent",pilot)
			TriggerEvent("CayoPlane2:ReqcontrolEvent",plane)
			
			DeleteEntity(plane)
			DeleteEntity(pilot)
		end
		
		
	end)
end)


function WriteSubtitle(texte,waitTime)
	BeginTextCommandPrint("STRING")
	AddTextComponentSubstringPlayerName(texte)
	-- Wait(waitTime)
	EndTextCommandPrint(math.floor(waitTime), false)
	Wait(waitTime)
end

RegisterNetEvent("CayoPlane2:SendMessage")
AddEventHandler('CayoPlane2:SendMessage', function()
	WriteSubtitle("Avion plein",2500)
end)


RegisterNetEvent("CayoPlane2:GoToPlane")
AddEventHandler('CayoPlane2:GoToPlane', function(loc,player,seatfree)
	Citizen.CreateThread(function()
		
		DoScreenFadeOut(50)
		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end
		-- print("GoToPlane :"..tostring(seatfree))
		if loc == "LsToCayo" then
			d = LsToCayo
		else
			d = CayoToLs
		end
		
		-- loadPedAndPlane(d.planeModel)
		SetEntityCoords(PlayerPedId(),d.spawn.x,d.spawn.y,d.spawn.z-3.0)
		FreezeEntityPosition(PlayerPedId(),true)
		-- Wait(1000)
		Wait(1500)
		-- local plane = CreateVehicle(GetHashKey(d.planeModel),d.spawn.x,d.spawn.y,d.spawn.z,d.spawn.h,true,true)
		-- local pilot = CreatePedInsideVehicle(plane,5,GetHashKey("s_m_m_pilot_01"),-1,true,true)
		
		-- SetEntityAsMissionEntity(plane,true,true)
		-- SetVehicleEngineOn(plane, true, true, true)
		-- SetEntityProofs(plane, true, true, true, true, true, true, true, false)
		-- SetVehicleHasBeenOwnedByPlayer(plane, true)
		
		-- print("plane created : "..tostring(plane).." at coords : "..tostring(randX).." "..tostring(randY).." ped : "..tostring(pilot))
		-- SetBlockingOfNonTemporaryEvents(pilot, true)
		--print("ServerId : "..tostring(player))
		--print("Player : "..tostring(GetPlayerFromServerId(player)))
		plane = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(player)),false)
		--print("plane : "..tostring(plane))
		--freeSeat = 0
		--for i=0,7 do
		--	print("i : "..tostring(i).." "..tostring(IsVehicleSeatFree(plane,i)))
		--	if IsVehicleSeatFree(plane,i) then
		--		print("free")
		--		freeSeat = i
		--		break;
		--	end
		--end
		---- if freeSeat ~= 0 then
		--	print("set ped intovehicle")
		FreezeEntityPosition(PlayerPedId(),false)
		SetPedIntoVehicle(PlayerPedId(),plane,seatfree)
		-- end
		FreezeEntityPosition(PlayerPedId(),false)
		Wait(500)
		DoScreenFadeIn(250)
		-- SetVehicleDoorsLockedForAllPlayers(plane,true)
		-- SetVehicleDoorsLocked(plane, 2)
		-- SetVehicleDoorsLocked(plane, 4)
		
	end)
end)


RegisterNetEvent("CayoPlane2:TeleportToPlane")
AddEventHandler('CayoPlane2:TeleportToPlane', function()
	Citizen.CreateThread(function()
		
		
		
	end)
end)

RegisterNetEvent("CayoPlane2:AskForAPlane")
AddEventHandler('CayoPlane2:AskForAPlane', function()
	Citizen.CreateThread(function()
		
		
		
	end)
end)

RegisterNetEvent("CayoPlane2:CliGetOut")
AddEventHandler('CayoPlane2:CliGetOut', function(plane,loc)
	-- print("get out plane :"..tostring(plane).." entity : "..tostring(NetworkGetEntityFromNetworkId(plane)))
	
	TaskLeaveVehicle(PlayerPedId(), NetworkGetEntityFromNetworkId(plane), 0)
	if loc == "CayoToLs" then
		while IsPedInAnyVehicle(PlayerPedId()) do
			Wait(200)
		end
		Wait(100)
		DoScreenFadeOut(250)
		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end
		Wait(1000)
		SetEntityCoords(PlayerPedId(),Config.TPout.x,Config.TPout.y,Config.TPout.z)
		DoScreenFadeIn(250)
	end
end)



function DisplayHelpText(text)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	for _, item in pairs(Config.CayoPlane) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
	  SetBlipScale(item.blip, item.scale)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
	local markerRotate = 0.0
    while true do
		Wait(0)
        local pos = GetEntityCoords(PlayerPedId(), true)
		markerRotate = markerRotate + 1.0
		if markerRotate>360.0 then markerRotate = 0 end
        for k,v in ipairs(Config.CayoPlane) do
            if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 55.0)then
				
                DrawMarker(7, v.x, v.y,v.z-0.5,0, 0,   0,   0,   0,    0+markerRotate,  2.01, 2.01,    2.01, 50, 250,   50,128, 1, 0, 0,0)
				DrawMarker(1, v.x, v.y,v.z-1,0, 0,   0,   0,   0,    0,  2.01, 2.01,    0.21, 50, 250,   50,128, 0, 0, 0,0)
				
                if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
                    if (incirclePlane == false) then
                        DisplayHelpText(Config.Text.DisplayHelp)
                    end
                    incirclePlane = true
                    if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN
                        TriggerServerEvent("CayoPlane2:APlayerAskForAplane",v.Dest)
						Wait(500)
                    end
                elseif(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) > 3.0)then
                    incirclePlane = false
                end
            end
        end
	end
end)