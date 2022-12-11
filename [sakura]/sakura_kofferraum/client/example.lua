ESX = nil
local GUI      = {}
local lastVehicle = nil
local lastOpen = false
GUI.Time                      = 0
local vehiclePlate = {}
local arrayWeight = Config.localWeight
local CloseToVehicle = false
local entityWorld = nil
local globalplate = nil
local lastChecked					= 0
local maxda = nil
local platedas = nil
local inventorydas = {}
local inventorydasda = {}


local index = {
	WeaponData = {},
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end



	ESX.PlayerData = ESX.GetPlayerData()
	
	index.WeaponData = ESX.GetWeaponList()

	for i = 1, #index.WeaponData, 1 do
		if index.WeaponData[i].name == 'WEAPON_UNARMED' then
			index.WeaponData[i] = nil
		else
			index.WeaponData[i].hash = GetHashKey(index.WeaponData[i].name)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
	TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
	lastChecked = GetGameTimer()
end)

AddEventHandler('onResourceStart', function()
	PlayerData = xPlayer
	TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
	lastChecked = GetGameTimer()
end)

--[[RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setLevel')
AddEventHandler('esx:setLevel', function(level)
	ESX.PlayerData.level = level
end)

RegisterNetEvent('esx:setRP')
AddEventHandler('esx:setRP', function(rp)
	ESX.PlayerData.rp = rp
end)

RegisterNetEvent('esx:setGWD')
AddEventHandler('esx:setGWD', function(gwd)
	ESX.PlayerData.gwd = gwd
end)--]]

RegisterNetEvent('esx_trunk_inventory:setOwnedVehicule')
AddEventHandler('esx_trunk_inventory:setOwnedVehicule', function(vehicle)
		vehiclePlate = vehicle
		--print('Your vehiclePlates: ',ESX.DumpTable(vehiclePlate))
end)

--==--==--==--==----==--==--==--=Menu Einstellung=----==--==--==--==----==--==--==--==--
local mainMenu = RageUI.CreateMenu(" ", "Kofferraum")
RMenu.Add('showcase2', 'main2', RageUI.CreateSubMenu(mainMenu, " ", "Kofferraum"))
RMenu.Add('showcase3', 'main3', RageUI.CreateSubMenu(mainMenu, " ", "Kofferraum"))

mainMenu:DisplayGlare(false)
RMenu:Get('showcase2', 'main2'):DisplayGlare(false)
RMenu:Get('showcase3', 'main3'):DisplayGlare(false)

mainMenu.Sprite = {
    Dictionary = "Custom_Menu_Head" or "WS_commonmenu",
    Texture = "Custom_Menu_Head" or "interaction_bgd",
    Color = {
        R = R,
        G = G,
        B = B,
        A = A
    }
}

RMenu:Get('showcase2', "main2").Sprite = {
    Dictionary = "Custom_Menu_Head" or "WS_commonmenu",
    Texture = "Custom_Menu_Head" or "interaction_bgd",
    Color = {
        R = R,
        G = G,
        B = B,
        A = A
    }
}

RMenu:Get('showcase3', "main3").Sprite = {
    Dictionary = "Custom_Menu_Head" or "WS_commonmenu",
    Texture = "Custom_Menu_Head" or "interaction_bgd",
    Color = {
        R = R,
        G = G,
        B = B,
        A = A
    }
}


--==--==--==--==----==--==--==--=Menu Einstellung=----==--==--==--==----==--==--==--==--
function OpenCoffreInventoryMenu(plate,max)
	RageUI.Visible(RMenu:Get('showcase', 'main'), not RageUI.Visible(RMenu:Get('showcase', 'main')))
	ESX.TriggerServerCallback('esx_trunk:getPlayerInventory', function(inventory)
		ESX.TriggerServerCallback('esx_trunk:getInventoryV', function(inventory2)
			inventorydas = inventory
			inventorydasda = inventory2
			platedas = plate
			maxda = max
			RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
		end,plate)
	end,plate)
