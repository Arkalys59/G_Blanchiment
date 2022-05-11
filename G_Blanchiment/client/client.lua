Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(5000)
    end
end)

local mainMenu = RageUI.CreateMenu("Menu Blanchissement", "MENU")
local open = false
IndexSale,amount,index,percentage,arguments = 0,0.0,0,true,true

mainMenu.Closed = function() open,IndexSale,amount = false,0,0.0 end
mainMenu.EnableMouse = true

function Blanchissement()
    if not open then open = true RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    ESX.PlayerData = ESX.GetPlayerData()                   
                    RageUI.Separator("Taux : ~o~"..G_Blanchissement.Pourcentage.."%")
                    RageUI.Separator("Votre Compte : ~r~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[2].money).."$")
                    RageUI.Separator("Montant final : ~g~"..amount.."$")
                    RageUI.Button("Blanchir le montant sélectionné", nil, {RightLabel = "→"}, arguments, {
                        onSelected = function()
                            mainMenu.Closable,arguments,percentage = false,false,false                                                        
                        end
                    })
                    if percentage then
                        RageUI.SliderPanel(IndexSale, 0, "Montant : ~b~"..IndexSale.."$", ESX.PlayerData.accounts[2].money, {  
                            onSliderChange = function(Index)
                                IndexSale = Index
                                amount = ((IndexSale*(100-G_Blanchissement.Pourcentage))/100)
                                valueindex = 1 / IndexSale
                            end
                        }, 4)
                    else
                        RageUI.PercentagePanel(index, "Argent Blanchis : ~g~"..math.floor(index*IndexSale).."$", "", "", {})
                        if index < 1.0 then
                            index = index + valueindex
                        else
                            percentage,arguments,mainMenu.Closable,index = true,true,true,0
                            TriggerServerEvent("G_Blanchissement:wash", amount)
                        end
                    end
                end)
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k,v in pairs(G_Blanchissement.coords) do
            local coords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(coords.x, coords.y, coords.z, v.x, v.y, v.z)
            if dist <= 2.0 then 
                wait = 0 
                ESX.ShowHelpNotification("~INPUT_TALK~ pour parler au ~r~Blanchisseur")
                if IsControlJustPressed(1,51) then 
                    Blanchissement()
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("cs_movpremmale")
    while not HasModelLoaded(hash) do RequestModel(hash) Wait(20) end
	ped = CreatePed("PED_TYPE_CIVMALE", "cs_movpremmale", G_Blanchissement.coordsped.x, G_Blanchissement.coordsped.y, G_Blanchissement.coordsped.z, G_Blanchissement.coordsped.h, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
end)