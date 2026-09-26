if not getgenv().EnableLogger then
    return
end

if getgenv().ScriptLoggerLoaded then
    return
end

local COOLDOWN_TIME = 30
local currentTime = os.clock()
local lastTime = getgenv().LastLoggerTime or 0

if currentTime - lastTime < COOLDOWN_TIME then
    return
end

getgenv().LastLoggerTime = currentTime
getgenv().ScriptLoggerLoaded = true

local SCRIPT_NAME = "Unknown Script"
local SCRIPT_URL = nil

if getgenv().Vahleah then
    SCRIPT_NAME = "VahleahReanimate 1Larp"
    SCRIPT_URL = "https://raw.githubusercontent.com/imtuffboybreday-dotcom/LeoWinners/refs/heads/main/VAHLEAH"
elseif getgenv().Truehub then
    SCRIPT_NAME = "truehub"
    SCRIPT_URL = "https://raw.githubusercontent.com/imtuffboybreday-dotcom/-/refs/heads/main/2"
end

local WEBHOOK_URL = "https://discord.com/api/webhooks/1552987373506265236/8VTnUgnm1OHGG2fAcd1UBdQG843SjwlGE-juIclRo-Vr3kS8uxn5nchQ7k6ayh54fi-P"

local HttpService = game:GetService("HttpService")

local function safeRequest(options)
    local success, result = pcall(function()
        if syn and syn.request then
            return syn.request(options)
        end

        if http and http.request then
            return http.request(options)
        end

        if http_request then
            return http_request(options)
        end

        if request then
            return request(options)
        end

        if fluxus and fluxus.request then
            return fluxus.request(options)
        end

        return nil
    end)

    if success then
        return result
    end

    return nil
end

local function sendLog()
    if WEBHOOK_URL == "" then
        return
    end

    if WEBHOOK_URL == "" then
    return
end

    local payload = {
        username = "BB1XLogs",

        embeds = {
            {
                title = "Script Execution Log",

                color = 5793266,

                fields = {
                    {
                        name = "Script",
                        value = SCRIPT_NAME,
                        inline = true
                    },

                    {
                        name = "PlaceId",
                        value = tostring(game.PlaceId),
                        inline = true
                    },

                    {
                        name = "Time",
                        value = os.date("%Y-%m-%d %H:%M:%S"),
                        inline = true
                    }
                },

                footer = {
                    text = "BB1XLogs"
                },

                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    local success, body = pcall(function()
        return HttpService:JSONEncode(payload)
    end)

    if not success then
        return
    end

    task.spawn(function()
        safeRequest({
            Url = WEBHOOK_URL,
            Method = "POST",

            Headers = {
                ["Content-Type"] = "application/json"
            },

            Body = body
        })
    end)
end

sendLog()

if SCRIPT_URL and SCRIPT_URL ~= "" then
    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(SCRIPT_URL)
        end)

        if not success then
            warn("[Logger] HTTP request failed:", result)
            return
        end

        local loaderSuccess, loaderError = pcall(function()
            local fn = loadstring(result)

            if not fn then
                error("loadstring returned nil")
            end

            fn()
        end)

        if not loaderSuccess then
            warn("[Logger] Failed to load main script:", loaderError)
        end
    end)
end
