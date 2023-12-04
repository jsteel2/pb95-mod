print("MOD: LUABASIC")

local utf8 = require("plugin.utf8")

local function syntax(line)
    local spaceIndex = utf8.find(Game.Duty.DOSCommand, " ")
    if not spaceIndex then return false end
    local lineNumber = tonumber(utf8.sub(Game.Duty.DOSCommand, 1, spaceIndex - 1))
    if not lineNumber then return false end

    local index = #PBASIC.CurrentProgram + 1
    for i = 1, #PBASIC.CurrentProgram do
        if lineNumber <= PBASIC.CurrentProgram[i][1] then
            if PBASIC.CurrentProgram[i][1] == lineNumber then
                table.remove(PBASIC.CurrentProgram, i)
            end
            index = i
            break
        end
    end
    
    table.insert(PBASIC.CurrentProgram, index, {lineNumber, line})
    PBASIC.CurrentLine = PBASIC.CurrentLine + 1
    DOSprint("")
    return true
end

local function interp()
    table.sort(PBASIC.CurrentProgram, function(x, y)
        return x[1] < y[1]
    end)

    local t = {}
    for i = 1, #PBASIC.CurrentProgram do
        local x = PBASIC.CurrentProgram[i][2]
        if utf8.find(x, "9999 BINARYDATA 57") then
            OldInterp()
            return
        end
        local spaceIndex = utf8.find(x, " ")
        local caps = false
        t[i] = ""
        for c in utf8.sub(x, spaceIndex + 1, -1):gmatch(".") do
            if c == "." and caps then c = ":" end
            if c == "!" then
                caps = not caps
            else
                if caps then t[i] = t[i] .. string.upper(c)
                else t[i] = t[i] .. string.lower(c)
                end
            end
        end
    end

    local p = print
    print = function(...)
        local arg = {...}
        local r = ""
        for i, v in pairs(arg) do
            r = r .. tostring(v) .. " "
        end
        DOSprint(r)
    end
    local status, err = pcall(loadstring(table.concat(t, "\n")))
    if not status then DOSprint(err) end
    print = p
    DOSprint("")
    DOSprint("READY")
end

local function tim()
    if PBASIC.SyntaxCheck and PBASIC.Interpretator then
        PBASIC.SyntaxCheck = syntax
        OldInterp = PBASIC.Interpretator
        PBASIC.Interpretator = interp
    else
        timer.performWithDelay(1, tim)
    end
end

local req = require

require = function(x)
    if x == "bit8help" then
        local a = 1
        while true do
            local name, value = debug.getlocal(2, a)
            if not name then break end
            if type(value) == "table" then PBASIC = value
            elseif type(value) == "function" then DOSprint = value
            end
            a = a + 1
        end
        timer.performWithDelay(1, tim)
    end
    return req(x)
end
