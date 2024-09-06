ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('supermarket:buyItems')
AddEventHandler('supermarket:buyItems', function(items)
    local xPlayer = ESX.GetPlayerFromId(source)
    local totalPrice = 0

    for i=1, #items do
        totalPrice = totalPrice + items[i].price
    end

    if xPlayer.getMoney() >= totalPrice then
        xPlayer.removeMoney(totalPrice)

        for i=1, #items do
            xPlayer.addInventoryItem(items[i].name, 1)
        end

        TriggerClientEvent('esx:showNotification', source, 'لقد قمت بشراء المنتجات بنجاح.')
    else
        TriggerClientEvent('esx:showNotification', source, 'ليس لديك ما يكفي من المال!')
    end
end)
