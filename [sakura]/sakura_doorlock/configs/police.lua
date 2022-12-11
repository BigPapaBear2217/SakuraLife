

-- 
table.insert(Config.DoorList, {
	objHash = -190780785,
	lockpick = false,
	objHeading = 31.530559539794,
	slides = 6.0,
	locked = true,
	authorizedJobs = { ['police']=0 },
	maxDistance = 6.0,
	objCoords = vector3(532.998, -34.1838, 71.64984),
	audioRemote = false,
	fixText = false,
	garage = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- police
table.insert(Config.DoorList, {
	maxDistance = 2.5,
	audioRemote = false,
	authorizedJobs = { ['police']=0 },
	doors = {
		{objHash = -1215222675, objHeading = 70.056037902832, objCoords = vector3(637.1832, 0.8762293, 82.9353)},
		{objHash = -1215222675, objHeading = 249.95581054688, objCoords = vector3(638.0731, 3.31988, 82.9353)}
 },
	lockpick = false,
	slides = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})