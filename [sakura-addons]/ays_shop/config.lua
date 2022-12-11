AYS = {}

AYS.esxgetSharedObjectevent = 'esx:getSharedObject'
AYS.esxprefix = "esx:"

AYS.messages = {
  "Sie haben einen Einkauf für %s$ abgeschlossen.",
  "Sie haben nicht genug Geld dabei.",
  "Sie haben nicht genug Geld auf der Bank.",
  "Drücke ~INPUT_CONTEXT~ um auf den Shop zuzugreifen"
}

AYS.notfication = function(source, message)
  TriggerClientEvent(AYS.esxprefix..'showNotification', source, message)
end

AYS.shops = {
  {
    location = vector3(25.735443115234,-1346.6320800781,29.497018814087), --Standart
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = { 
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },
  {
    location = vector3(4904.02, -4939.94, 3.36), --Standart
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = { 
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },
  {
    location = vector3(-48.29, -1757.77, 29.42), -- KA
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(-707.41, -914.04, 19.22),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(-1069.27, -2836.44, 27.7),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(1163.53, -323.51, 69.21),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(373.72, 325.79, 103.57),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(-3242.02, 1001.24, 12.83),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(547.75, 2671.66, 42.16),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(1961.45, 3740.64, 32.34),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(1698.09, 4924.39, 42.06),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(1728.94, 6414.54, 35.04),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(1165.93, 2709.36, 38.16),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(-3039.11, 585.83, 7.91),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(-2071.38, -331.85, 13.34),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(161.24, 6640.58, 31.61),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(2678.88, 3280.5, 55.24),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'benzin',
        label = 'Laborbenzin',
        price = 9500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(-2967.87, 391.17, 15.04),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(-1222.04, -906.62, 12.33),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(1985.91, 3053.95, 47.22),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"Alkohol"},
    items = {
      {
        name = 'wein',
        label = 'Weinflasche',
        price = 2500,
        category = "Alkohol"
      }    }
  },
  {
    location = vector3(-1387.2, -614.21, 30.32),
    blip = {
      Name = "Bar",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 0
    },
    categorys = {"Alkohol"},
    items = {
      {
        name = 'wein',
        label = 'Weinflasche',
        price = 250,
        category = "Alkohol"
      }    }
  },

  {
    location = vector3(1135.58, -982.21, 46.42),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },

  {
    location = vector3(2557.32, 382.09, 108.62),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },
  {
    location = vector3(555.22, 2795.44, 38.2),
    blip = {
      Name = "Dullis Schmuggelbude",
      Sprite = 567,
      Scale = 0.8,
      Colour = 40,
      Display = 2
    },
    categorys = {"waffenaufsätze","munition","Militärstuff"},
    items = {
      {
        name = 'silencieux',
        label = 'Schalldämpfer',
        price = 55000,
        category = "waffenaufsätze"
      },
      {
        name = 'grip',
        label = 'Waffengriff',
        price = 28800,
        category = "waffenaufsätze"
      },
      {
        name = 'flashlight',
        label = 'Taktische Lampe',
        price = 17000,
        category = "waffenaufsätze"
      },
      {
        name = 'bulletproof',
        label = 'Schutzweste',
        price = 5000,
        category = "Militärstuff"
      },
      {
        name = 'clip',
        label = 'Munition',
        price = 15000,
        category = "munition"
      }
    }
  },
  {
    location = vector3(-1820.44, 792.64, 138.11),
    blip = {
      Name = "Supermarkt",
      Sprite = 52,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"lottery","misc"},
    items = {
      {
        name = 'spray_remover',
        label = 'Schwamm',
        price = 3000,
        category = "misc"
      },
      {
        name = 'spray',
        label = 'Spray',
        price = 5000,
        category = "misc"
      },
      {
        name = 'contract',
        label = 'Kaufvertrag',
        price = 3500,
        category = "misc"
      },
      {    
        name = 'fixkit',
        label = 'Reperaturkit',
        price = 2800,
        category = "misc"
      },
      {
        name = 'kabelbinder',
        label = 'Kabelbinder',
        price = 2800,
        category = "misc"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 800,
        category = "lottery"
      }
    }
  },
  {
    location = vector3(959.26, 25.03, 76.99),
    blip = {
      Name = "Casino",
      Sprite = 617,
      Scale = 0.8,
      Colour = 2,
      Display = 2
    },
    categorys = {"casino","trinken"},
    items = {
      {
        name = 'spielechipspack',
        label = 'SpieleChips',
        price = 5000,
        category = "casino"
      },
      {
        name = 'scratchcard',
        label = 'Rubbellos',
        price = 5000,
        category = "casino"
      },
      {
        name = 'wein',
        label = 'Weinflasche',
        price = 2000,
        category = "trinken"
      }

    }
},
{
    location = vector3(149.39, -232.85, 54.42),
    blip = {
      Name = "Handyladen",
      Sprite = 767,
      Scale = 0.8,
      Colour = 8,
      Display = 2
    },
    categorys = {"Elektronik","simkarten"},
    items = {
      {
        name = 'phone',
        label = 'Smarthphone',
        price = 4000,
        category = "Elektronik"
      }
    }
  },
  {
    location = vector3(4834.9, -5175.91, 2.16),
    blip = {
      Name = "Blackmarket",
      Sprite = 767,
      Scale = 0.8,
      Colour = 8,
      Display = 0 -- Würd ich auf 2 stellen würde man sehen wo de rShop is 
    },
    categorys = {"Werkzeug","Tools"},
    items = {
      {
        name = 'lockpick',
        label = 'Lockpick Set',
        price = 3000,
        category = "Werkzeug"
      },
      { -- du siehst hier klammer auf 
        name = 'drill',
        label = 'Bohrer',
        price = 100000,
        category = "Werkzeug"
      }, -- und hier geht sie zu 
      { -- Ne das is das Item 
        name = 'hackerDevice',
        label = 'Sakura OS Gerät',
        price = 150000,
        category = "Tools" -- Korrekt 
      }
    }
  },
  {
    location = vector3(1029.96, 2461.96, 45.94),
    blip = {
      Name = "",
      Sprite = 0,
      Scale = 0.8,
      Colour = 8,
      Display = 0
    },
    categorys = {"Laborupgrades","Laboritems"},
    items = {
      {
        name = 'kochtopf',
        label = 'Kochtopf',
        price = 4000,
        category = "Laboritems"
      },
      {
        name = 'metchkitchen',
        label = ' Methküche',
        price = 400000,
        category = "Laborupgrades"
      }
    }
  },
  {
    location = vector3(51.17, -810.27, 31.54),
    blip = {
      Name = "Shishabar",
      Sprite = 304,
      Scale = 0.8,
      Colour = 13,
      Display = 2
    },
    categorys = {"shisha","misc"},
    items = {
      {
        name = 'hookah',
        label = 'Pfeife',
        price = 20000,
        category = "shisha"
      }
    }
  }
}
