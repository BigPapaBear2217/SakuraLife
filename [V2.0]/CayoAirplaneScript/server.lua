local playerGoingToLS
local playerGoingToCayo

local CurrentPlaneGoingToLS = 0
local CurrentPlaneGoingToCayo = 0

local CurrentPlaneLandingSoonLS = 0
local CurrentPlaneLandingSoonCayo = 0

local WaitingPlaneGoingToLS = {}
local WaitingPlaneGoingToCayo = {}

local nimbusPlace = 7 -- (8 - 1 pilot ped)

RegisterServerEvent('CayoPlane2:GeneratePlaneOnRoute')
AddEventHandler('CayoPlane2:GeneratePlaneOnRoute', function(loc)
	-- print("GeneratePlaneOnRoute + 1")
	
	if loc == "LsToCayo" then
		CurrentPlaneGoingToCayo = CurrentPlaneGoingToCayo + 1
	else
		CurrentPlaneGoingToLS = CurrentPlaneGoingToLS + 1
	end
end)

RegisterServerEvent('CayoPlane2:GetPlaneOnRoute')
AddEventHandler('CayoPlane2:GetPlaneOnRoute', function(loc)
	local player = source
	if loc == "LsToCayo" then
		TriggerClientEvent("CayoPlane2:SendRouteCurrentTrafic",player,CurrentPlaneGoingToCayo)
		TriggerClientEvent("notifications", source, "#7b5fdd", "Airline", "Der Flug wird in Kürze beginnen bitte warte etwas ab! - Zielort: Cayo Perico")
	else
		TriggerClientEvent("CayoPlane2:SendRouteCurrentTrafic",player,CurrentPlaneGoingToLS)
		TriggerClientEvent("notifications", source, "#7b5fdd", "Airline", "Der Flug wird in Kürze beginnen bitte warte etwas ab! - Zielort: Los Santos")

	end
end)

RegisterServerEvent('CayoPlane2:PlaneLandOnRoute')
AddEventHandler('CayoPlane2:PlaneLandOnRoute', function(loc)
	-- print("GeneratePlaneOnRoute - 1")
	
	if loc == "LsToCayo" then
		CurrentPlaneGoingToCayo = CurrentPlaneGoingToCayo - 1
		if CurrentPlaneGoingToCayo < 0 then CurrentPlaneGoingToCayo = 0 end
	else
		CurrentPlaneGoingToLS = CurrentPlaneGoingToLS - 1
		if CurrentPlaneGoingToLS < 0 then CurrentPlaneGoingToLS = 0 end
	end
end)






RegisterServerEvent('CayoPlane2:PlaneWillLandSoonOnRoute')
AddEventHandler('CayoPlane2:PlaneWillLandSoonOnRoute', function(loc)
	-- print("PlaneWillLandSoonOnRoute + 1")
	
	if loc == "LsToCayo" then
		CurrentPlaneLandingSoonCayo = CurrentPlaneLandingSoonCayo + 1
	else
		CurrentPlaneLandingSoonLS = CurrentPlaneLandingSoonLS + 1
	end
end)

RegisterServerEvent('CayoPlane2:GetPlaneLandSoonOnRoute')
AddEventHandler('CayoPlane2:GetPlaneLandSoonOnRoute', function(loc)
	local player = source
	if loc == "LsToCayo" then
		TriggerClientEvent("CayoPlane2:SendRouteCurrentTrafic",player,CurrentPlaneLandingSoonCayo)
	else
		TriggerClientEvent("CayoPlane2:SendRouteCurrentTrafic",player,CurrentPlaneLandingSoonLS)
	end
end)

RegisterServerEvent('CayoPlane2:PlaneLeaveOnRoute')
AddEventHandler('CayoPlane2:PlaneLeaveOnRoute', function(loc)
	-- print("PlaneWillLandSoonOnRoute + 1")
	
	if loc == "LsToCayo" then
		CurrentPlaneLandingSoonCayo = CurrentPlaneLandingSoonCayo - 1
		if CurrentPlaneLandingSoonCayo < 0 then CurrentPlaneLandingSoonCayo = 0 end
	else
		CurrentPlaneLandingSoonCayo = CurrentPlaneLandingSoonCayo - 1
		if CurrentPlaneLandingSoonCayo < 0 then CurrentPlaneLandingSoonCayo = 0 end
	end
end)


RegisterServerEvent('CayoPlane2:PlaneNoMoreWaiting')
AddEventHandler('CayoPlane2:PlaneNoMoreWaiting', function(loc)
	-- print("PlaneWillLandSoonOnRoute + 1")
	local player = source
	if loc == "LsToCayo" then
		WaitingPlaneGoingToCayo.actif = false
	else
		WaitingPlaneGoingToLS.actif = false
	end
end)

