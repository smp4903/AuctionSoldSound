dofile("harness.lua")
ERR_AUCTION_SOLD_S = "A buyer has been found for your auction of %s."
Load()
Fire("ADDON_LOADED", "AuctionSoldSound")
Check("defaults applied", AuctionSoldSound_Options.soundId == 891)

Fire("CHAT_MSG_SYSTEM", "A buyer has been found for your auction of Arcane Dust.")
Check("plays once on a sale", #SOUNDS == 1 and SOUNDS[1] == 891)

Fire("CHAT_MSG_SYSTEM", "You have been outbid on Arcane Dust.")
Check("ignores other system messages", #SOUNDS == 1)

local secret = "A buyer has been found for your auction of Linen Cloth."
SECRET[secret] = true
Fire("CHAT_MSG_SYSTEM", secret)
Check("skips secret messages without error", #SOUNDS == 1)

Fire("CHAT_MSG_SYSTEM", nil)
Check("tolerates a missing message", #SOUNDS == 1)

-- Pattern characters in the localized template must be matched literally.
ERR_AUCTION_SOLD_S = "Für Eure Auktion von %s wurde ein Käufer gefunden (+)."
SOUNDS, FRAMES = {}, {}
Load()
Fire("ADDON_LOADED", "AuctionSoldSound")
NOW = NOW + 5; Fire("CHAT_MSG_SYSTEM", "Für Eure Auktion von Arkaner Staub wurde ein Käufer gefunden (+).")
Check("localized template matches", #SOUNDS == 1)
NOW = NOW + 5; Fire("CHAT_MSG_SYSTEM", "Für Eure Auktion von Arkaner Staub wurde ein Käufer gefunden.")
Check("localized template is literal", #SOUNDS == 1)
Done()
