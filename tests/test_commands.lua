dofile("harness.lua")
Load()
Fire("ADDON_LOADED", "AuctionSoldSound")

SlashCmdList.ASS("set 12345")
Check("set stores a number", AuctionSoldSound_Options.soundId == 12345)

SlashCmdList.ASS("set loud")
Check("set ignores non-numbers", AuctionSoldSound_Options.soundId == 12345)

SlashCmdList.ASS("test")
Check("test plays the custom sound", SOUNDS[#SOUNDS] == 12345)

AuctionSoldSound_Options.soundId = "891"
SlashCmdList.ASS("test")
Check("old string IDs from saved variables still play", SOUNDS[#SOUNDS] == 891)

SlashCmdList.ASS("reset")
Check("reset restores the default", AuctionSoldSound_Options.soundId == 891)
Done()