RegisterServerEvent('CayoPlane2:PlaneDeparture')
AddEventHandler('CayoPlane2:PlaneDeparture', function(loc)
	-- print("PlaneWillLandSoonOnRoute + 1")
	local player = source
	if loc == "LsToCayo" then
		WaitingPlaneGoingToCayo.seatFree = -1
	else
		WaitingPlaneGoingToLS.seatFree = -1
	end
end)

local lstQueueLsToCayo = {}
local QueueLsToCayo = false
local cptTimeoutLsToCayo = {}

local QueueCayoToLs = false
local cptTimeoutCayoToLs = {}

-- Citizen.CreateThread(function()
	-- while true do
		-- Wait(100)
		-- for k,v in pairs(lstQueueLsToCayo)
			
		-- end
	-- end
-- end)

RegisterServerEvent('CayoPlane2:APlayerAskForAplane')
AddEventHandler('CayoPlane2:APlayerAskForAplane', function(loc)
	local player = source
	
	if loc == "LsToCayo" then
		-- print("APlayerAskForAplane : "..tostring(player).." loc: "..tostring(loc).." Queue : "..tostring(QueueLsToCayo))
		Citizen.CreateThread(function()
			cptTimeoutLsToCayo[player] = 0
			while QueueLsToCayo and cptTimeoutLsToCayo[player] < 50 do
				-- print("Queue Active CayoToLs")
				cptTimeoutLsToCayo[player] = cptTimeoutLsToCayo[player] + 1
				Wait(100)
			end
			QueueLsToCayo = true
			if WaitingPlaneGoingToCayo.actif then
				if WaitingPlaneGoingToCayo.seatFree > 0 then
					WaitingPlaneGoingToCayo.seatFree = WaitingPlaneGoingToCayo.seatFree - 1
					TriggerClientEvent("CayoPlane2:GoToPlane",player,loc,WaitingPlaneGoingToCayo.owner,WaitingPlaneGoingToCayo.seatFree)
					-- print(tostring(player).." GoToPlane Cayo => LS seat : "..tostring(WaitingPlaneGoingToCayo.seatFree))
				else
					-- print("avion plein")
					TriggerClientEvent("CayoPlane2:SendMessage",player)
				end
			else
				WaitingPlaneGoingToCayo = {owner = player,seatFree = 6,actif = true}
				TriggerClientEvent("CayoPlane2:CreatePlane",player,loc)
				-- print("Create Plane Cayo => LS : "..tostring(player))
			end
			Wait(250)
			QueueLsToCayo = false
		end)
		
		
		
	else
		-- print("APlayerAskForAplane : "..tostring(player).." loc: "..tostring(loc).." Queue : "..tostring(QueueCayoToLs))
		Citizen.CreateThread(function()
			cptTimeoutCayoToLs[player] = 0
			while QueueCayoToLs and cptTimeoutCayoToLs[player] < 50 do
				-- print("Queue Active CayoToLs")
				cptTimeoutCayoToLs[player] = cptTimeoutCayoToLs[player] + 1
				Wait(100)
			end
			QueueCayoToLs = true
			if WaitingPlaneGoingToLS.actif then
				if WaitingPlaneGoingToLS.seatFree > 0 then
					WaitingPlaneGoingToLS.seatFree = WaitingPlaneGoingToLS.seatFree - 1
					TriggerClientEvent("CayoPlane2:GoToPlane",player,loc,WaitingPlaneGoingToLS.owner,WaitingPlaneGoingToLS.seatFree)
					-- print("GoToPlane Cayo => LS : "..tostring(player))
				else
					-- print("avion plein")
					TriggerClientEvent("CayoPlane2:SendMessage",player)
				end
			else
				WaitingPlaneGoingToLS = {owner = player,seatFree = 6,actif = true}
				TriggerClientEvent("CayoPlane2:CreatePlane",player,loc)
				-- print("Create Plane Cayo => LS : "..tostring(player))
			end
			Wait(250)
			QueueCayoToLs = false
		end)
	end
end)




RegisterServerEvent('CayoPlane2:GetOut')
AddEventHandler('CayoPlane2:GetOut', function(lstPlayer,plane,loc)
	for k,v in pairs(lstPlayer) do
		-- print("k: "..tostring(k).." v : "..tostring(v).." ply: "..tostring(GetPlayerFromIndex(v)))
		TriggerClientEvent("CayoPlane2:CliGetOut",v,plane,loc)
		Wait(600)
	end
end)