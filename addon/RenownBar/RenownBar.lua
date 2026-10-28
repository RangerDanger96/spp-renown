-- RenownBar: a Renown progress bar for the spp-renown server module (WoW 1.12 / Lua 5.0)
-- The server pushes Renown updates as hidden addon messages (prefix "RENOWN") the moment they
-- change. ".renown sync" asks for one silently on login. If the server is an older build without
-- push support, the addon falls back to polling ".renown info" and hiding the reply.

local QUERY_COMMAND = ".renown info"
local MIN_QUERY_GAP = 3        -- seconds between queries
local BG_POLL_INTERVAL = 30    -- seconds, while inside a battleground
local WORLD_POLL_INTERVAL = 180

local rank, title, current, needed, nextRank, total, maxed = nil
local spendable = nil          -- Renown points available to spend at vendors
local prices = {}              -- item id -> Renown cost (sent by the server)
local priceByName = {}         -- item name -> Renown cost (filled from the item cache)
local lastQuery = 0
local pendingSuppress = 0      -- number of status replies to hide from chat
local queryDeadline = 0
local pollTimer = 0
local delayedQueryAt = nil
local available = nil          -- nil = unknown, true/false once the server answered
local pushMode = false         -- true once the server has pushed an update
local syncDeadline = nil       -- fall back to polling if no push arrives by then

RenownBarDB = RenownBarDB or {}

-- ---------------------------------------------------------------- frame
local bar = CreateFrame("StatusBar", "RenownBarFrame", UIParent)
bar:SetWidth(512)
bar:SetHeight(12)
bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
bar:SetStatusBarColor(0.80, 0.55, 0.10)
bar:SetMinMaxValues(0, 1)
bar:SetValue(0)
bar:SetMovable(true)
bar:EnableMouse(true)
if bar.SetClampedToScreen then bar:SetClampedToScreen(true) end

local bg = bar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(bar)
bg:SetTexture(0, 0, 0, 0.55)

local border = CreateFrame("Frame", nil, bar)
border:SetPoint("TOPLEFT", bar, "TOPLEFT", -3, 3)
border:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 3, -3)
border:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10 })
border:SetBackdropBorderColor(0.85, 0.65, 0.20, 0.9)

local text = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
text:SetPoint("CENTER", bar, "CENTER", 0, 1)
text:SetText("Renown: waiting for server...")

local function SavePosition()
    local point, _, relPoint, x, y = bar:GetPoint()
    RenownBarDB.point, RenownBarDB.relPoint, RenownBarDB.x, RenownBarDB.y = point, relPoint, x, y
end

local function RestorePosition()
    bar:ClearAllPoints()
    if RenownBarDB.point then
        bar:SetPoint(RenownBarDB.point, UIParent, RenownBarDB.relPoint, RenownBarDB.x, RenownBarDB.y)
    else
        -- just above the action bar / experience bar
        bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 92)
    end
end

bar:SetScript("OnMouseDown", function()
    if IsShiftKeyDown() then this:StartMoving() end
end)
bar:SetScript("OnMouseUp", function()
    this:StopMovingOrSizing()
    SavePosition()
end)

bar:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_TOP")
    GameTooltip:AddLine("Renown", 1, 0.82, 0)
    if rank then
        GameTooltip:AddLine("Rank " .. rank .. " - " .. title, 1, 1, 1)
        if maxed then
            GameTooltip:AddLine("Maximum rank reached (" .. total .. " renown)", 0.6, 1, 0.6)
        else
            GameTooltip:AddLine(current .. " / " .. needed .. " renown to rank " .. nextRank, 0.9, 0.9, 0.9)
            GameTooltip:AddLine((needed - current) .. " renown remaining", 0.7, 0.7, 0.7)
        end
        if spendable then
            GameTooltip:AddLine(spendable .. " Renown points to spend at the Battleground Quartermaster", 1, 0.82, 0)
        end
    else
        GameTooltip:AddLine("No data from the server yet.", 0.8, 0.8, 0.8)
    end
    GameTooltip:AddLine("Earn renown from player kills, objectives and battleground wins.", 0.6, 0.6, 0.6, 1)
    GameTooltip:AddLine("Shift-drag to move. /renownbar for options.", 0.5, 0.5, 0.5)
    GameTooltip:Show()
end)
bar:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function Refresh()
    if not rank then return end
    if maxed then
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(1)
        text:SetText("Renown Rank " .. rank .. " (" .. title .. ") - MAX" .. (spendable and ("   |cffffd100" .. spendable .. " to spend|r") or ""))
    else
        bar:SetMinMaxValues(0, math.max(needed, 1))
        bar:SetValue(current)
        text:SetText("Renown Rank " .. rank .. " (" .. title .. ")   " .. current .. " / " .. needed .. (spendable and ("   |cffffd100" .. spendable .. " to spend|r") or ""))
    end
end

-- ---------------------------------------------------------------- querying
local function Query(force)
    local now = GetTime()
    if not force and now - lastQuery < MIN_QUERY_GAP then
        delayedQueryAt = lastQuery + MIN_QUERY_GAP
        return
    end
    lastQuery = now
    pendingSuppress = pendingSuppress + 1
    queryDeadline = now + 6
    -- name the player explicitly, otherwise the server reports on your current target
    SendChatMessage(QUERY_COMMAND .. " " .. UnitName("player"), "SAY")
