-- COMMANDS
SLASH_ASS1 = '/AuctionSoldSound';
SLASH_ASS2 = '/ass';

function SlashCmdList.ASS(msg, editbox)
    local cmd, arg = msg:match("^(%S*)%s*(.*)")
    cmd = cmd and cmd:lower() or ""

    if cmd == "test" then
        -- try to play the sound immediately
        AuctionSoldSound.playNotificationSoundSimple()
        print("[AuctionSoldSound] Played test sound.")
    elseif cmd == "reset" then
        -- reset to default sound ID
        AuctionSoldSound_Options = AuctionSoldSound_Options or {}
        AuctionSoldSound_Options.soundId = AuctionSoldSound.defaults.soundId
        print("[AuctionSoldSound] Reset to default sound ID.")
    elseif cmd == "set" and arg ~= "" then
        AuctionSoldSound_Options = AuctionSoldSound_Options or {}
        AuctionSoldSound_Options.soundId = arg
        print("[AuctionSoldSound] Sound ID set to: " .. arg)
    else
        print("[AuctionSoldSound] commands:")
        print("/ass test               - play the current notification sound")
        print("/ass reset              - reset to default sound ID")
        print("/ass set <soundId>      - specify custom sound ID")
    end
end
