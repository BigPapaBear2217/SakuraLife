

-- f
table.insert(Config.DoorList, {
	audioRemote = false,
	slides = false,
	locked = true,
	authorizedJobs = { ['yakuza']=0 },
	maxDistance = 2.5,
	lockpick = false,
	doors = {
		{objHash = -2146494197, objHeading = 229.98397827148, objCoords = vector3(-62.79199, 998.9296, 234.9928)},
		{objHash = -2146494197, objHeading = 49.983966827393, objCoords = vector3(-61.68702, 998.0019, 234.9928)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})