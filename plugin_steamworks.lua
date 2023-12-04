print("loading Sneed's mod loader (formerly chucks)")

local lfs = require("lfs")

local a = 1
while true do
    local name, value = debug.getlocal(4, a)
    if not name then break end
    if type(value) == "table" then
        if value.INI then Game = value
        elseif a == 21 then StageLayer = value
        elseif a == 22 then Sky = value
        elseif a == 23 then Foreground = value
        elseif a == 25 then UILayer = value
        elseif a == 26 then TutorialLayer = value
        end
    end
    a = a + 1
end

local mods = {}

for file in lfs.dir("mods") do
    if file ~= "." and file ~= ".." then
        table.insert(mods, file)
        require("mods." .. file .. ".init")
    end
end

native.setProperty("windowTitleText", native.getProperty("windowTitleText") .. " - Sneed's Mods: " .. table.concat(mods, ", "))

return {isLoggedOn = false}
