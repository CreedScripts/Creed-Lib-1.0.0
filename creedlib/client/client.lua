local CreedCore = {}


local function debugPrint(message)
    print(('[CreedLib - CLIENT] %s'):format(message))
end


CreedCore.Functions = {

    GetPlayerName = function()
        local playerName = GetPlayerName(PlayerId())
        debugPrint(('Player Name: %s'):format(playerName))
        return playerName
    end,


    Notify = function(message, type)
        debugPrint(('Showing notification: %s [%s]'):format(message, type or 'info'))
        exports.ox_lib:notify({
            description = message,
            type = type or 'info', 
            duration = 5000 
        })
    end,


    Teleport = function(coords)
        local playerPed = PlayerPedId()
        debugPrint(('Teleporting player to: %.2f, %.2f, %.2f'):format(coords.x, coords.y, coords.z))
        SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
        CreedCore.Functions.Notify('You have been teleported!', 'success')
    end,


    ApplyDrugEffect = function()
        debugPrint('Applying drug effect...')
        StartScreenEffect('DrugsMichaelAliensFight', 0, true)
        CreedCore.Functions.Notify('Drug effect applied!', 'info')
        Citizen.Wait(10000) -- Effect duration
        StopScreenEffect('DrugsMichaelAliensFight')
        CreedCore.Functions.Notify('Drug effect worn off!', 'info')
    end,


    SetWalkingStyle = function(style)
        local playerPed = PlayerPedId()
        debugPrint(('Changing walking style to: %s'):format(style))
        RequestAnimSet(style)
        while not HasAnimSetLoaded(style) do
            Citizen.Wait(0)
        end
        SetPedMovementClipset(playerPed, style, 0.2)
        CreedCore.Functions.Notify(('Walking style set to: %s'):format(style), 'info')
    end,


    ResetWalkingStyle = function()
        debugPrint('Resetting walking style...')
        ResetPedMovementClipset(PlayerPedId(), 0.2)
        CreedCore.Functions.Notify('Walking style reset!', 'info')
    end
}


local function getCoreObject()
    return CreedCore
end


exports('getCoreObject', getCoreObject)


debugPrint('CreedLib client.lua with Core Object loaded successfully!')




local CreedCore = {}


local function debugPrint(message)
    print(('[CreedLib - CLIENT] %s'):format(message))
end


CreedCore.Functions = {

    LoadModel = function(model)
        if not IsModelInCdimage(model) then
            debugPrint(('Model %s does not exist.'):format(model))
            return false
        end

        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        debugPrint(('Model %s loaded successfully.'):format(model))
        return true
    end,


    Notify = function(message, type)
        exports.ox_lib:notify({
            description = message,
            type = type or 'info',
            duration = 5000
        })
    end
}


local function getCoreObject()
    return CreedCore
end


exports('getCoreObject', getCoreObject)


debugPrint('CreedLib client.lua loaded with LoadModel!')
