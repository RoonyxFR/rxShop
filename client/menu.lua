quantityToBuyToBuy = 1

shopState = false
local shopMenu = RageUI.CreateMenu("Supérette", "Nos rayons : ")
local boissonsMenu = RageUI.CreateSubMenu(shopMenu, "Supérette", "Sélectionnez une boisson : ")
local alimentsMenu = RageUI.CreateSubMenu(shopMenu, "Supérette", "Sélectionnez un aliment : ")
local diversMenu = RageUI.CreateSubMenu(shopMenu, "Supérette", "Sélectionnez un produit : ")
local payementMenu = RageUI.CreateSubMenu(shopMenu, "Supérette", "Sélectionnez un payement : ")
shopMenu.Closed = function()
    shopState = false
end

function rxShop()
    if shopState then
        shopState = false
        RageUI.Visible(shopMenu, false)
        return
    else
        shopState = true
        RageUI.Visible(shopMenu, true)
    end

    CreateThread(function()
        while shopState do
            Wait(1)

            RageUI.IsVisible(shopMenu, function()
                RageUI.Separator("~o~↓↓~s~  Supérette  ~o~↓↓~s~")
                RageUI.Line()

                RageUI.Button("Nos boissons", nil, {RightLabel = "→→"}, true, {
                }, boissonsMenu)

                RageUI.Button("Nos aliments", nil, {RightLabel = "→→"}, true, {
                }, alimentsMenu)

                RageUI.Button("Nos produits électroniques", nil, {RightLabel = "→→"}, true, {
                }, diversMenu)
            end)

            RageUI.IsVisible(boissonsMenu, function()
                RageUI.Separator("~o~↓↓~s~  Nos boissons  ~o~↓↓~s~")
                RageUI.Line()

                for k,v in pairs(rxConfig.Boissons) do
                    RageUI.Button(v.label, nil, {RightLabel = ("~g~%s$~s~ →→"):format(v.price)}, true, {
                        onSelected = function()
                            infoToSubMenu(v)
                        end
                    }, payementMenu)
                end
            end)

            RageUI.IsVisible(alimentsMenu, function()
                RageUI.Separator("~o~↓↓~s~  Nos aliments  ~o~↓↓~s~")
                RageUI.Line()

                for k,v in pairs(rxConfig.Aliment) do
                    RageUI.Button(v.label, nil, {RightLabel = ("~g~%s$~s~ →→"):format(v.price)}, true, {
                        onSelected = function()
                            infoToSubMenu(v)
                        end
                    }, payementMenu)
                end
            end)

            RageUI.IsVisible(diversMenu, function()
                RageUI.Separator("~o~↓↓~s~  Nos produits  ~o~↓↓~s~")
                RageUI.Line()

                for k,v in pairs(rxConfig.Divers) do
                    RageUI.Button(v.label, nil, {RightLabel = ("~g~%s$~s~ →→"):format(v.price)}, true, {
                        onSelected = function()
                            infoToSubMenu(v)
                        end
                    }, payementMenu)
                end
            end)

            RageUI.IsVisible(payementMenu, function()
                if label ~= nil then
                    RageUI.Separator("~b~↓↓~s~  Moyen de payement  ~b~↓↓~s~")
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'money' then
                            RageUI.Separator(("Liquide : ~g~%s$~s~"):format(ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)))
                        end
                    end

                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'bank' then
                            RageUI.Separator(("Banque : ~b~%s$~s~"):format(ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)))
                        end
                    end
                    RageUI.Separator(("[ %s - ~g~%s$~s~ ]"):format(label, price * quantityToBuy))
                    RageUI.Line()

                    RageUI.Button("Définissez la quantité :", nil, {RightLabel = ("%s"):format(quantityToBuy)}, true, {
                        onSelected = function()
                            local quantity = EntrerText("Combien souhaitez vous en acheter ", "", 3)

                            if tonumber(quantity) then
                                quantityToBuy = tonumber(quantity)
                            else
                            Notification("[~r~Erreur~s~] Seuls les chiffres sont tolérés.")
                            end
                        end
                    })

                    RageUI.Button("Payer en liquide", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('rxShop:Payement', 'liquide', label, name, price, quantityToBuy)
                            RageUI.GoBack()
                        end
                    })

                    RageUI.Button("Payer en banque", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('rxShop:Payement', 'banque', label, name, price, quantityToBuy)
                            RageUI.GoBack()
                        end
                    })
                end
            end)
        end
    end)
end