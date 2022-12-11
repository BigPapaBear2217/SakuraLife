ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("removeextras", function(source, args)
	TriggerClientEvent("JasonIstGott:RemoveExtras",source)
end, false)

RegisterCommand("addextras", function(source, args)
	TriggerClientEvent("JasonIstGott:AddExtras",source)
end, false)

RegisterCommand("fulltune", function(source, args)
	TriggerClientEvent("JasonIstGott:FullTune",source)
end, true)

RegisterCommand("tint", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("asd:bcd", source)
end, true)

--[[RegisterCommand("123deletehookah", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("only_hooka:delete", source)
	if shishaSpawned == true then
		shishaSpawned = false
	end
end, true)

RegisterCommand("adingsda", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("test:asd", source)
end, true)

RegisterCommand("adingsdaoff", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("test:asdoff", source)
end, true)]]

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
		live = "",
		fivem = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
			local test = string.gsub(id,"discord:","")
            identifiers.discord = test
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        elseif string.find(id, "fivem") then
            identifiers.fivem = id
        end
    end

    return identifiers
end