-- NAMESPACE / CLASS: AuctionSoldSound
-- OPTIONS: AuctionSoldSound_Options

AuctionSoldSound = CreateFrame("Frame")

do -- Private Scope
    local ADDON_NAME = "AuctionSoldSound"
    local PREFIX = "[AuctionSoldSound] "

    local defaults = {
        soundId = SOUNDKIT.MONEY_FRAME_OPEN -- 891, https://github.com/Resike/BlizzardInterfaceResources/blob/master/Resources/SoundKit.lua
    }

    -- Sales reported through more than one path within this window are one sale.
    local DEDUPE_WINDOW = 0.5
    local lastPlayed = -math.huge

    local Init, OnEvent, HandleSystemMessage, HandleNotification, OnSold, PlayNotificationSound, BuildSoldPattern, IsSecret

    AuctionSoldSound:RegisterEvent("ADDON_LOADED")
    AuctionSoldSound:RegisterEvent("CHAT_MSG_SYSTEM")
    -- The modern auction house (Forever) reports sales as notifications and prints
    -- the chat line itself, so CHAT_MSG_SYSTEM never fires for them there.
    pcall(AuctionSoldSound.RegisterEvent, AuctionSoldSound, "AUCTION_HOUSE_SHOW_NOTIFICATION")
    pcall(AuctionSoldSound.RegisterEvent, AuctionSoldSound, "AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION")

    AuctionSoldSound:SetScript("OnEvent", function(self, event, ...) OnEvent(event, ...) end)

    -- ERR_AUCTION_SOLD_S is "A buyer has been found for your auction of %s." in the
    -- client's own language, so the match works on every locale.
    function BuildSoldPattern()
        local template = ERR_AUCTION_SOLD_S or "A buyer has been found for your auction of %s."
        local escaped = template:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
        return "^"..escaped:gsub("%%%%s", "(.+)").."$"
    end

    local soldPattern = BuildSoldPattern()

    function IsSecret(value)
        return issecretvalue and issecretvalue(value)
    end

    function OnEvent(event, arg1)
        if event == "ADDON_LOADED" then
            if arg1 == ADDON_NAME then
                Init()
            end
        elseif event == "CHAT_MSG_SYSTEM" then
            HandleSystemMessage(arg1)
        elseif event == "AUCTION_HOUSE_SHOW_NOTIFICATION" or event == "AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION" then
            HandleNotification(arg1)
        end
    end

    function Init()
        AuctionSoldSound_Options = AuctionSoldSound_Options or {}
        for key, value in pairs(defaults) do
            if AuctionSoldSound_Options[key] == nil then
                AuctionSoldSound_Options[key] = value
            end
        end
    end

    function PlayNotificationSound()
        local soundId = AuctionSoldSound_Options and tonumber(AuctionSoldSound_Options.soundId)
        if not soundId then
            soundId = defaults.soundId
        end

        if not pcall(PlaySound, soundId) then
            print(PREFIX.."Could not play sound "..tostring(soundId)..". Use /ass reset to go back to the default.")
        end
    end

    function HandleSystemMessage(msg)
        if type(msg) ~= "string" or IsSecret(msg) then
            return
        end

        if msg:match(soldPattern) then
            OnSold()
        end
    end

    function HandleNotification(notification)
        local sold = Enum and Enum.AuctionHouseNotification and Enum.AuctionHouseNotification.AuctionSold
        if sold == nil or type(notification) ~= "number" or IsSecret(notification) then
            return
        end

        if notification == sold then
            OnSold()
        end
    end

    function OnSold()
        local now = GetTime()
        if now - lastPlayed < DEDUPE_WINDOW then
            return
        end
        lastPlayed = now
        PlayNotificationSound()
    end

    AuctionSoldSound.PlayNotificationSound = PlayNotificationSound
    AuctionSoldSound.HandleSystemMessage = HandleSystemMessage
    AuctionSoldSound.HandleNotification = HandleNotification
    AuctionSoldSound.defaults = defaults
end
