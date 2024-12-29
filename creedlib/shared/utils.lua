function DebugPrint(message)
    print(('[CreedLib - SHARED] %s'):format(message))
end


function DeepCopy(original)
    if type(original) ~= 'table' then
        return original
    end
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = DeepCopy(value)
    end
    return copy
end


function TableToJson(tbl, pretty)
    local json = json.encode(tbl, { indent = pretty and 2 or nil })
    return json
end


function JsonToTable(jsonString)
    local success, result = pcall(json.decode, jsonString)
    if success then
        return result
    else
        DebugPrint(('Failed to decode JSON string: %s'):format(jsonString))
        return nil
    end
end


function FormatString(format, ...)
    local success, result = pcall(string.format, format, ...)
    if success then
        return result
    else
        DebugPrint('Failed to format string: Invalid arguments provided.')
        return format
    end
end


function GetRandomItem(tbl)
    if type(tbl) ~= 'table' or #tbl == 0 then
        DebugPrint('GetRandomItem: Invalid table or empty table provided.')
        return nil
    end
    return tbl[math.random(1, #tbl)]
end


function TableContains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end


function SplitString(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch('(.-)' .. delimiter) do
        table.insert(result, match)
    end
    return result
end


function RoundNumber(num, numDecimalPlaces)
    local multiplier = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end


DebugPrint('CreedLib shared/utils.lua loaded successfully!')
