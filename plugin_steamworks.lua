print("loading Sneed's mod loader (formerly chucks)")

local lfs = require("lfs")

Game = nil

local a = 1
while true do
    local name, value = debug.getlocal(4, a)
    if not name then break end
    if type(value) == "table" and value.INI then
        Game = value
        break
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
