dofile("harness.lua")
ERR_AUCTION_SOLD_S = "A buyer has been found for your auction of %s."
Load()
Fire("ADDON_LOADED", "AuctionSoldSound")
Check("listens to auction house notifications", FRAMES[1]._events.AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION and FRAMES[1]._events.AUCTION_HOUSE_SHOW_NOTIFICATION)

Fire("AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION", 4, "Linen Cloth", 1234)
Check("plays on a sold notification", #SOUNDS == 1)

Fire("AUCTION_HOUSE_SHOW_NOTIFICATION", 4)
Check("one sale reported twice plays once", #SOUNDS == 1)

NOW = NOW + 5
Fire("AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION", 3, "Linen Cloth", 1235)
Fire("AUCTION_HOUSE_SHOW_NOTIFICATION", 5)
Check("ignores outbid and expired", #SOUNDS == 1)

Fire("AUCTION_HOUSE_SHOW_NOTIFICATION", 4)
Check("a later sale plays again", #SOUNDS == 2)

NOW = NOW + 5
Fire("CHAT_MSG_SYSTEM", "A buyer has been found for your auction of Linen Cloth.")
Check("the Classic chat line still plays", #SOUNDS == 3)
Done()
