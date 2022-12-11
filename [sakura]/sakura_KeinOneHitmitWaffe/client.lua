Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local weapon = GetSelectedPedWeapon(ped)

		if IsPedArmed(ped, 6) then
        	DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end
