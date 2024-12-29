local CreedCore = {
    Functions = {} 
}


local function debugPrint(message)
    print(('[CreedLib - SERVER] %s'):format(message))
end


local ActiveFramework = nil

local function detectFramework()
    if GetResourceState('qb-core') == 'started' then
        ActiveFramework = 'QBCore'
        debugPrint('Detected QBCore Framework.')
    elseif GetResourceState('es_extended') == 'started' then
        ActiveFramework = 'ESX'
        debugPrint('Detected ESX Framework.')
    elseif GetResourceState('qbox') == 'started' then
        ActiveFramework = 'QBOX'
        debugPrint('Detected QBOX Framework.')
    else
        ActiveFramework = nil
        debugPrint('No compatible framework detected.')
    end
end


detectFramework()

local function CreatePlayerObject(player)
    if ActiveFramework == 'QBCore' then
        return {
            Functions = {
                GetItemByName = function(itemName)
                    return player.Functions.GetItemByName(itemName)
                end,
                RemoveItem = function(itemName, amount)
                    player.Functions.RemoveItem(itemName, amount)
                end,
                AddItem = function(itemName, amount)
                    player.Functions.AddItem(itemName, amount)
                end,
                AddMoney = function(account, amount)
                    player.Functions.AddMoney(account, amount)
                end,
                RemoveMoney = function(account, amount)
                    return player.Functions.RemoveMoney(account, amount)
                end
            }
        }
    elseif ActiveFramework == 'ESX' then
        return {
            Functions = {
                GetItemByName = function(itemName)
                    return player.getInventoryItem(itemName)
                end,
                RemoveItem = function(itemName, amount)
                    player.removeInventoryItem(itemName, amount)
                end,
                AddItem = function(itemName, amount)
                    player.addInventoryItem(itemName, amount)
                end,
                AddMoney = function(account, amount)
                    player.addAccountMoney(account, amount)
                end,
                RemoveMoney = function(account, amount)
                    return player.removeAccountMoney(account, amount)
                end
            }
        }
    elseif ActiveFramework == 'QBOX' then
        return {
            Functions = {
                GetItemByName = function(itemName)
                    return player.GetInventoryItem(itemName)
                end,
                RemoveItem = function(itemName, amount)
                    player.RemoveInventoryItem(itemName, amount)
                end,
                AddItem = function(itemName, amount)
                    player.AddInventoryItem(itemName, amount)
                end,
                AddMoney = function(account, amount)
                    player.AddMoney(account, amount)
                end,
                RemoveMoney = function(account, amount)
                    return player.RemoveMoney(account, amount)
                end
            }
        }
    else
        return nil
    end
end


CreedCore.Functions.GetPlayer = function(src)
    if ActiveFramework == 'QBCore' then
        local Player = exports['qb-core']:GetCoreObject().Functions.GetPlayer(src)
        if Player then
            debugPrint(('Player data found for source %d in QBCore.'):format(src))
            return CreatePlayerObject(Player)
        end
    elseif ActiveFramework == 'ESX' then
        local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(src)
        if xPlayer then
            debugPrint(('Player data found for source %d in ESX.'):format(src))
            return CreatePlayerObject(xPlayer)
        end
    elseif ActiveFramework == 'QBOX' then
        local Player = exports['qbox']:GetPlayer(src)
        if Player then
            debugPrint(('Player data found for source %d in QBOX.'):format(src))
            return CreatePlayerObject(Player)
        end
    end

    debugPrint(('Player data NOT found for source %d. Framework: %s'):format(src, ActiveFramework or 'None'))
    return nil
end


exports('getCoreObject', function()
    return CreedCore
end)


debugPrint('CreedLib server.lua initialized successfully!')
print('CreedCore:', CreedCore)
print('CreedCore.Functions:', CreedCore.Functions)
print('CreedCore.Functions.GetPlayer:', CreedCore.Functions.GetPlayer)




