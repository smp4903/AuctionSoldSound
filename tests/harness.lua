-- Minimal Forever (Mainline) API stub for loading AuctionSoldSound outside the client.
-- Globals the client no longer has (ChatFrame_AddMessageEventFilter) are left out on purpose.
local root = arg[1] or ".."

FRAMES = {}
function CreateFrame()
  local f = { _events = {}, _scripts = {} }
  function f:RegisterEvent(e) self._events[e] = true end
  function f:SetScript(s, fn) self._scripts[s] = fn end
  table.insert(FRAMES, f)
  return f
end

SOUNDKIT = { MONEY_FRAME_OPEN = 891 }
Enum = { AuctionHouseNotification = { BidPlaced = 0, AuctionRemoved = 1, AuctionWon = 2, AuctionOutbid = 3, AuctionSold = 4, AuctionExpired = 5 } }
NOW = 100
function GetTime() return NOW end
SlashCmdList = {}
SOUNDS = {}
function PlaySound(id)
  assert(type(id) == "number", "PlaySound needs a number, got "..type(id))
  table.insert(SOUNDS, id)
  return true
end
SECRET = {}
function issecretvalue(v) return SECRET[v] == true end
PRINTED = {}
print = function(...) table.insert(PRINTED, table.concat({ ... }, " ")) end

function Load()
  local toc = assert(io.open(root.."/AuctionSoldSound.toc")):read("*a")
  for line in toc:gmatch("[^\r\n]+") do
    if not line:match("^%s*#") and line:match("%S") then
      local chunk = assert(loadfile(root.."/"..line:gsub("\\", "/")))
      chunk("AuctionSoldSound", {})
    end
  end
end

function Fire(event, ...)
  for _, f in ipairs(FRAMES) do
    if f._events[event] and f._scripts.OnEvent then f._scripts.OnEvent(f, event, ...) end
  end
end

local failures = 0
function Check(name, ok)
  if not ok then failures = failures + 1; io.write("\n  FAIL: "..name) end
end
function Done()
  io.write(failures == 0 and "ok\n" or "\n")
  os.exit(failures == 0 and 0 or 1)
end
