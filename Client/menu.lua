
-------------------------Declare ESX-------------------------
ESX = exports['es_extended']:getSharedObject()
local ArgentSaleVisu = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

-------------------------Menu--------------------------------
open = false
local MainMenu = RageUI.CreateMenu("Blanchisseur", "Interaction")


MainMenu.Closed = function() 
    open = false 
    FreezeEntityPosition(PlayerPedId(), false)
end

local function OpenMenuBlanchiment()
    if open then 
        open = false 
        RageUI.Visible(MainMenu, false)
    else
        open = true 
        RageUI.Visible(MainMenu, true)
        Citizen.CreateThread(function()
            while open do 

                RageUI.IsVisible(MainMenu, function()

                    RageUI.Line()
                    RageUI.Separator("~r~→ ~s~ Taxe: ~r~".. Blanchi.Pourcent.PourcentageVisu .. "~s~%")
                    RageUI.Line()         
                    RageUI.Button("Blanchire", nil, {}, true , {
                        onSelected = function()

 

                            local input = lib.inputDialog('Blanchissement', {  
                                {type = 'number', label = 'Montant', description = 'Choisi un montant à blanchir', icon = 'hashtag'},
                        })
 
                        if not input then return end
                        
                        print( input[1])
                        local ArgentSale = input[1]


                            TriggerServerEvent('ExodeRP:Blanchiment', ArgentSale)
                            RageUI.CloseAll()

                        end
                    })

                end)


                Wait(0)

            end
        end)
    end
end




-------------------------Ouvrir Menu-----------------------------



Citizen.CreateThread(function()
    while true do
        local Timer = 500
        for k,v in pairs(Blanchi.pos) do 
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v)
            if distance <= 3.0 then
                Timer = 0   
                DrawMarker(22, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
            end
            if distance <= 2.0 then
                Timer = 0   
                lib.showTextUI('[E] - Pour blanchir')
                if IsControlJustPressed(1,51) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    OpenMenuBlanchiment()
                end
            end
        end 
        Citizen.Wait(Timer)
        lib.hideTextUI()

    end
end)

