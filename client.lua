Config = {}
Config.Items = {
    { label = "ماء", name = "water", price = 5 , image = 'https://cdn-icons-png.flaticon.com/512/824/824239.png' },
    { label = "عصير برتقال", name = "orange_juice", price = 7 , image = 'https://cdn-icons-png.flaticon.com/512/2442/2442251.png'},
    { label = "خبز", name = "bread", price = 10, image = 'https://cdn-icons-png.flaticon.com/512/1182/1182129.png' },
    { label = "شيكولاته", name = "chocolate", price = 15, image = 'https://cdn-icons-png.flaticon.com/512/2136/2136997.png'},
    { label = "جالاكسي", name = "chaser", price = 7, image = 'https://cdn-icons-png.flaticon.com/512/16996/16996255.png' },
    { label = "كوكاكولا", name = "cola", price = 10, image = 'https://cdn-icons-png.flaticon.com/512/2405/2405447.png' },
    { label = "عصير", name = "juice", price = 15, image = 'https://cdn-icons-png.flaticon.com/512/5821/5821103.png' },
    { label = "ولاعة سخان", name = "lighter", price = 7, image = 'https://cdn-icons-png.flaticon.com/512/1930/1930639.png' },
    { label = "مصاصه", name = "lollipop", price = 10, image = 'https://cdn-icons-png.flaticon.com/512/11702/11702069.png' },
    { label = "بيبسي", name = "pepsi", price = 15, image = 'https://cdn-icons-png.flaticon.com/512/1159/1159145.png' },
    { label = "راديو", name = "radio", price = 7, image ='https://cdn-icons-png.flaticon.com/512/3814/3814416.png'},
    { label = "حبل", name = "rope", price = 10}
}
Config.supermarkets = {
    { x = 269.0920, y = -980.3533, z = 29.3696},
}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)
function getItems()
    return Config.Items
end
local supermarketBlips = {}

Citizen.CreateThread(function()
   
    for _, supermarket in pairs(Config.supermarkets) do
        local blip = AddBlipForCoord(supermarket.x, supermarket.y, supermarket.z)
        SetBlipSprite(blip, 52) 
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("سوبرماركت")
        EndTextCommandSetBlipName(blip)
        table.insert(supermarketBlips, blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, supermarket in pairs(supermarketBlips) do
            local blipCoords = GetBlipCoords(supermarket)
            local distance = GetDistanceBetweenCoords(playerCoords, blipCoords, true)

            if distance < 10.0 then
                ESX.ShowHelpNotification('اضغط ~INPUT_CONTEXT~ لفتح المتجر')
                if IsControlJustReleased(0, 38) then 
                    SetNuiFocus(true, true)
                    SendNUIMessage({ action = 'open' })
                end
            end
        end
    end
end)

RegisterNUICallback('requestItems', function(_, cb)
    cb(getItems())
end)

RegisterNUICallback('purchaseItems', function(data, cb)
    TriggerServerEvent('supermarket:buyItems', data)
    cb('success')
end)

RegisterCommand('openSupermarket', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
end, false)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    cb('ok')
end)
function closeMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end