end
--==--==--==--==----==--==--==--==----==--==--==--==--
--==--==--==--==----==--==--==--==----==--==--==--==--
	Citizen.CreateThread(function()
		plyPed = PlayerPedId()
		local plate = platedas
		local owner= GetPlayerPed(-1)
		while (true) do
			local sleep = 500
			RageUI.IsVisible(mainMenu, function()
				sleep = 4
				RageUI.Separator(platedas .. ' - ' .. (inventorydasda.weight/1000) .. " / "..(maxda/1000))
				RageUI.Button('Reinlegen', nil, {  }, true, {
					onSelected = function()
						RageUI.CloseAll()
						RageUI.Visible(RMenu:Get('showcase3', 'main3'), not RageUI.Visible(RMenu:Get('showcase3', 'main3')))
					end,
				})
				RageUI.Button('Rausnehmen', nil, {  }, true, {
					onSelected = function()
						RageUI.CloseAll()
						RageUI.Visible(RMenu:Get('showcase2', 'main2'), not RageUI.Visible(RMenu:Get('showcase2', 'main2')))
					end,
				})
			end, function() end)		
			RageUI.IsVisible(RMenu:Get('showcase3', 'main3'), function()
				sleep = 4
					RageUI.Separator(platedas .. ' - ' .. (inventorydasda.weight/1000) .. " / "..(maxda/1000))
					for i=1, #inventorydas.items, 1 do
						  local item = inventorydas.items[i]
						  if item.count > 0 then
							local invCount = {}
							
							
							RageUI.Button(item.label.." ("..item.count..")", description, {}, true, {
								onHovered = function()
									Visual.Subtitle("onHovered", 100)
								end,
								onSelected = function()
									Visual.Subtitle("onSelected", 100)
									--print(item.name)
									local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', "Menge", '', 8))

									if post then
										local typeda = "item_standard"		
										TriggerServerEvent('esx_trunk:putItem', platedas, typeda, item.name, quantity ,maxda, myVeh)
										CloseToVehicle = false
										lastOpen = false
										  if lastVehicle > 0 then
											SetVehicleDoorShut(lastVehicle, 5, false)
											lastVehicle = 0
										  end
										RageUI.CloseAll()
									end
								end,
							});		
						end
					end	
					RageUI.Separator("Waffen")
					plyPed = PlayerPedId()
					for i = 1, #index.WeaponData, 1 do
						if HasPedGotWeapon(plyPed, index.WeaponData[i].hash, false) then
							local ammo = GetAmmoInPedWeapon(plyPed, index.WeaponData[i].hash)			
							RageUI.Button(index.WeaponData[i].label .. ' [' .. ammo .. ']', description, {}, true, {
								onSelected = function()
									Visual.Subtitle("onSelected", 100)
									local typeda = "item_weapon"
									TriggerServerEvent('esx_trunk:putItem', platedas, typeda, index.WeaponData[i].name, ammo,maxda, myVeh)
									CloseToVehicle = false
									lastOpen = false
									  if lastVehicle > 0 then
										SetVehicleDoorShut(lastVehicle, 5, false)
										lastVehicle = 0
									  end
									RageUI.CloseAll()
								end,
							});		
						end
					end	
			end, function() end)	
			RageUI.IsVisible(RMenu:Get('showcase2', 'main2'), function()
				sleep = 4
				RageUI.Separator(platedas .. ' - ' .. (inventorydasda.weight/1000) .. " / "..(maxda/1000))
					for i=1, #inventorydasda.items, 1 do
						  local item = inventorydasda.items[i]
						  if item.count > 0 then
							local invCount = {}
							
							
							RageUI.Button(item.label.." ("..item.count..")", description, {}, true, {
								onHovered = function()
									Visual.Subtitle("onHovered", 100)
								end,
								onSelected = function()
									Visual.Subtitle("onSelected", 100)
									local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', "Menge", '', 8))

									if post then
										local typeda = "item_standard"	
										TriggerServerEvent('esx_trunk:getItem', platedas, typeda, item.name, quantity)
										CloseToVehicle = false
										lastOpen = false
										  if lastVehicle > 0 then
											SetVehicleDoorShut(lastVehicle, 5, false)
											lastVehicle = 0
										  end
										RageUI.CloseAll()								
									end
								end,
							});		
						end
					end	
					RageUI.Separator("Waffen")
					for i=1, #inventorydasda.weapons, 1 do
						local weapon = inventorydasda.weapons[i]
						RageUI.Button(ESX.GetWeaponLabel(weapon.name).." ("..weapon.ammo..")", description, {}, true, {
							onSelected = function()
								Visual.Subtitle("onSelected", 100)
									local typeda = "item_weapon"
									TriggerServerEvent('esx_trunk:getItem', platedas, typeda, weapon.name, weapon.ammo)
										CloseToVehicle = false
										lastOpen = false
										  if lastVehicle > 0 then
											SetVehicleDoorShut(lastVehicle, 5, false)
											lastVehicle = 0
										  end
									RageUI.CloseAll()
							end,
						});		
					end						
			end, function() end)	
		Citizen.Wait(sleep)
		end
	end)
--==--==--==--==----==--==--==--==----==--==--==--==--
--==--==--==--==----==--==--==--==----==--==--==--==--



function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.017, 0.977)
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

function getItemyWeight(item)
  local weight = 0
  local itemWeight = 0
  if item ~= nil then
	   itemWeight = Config.DefaultWeight
	   if arrayWeight[item] ~= nil then
	        itemWeight = arrayWeight[item]
	   end
	end
  return itemWeight
