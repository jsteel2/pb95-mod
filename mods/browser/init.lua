print("MOD: BROWSER")

local webview = nil
local toolbarButtons = nil

local newImageSheet = graphics.newImageSheet

local function browserBack()
    webview:back()
end

local function browserForward()
    webview:forward()
end

local function browserReload()
    webview:reload()
end

local function browserHome()
    webview:request("https://www.yahoo.com")
end

local function browserClose(orig)
    return function()
        webview:removeSelf()
        webview = nil
        return orig()
    end
end

local function browserTim()
    if not webview then return end
    if webview.canGoBack then toolbarButtons[1][1].TurnToEnable()
    else toolbarButtons[1][1].TurnToDisable()
    end
    if webview.canGoForward then toolbarButtons[2][1].TurnToEnable()
    else toolbarButtons[2][1].TurnToDisable()
    end
    timer.performWithDelay(100, browserTim)
end

local function browserOpen(orig)
    return function(url)
        if webview == nil then
            webview = native.newWebView(320, 555, 620, 670)
            orig(url)
            webview:request("https://www.yahoo.com")
            toolbarButtons[1][1].Func = browserBack
            toolbarButtons[2][1].Func = browserForward
            toolbarButtons[3][1].Func = browserReload
            toolbarButtons[4][1].Func = browserHome
            toolbarButtons[3][1].TurnToEnable()
            timer.performWithDelay(100, browserTim)
        end
    end
end

graphics.newImageSheet = function(x, y)
    if x:match("browseranimation.png$") then
        Game.UI.BrowserWindow[2].CloseButton.Func = browserClose(Game.UI.BrowserWindow[2].CloseButton.Func)
        local a = 1
        while true do
            local name, value = debug.getlocal(3, a)
            if not name then break end
            if type(value) == "function" then
                if a == 11 then debug.setlocal(3, a, browserOpen(value)) end
            elseif type(value) == "table" then
                if type(value[1]) == "table" and type(value[1][1]) == "table" and value[1][1].TurnToEnable then
                    toolbarButtons = value
                end
            end
            a = a + 1
        end
    end
    return newImageSheet(x, y)
end
