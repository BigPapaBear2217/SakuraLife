-- Made by ! der_nqmenl0se#1337 --
-- Support & more of my Work - https://discord.gg/6jsHUVMh8G --
-- Copyright (C) 2021 - EgoPvP.com
-- This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published 
-- by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.
-- This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or 
-- FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.
-- You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.

local markerType = 1 -- Change to a Marker of your choice - https://docs.fivem.net/docs/game-references/markers/

local markerColorR = 255 -- Change Marker color here (RED)
local markerColorG = 51 -- Change Magithrker color here (GREEN)
local markerColorB = 204 -- Change Marker color here (BLUE)

local afterBurn = 5000 -- How long should the Marker be drawn after the range has been changed?

local isDrawing = false -- don't touch!
local curProx = 0.0 -- don't touch!

RegisterNetEvent('SaltyChat_VoiceRangeChanged')
AddEventHandler('SaltyChat_VoiceRangeChanged', function(range)


   
    isDrawing = true
    curProx = tonumber(range)

    CreateThread(function() 
     drawMarker()
    end)
    Wait(afterBurn)

   
    isDrawing = false

end)

function drawMarker()

    
    while isDrawing do

      
        local posPlayer = GetEntityCoords(PlayerPedId())

     
        DrawMarker(markerType, posPlayer.x, posPlayer.y, posPlayer.z - 1, 0, 0, 0, 0, 0, curProx * 2, curProx * 2, 0.8001, 0, markerColorR, markerColorG, markerColorB, 0, 0, 0, 0)

        Wait(1)

    end

end
