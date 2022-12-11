RegisterNetEvent('ot-progress:startProgress')
AddEventHandler("ot-progress:startProgress", function(time)
	SendNUIMessage({
		type = "ui",
		display = true,
		time = time,
		percentage = percentage
	})
end)

function startUI(time) 
	SendNUIMessage({
		type = "ui",
		display = true,
		time = time,
		percentage = percentage
	})
end