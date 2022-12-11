Config	=	{}

Config.CheckOwnership = false -- If true, Only owner of vehicle can store items in trunk.
Config.AllowPolice = false -- If true, police will be able to search players' trunks.

Config.Locale   = 'en'

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 1000

Config.localWeight = {
    WEAPON_NIGHTSTICK       = 500,
    WEAPON_STUNGUN          = 1000,
    WEAPON_FLASHLIGHT       = 500,
    WEAPON_FLAREGUN         = 1000,
    WEAPON_FLARE            = 1000,
    WEAPON_COMBATPISTOL     = 2500,
    WEAPON_HEAVYPISTOL      = 4000,
    WEAPON_ASSAULTSMG       = 7000,
    WEAPON_COMBATPDW        = 7000,
    WEAPON_BULLPUPRIFLE     = 8000,
    WEAPON_PUMPSHOTGUN      = 8000,
    WEAPON_BULLPUPSHOTGUN   = 10000,
    WEAPON_CARBINERIFLE     = 10000,
    WEAPON_ADVANCEDRIFLE    = 10000,
    WEAPON_MARKSMANRRIFLE   = 15000,
    WEAPON_SNIPERRIFLE      = 15000,
    WEAPON_FIREEXTINGUISHER = 1500, 
    GADGET_PARACHUTE        = 5000,
    WEAPON_BAT              = 1500,
    WEAPON_PISTOL           = 5000,
    money                   = 10,
	black_money             = 10
}

Config.VehicleLimit = {
    [0] = 30 * 1000, --Compact
    [1] = 40 * 1000, --Sedan
    [2] = 100 * 1000, --SUV
    [3] = 40 * 1000, --Coupes
    [4] = 40 * 1000, --Muscle
    [5] = 25 * 1000, --Sports Classics
    [6] = 40 * 1000, --Sports
    [7] = 5 * 1000, --Super
    [8] = 0, --Motorcycles
    [9] = 15 * 1000, --Off-road
    [10] = 800 * 1000, --Industrial
    [11] = 100 * 1000, --Utility
    [12] = 150 * 1000, --Vans
    [13] = 0, --Cycles
    [14] = 100 * 1000, --Boats
    [15] = 350 * 1000, --Helicopters
    [16] = 0, --Planes
    [17] = 40 * 1000, --Service
    [18] = 350 * 1000, --Emergency
    [19] = 1000 * 1000, --Military
    [20] = 350 * 1000, --Commercial
    [21] = 0, --Trains

}

Config.VehicleModel = {
    rmode63s  = 800 * 1000,
    rmodrs6   = 600 * 1000,
    rmodg65   = 5000 * 1000,
    --oracle    = 2400 * 1000,
}

Config.VehiclePlate = {
	taxi        = "TAXI",
	cop         = "LSPD",
	ambulance   = "EMS0",
	mecano	    = "MECA",
}
