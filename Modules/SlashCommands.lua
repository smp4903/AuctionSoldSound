-- COMMANDS
SLASH_ASS1 = '/AuctionSoldSound';
SLASH_ASS2 = '/ass';

local PREFIX = "[AuctionSoldSound] "

function SlashCmdList.ASS(msg, editbox)
    local cmd, arg = msg:match("^(%S*)%s*(.*)")
    cmd = cmd and cmd:lower() or ""

    if cmd == "test" then
        AuctionSoldSound.PlayNotificationSound()
        print(PREFIX.."Played test sound.")
    elseif cmd == "reset" then
        AuctionSoldSound_Options = AuctionSoldSound_Options or {}
        AuctionSoldSound_Options.soundId = AuctionSoldSound.defaults.soundId
        print(PREFIX.."Reset to default sound ID.")
    elseif cmd == "set" and tonumber(arg) then
        AuctionSoldSound_Options = AuctionSoldSound_Options or {}
        AuctionSoldSound_Options.soundId = tonumber(arg)
        print(PREFIX.."Sound ID set to: "..arg)
    else
        print(PREFIX.."commands:")
        print("/ass test               - play the current notification sound")
        print("/ass reset              - reset to default sound ID")
        print("/ass set <soundId>      - specify custom sound ID (a number)")
    end
end
