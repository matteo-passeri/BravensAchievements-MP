-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

BB_Achievements_Utils = {}

BB_Achievements_Utils.TryPlaySoundClip = function(obj, soundName)
	if obj:getEmitter():isPlaying(soundName) then return end
    obj:getEmitter():playSoundImpl(soundName, IsoObject.new())
end

BB_Achievements_Utils.TryStopSoundClip = function(obj, soundName)
	if not obj:getEmitter():isPlaying(soundName) then return end
	obj:getEmitter():stopSoundByName(soundName)
end

BB_Achievements_Utils.WrapText = function(inputString, lineLength)
    if inputString == nil then return "ERR: NO TEXT FOUND" end
    local lines = {}
    local line = ""
    for word in inputString:gmatch("%S+") do
        if #line + #word + 1 <= lineLength then
            if line ~= "" then
                line = line .. " " .. word
            else
                line = word
            end
        else
            table.insert(lines, line)
            line = word
        end
    end
    table.insert(lines, line)
    return table.concat(lines, "\n")
end

BB_Achievements_Utils.TruncateString = function(inputString, lineLength)
    if inputString == nil then return "ERR: NO TEXT FOUND" end
    if #inputString > lineLength then
        return inputString:sub(1, lineLength) .. "..."
    else
        return inputString
    end
end

BB_Achievements_Utils.WrapAndTruncateString = function(inputString, wrapLength, truncateLength)
    if inputString == nil then return "ERR: NO TEXT FOUND" end
    local wrappedText = BB_Achievements_Utils.WrapText(inputString, wrapLength)
    local truncatedText = BB_Achievements_Utils.TruncateString(wrappedText, truncateLength)
    return truncatedText
end

-- Credits for this function: Konijima
BB_Achievements_Utils.DelayFunction = function(func, delay)

    delay = delay or 1
    local ticks = 0
    local canceled = false

    local function onTick()

        if not canceled and ticks < delay then
            ticks = ticks + 1
            return
        end

        Events.OnTick.Remove(onTick)
        if not canceled then func() end
    end

    Events.OnTick.Add(onTick)
    return function()
        canceled = true
    end
end

-- Helper function to check if an element is in a table
BB_Achievements_Utils.tableContains = function(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

BB_Achievements_Utils.KeyMappings = {
    ["ESC"] = 1,
    ["1"] = 2,
    ["2"] = 3,
    ["3"] = 4,
    ["4"] = 5,
    ["5"] = 6,
    ["6"] = 7,
    ["7"] = 8,
    ["8"] = 9,
    ["9"] = 10,
    ["0"] = 11,
    ["-"] = 12,
    ["="] = 13,
    ["BACKSPACE"] = 14,  -- Assuming this is the Backspace key
    ["TAB"] = 15,
    ["Q"] = 16,
    ["W"] = 17,
    ["E"] = 18,
    ["R"] = 19,
    ["T"] = 20,
    ["Y"] = 21,
    ["U"] = 22,
    ["I"] = 23,
    ["O"] = 24,
    ["P"] = 25,
    ["["] = 26,
    ["]"] = 27,
    ["ENTER"] = 28,
    ["LEFT_CTRL"] = 29,  -- Assuming this is the Left Ctrl key
    ["A"] = 30,
    ["S"] = 31,
    ["D"] = 32,
    ["F"] = 33,
    ["G"] = 34,
    ["H"] = 35,
    ["J"] = 36,
    ["K"] = 37,
    ["L"] = 38,
    [";"] = 39,
    ["'"] = 40,
    ["`"] = 41,
    ["LEFT_SHIFT"] = 42,  -- Assuming this is the Left Shift key
    ["\\"] = 43,
    ["Z"] = 44,
    ["X"] = 45,
    ["C"] = 46,
    ["V"] = 47,
    ["B"] = 48,
    ["N"] = 49,
    ["M"] = 50,
    [","] = 51,
    ["."] = 52,
    ["/"] = 53,
    ["RIGHT_SHIFT"] = 54,  -- Assuming this is the Right Shift key
    ["*"] = 55,
    ["LEFT_ALT"] = 56,  -- Assuming this is the Left Alt key
    ["SPACE"] = 57,
    ["CAPS_LOCK"] = 58,
    ["F1"] = 59,
    ["F2"] = 60,
    ["F3"] = 61,
    ["F4"] = 62,
    ["F5"] = 63,
    ["F6"] = 64,
    ["F7"] = 65,
    ["F8"] = 66,
    ["F9"] = 67,
    ["F10"] = 68,
    ["NUM_LOCK"] = 69,
    ["SCROLL_LOCK"] = 70,
    ["NUMPAD_7"] = 71,
    ["NUMPAD_8"] = 72,
    ["NUMPAD_9"] = 73,
    ["NUMPAD_MINUS"] = 74,
    ["NUMPAD_4"] = 75,
    ["NUMPAD_5"] = 76,
    ["NUMPAD_6"] = 77,
    ["NUMPAD_PLUS"] = 78,
    ["NUMPAD_1"] = 79,
    ["NUMPAD_2"] = 80,
    ["NUMPAD_3"] = 81,
    ["NUMPAD_0"] = 82,
    ["NUMPAD_PERIOD"] = 83,
    ["F11"] = 87,
    ["F12"] = 88,
}

