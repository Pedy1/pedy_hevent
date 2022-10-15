local framework = nil

if GetResourceState('es_extended') == 'started' or GetResourceState('es_extended') == 'starting' then
    framework = 'esx'
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' or GetResourceState('qb-core') == 'starting' then
    framework = 'qb'
    QBCore = exports['qb-core']:GetCoreObject()
else
    print("^0[^1ERROR^0] A scriptett nem sikerült inicializálni!^0")
    print("^0[^1ERROR^0] Segítségért: Pedy#9084 ^0")
end
local houses = {}

if framework == 'esx' then
    ESX.RegisterUsableItem(Config.CandyBasket, function(source)
        TriggerClientEvent('pedy_hevent:usePumpkin', source)
    end)
else
    QBCore.Functions.CreateUseableItem(Config.CandyBasket, function(source)
        TriggerClientEvent('pedy_hevent:usePumpkin', source)
    end)
end

RegisterServerEvent('pedy_hevent:deleteObj')
AddEventHandler('pedy_hevent:deleteObj', function(netId)
    TriggerClientEvent('pedy_hevent:deletePumpkin', -1, netId)
end)

lib.callback.register('pedy_hevent:canKnock', function(source, house)
    if houses[house] then
        return false
    else
        return true
    end
end)

lib.callback.register('pedy_hevent:syncBlips', function(source)
    if #houses < 1 then
        return false
    else
        return houses
    end
end)

RegisterServerEvent('pedy_hevent:trickOrTreat')
AddEventHandler('pedy_hevent:trickOrTreat', function(house, coords)
    if not houses[house] then
        local dist = #(Config.Houses[house] - coords)
        if dist < 5.5 then
            local rTreat = Config.Treats[math.random(1,#Config.Treats)]
            if framework == 'esx' then
                local xPlayer = ESX.GetPlayerFromId(source)
                xPlayer.addInventoryItem(rTreat.item, math.random(rTreat.min,rTreat.max))
            else
                local Player = QBCore.Functions.GetPlayer(source)
                Player.Functions.AddItem(rTreat.item, math.random(rTreat.min,rTreat.max))
				TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[rTreat.item], "add")
            end
            houses[house] = true
            TriggerClientEvent('pedy_hevent:removeBlip', -1, house)
        end
    end
end)
