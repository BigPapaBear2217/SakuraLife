local function isAdmin(source)
    local allowed = false
    for i,id in ipairs(Config.EAS.admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(source)) do
            if string.lower(pid) == string.lower(id) then
                print(pid)
                allowed = true
            end
        end
	end
	if IsPlayerAceAllowed(source, "lance.eas") then
		allowed = true
	end
    return allowed
end

local function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterServerEvent("alert:sv")
AddEventHandler("alert:sv", function (msg, msg2)
	if (isAdmin(source)) then
    		TriggerClientEvent("SendAlert", -1, msg, msg2)
	end
end)

TriggerEvent('es:addGroupCommand', 'purger', 'superadmin', function(source, args, user)
    TriggerClientEvent("alert:Send", source, "DIE PURGE BEGINNT!")
    TriggerClientEvent("alert:test", -1)
end, function(source, args, user)
end, {help = 'revive all'})
