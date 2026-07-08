-- NAMESPACE / CLASS: AuctionSoldSound   
-- OPTIONS: AuctionSoldSound_Options      

AuctionSoldSound = CreateFrame("Frame")

do -- Private Scope
    local ADDON_NAME = "AuctionSoldSound"

    local defaults = {
        soundId = SOUNDKIT.MONEY_FRAME_OPEN -- 891 , https://github.com/Resike/BlizzardInterfaceResources/blob/master/Resources/SoundKit.lua
    }

    -- REGISTER EVENTS
    -- this frame needs to know when the addon is loaded and when system chat messages arrive
    AuctionSoldSound:RegisterEvent("ADDON_LOADED")
    AuctionSoldSound:RegisterEvent("CHAT_MSG_SYSTEM")

    -- set up our frame script; we pass all extra args through and handle them in onEvent
    AuctionSoldSound:SetScript("OnEvent", function(self, event, arg1, ...)
        onEvent(self, event, arg1, ...)
    end)

    function onEvent(self, event, arg1, ...)
        if event == "ADDON_LOADED" then
            if arg1 == ADDON_NAME then
                Init()
            end
        elseif event == "CHAT_MSG_SYSTEM" then
            handleSystemMessage(arg1)
        end
    end
  
    function Init()
        AuctionSoldSound_Options = AuctionSoldSound_Options or AddonUtils:deepcopy(defaults)
        for key,value in pairs(defaults) do
            if AuctionSoldSound_Options[key] == nil then
                AuctionSoldSound_Options[key] = value
            end
        end

        AuctionSoldSound:SetScript("OnUpdate", onUpdate)
        AuctionSoldSound:Show() -- Starts the OnUpdate loop
    end

    -- Chat parsing ----------------------------------------------------------
    local sellPattern = "A buyer has been found for your auction of (.+)"
    
    local function playNotificationSoundSimple()
       local soundId = SOUNDKIT.MONEY_FRAME_OPEN
        if AuctionSoldSound_Options and AuctionSoldSound_Options.soundId and AuctionSoldSound_Options.soundId ~= "" then
            soundId = AuctionSoldSound_Options.soundId
        end

        PlaySound(soundId) 
    end

    local function handleSystemMessage(msg)
        if not msg then return end

        -- match the English pattern; this will capture the item name
        local item = msg:match(sellPattern)
        if item then
            -- item contains something like "Arcane Dust"
            playNotificationSoundSimple()
        end
    end

    -- some versions of Classic or ChatFrame setups may not dispatch the event to addons
    -- always; add a filter as a fallback so we catch the message if it makes it to a
    -- chat frame instead.  This runs even if CHAT_MSG_SYSTEM doesn't fire for us.
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, msg, ...)
        handleSystemMessage(msg)
        return false  -- don't block default behavior
    end)

    AuctionSoldSound.playNotificationSoundSimple = playNotificationSoundSimple
    AuctionSoldSound.defaults = defaults
end