end

local function QueryLater(seconds)
    local at = GetTime() + seconds
    if not delayedQueryAt or at < delayedQueryAt then delayedQueryAt = at end
end

-- Handles a pushed update: "rank:progress:needed:nextRank:total:maxed:spendable:title"
-- (older servers send "rank:progress:needed:nextRank:total:maxed:title")
local MerchantRefresh
local function ParsePush(msg)
    local _, _, r, c, n, nr, tot, mx, sp, t = string.find(msg or "", "^(%d+):(%d+):(%d+):(%d+):(%d+):(%d):(%d+):(.*)$")
    if not r then
        _, _, r, c, n, nr, tot, mx, t = string.find(msg or "", "^(%d+):(%d+):(%d+):(%d+):(%d+):(%d):(.*)$")
        sp = nil
    end
    if not r then return end
    rank, current, needed, nextRank, total, title = tonumber(r), tonumber(c), tonumber(n), tonumber(nr), tonumber(tot), t
    spendable = sp and tonumber(sp) or nil
    if MerchantRefresh then MerchantRefresh() end
    maxed = (mx == "1")
    available = true
    pushMode = true
    syncDeadline = nil
    Refresh()
end

-- Handles the price list: "item=cost,item=cost,..."
local function ParsePrices(msg)
    for id, cost in string.gfind(msg or "", "(%d+)=(%d+)") do
        prices[tonumber(id)] = tonumber(cost)
    end
    if MerchantRefresh then MerchantRefresh() end
end

local function CostForMerchantIndex(index)
    if GetMerchantItemLink then
        local link = GetMerchantItemLink(index)
        if link then
            local _, _, id = string.find(link, "item:(%d+)")
            if id and prices[tonumber(id)] then return prices[tonumber(id)] end
        end
    end
    local name = GetMerchantItemInfo(index)
    if name and not priceByName[name] then
        for id, cost in pairs(prices) do
            local itemName = GetItemInfo(id)
            if itemName then priceByName[itemName] = cost end
        end
    end
    return name and priceByName[name]
end

-- Vendor window: show "N Renown" instead of the gold price for Renown items
local labels = {}
local merchantTotal
MerchantRefresh = function()
    if not MerchantFrame or not MerchantFrame:IsVisible() then return end
    local perPage = MERCHANT_ITEMS_PER_PAGE or 10
    local showingBuy = (not MerchantFrame.selectedTab) or MerchantFrame.selectedTab == 1
    local anyRenown = false
    for i = 1, perPage do
        local moneyFrame = getglobal("MerchantItem" .. i .. "MoneyFrame")
        local button = getglobal("MerchantItem" .. i)
        if not labels[i] and button then
            labels[i] = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            if moneyFrame then labels[i]:SetPoint("BOTTOMLEFT", moneyFrame, "BOTTOMLEFT", 0, 2) end
        end
        local label = labels[i]
        local index = ((MerchantFrame.page or 1) - 1) * perPage + i
        local cost = showingBuy and index <= GetMerchantNumItems() and CostForMerchantIndex(index)
        if label then
            if cost then
                anyRenown = true
                if moneyFrame then moneyFrame:Hide() end
                if spendable and spendable < cost then
                    label:SetText("|cffff2020" .. cost .. " Renown|r")
                else
                    label:SetText("|cffffd100" .. cost .. " Renown|r")
                end
                label:Show()
            else
                label:Hide()
            end
        end
    end
    if not merchantTotal then
        merchantTotal = MerchantFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        merchantTotal:SetPoint("BOTTOMLEFT", MerchantFrame, "BOTTOMLEFT", 28, 92)
    end
    if anyRenown and spendable then
        merchantTotal:SetText("Renown points: " .. spendable)
        merchantTotal:Show()
    else
        merchantTotal:Hide()
    end
end

if MerchantFrame_UpdateMerchantInfo then
    local Original_UpdateMerchantInfo = MerchantFrame_UpdateMerchantInfo
    function MerchantFrame_UpdateMerchantInfo()
        Original_UpdateMerchantInfo()
        MerchantRefresh()
    end
end

-- Vendor tooltip: add the Renown cost
local Original_SetMerchantItem = GameTooltip.SetMerchantItem
GameTooltip.SetMerchantItem = function(self, index)
    Original_SetMerchantItem(self, index)
    local cost = CostForMerchantIndex(index)
    if cost then
        self:AddLine("Costs " .. cost .. " Renown points", 1, 0.82, 0)
        self:Show()
    end
end

local function Sync()
    SendChatMessage(".renown sync", "SAY")
    syncDeadline = GetTime() + 8
end

