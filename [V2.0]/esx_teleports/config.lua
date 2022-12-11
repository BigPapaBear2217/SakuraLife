Config                            = {}

Config.Teleporters = {
    ['weed'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 605.18, 
			['y'] = 5.72, 
			['z'] = 97.67 - 0.7,
			['Information'] = '~g~[E] Helipad betreten',
		},
		['Exit'] = {
			['x'] = 565.68, 
			['y'] = 4.99, 
			['z'] = 103.03 - 0.7, 
			['Information'] = '~g~[E] Helipad verlassen' 
		}
	},

    --MD
    ['krankenhaus_garage'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 341.4187, 
			['y'] = -581.026, 
			['z'] = 28.796-0.95,
			['Information'] = '~g~[E] Aufzug nach Oben',
		},
		['Exit'] = {
			['x'] = 327.1333, 
			['y'] = -603.787, 
			['z'] = 43.2840-0.96, 
			['Information'] = '~g~ [E] Aufzug zur Garage' 
		}
	},

    --MD
    ['oxince_garage'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -304.84704589844, 
			['y'] = -721.10595703125, 
			['z'] = 28.028612136841 - 0.95,
			['Information'] = '~g~[E] Aufzug nach Oben',
		},
		['Exit'] = {
            ['x'] = -288.28625488281, 
			['y'] = -722.40368652344, 
			['z'] = 125.4732208252 - 0.96, 
			['Information'] = '~g~ [E] Aufzug zur Garage' 
		}
	},

    ['marius'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -1241.1197509766, 
			['y'] = -3380.6462402344, 
			['z'] = 13.940158843994 - 0.95,
			['Information'] = '~g~[E] Aufzug zum Lager',
		},
		['Exit'] = {
            ['x'] = -290.48629760742, 
			['y'] = -3656.3940429688, 
			['z'] = 290.24514770508 - 0.96, 
			['Information'] = '~g~ [E] Aufzug zum Hangar' 
		}
	},

    ['marius2'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -297.10955810547, 
			['y'] = -3653.4982910156, 
			['z'] = 290.24554443359 - 0.95,
			['Information'] = '~g~[E] Aufzug zum Tintenfisch-Spiel',
		},
		['Exit'] = {
            ['x'] = -249.26362609863, 
			['y'] = -3287.0832519531,
			['z'] = 290.00961303711 - 0.96, 
			['Information'] = '~g~ [E] Aufzug zum Lager' 
		}
	},

    --[['oxince_s1'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -302.89514160156, 
			['y'] = -3656.2158203125, 
			['z'] = 290.24514770508 - 0.95,
			['Information'] = '~g~[E] Aufzug zum Spiel',
		},

		['Exit'] = {
            ['x'] = -297.55706787109, 
			['y'] = -3586.6328125, 
			['z'] = 304.79650878906 - 0.96, 
			['Information'] = '~g~ [E] Aufzug ins Lager' 
		}
	},

    ['oxince_s2'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -297.22982788086, 
			['y'] = -3508.6340332031, 
			['z'] = 304.79653930664 - 0.95,
			['Information'] = '~g~[E] Aufzug zum zweitem Spiel',
		},
		['Exit'] = {
            ['x'] = -297.20303344727, 
			['y'] = -3496.9821777344, 
			['z'] = 304.79272460938 - 0.96, 
			['Information'] = '~g~ [E] Aufzug zum ersten Spiel' 
		}
	},

    ['oxince_s3'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -297.46826171875, 
			['y'] = -3419.2185058594, 
			['z'] = 304.7958984375 - 0.95,
			['Information'] = '~g~[E] Aufzug zum dritten Spiel',
		},
		['Exit'] = {
            ['x'] = -297.49172973633, 
			['y'] = -3405.6179199219, 
			['z'] = 304.79290771484 - 0.96, 
			['Information'] = '~g~ [E] Aufzug zum zweiten Spiel' 
		}
	},

    ['oxince_s4'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = -297.45324707031, 
			['y'] = -3328.6755371094, 
			['z'] = 304.79653930664 - 0.95,
			['Information'] = '~g~[E] Aufzug zum vierten Spiel',
		},
		['Exit'] = {
            ['x'] = -249.81533813477, ['y'] = -3269.4267578125, ['z'] = 290.01034545898 - 0.96,
			['Information'] = '~g~ [E] Aufzug zum dritten Spiel' 
		}
	},]]--

    ['fib_zu_garage'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 136.03, 
			['y'] = -761.74, 
			['z'] = 45.75 - 0.95,
			['Information'] = '~g~[E] Rein in die Garage',
		},
		['Exit'] = {
            ['x'] = 109.95, ['y'] = -736.4, ['z'] = 33.13 - 0.96,
			['Information'] = '~g~[E] Rein ins FIB' 
		}
	},

    ['fib_zu_office'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 138.86, 
			['y'] = -763.18, 
			['z'] = 45.75 - 0.95,
			['Information'] = '~g~[E] Hoch ins Office',
		},
		['Exit'] = {
            ['x'] = 136.15, ['y'] = -761.77, ['z'] = 242.15 - 0.96,
			['Information'] = '~g~[E] Zur Rezeption' 
		}
	},

    ['fib_zu_head'] = {
		['Job'] = 'none',
		['Enter'] = { 
			['x'] = 114.94, 
			['y'] = -741.75, 
			['z'] = 258.15 - 0.95,
            ['Information'] = '~g~[E] Runter ins Office' 
		},
		['Exit'] = {
            ['x'] = 147.28, ['y'] = -738.01, ['z'] = 242.15 - 0.96,
            ['Information'] = '~g~[E] Hoch ins Head-Quater',
		}
	},
}


