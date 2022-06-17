ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------> Payement <-----------------------------------------------

RegisterServerEvent("rxShop:Payement")
AddEventHandler("rxShop:Payement", function(type, label, name, price, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    local total = price * quantity

    if type == "liquide" then
        if xPlayer.getMoney() >= total then
            xPlayer.removeMoney(total)
            xPlayer.addInventoryItem(name, quantity)
            TriggerClientEvent('esx:showNotification', source, ("[~g~Succès~s~] Vous avez acheter %sx %s. (~r~-%s$~s~)"):format(quantity, label, total))
        else
            TriggerClientEvent('esx:showNotification', source, "[~r~Impossible~s~] Vous n'avez pas assez d'argent dans votre portefeuille.")
        end
    elseif type == "banque" then
        if xPlayer.getAccount('bank').money >= total then
            xPlayer.removeAccountMoney('bank', total)
            xPlayer.addInventoryItem(name, quantity)
            TriggerClientEvent('esx:showNotification', source, ("[~g~Succès~s~] Vous avez acheter %sx %s. (~r~-%s$~s~)"):format(quantity, label, total))
        else
            TriggerClientEvent('esx:showNotification', source, "[~r~Impossible~s~] Vous n'avez pas assez d'argent dans votre compte bancaire.")
        end
    end
end)