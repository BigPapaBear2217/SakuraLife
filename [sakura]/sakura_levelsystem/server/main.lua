ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---
---
--- Globale Definitionen
---
---

local playtime = 0
local timePlay = {}

---
---
--- Level System
---
---

-- Laden der Spielzeit des Spielers nachm Joinen
AddEventHandler('esx:playerLoaded', function(source)
    local _source = source
    local identifier = GetPlayerIdentifier(_source)
    timePlay[identifier] = {source = _source, joinTime = os.time(), timePlay = 0}
    MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", { ["@identifier"] = identifier }, function(result)

        if result then

            local timePlayP = result[1].timePlay
            timePlay[identifier].timePlay = timePlayP
        end

    end)

end)

-- Wenn Spieler disconnectet die Spielzeit aktualisieren
AddEventHandler('playerDropped', function()
	local _source = source
	if _source ~= nil then
		local identifier = GetPlayerIdentifier(_source)
		if timePlay[identifier] ~= nil then

			local leaveTime = os.time()
			local saveTime = leaveTime - timePlay[identifier].joinTime

			MySQL.Async.execute('UPDATE users SET timePlay = timePlay + @timePlay WHERE identifier=@identifier', 
			{
				['@identifier'] = identifier,
				['@timePlay'] = saveTime
				
			}, function()

				timePlay[identifier] = nil
			end)
		end
	end
end)

-- Fake Event Name = Speichern des Spielers seine Spielzeit
RegisterServerEvent("bloodline-level:syncServer")
AddEventHandler("bloodline-level:syncServer", function()
	SavePlayer(source)
end)

-- Speichert den Spieler seine Spielzeit
function SavePlayer(source)
	local _source = source
	if _source ~= nil then
		local identifier = GetPlayerIdentifier(_source)
		if timePlay[identifier] ~= nil then

			local leaveTime = os.time()
			local saveTime = leaveTime - timePlay[identifier].joinTime

			MySQL.Async.execute('UPDATE users SET timePlay = timePlay + @timePlay WHERE identifier=@identifier', 
			{
				['@identifier'] = identifier,
				['@timePlay'] = saveTime
				
			}, function()

				timePlay[identifier] = nil
				StartTimer(source)
			end)
		else
			StartTimer(source)
		end
	end
end

-- Startet den Timer
function StartTimer(source)
    local _source = source
    local identifier = GetPlayerIdentifier(_source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local test = xPlayer.getRP()
    timePlay[identifier] = {source = _source, joinTime = os.time(), timePlay = 0}
    MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", { ["@identifier"] = identifier }, function(result)

        if result then

            local timePlayP = result[1].timePlay
            timePlay[identifier].timePlay = timePlayP
			if timePlayP > 3600 then
				local rpalt = test
				local rpneu = test+1
				local aktuelleslevel = xPlayer.getLevel()
				xPlayer.setRP(tostring(rpneu))
				if rpneu >= (aktuelleslevel*4) then
					xPlayer.setRP(tostring(0))
					local LevelUp = aktuelleslevel+1
					xPlayer.setLevel(tostring(LevelUp))
					TriggerClientEvent("ot-notify:notify",source, "#ff3838", "Gratulation! Deine Visumsstufe ist angestiegen!")
				end
				ResetTimer(source)
			end
        end

    end)
end

-- Reset aktuelle Spielzeit auf 0
function ResetTimer(source)
	local _source = source
	if _source ~= nil then
		local identifier = GetPlayerIdentifier(_source)
		MySQL.Async.execute('UPDATE users SET timePlay = @timePlay WHERE identifier=@identifier', 
		{
			['@identifier'] = identifier,
			['@timePlay'] = 0
			
		}, function()

			timePlay[identifier] = nil
			StartTimer(source)
		end)
	end
end

---
---
--- Kills/Tode Datenbank
---
---

RegisterServerEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(data)
	data.victim = source
	
	if data.killedByPlayer then
		local identifierkiller = GetPlayerIdentifiers(data.killerServerId)[1]
		local identifieropfer = GetPlayerIdentifiers(data.victim)[1]
		
		MySQL.Sync.execute("UPDATE users SET kills = kills + 1 WHERE identifier = @identifier", {
			["@identifier"] = identifierkiller
		})
		MySQL.Sync.execute("UPDATE users SET deaths = deaths + 1 WHERE identifier = @identifier", {
			["@identifier"] = identifieropfer
		})		
		
	else
		MySQL.Sync.execute("UPDATE users SET deaths = deaths + 1 WHERE identifier = @identifier", {
			["@identifier"] = identifieropfer
		})
	end
end)

---
---
--- Neulingssystem
---
---


---
---
--- Funktionen
---
---

function ExtractIdentifiers(src)
	-- Definieren Leerer Identifier Table
	local identifier = {
		steam = "",
		ip = "",
		discord = "",
		license = "",
		live = "",
		xbl = "",
		fivem = "",
	}
	
	-- Jeden Identifier finden
	for i = 0, GetNumPlayerIdentifiers(src) - 1 do
		local id = GetPlayerIdentifier(src,i)
		
		if string.find(id, "steam") then
			identifiers.steam = id
		elseif string.find(id, "ip") then
			identifiers.ip = id
		elseif string.find(id, "discord") then
			-- Bei Discord Identifier das "discord:" entfernen
			local ordentlich = string.gsub(id,"discord:","")
			identifiers.discord = ordentlich
		elseif string.find(id, "license") then
			identifiers.license = id
		elseif string.find(id, "live") then
			identifiers.live = id
		elseif string.find(id, "xbl") then
			identifiers.xbl = id
		elseif string.find(id, "fivem") then
			identifiers.fivem = id
		end
	end
	
	return identifiers
end