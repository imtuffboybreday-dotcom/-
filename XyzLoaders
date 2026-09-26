local COOLDOWN_TIME = 10
local lastLog = getgenv().LastLoggerTime or 0
local currentTime = tick()

if currentTime - lastLog < COOLDOWN_TIME then
    return
end

getgenv().LastLoggerTime = currentTime

if getgenv().ScriptLoggerLoaded then
    return
end

getgenv().ScriptLoggerLoaded = true

local SCRIPT_NAME = "Unknown Script"
local SCRIPT_URL = nil

if getgenv().Vahleah then
    SCRIPT_NAME = "VahleahReanimate 1Larps"
    SCRIPT_URL = "https://raw.githubusercontent.com/imtuffboybreday-dotcom/LeoWinners/refs/heads/main/VAHLEAH"
elseif getgenv().Truehub then
    SCRIPT_NAME = "MS TRUEHUB"
    SCRIPT_URL = "https://raw.githubusercontent.com/imtuffboybreday-dotcom/-/refs/heads/main/2"
else
    return
end

local WEBHOOK_URL = "https://discord.com/api/webhooks/1552987373506265236/8VTnUgnm1OHGG2fAcd1UBdQG843SjwlGE-juIclRo-Vr3kS8uxn5nchQ7k6ayh54fi-P"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function safeRequest(options)
    local success, result = pcall(function()
        if type(syn) == "table" and type(syn.request) == "function" then
            return syn.request(options)
        end

        if type(http) == "table" and type(http.request) == "function" then
            return http.request(options)
        end

        if type(http_request) == "function" then
            return http_request(options)
        end

        if type(request) == "function" then
            return request(options)
        end

        if type(fluxus) == "table" and type(fluxus.request) == "function" then
            return fluxus.request(options)
        end

        return nil
    end)

    if success then
        return result
    end

    return nil
end

local function getExecutorName()
    if type(identifyexecutor) == "function" then
        local ok, name, version = pcall(identifyexecutor)

        if ok and type(name) == "string" and name ~= "" then
            if type(version) == "string" and version ~= "" then
                return name .. " v" .. version
            end

            return name
        end
    end

    if type(getexecutorname) == "function" then
        local ok, name = pcall(getexecutorname)

        if ok and type(name) == "string" and name ~= "" then
            return name
        end
    end

    return "Unknown"
end

local function sendLog(isTamper)
    if WEBHOOK_URL == "" then
        return
    end

    local executor = getExecutorName()
    local username = LocalPlayer and LocalPlayer.Name or "Unknown"
    local userId = LocalPlayer and LocalPlayer.UserId or 0
    local placeId = game.PlaceId
    local jobId = game.JobId ~= "" and game.JobId or "N/A"
    local accountAge = LocalPlayer and LocalPlayer.AccountAge or 0

    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId="
        .. tostring(userId)
        .. "&width=420&height=420&format=png"

    local title = isTamper
        and "SomeOne Tryna Steal"
        or "BBX1Loggers"

    local color = isTamper and 16711680 or 5793266

    local embed = {
        title = title,
        color = color,

        thumbnail = {
            url = avatarUrl
        },

        fields = {
            {
                name = "Script",
                value = SCRIPT_NAME,
                inline = true
            },
            {
                name = "Executor",
                value = executor,
                inline = true
            },
            {
                name = "Username",
                value = string.format("%s (%s)", username, tostring(userId)),
                inline = false
            },
            {
                name = "PlaceId",
                value = tostring(placeId),
                inline = true
            },
            {
                name = "JobId",
                value = tostring(jobId),
                inline = true
            },
            {
                name = "Account Age",
                value = tostring(accountAge) .. " days",
                inline = true
            }
        },

        footer = {
            text = "FuckerLogs • " .. os.date("%Y-%m-%d %H:%M:%S")
        },

        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = {
        username = "BB1XLogs",
        embeds = {
            embed
        }
    }

    local ok, body = pcall(function()
        return HttpService:JSONEncode(payload)
    end)

    if not ok then
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

sendLog(false)

if SCRIPT_URL and SCRIPT_URL ~= "" then
    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(SCRIPT_URL)
        end)

        if not success then
            warn("[Logger] HTTP request failed:", result)
            return
        end

        local loadSuccess, loadError = pcall(function()
            local fn = loadstring(result)

            if type(fn) ~= "function" then
                error("loadstring returned nil")
            end

            fn()
        end)

        if not loadSuccess then
            warn("[Logger] Failed to load main script:", loadError)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)

        local tampered = false

        if getgenv().ScriptLoggerLoaded ~= true then
            tampered = true
        end

        if not getgenv().Vahleah and not getgenv().Truehub then
            tampered = true
        end

        if tampered then
            sendLog(true)

            pcall(function()
                if LocalPlayer then
                    LocalPlayer:Kick("Why R U deleting The Getgenv I say dont Ok.? Ratted....")
                end
            end)

            break
        end
    end
end)
