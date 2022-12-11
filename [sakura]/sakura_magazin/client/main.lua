ESX          = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('bloodline_clip:clipcli')
AddEventHandler('bloodline_clip:clipcli', function()
  ped = GetPlayerPed(-1)
  if IsPedArmed(ped, 4) then
    hash=GetSelectedPedWeapon(ped)
    if hash~=nil then
      TriggerServerEvent('bloodline_clip:remove')
      AddAmmoToPed(GetPlayerPed(-1), hash,250)
      TriggerEvent("ot-notify:notify", "#ff0000", "Sakura-Core", "Du hast 1x Magazin benutzt")
    else
      TriggerEvent("ot-notify:notify", "#ff0000", "Sakura-Core", "Du musst eine Waffe in der Hand halten")
    end
  else
    TriggerEvent("ot-notify:notify", "#ff0000", "Sakura-Core", "Die Munition ist für diese Waffe nicht geeignet")
  end
end)

