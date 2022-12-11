---------------------------------------------------------------------
                --[[SCRIPT MADE BY : ALEXMIHAI04]]--
               --[[DO NOT SELL OR COPY THIS SCRIPT]]--
                   --[[github.com/ItsAlexYTB]]--
        --[[ENJOY THE SCRIPT , DO NOT MAKE 1000 NPCS :))))) ]]
---------------------------------------------------------------------

--[[EXPLANATION [EN]: 

-1,2,3 : Coordonates
-4 : Name for the drawtext
-5 : Ped heading
-6 : Ped hash
-7: Ped model

]]--

--[[DO NOT TOUCH IF YOU DON'T KNOW WHAT YOU DO]]--

--[[EXPLANATION [RO]
-1,2,3 : sunt coordonatele de la npc
-4 : Numele care apare deasupra npc-ului
-5 : Heading (partea in care sta orientat)
-6 : Hash de la ped , se poate lua de pe net
-7 : Modelul de la ped , asemenea , il gasiti pe net

]]--

local coordonate = {
    {1117.8, -3195.93, -41.4,"",317.05,0xAD9EF1BB,"s_m_o_busker_01"},
    {-1828.19, -1193.78, 13.31,"",240.69,0xBB0D72F5,"U_F_M_CasinoCash_01"},
    {24.4, -1347.08, 28.5,"",263.59,0x18CE57D0,"mp_m_shopkeep_01"},
    {-47.21, -1758.57, 28.42,"",50.26,0x18CE57D0,"mp_m_shopkeep_01"},
    {4904.84, -4941.59, 2.38,"",34.26,0x18CE57D0,"mp_m_shopkeep_01"}, --perico
    {125.26, -1036.74, 28.28,"",66.45,0xAD9EF1BB,"s_m_o_busker_01"}, -- orangen verk
    {-1070.67, -2836.41, 26.7,"",285.49,0x18CE57D0,"mp_m_shopkeep_01"},
    {-706.13, -914.8, 18.22,"",84.52,0x18CE57D0,"mp_m_shopkeep_01"},
    {-1388.1, -613.0, 29.32,"",207.52,0x780C01BD,"s_f_y_bartender_01"}, -- Bar
    {-1486.58, -377.61, 39.16,"",135.09,0x5244247D,"u_m_y_baygor"},  -- Sch�biger Laden
    {1164.97, -323.88, 68.21,"",90.37,0x18CE57D0,"mp_m_shopkeep_01"},
    {1134.2, -982.87, 45.42,"",279.14,0x5244247D,"u_m_y_baygor"},
    {158.07, 6654.54, 30.67,"",139.67,0x9E08633D,"s_m_y_ammucity_01"},  -- Keyladen
    {-1221.39, -907.99, 11.33,"",24.84,0x5244247D,"u_m_y_baygor"},
    {372.36, 325.87, 102.57,"",276.84,0x18CE57D0,"mp_m_shopkeep_01"},
    {1030.35, 2462.5, 44.94,"",138.84,0xF1E823A2,"g_m_m_armboss_01"},
    {-3242.69, 999.99, 11.83,"",342.09,0x18CE57D0,"mp_m_shopkeep_01"},
    {4834.0, -5175.74, 1.17,"",285.09,0x62CC28E2,"s_m_y_armymech_01"}, --Black
    {-1195.48, -893.34, 13.0,"",285.09,0x18CE57D0,"mp_m_shopkeep_01"},
    {1338.59, 4359.67, 43.37,"",342.09,0xC8BB1E52,"u_m_y_mani"},
    {1697.09, 4923.53, 41.06,"",321.06,0x18CE57D0,"mp_m_shopkeep_01"},
    {-545.06, -203.89, 37.22,"",203.06,0x5D71A46F,"s_f_y_airhostess_01"}, --fffffffg
    {50.25, -811.82, 30.54,"",337.06,0x654AD86E,"a_f_m_downtown_01"}, -- Shisha
    {160.17, 6641.3, 30.61,"",223.49,0x18CE57D0,"mp_m_shopkeep_01"},
    {1960.14, 3739.96, 31.34,"",274.23,0x18CE57D0,"mp_m_shopkeep_01"},
    {-1686.69, 56.66, 63.15,"",140.15,0x62018559,"s_m_y_airworker"},
    {2678.56, 3279.13, 54.24,"",333.66,0x18CE57D0,"mp_m_shopkeep_01"},
    {-3038.43, 584.72, 6.91,"",18.08,0x18CE57D0,"mp_m_shopkeep_01"},
    {-1816.33, -1193.87, 13.3,"",316.58,0x47CF5E96,"a_f_o_ktown_01"},  -- Fish Verk�ufer
    {-775.09, -2632.2, 12.94,"",235.61,0x59511A6C,"s_m_m_trucker_01"},
    {2557.74, 380.73, 107.62,"",353.62,0x18CE57D0,"mp_m_shopkeep_01"},
    {-3424.92, 974.43, 7.35,"",96.73,0xCE9113A9,"s_m_m_strvend_01"}, -- Fish Verarbeiter
    {1984.43, 3054.75, 46.22,"",234.96,0x820B33BD,"ig_denise"},
    {-1263.55, -1140.17, 6.54,"",293.96,0xB3F3EE34,"s_m_y_blackops_01"}, -- Drogen Ankauf
    {555.27, 2796.02, 37.2,"",184.3,0x6C9B2849,"a_m_m_hillbilly_01"},
    {-2071.45, -333.16, 12.34,"",353.38,0x18CE57D0,"mp_m_shopkeep_01"},
    {148.71, -234.55, 53.42,"",337.24,0x625D6958,"s_m_m_ciasec_01"}, 
    {1727.56, 6414.75, 34.04,"",273.23,0x18CE57D0,"mp_m_shopkeep_01"},
    {1165.59, 2710.9, 37.16,"",184.45,0x5244247D,"u_m_y_baygor"},
    {-2966.3, 391.57, 14.04,"",84.78,0x5244247D,"u_m_y_baygor"},
    {-506.74, 5312.13, 79.24,"",273.78,0xB2273D4E,"s_m_y_autopsy_01"},
	{-287.39, 2535.85, 74.47,"",270.78,0x5244247D,"u_m_y_baygor"},
    {53.09, -1479.01, 28.28,"",184.17,0x8B7D3766,"u_m_y_burgerdrug_01"},  -- Orangen Verarbeiter
    {549.03, 2671.82, 41.16,"",101.91,0x18CE57D0,"mp_m_shopkeep_01"},
    {2193.89, 5594.12, 52.76,"",345.27,0x6C19E962,"u_m_m_streetart_01"},
    {-1775.46, 4383.18, 46.08,"",331.27,0x6C19E962,"u_m_m_streetart_01"},
    {1208.44, -3114.66, 4.55,"",92.76,0x106D9A99,"g_m_m_chicold_01"},
    {291.84, -1272.61, 28.52,"",354.29,0xCA56FA52,"a_m_y_beachvesp_02"},
  {-224.38,-1319.87,29.90,"",182.3,0xffffffff9760192e,"cs_bankman"},
    {-196.27,-1318.22,30.10,"",86.82,0xffffffff98f9e770,"cs_old_man2"},
    {794.31, -218.92, 36.08,"",119.52,0xCF623A2C,"u_m_y_antonb"},
    {-176.72,-1283.6,30.3,"",139.83,0xfffffffff00b49db,"csb_prologuedriver"},
    {-806.1, -1368.41, 4.18,"",334.45,0xEDBC7546,"s_m_m_fiboffice_01"}
	}
Citizen.CreateThread(function()
    vector3(-805.74, -1368.51, 5.18)
    for _,v in pairs(coordonate) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
  
      RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
      end
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        Citizen.Wait(0)
        for _,v in pairs(coordonate) do
            x = v[1]
            y = v[2]
            z = v[3]
            if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 20.0)then
                DrawText3D(x,y,z+2.10, "~g~"..v[4], 1.2, 1)
                DrawText3D(x,y,z+1.95, "~w~", 1.0, 1)
            end
        end
    end
end)


function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

--[[ENJOY]]--