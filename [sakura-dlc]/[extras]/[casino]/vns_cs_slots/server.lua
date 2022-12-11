math.randomseed(os.time())

ESX = nil
local activeSlot = {}
TriggerEvent(Config.ESX, function(obj) ESX = obj end)


ESX.RegisterServerCallback('casino:slots:isSeatUsed',function(source, cb, index)
	if activeSlot[index] ~= nil then
		if activeSlot[index].used then
			cb(true)
		else
			activeSlot[index].used = true
			cb(false)
		end
	else
		activeSlot[index] = {}
		activeSlot[index].used = true
		cb(false)
	end
end)

RegisterNetEvent('casino:slots:notUsing')
AddEventHandler('casino:slots:notUsing',function(index)
	if activeSlot[index] ~= nil then
		activeSlot[index].used = false
	end
end)



RegisterNetEvent('casino:taskStartSlots')
AddEventHandler('casino:taskStartSlots',function(index, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if activeSlot[index] then
		if CanPlay(xPlayer, data) then
			local w = {a = math.random(1,16),b = math.random(1,16),c = math.random(1,16)}
			local rnd1 = math.random(1,100)
			local rnd2 = math.random(1,100)
			local rnd3 = math.random(1,100)
			if Config.Offset then
				if rnd1 < Config.OffsetNum then w.a = w.a + 0.5 end
				if rnd2 < Config.OffsetNum then w.b = w.b + 0.5 end
				if rnd3 < Config.OffsetNum then w.c = w.c + 0.5 end
			end
			TriggerClientEvent('casino:slots:startSpin', source, index, w)
			activeSlot[index].win = w
		end
	end
end)

function CanPlay(plr, data)
	if Config.Play.Item and not Config.Play.Money then
		if plr.getInventoryItem(Config.Play.ItemName).count >= data.bet then
			plr.removeInventoryItem(Config.Play.ItemName,data.bet)
			return true
		else
			return false
		end
	elseif not Config.Play.Item and Config.Play.Money then
		if Config.Play.AccountMoney == '' then
			if plr.getMoney() >= data.bet then
				plr.removeMoney(data.bet)
				return true
			else
				return false
			end
		elseif plr.getAccount(Config.Play.AccountMoney).money >= data.bet then
			plr.removeAccountMoney(Config.Play.AccountMoney, data.bet)
			return true
		else
			return false
		end
	else
		return false
	end
end

function GivePrice(plr, total)
	if Config.Play.Item and not Config.Play.Money then
		plr.showNotification(_U('win')..' '..total..' '.._U('win2'))
		plr.addInventoryItem(Config.Play.ItemName, total)
	elseif not Config.Play.Item and Config.Play.Money then
		if Config.Play.AccountMoney == '' then
			plr.showNotification("You have won "..total..'$')
			plr.addMoney(total)
		else
			plr.showNotification("You have won "..total..'$')
			plr.addAccountMoney(Config.Play.AccountMoney, total)
		end
	end
end

RegisterNetEvent('casino:slotsCheckWin')
AddEventHandler('casino:slotsCheckWin',function(index, data, dt)
	if activeSlot[index] then
		if activeSlot[index].win then
			if activeSlot[index].win.a == data.a
			and activeSlot[index].win.b == data.b
			and activeSlot[index].win.c == data.c then
				CheckForWin(activeSlot[index].win, dt)
			end
		end
	end
end)

function CheckForWin(w, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local a = Config.Wins[w.a]
	local b = Config.Wins[w.b]
	local c = Config.Wins[w.c]
	local total = 0
	if a == b and b == c and a == c then
		if Config.Mult[a] then
			total = data.bet*Config.Mult[a]
		end		
	elseif a == '6' and b == '6' then
		total = data.bet*5
	elseif a == '6' and c == '6' then
		total = data.bet*5
	elseif b == '6' and c == '6' then
		total = data.bet*5
		
	elseif a == '6' then
		total = data.bet*2
	elseif b == '6' then
		total = data.bet*2
	elseif c == '6' then
		total = data.bet*2
	end
	if total > 0 then
		GivePrice(xPlayer, total)
	end
end