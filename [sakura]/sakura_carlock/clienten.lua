ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

local PlayerData                = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


RegisterNetEvent('esx_carlock:lock')
AddEventHandler('esx_carlock:lock', function()
	local coords = GetEntityCoords(GetPlayerPed(-1))
	local hasAlreadyLocked = false
	cars = ESX.Game.GetVehiclesInArea(coords, 3)
	local carstrie = {}
	local cars_dist = {}		
	notowned = 0
	if #cars == 0 then
		--exports['grv_notify']:SendAlert('error', 'Kein Fahrzeug in der Nähe')
	else
		for j=1, #cars, 1 do
			local coordscar = GetEntityCoords(cars[j])
			local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
			table.insert(cars_dist, {cars[j], distance})
		end
		for k=1, #cars_dist, 1 do
			local z = -1
			local distance, car = 999
			for l=1, #cars_dist, 1 do
				if cars_dist[l][2] < distance then
					distance = cars_dist[l][2]
					car = cars_dist[l][1]
					z = l
				end
			end
			if z ~= -1 then
				table.remove(cars_dist, z)
				table.insert(carstrie, car)
			end
		end
		for i=1, #carstrie, 1 do
			local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
			ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owner)
				if owner and hasAlreadyLocked ~= true then
					local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
					vehicleLabel = GetLabelText(vehicleLabel)
					local lock = GetVehicleDoorLockStatus(carstrie[i])
					if lock == 1 or lock == 0 then
						SetVehicleDoorShut(carstrie[i], 0, false)
						SetVehicleDoorShut(carstrie[i], 1, false)
						SetVehicleDoorShut(carstrie[i], 2, false)
						SetVehicleDoorShut(carstrie[i], 3, false)
						SetVehicleDoorsLocked(carstrie[i], 2)
						PlayVehicleDoorCloseSound(carstrie[i], 1)
						TriggerEvent("ot-notify:notify", "#ab0503", "INFORMATION", "Fahrzeug abgeschlossen")
	  
						if not IsPedInAnyVehicle(PlayerPedId(), true) then
									  
						end
						SetVehicleLights(carstrie[i], 2)
						Citizen.Wait(150)
						SetVehicleLights(carstrie[i], 0)
						Citizen.Wait(150)
						SetVehicleLights(carstrie[i], 2)
						Citizen.Wait(150)
						SetVehicleLights(carstrie[i], 0)
						hasAlreadyLocked = true
					elseif lock == 2 then
						SetVehicleDoorsLocked(carstrie[i], 1)
						PlayVehicleDoorOpenSound(carstrie[i], 0)
						TriggerEvent("ot-notify:notify", "#18880c", "INFORMATION", "Fahrzeug aufgeschlossen")
	  
	  
						if not IsPedInAnyVehicle(PlayerPedId(), true) then
									  
						end
						SetVehicleLights(carstrie[i], 2)
						Citizen.Wait(150)
						SetVehicleLights(carstrie[i], 0)
						Citizen.Wait(150)
						SetVehicleLights(carstrie[i], 2)
						Citizen.Wait(150)
						SetVehicleLights(carstrie[i], 0)
						hasAlreadyLocked = true
					end
				else
					notowned = notowned + 1
				end
				if notowned == #carstrie then
					--exports['grv_notify']:SendAlert('error', 'Kein Fahrzeug in der Nähe')
				end	
			end, plate)
		end			
	end
end)


			


