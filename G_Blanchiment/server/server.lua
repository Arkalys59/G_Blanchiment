ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("G_Blanchissement:wash")
AddEventHandler("G_Blanchissement:wash", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	if amount > 0 then
		if account.money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
			xPlayer.addMoney(amount)
			TriggerClientEvent("esx:showNotification", source, "Vous venez de blanchir ~r~"..amount.."$~w~ d'argent sale")
        	TriggerClientEvent("esx:showNotification", source, "Vous venez de recevoir ~g~"..amount.."$~w~ d'argent propre")
		else
			TriggerClientEvent("esx:showNotification", source, "Vous n'avez pas assez d'argent")
		end
	else
		TriggerClientEvent("esx:showNotification", source, "La somme à blanchir ne peut pas être de ~g~0$")
	end
end)