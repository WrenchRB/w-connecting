-- Configuration table for the server and bot settings
Config = {
    -- Discord server and bot configuration
    GuildID = '',  -- Your Discord server ID
    Token = '',  -- Your Discord bot token

    -- Configuration options
    IncreaseSlot = false, -- Increase slots for admins 
    -- if you want to use IncreaseSlot add this line to server.cfg: add_ace resource.w-connecting command allow

    RelogPriority = true, -- Users who reconnect have higher priority

    -- Role IDs that are allowed to join
    Roles = {
        '700974891956174879', -- priority = 1, highest
        '700974891956174879', -- priority = 2, high
        '700974891956174879', -- priority = 3, normal
        -- higher index = lower priority
    },

    -- Admin role IDs, used if IncreaseSlot is enabled
    Roles2 = { 
        '1021079673091932160',
    },

    -- Your server's name
    ServerName = "Kaya",

    -- Background Image
    Background = "https://i.postimg.cc/rzcdb8V8/Asset-2.png",

    -- Language configuration for messages sent to users
    Lang = {
        ["dont_have_roles"] = "You need a whitelist role to join.",
        ["dont_have_discord"] = "Please connect your Discord to FiveM!",
        ["not_in_guild"] = "Please join our Discord server.",
        ["joining"] = "Joining...",
        ["queue"] = "You are %s/%s in queue",
        ["custom"] = "Analyzing Your Information",
        ["custom2"] = "Analyzing Your Information.",
        ["custom3"] = "Analyzing Your Information..",
        ["custom4"] = "Analyzing Your Information...",
        ["custom5"] = "Checking Ban/Whitelist Database",
        ["custom6"] = "Finished",
        ["bannertext"] = "© 2023-2024 %s. All Rights Reserved.",
    }
}