end

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = StartShapeTestRay(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 2, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function openmenuvehicle()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local vehicle   =VehicleInFront()
  globalplate  = GetVehicleNumberPlateText(vehicle)
  
  myVeh = false
  local thisVeh = VehicleInFront()
  PlayerData = ESX.GetPlayerData()
  for i=1, #vehiclePlate do
    local vPlate = all_trim(vehiclePlate[i].plate)
    local vFront = all_trim(GetVehicleNumberPlateText(thisVeh))
    --print('vPlate: ',vPlate)
    --print('vFront: ',vFront)
    if vPlate ~= vFront then
      --print('No match: ' .. vPlate .. ' / '.. vFront)
    end
    if  vPlate == vFront then
      myVeh = true
      --print('Plate match: ' .. vPlate .. ' / '.. vFront)
    elseif lastChecked < GetGameTimer() - 60000 then
      TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
      --print('Checking for new plates(timed event)')
      lastChecked = GetGameTimer()
      Wait(2000)
      for i=1, #vehiclePlate do
        local vPlate = all_trim(vehiclePlate[i].plate)
        local vFront = all_trim(GetVehicleNumberPlateText(thisVeh))
        if vPlate ~= vFront then
          --print('2nd attempt no match: ' .. vPlate .. ' / '.. vFront)
        end
        if  vPlate == vFront then
          myVeh = true
          --print('Plate match: ' .. vPlate .. ' / '.. vFront)
        end
      end
    end
  end

  if not Config.CheckOwnership or (Config.AllowPolice and PlayerData.job.name == 'police') or (Config.CheckOwnership and myVeh) then  
    if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
      CloseToVehicle = true
      local vehFront = VehicleInFront()
      local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
      local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)

      if vehFront > 0 and closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) then
        lastVehicle = vehFront
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
        local locked = GetVehicleDoorLockStatus(closecar)
        local class = GetVehicleClass(vehFront)
        RageUI.CloseAll()

        if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'inventory') then
          SetVehicleDoorShut(vehFront, 5, false)
        else

          if locked == 1 or class == 15 or class == 16 or class == 14 then
            --print('Trunk locked or improper class.')
            SetVehicleDoorOpen(vehFront, 5, false, false)
            RageUI.CloseAll()

            if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
              CloseToVehicle = true


              if tostring(model) == "G63AMG6x6" then
                OpenCoffreInventoryMenu(GetVehicleNumberPlateText(vehFront), 6000 * 1000)
                return
              end

              if inArray(model, Config.VehicleModel) then
                model = string.lower(model)
                vehCapacity = Config.VehicleModel[model]
                maxda = Config.VehicleModel[model]
                --ESX.ShowNotification('weight is '..vehCapacity)
              else
                vehCapacity = Config.VehicleLimit[class]
                --ESX.ShowNotification('weight is '..vehCapacity)
              end
              OpenCoffreInventoryMenu(GetVehicleNumberPlateText(vehFront), vehCapacity)
            end

          else
            ESX.ShowNotification("Der Kofferraum ist Abgeschlossen")
            --print('Trunk has been closed.')
          end
        end
      else
        ESX.ShowNotification("Kein Fahrzeug in der Nähe")
        --print('Trunk: No vehicle nearby.')
      end
      lastOpen = true
      GUI.Time  = GetGameTimer()
    end
  else
    -- Not their vehicle
    ESX.ShowNotification("Das ist nicht dein Fahrzeug")
    --print('Trunk: NOT YOUR VEHICLE')
    --print('Your Plates: ',ESX.DumpTable(vehiclePlate))
    --print('Veh in front: ',ESX.DumpTable(vehFront))
  end
end
local count = 0


RegisterNetEvent('bloodline-trunk:open')
AddEventHandler('bloodline-trunk:open', function()
	if lastOpen == false then
		openmenuvehicle()
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 194) and lastOpen == true then
			lastOpen = false
			if lastVehicle > 0 then
			SetVehicleDoorShut(lastVehicle, 5, false)
			lastVehicle = 0
			end
			RageUI.CloseAll()
		end
	end
end)

Citizen.CreateThread(function()
  while true do
  Wait(0)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	if CloseToVehicle then
		local vehicle = GetClosestVehicle(pos['x'], pos['y'], pos['z'], 2.0, 0, 70)
		if DoesEntityExist(vehicle) then
			CloseToVehicle = true
		else
			CloseToVehicle = false
			lastOpen = false
			RageUI.CloseAll()
			SetVehicleDoorShut(lastVehicle, 5, false)
		end
	end
  end
end)

function all_trim(s)
	if s then
		return s:match"^%s*(.*)":match"(.-)%s*$"
	else
		return 'noTagProvided'
	end
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


function inArray(needle, haystack)
	for k,v in pairs(haystack) do
		if string.lower(k) == string.lower(needle) then
			return true
		end
	end
	return false
end
