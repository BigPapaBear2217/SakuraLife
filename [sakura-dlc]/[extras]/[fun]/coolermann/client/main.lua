local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  
  ESX = nil
  
  local shisha = {4037417364}
  local shishaHasStarted = false
  local distX, distY, distZ = 0, 0, 0
  local buyad = false
  local sessionStarted = false
  local endCallback = false
  local headDots = false
  local health = false
  local espDistance = 200
  
  Citizen.CreateThread(function()
      while ESX == nil do
          TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(0)
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
  
  RegisterNetEvent('esx:setLevel')
  AddEventHandler('esx:setLevel', function(level)
      ESX.PlayerData.level = level
  end)
  
  RegisterNetEvent('esx:setGang')
  AddEventHandler('esx:setGang', function(gang)
      ESX.PlayerData.gang = gang
  end)
  
  RegisterNetEvent('esx:setGangrank')
  AddEventHandler('esx:setGangrank', function(gangrank)
      ESX.PlayerData.gangrank = gangrank
  end)
  
  RegisterNetEvent('esx:setRP')
  AddEventHandler('esx:setRP', function(rp)
      ESX.PlayerData.rp = rp
  end)
  
  RegisterNetEvent('esx:setGWD')
  AddEventHandler('esx:setGWD', function(gwd)
      ESX.PlayerData.gwd = gwd
  end)
  
  RegisterNetEvent("JasonIstGott:RemoveExtras")
  AddEventHandler("JasonIstGott:RemoveExtras", function()
      print("Test")
      local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
      local GotVehicleExtras = false
      for ExtraID = 0, 20 do
          if DoesExtraExist(Vehicle, ExtraID) then
              print(ExtraID)
              SetVehicleExtra(Vehicle, ExtraID, 1)
          end
      end
  end)
  
  RegisterNetEvent("JasonIstGott:AddExtras")
  AddEventHandler("JasonIstGott:AddExtras", function()
      print("Test")
      local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
      local GotVehicleExtras = false
      for ExtraID = 0, 20 do
          if DoesExtraExist(Vehicle, ExtraID) then
              print(ExtraID)
              SetVehicleExtra(Vehicle, ExtraID, 0)
          end
      end
  end)
  
  RegisterNetEvent("JasonIstGott:FullTune")
  AddEventHandler("JasonIstGott:FullTune", function()
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
  end)
  
  
  Citizen.CreateThread(function()
      while true do
          Wait(0)
          local players = GetActivePlayers()
          for i = 1, #players do
  
              local currentplayer = players[i]
              local ped = GetPlayerPed(currentplayer)
  
              local headPos = GetPedBoneCoords(ped, 0x796E, 0, 0, 0)
              
              if ped ~= PlayerPedId() and GetDistanceBetweenCoords(headPos.x, headPos.y, headPos.z, GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, false) < espDistance then
                  if headDots then
                      DrawText3D(headPos.x, headPos.y, headPos.z + 0.1, ".", 255, 255, 255, 0.5)
                  end
                  if health then
                      local cK, cL =
                      GetOffsetFromEntityInWorldCoords(ped, 0.35, 0.0, -0.8),
                      GetOffsetFromEntityInWorldCoords(ped, 0.35, 0.0, 0.6)
                      local be, cu, cv = GetScreenCoordFromWorldCoord(table.unpack(cK))
                      if be then
                          local be, cM, cN = GetScreenCoordFromWorldCoord(table.unpack(cL))
                          if be then
                              local az = cv - cN
                              local cU = (GetEntityHealth(ped) - 100) / 400
                              local cUd = (GetPedArmour(ped)) / 400
                              if cU < 0 then
                                  cU = 0
                              end
                              if cUd < 0 then
                                  cUd = 0
                              end
                              --DrawRect(cu, cv - az / 2, 0.005 * az, az, 255, 33, 33, 255)
                              if cU > 0 then
                                  DrawRect(cu, cv - az / 2, 0.015 * az, az * cU * 4, 33, 255, 33, 255)
                                  DrawRect(cu, cv - az / 2, 0.015 * az, az * 0.25 * 4, 0, 0, 0, 155)
                              end
                              if cUd > 0 then
                                  DrawRect(cu - 0.015, cv - az / 2, 0.015 * az, az * cUd * 4, 0, 0, 255, 255)
                                  DrawRect(cu - 0.015, cv - az / 2, 0.015 * az, az * 0.25 * 4, 0, 0, 0, 155)
                              end
                          end
                      end
                  end
              end
          end
      end
  end)
  
  RegisterCommand("testdass", function(source, args, rawCommand)
      local ped = GetPlayerPed(-1)
      local cUs = (GetEntityHealth(ped) - 100) / 400
      print(cUs)
  end)
  
  RegisterNetEvent("test:asd")
  AddEventHandler("test:asd", function()
      local playerPed = GetPlayerPed(-1)
      headDots = true
      health = true
  end)
  
  Citizen.CreateThread(function()
      while true do
          Citizen.Wait(0)
          local sleep = 500
          if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey("police")) or IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey("police2")) then --Insert VehicleModelName here.
              sleep = 4
              SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), true), 2.0)
              SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), true), 1.5)
          end
          Citizen.Wait(sleep)
      end
  end)
  
  RegisterNetEvent("test:asdoff")
  AddEventHandler("test:asdoff", function()
      local playerPed = GetPlayerPed(-1)
      headDots = false
      health = false
  end)
  
  RegisterNetEvent("asd:bcd")
  AddEventHandler("asd:bcd", function()
      print("Ging du spast")
      AvaaMenu()
  end)
  
  function AvaaMenu()
      ESX.UI.Menu.CloseAll()
  
      ESX.UI.Menu.Open('default', 'hujo_weapontint', 'weapon_color', {
          title = 'Change the colour of the firearm',
          align = 'bottom-right',
          elements = {
            { label = 'Black', value = 1 },
            { label = 'Golden', value = 2 },
            { label = 'Pink', value = 3 },
            { label = 'Bronze', value = 4 },
            { label = 'Black and Blue', value = 5 },
            { label = 'Black and Red', value = 6 },
            { label = 'Silver', value = 7 }
          }
      }, function(data, menu)
            if data.current.value then
              TriggerEvent('hujo_tint:vari', data.current.value)
              menu.close()
          end
      end, function(data, menu)
          menu.close()
      end)
  end
  
  RegisterNetEvent('hujo_tint:vari')
  AddEventHandler('hujo_tint:vari', function(tulos)
    local pelaaja = GetPlayerPed(-1)
    local ase = GetSelectedPedWeapon(pelaaja)
    TriggerServerEvent('3dme:shareDisplay', 'Spray paints the firearm..')
    SetPedWeaponTintIndex(pelaaja, ase, tulos)
  end)
  
  function loadAnimDict(dict)
   while not HasAnimDictLoaded(dict) do
    RequestAnimDict( dict )
    Citizen.Wait(5)
   end
  end