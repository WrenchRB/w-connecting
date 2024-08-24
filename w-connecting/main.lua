-- Function to make HTTP requests to Discord API
local function request(url)
    local result = nil

    -- Sending the HTTP request
    PerformHttpRequest("https://discord.com/api/" .. url, function(code, data, headers)
        result = {
            code = code,
            data = data,
            headers = headers
        }
    end, "GET", "",
    {
        ["Content-Type"] = "application/json",
        ["Authorization"] = Config.Token
    })

    -- Wait for the request to complete
    while result == nil do
        Citizen.Wait(0)
    end

    return result
end

-- Function to get the Discord ID from the player's identifiers
function GetDiscordId(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, "discord") then
            return string.gsub(identifier, "discord:", "" )
        end
    end
    return nil
end

-- Function to get the roles of a user in the Discord server
function GetUserRoles(discord)
    if not discord then return false end

    local url = "guilds/"..Config.GuildID.."/members/"..discord
    local result = request(url)
    if result.code ~= 200 then return false end

    local data = json.decode(result.data)
    return data.roles
end

-- Function to get the user's data from the Discord server
function GetUserData(discord)
    if not discord then return false end

    local url = "users/"..discord
    local result = request(url)
    if result.code ~= 200 then return false end

    local data = json.decode(result.data)
    return data
end

-- Event handler for when a player is connecting to the server
AddEventHandler('playerConnecting', function (playerName,setKickReason,deferrals)
    local source = source
    deferrals.defer()
    Wait(750)
    local discord = GetDiscordId(source)
    local data = GetUserData(discord) 
    if not discord or not data then
        deferrals.done(Config.Lang["dont_have_discord"])
        return
    end
    if not data.user then
        deferrals.done(Config.Lang["not_in_guild"])
        return
    end
    local logo =  ( "https://cdn.discordapp.com/avatars/%s/%s.png" ):format( discord, data.user.avatar)
    local name =  data.user.global_name
    UpdateCard(Config.Lang["custom"],function(card)
        deferrals.presentCard(card)
    end, logo, name)
    UpdateCard(Config.Lang["custom2"],function(card)
        deferrals.presentCard(card)
    end, logo, name)
    Wait(3000)
    UpdateCard(Config.Lang["custom3"],function(card)
        deferrals.presentCard(card)
    end, logo, name)
    Wait(3000)
    UpdateCard(Config.Lang["custom4"],function(card)
        deferrals.presentCard(card)
    end, logo, name)
    Wait(3000)
    UpdateCard(Config.Lang["custom5"],function(card)
        deferrals.presentCard(card)
    end, logo, name)      
    Wait(3000)
    UpdateCard(Config.Lang["custom6"],function(card)
        deferrals.presentCard(card)
    end, logo, name)
    Wait(1000)
    local wh = false
    local userRoles = GetUserRoles(discord)
    if userRoles then
        for _, v in pairs(Config.Roles) do
            for _, v2 in pairs(userRoles) do
                if v == v2 then
                    wh = true
                    break
                end
            end
        end
        if not wh and Config.IncreaseSlot then
            for _, v in pairs(Config.Roles2) do
                for _, v2 in pairs(userRoles) do
                    if v == v2 then
                        wh = true
                        break
                    end
                end
            end
        end
    end
    if not wh then
        deferrals.done(Config.Lang["dont_have_roles"])
        return
    end 
    AddQ(source)
    repeat
        Wait(500)
        UpdateCard((Config.Lang["queue"]):format(GetQ(source), GetMaxQ()),function(card)
            deferrals.presentCard(card)
        end, logo, name)
    until not GetPlayerName(source) or CanJoin(source)
    if GetPlayerName(source) then
        UpdateCard(Config.Lang["joining"],function(card)
            deferrals.presentCard(card)
        end, logo, name)
        Wait(100)
        deferrals.done()
    end
end)

AddEventHandler("onResourceStarting", function(resource)
    if resource == "hardcap" then CancelEvent() return end
end)

