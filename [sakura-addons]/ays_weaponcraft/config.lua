AYS = {}

AYS.esxgetSharedObjectevent = 'esx:getSharedObject'
AYS.esxprefix = "esx:"

AYS.location = vector3(1207.88, -3114.88, 5.54)

AYS.messages = {
    "Dir fehlen einige Rohstoffe um diese Waffe herstellen zu können.",
    "Du hast die Waffe erfolgreich hergestellt.",
    "Du hast diese Waffe bereits im Waffenrad.",

    "Drücke ~INPUT_PICKUP~ um mit Kevin zu reden"
}

AYS.notfication = function(source, message)
    TriggerClientEvent(AYS.esxprefix..'showNotification', source, message)
end

AYS.marker = {
    type = 4,
    size = 0,
    color = {
        red = 0, 
        green = 80, 
        blue = 144, 
        alpha = 244
    }
}

AYS.weapons = {
    {
        label = "Assault Rifle",
        name = "weapon_assaultrifle", -- /html/img/ >> Same name (WEAPON_ASSAULTRIFLE.png)
        specs = {
            {
                label = "Schaden",
                state = 4 -- min. 1 // max. 5
            },
            {
                label = "Feuerrate",
                state = 3
            },
            {
                label = "Genauigkeit",
                state = 3
            },
            {
                label = "Schussweite",
                state = 3
            }
        },
        needs = {
            {
                name = "waffenteil", -- /html/img/ >> Same name (phone.png)
                label = "Verarbeite Waffenteile",
                amount = 320
            }
        }
    },
    {
        label = "Micro SMG",
        name = "weapon_microsmg", -- /html/img/ >> Same name (WEAPON_ASSAULTRIFLE.png)
        specs = {
            {
                label = "Schaden",
                state = 3 -- min. 1 // max. 5
            },
            {
                label = "Feuerrate",
                state = 5
            },
            {
                label = "Genauigkeit",
                state = 2
            },
            {
                label = "Schussweite",
                state = 2
            }
        },
        needs = {
            {
                name = "waffenteil", -- /html/img/ >> Same name (phone.png)
                label = "Verarbeite Waffenteile",
                amount = 200
            }
        }
    },
    {
        label = "Advanced Rifle",
        name = "weapon_advancedrifle", -- /html/img/ >> Same name (WEAPON_ASSAULTRIFLE.png)
        specs = {
            {
                label = "Schaden",
                state = 5 -- min. 1 // max. 5
            },
            {
                label = "Feuerrate",
                state = 3
            },
            {
                label = "Genauigkeit",
                state = 2
            },
            {
                label = "Schussweite",
                state = 4
            }
        },
        needs = {
            {
                name = "waffenteil", -- /html/img/ >> Same name (phone.png)
                label = "Verarbeite Waffenteile",
                amount = 550
            }
        }
    },   
  {
        label = "Schwere Pistole",
        name = "weapon_heavypistol", -- /html/img/ >> Same name (WEAPON_ASSAULTRIFLE.png)
        specs = {
            {
                label = "Schaden",
                state = 5 -- min. 1 // max. 5
            },
            {
                label = "Feuerrate",
                state = 1
            },
            {
                label = "Genauigkeit",
                state = 4
            },
            {
                label = "Schussweite",
                state = 3
            }
        },
        needs = {
            {
                name = "waffenteil", -- /html/img/ >> Same name (phone.png)
                label = "Verarbeite Waffenteile",
                amount = 100
            }
        }
    }
   }
