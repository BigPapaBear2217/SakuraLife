RegisterCommand('coords2', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local coords2 = GetEntityHeading(PlayerPedId())
	SendNUIMessage({
		coords = "x = "..coords.x..", y = "..coords.y..", z = "..coords.z..", pitch = "..coords2
	})
end)

RegisterCommand('coords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local coords2 = GetEntityHeading(PlayerPedId())
	SendNUIMessage({
		coords = "vector3(" .. Round(coords.x, 2) .. ", " .. Round(coords.y, 2) .. ", "..Round(coords.z, 2)..")"
	})
end)

RegisterCommand('coords3', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local coords2 = GetEntityHeading(PlayerPedId())

	SendNUIMessage({
		coords = "vector3(" .. Round(coords.x, 2) .. ", " .. Round(coords.y, 2) .. ", "..Round(coords.z, 2).."), heading = " .. Round(coords2, 2) .. ","
	})
end)

Round = function(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end



--[[RegisterCommand('tpc', function(source, args, rawCommand)
	local coords = {}
	for coord in string.gmatch(args[1] or "0,0,0","[^,]+") do
		table.insert(coords,tonumber(coord))
	end

	local x,y,z = 0,0,0
	if coords[1] ~= nil then x = coords[1] end
	if coords[2] ~= nil then y = coords[2] end
	if coords[3] ~= nil then z = coords[3] end

	SetEntityCoords(GetPlayerPed(-1), x,y,z, false)
end)]]