Citizen.CreateThread(function()
    local oq = {}
    local q = {}
    local lp = {}
    local ogNum = GetConvarInt("sv_maxclients", 64)

    StopResource("hardcap")
    AddEventHandler("playerDropped", function()
        local source = source
        local discord = GetDiscordId(source)
        local Num = GetConvarInt("sv_maxclients", 30)
        if Num - ogNum > 0 then
            ExecuteCommand("sv_maxclients "..(Num-1))
        end
        if not discord then
            return
        end
        if Config.RelogPriority then
            lp[discord] = true
            SetTimeout(1000*60*15, function ()
                lp[discord] = nil
            end)
        end
    end)

    function GetP(source)
        local discord = GetDiscordId(source)
        local userRoles = GetUserRoles(discord)
        if not userRoles then return 99 end
        if Config.IncreaseSlot then
            for _, value in ipairs(Config.Roles2) do
                for _, value2 in pairs(userRoles) do
                    if value == value2 then
                        return 1
                    end
                end
            end
        end
        if Config.RelogPriority then
            for discord2, _ in pairs(lp) do
                if discord == discord2 then
                    return 2
                end
            end
        end
        for index, value in ipairs(Config.Roles) do
            for _, value2 in pairs(userRoles) do
                if value == value2 then
                    return index + 1
                end
            end
        end
        return 99
    end
    function AddQ(source)
        local discord = GetDiscordId(source)
        table.insert(q, {p = GetP(source), j = GetGameTimer(), discord = discord, source = source})
    end
    function GetQ(source)
        local discord = GetDiscordId(source)
        for i = #q, 1, -1 do
            local odiscord = q[i].discord
            if odiscord == discord then
                return i
            end
        end
        return 0
    end
    function GetMaxQ()
        return #q
    end
    function CanJoin(source)
        local discord = GetDiscordId(source)
        for i = #oq, 1, -1 do
            local odiscord = oq[i].discord
            if odiscord == discord then
                return true
            end
        end
        return false
    end
    while true do
        Wait(500)
        local success, errorMessage = pcall(function ()
            for i = #q, 1, -1 do
                if q[i] then
                    local source = q[i].source
                    if not GetPlayerName(source) then
                        table.remove(q, i)
                    end
                end
            end
            if #q > 0 then
                table.sort(q, function (a,b)
                    if a.p == b.p then
                        return a.j < b.j
                    end
                    return a.p < b.p
                end)
                local Num = GetConvarInt("sv_maxclients", ogNum)
                local ogNum2 = math.floor(ogNum*1.75)
                if Num < ogNum2 then
                    ExecuteCommand("sv_maxclients "..(Num+1))
                end
                if #GetPlayers() < Num then
                    table.insert(oq, table.remove(q, 1))
                end
            end
        end)
        if not success then print(errorMessage) end
    end
end)
-- you can edit it with https://adaptivecards.io/designer/
local mainCard = [[{
    "type": "AdaptiveCard",
    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
    "version": "1.6",
    "body": [
        {
            "type": "Container",
            "items": [
                {
                    "type": "TextBlock",
                    "text": "Kaya Community",
                    "fontType": "Default",
                    "size": "ExtraLarge",
                    "weight": "Bolder",
                    "color": "Light",
                    "highlight": true,
                    "isSubtle": false,
                    "horizontalAlignment": "Center",
                    "spacing": "None",
                    "wrap": true
                },
                {
                    "type": "TextBlock",
                    "text": "Analyzing Your Information",
                    "color": "Default",
                    "size": "Medium",
                    "style": "heading",
                    "fontType": "Default",
                    "isSubtle": true,
                    "horizontalAlignment": "Center",
                    "weight": "Default",
                    "wrap": true
                },
                {
                    "type": "Container",
                    "items": [
                        {
                            "type": "Image",
                            "url": "https://i.postimg.cc/bSzs2RCG/Asset-1.png",
                            "horizontalAlignment": "Center",
                            "spacing": "None",
                            "size": "Large"
                        },
                        {
                            "type": "TextBlock",
                            "text": "player name",
                            "wrap": true,
                            "horizontalAlignment": "Center",
                            "fontType": "Monospace",
                            "size": "Medium",
                            "color": "Light",
                            "spacing": "Medium",
                            "style": "default"
                        }
                    ],
                    "spacing": "Large"
                },
                {
                    "type": "TextBlock",
                    "text": "© 2023-2024 Kaya Community. All Rights Reserved.",
                    "spacing": "Large",
                    "horizontalAlignment": "Center",
                    "wrap": true,
                    "maxLines": 1,
                    "size": "Small",
                    "weight": "Lighter",
                    "isSubtle": true,
                    "fontType": "Monospace",
                    "color": "Light"
                }
            ],
            "style": "default",
            "backgroundImage": {
                "url": "https://i.postimg.cc/rzcdb8V8/Asset-2.png"
            },
            "bleed": true,
            "height": "stretch",
            "spacing": "None"
        }
    ],
    "backgroundImage": {
        "url": "https://i.postimg.cc/rzcdb8V8/Asset-2.png",
        "verticalAlignment": "Center",
        "horizontalAlignment": "Right"
    },
    "verticalContentAlignment": "Center",
    "rtl": false
}]]

mainCard = json.decode(mainCard)
function UpdateCard(step,callback, logo, name)
    local card = mainCard
    card.body[1].items[3].items[1].url = logo
    card.body[1].items[3].items[2].text = name
    card.body[1].items[2].text = step
    card.body[1].items[1].text = Config.ServerName
    card.body[1].items[4].text = ( Config.Lang["bannertext"] ):format(Config.ServerName)
    card.backgroundImage.url = Config.Background
    card.body[1].backgroundImage.url = Config.Background
    callback(json.encode(card))
end