-- Returns true if the message is one of our status replies (and stores the values)
local function ParseStatus(msg)
    if not msg then return false end
    local me = UnitName("player")
    local plain = string.gsub(msg, "|c%x%x%x%x%x%x%x%x", "")
    plain = string.gsub(plain, "|r", "")
    local prefix = "[Renown] " .. me .. ": Renown Rank "
    if string.sub(plain, 1, string.len(prefix)) ~= prefix then return false end

    local _, _, r, t, c, n, nr = string.find(plain, "Renown Rank (%d+) %((.-)%)%. (%d+) / (%d+) renown to rank (%d+)")
    if r then
        rank, title, current, needed, nextRank = tonumber(r), t, tonumber(c), tonumber(n), tonumber(nr)
        maxed = false
        available = true
        Refresh()
        return true
    end

    local _, _, r2, t2, p2 = string.find(plain, "Renown Rank (%d+) %((.-)%), (%d+) renown%. Maximum")
    if r2 then
        rank, title, total = tonumber(r2), t2, tonumber(p2)
        maxed = true
        available = true
        Refresh()
        return true
    end

    return false
end

-- Hide our own status replies from every chat frame
local Original_ChatFrame_OnEvent = ChatFrame_OnEvent
function ChatFrame_OnEvent(event)
    if event == "CHAT_MSG_SYSTEM" and pendingSuppress > 0 and arg1 then
        local plain = string.gsub(arg1, "|c%x%x%x%x%x%x%x%x", "")
        plain = string.gsub(plain, "|r", "")
        if string.find(plain, "^%[Renown%] " .. UnitName("player") .. ": Renown Rank") then
            return
        end
        local _, _, sp = string.find(plain, "^%[Renown%] (%d+) Renown points to spend%.")
        if sp then
            spendable = tonumber(sp)
            Refresh()
            return
        end
    end
    Original_ChatFrame_OnEvent(event)
end

local function InBattleground()
    for i = 1, MAX_BATTLEFIELD_QUEUES or 3 do
        local status = GetBattlefieldStatus(i)
        if status == "active" then return true end
    end
    return false
end

-- ---------------------------------------------------------------- events
bar:RegisterEvent("VARIABLES_LOADED")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("CHAT_MSG_SYSTEM")
bar:RegisterEvent("CHAT_MSG_ADDON")
bar:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
bar:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")
bar:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
bar:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
bar:RegisterEvent("MERCHANT_SHOW")
bar:RegisterEvent("MERCHANT_UPDATE")

bar:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        RestorePosition()
        if RenownBarDB.hidden then bar:Hide() end
    elseif event == "PLAYER_ENTERING_WORLD" then
        Sync()
    elseif event == "CHAT_MSG_ADDON" then
        if arg4 == UnitName("player") then
            if arg1 == "RENOWN" then ParsePush(arg2)
            elseif arg1 == "RENOWNP" then ParsePrices(arg2) end
        end
    elseif event == "MERCHANT_SHOW" or event == "MERCHANT_UPDATE" then
        MerchantRefresh()
    elseif event == "CHAT_MSG_SYSTEM" then
        if ParseStatus(arg1) then
            if pendingSuppress > 0 then pendingSuppress = pendingSuppress - 1 end
        elseif arg1 and string.find(arg1, "Renown") and string.find(arg1, "You have reached") then
            QueryLater(1)
        elseif pendingSuppress > 0 and arg1 and (string.find(arg1, "no such command") or string.find(arg1, "no such subcommand")) then
            pendingSuppress = pendingSuppress - 1
            available = false
            text:SetText("Renown: server module not found")
        end
    elseif not pushMode and (event == "CHAT_MSG_COMBAT_HONOR_GAIN" or event == "PLAYER_PVP_KILLS_CHANGED") then
        QueryLater(2)
    elseif not pushMode and (event == "UPDATE_BATTLEFIELD_STATUS" or event == "UPDATE_BATTLEFIELD_SCORE") then
        QueryLater(3)
    end
end)

bar:SetScript("OnUpdate", function()
    local now = GetTime()

    -- No push arrived: older server build, use the polling fallback
    if syncDeadline and now > syncDeadline then
        syncDeadline = nil
        QueryLater(0)
    end

    if pushMode then return end

    if pendingSuppress > 0 and queryDeadline > 0 and now > queryDeadline then
        pendingSuppress = 0
        queryDeadline = 0
    end

    if delayedQueryAt and now >= delayedQueryAt then
        delayedQueryAt = nil
        if available ~= false then Query(true) end
    end

    pollTimer = pollTimer + arg1
    local interval = InBattleground() and BG_POLL_INTERVAL or WORLD_POLL_INTERVAL
    if pollTimer >= interval then
        pollTimer = 0
        if available ~= false then Query() end
    end
end)

-- ---------------------------------------------------------------- slash command
SLASH_RENOWNBAR1 = "/renownbar"
SlashCmdList["RENOWNBAR"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "hide" then
        bar:Hide(); RenownBarDB.hidden = true
    elseif msg == "show" then
        bar:Show(); RenownBarDB.hidden = nil
    elseif msg == "reset" then
        RenownBarDB.point = nil; RestorePosition()
    elseif msg == "refresh" then
        available = nil
        if pushMode then Sync() else Query(true) end
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffffd100RenownBar:|r /renownbar show | hide | reset | refresh  (shift-drag the bar to move it)")
    end
end
