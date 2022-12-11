TriggerEvent('es:addGroupCommand', 'tp', 'admin', function(source, args, user)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	local z = tonumber(args[3])
	
	if x and y and z then
		TriggerClientEvent("esx:teleport", source, {
			x = x,
			y = y,
			z = z
		})
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Invalid coordinates!")
	end
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Teleport to coordinates", params = {{name = "x", help = "X coords"}, {name = "y", help = "Y coords"}, {name = "z", help = "Z coords"}}})
