-- WotLK (3.3.5) compatibility shims for code written against the 1.12 API
if not string.gfind then string.gfind = string.gmatch end
if not math.mod then math.mod = math.fmod end
if not table.getn then table.getn = function(t) return #t end end

-- RenownPvP: a pop-out PvP panel for the spp-renown server module (WoW 1.12 / Lua 5.0).
--   * a small banner button (shift-drag to move) opens the panel
--   * Renown summary, battleground queues from anywhere, the Barrens Front, the field mount
--   * a Barrens Front HUD (domination bar, objectives, timers) and a capture bar while you are on the front,
--     and banners on the Barrens world map

RenownPvPDB = RenownPvPDB or {}

BINDING_HEADER_RENOWN = "Renown"
BINDING_NAME_RENOWN_PANEL = "Toggle the PvP panel"
BINDING_NAME_RENOWN_MOUNT = "Field mount (summon / dismount)"
BINDING_NAME_RENOWN_FRONT = "Travel to your front (Barrens 1-19, Plaguelands 55-60)"

local OBJECTIVES = { "Kolkar Watch", "Stagnant Oasis", "Raptor Grounds" }
local TEAM_COLOR = {
    [0] = { 0.6, 0.6, 0.6 },   -- neutral
    [1] = { 0.2, 0.6, 1.0 },   -- Alliance
    [2] = { 1.0, 0.2, 0.2 },   -- Horde
}
local TEAM_NAME = { [0] = "Neutral", [1] = "Alliance", [2] = "Horde" }
local BATTLEGROUNDS = {
    { key = "wsg", name = "Warsong Gulch",   levels = "1-60",  minLevel = 1 },
    { key = "ab",  name = "Arathi Basin",    levels = "1-60",  minLevel = 1 },
    { key = "av",  name = "Alterac Valley",  levels = "51-60", minLevel = 51 },
}
local BRACKETS = { "1-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60" }

local front = { owners = { 0, 0, 0 }, cap = { 0, 0, 0 }, pct = { 0, 0, 0 }, siege = 0, lock = 0, lockSecs = 0, inLake = false, underdog = 0, fort = 0 }

local function Command(text)
    SendChatMessage(text, "SAY")
end

local function MyBracket()
    local level = UnitLevel("player") or 1
    if level < 10 then return BRACKETS[1] end
    local b = math.floor(level / 10) + 1
    if b > 7 then b = 7 end
    return BRACKETS[b]
end

local function Backdrop(frame)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 14,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.85)
    frame:SetBackdropBorderColor(0.85, 0.65, 0.20, 1)
end

local function Button(parent, name, text, width, onClick, tip)
    local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    b:SetWidth(width)
    b:SetHeight(20)
    b:SetText(text)
    b:SetScript("OnClick", onClick)
    if tip then
        b.tip = tip
        b:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:AddLine(this.tip, 1, 1, 1, 1)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
    return b
end

local function Label(parent, template, text)
    local f = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlightSmall")
    f:SetJustifyH("LEFT")
    if text then f:SetText(text) end
    return f
end

-- ---------------------------------------------------------------- launcher button
local launcher = CreateFrame("Button", "RenownPvPLauncher", UIParent)
launcher:SetWidth(36)
launcher:SetHeight(36)
launcher:SetMovable(true)
launcher:EnableMouse(true)
launcher:RegisterForClicks("LeftButtonUp", "RightButtonUp")
if launcher.SetClampedToScreen then launcher:SetClampedToScreen(true) end

local launcherIcon = launcher:CreateTexture(nil, "ARTWORK")
launcherIcon:SetAllPoints(launcher)
launcherIcon:SetTexture("Interface\\Icons\\INV_BannerPVP_02")

local launcherBorder = launcher:CreateTexture(nil, "OVERLAY")
launcherBorder:SetWidth(62)
launcherBorder:SetHeight(62)
launcherBorder:SetPoint("CENTER", launcher, "CENTER", 0, 0)
launcherBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
launcherBorder:SetBlendMode("ADD")
launcherBorder:SetVertexColor(0.9, 0.7, 0.2, 0.6)

launcher:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

local function SaveLauncher()
    local point, _, relPoint, x, y = launcher:GetPoint()
    RenownPvPDB.point, RenownPvPDB.relPoint, RenownPvPDB.x, RenownPvPDB.y = point, relPoint, x, y
end

local function RestoreLauncher()
    launcher:ClearAllPoints()
    if RenownPvPDB.point then
        launcher:SetPoint(RenownPvPDB.point, UIParent, RenownPvPDB.relPoint, RenownPvPDB.x, RenownPvPDB.y)
    else
        launcher:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -200, -14)
    end
end

launcher:SetScript("OnMouseDown", function()
    if IsShiftKeyDown() then this:StartMoving() end
end)
launcher:SetScript("OnMouseUp", function()
    this:StopMovingOrSizing()
    SaveLauncher()
end)
launcher:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:AddLine("Renown PvP", 1, 0.82, 0)
    GameTooltip:AddLine("Click: open the PvP panel", 1, 1, 1)
    GameTooltip:AddLine("Right-click: field mount", 1, 1, 1)
    GameTooltip:AddLine("Shift-drag: move", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)
launcher:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- ---------------------------------------------------------------- panel
-- Layout: title bar, Renown summary strip, two tabs (Battlegrounds / Fronts), footer actions.
local PANEL_W, PANEL_H = 360, 452
local GOLD = { 1, 0.82, 0 }

local panel = CreateFrame("Frame", "RenownPvPPanel", UIParent)
panel:SetWidth(PANEL_W)
panel:SetHeight(PANEL_H)
panel:SetFrameStrata("MEDIUM")
panel:EnableMouse(true)
panel:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
panel:Hide()
tinsert(UISpecialFrames, "RenownPvPPanel")   -- Escape closes it

local function PlacePanel()
    panel:ClearAllPoints()
    local x = launcher:GetCenter()
    if x and x > GetScreenWidth() / 2 then
        panel:SetPoint("TOPRIGHT", launcher, "BOTTOMLEFT", 0, 0)
    else
        panel:SetPoint("TOPLEFT", launcher, "BOTTOMRIGHT", 0, 0)
    end
end

-- Title plate
local titleBg = panel:CreateTexture(nil, "ARTWORK")
titleBg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
titleBg:SetWidth(280)
titleBg:SetHeight(64)
titleBg:SetPoint("TOP", panel, "TOP", 0, 12)
local title = Label(panel, "GameFontNormal", "Renown PvP")
title:SetPoint("TOP", panel, "TOP", 0, -1)

local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -5, -5)

-- Small helpers for a consistent look
local function Divider(parent, anchor, offsetY)
    local t = parent:CreateTexture(nil, "ARTWORK")
    t:SetTexture(1, 0.82, 0, 0.25)
    t:SetHeight(1)
    t:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, offsetY)
    t:SetPoint("RIGHT", parent, "RIGHT", -18, 0)
    return t
end

local function Card(parent, width, height)
    local f = CreateFrame("Frame", nil, parent)
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    f:SetBackdropColor(0.05, 0.05, 0.05, 0.75)
    f:SetBackdropBorderColor(0.55, 0.45, 0.25, 0.9)
    return f
end

local function Bar(parent, width, height)
    local b = CreateFrame("StatusBar", nil, parent)
    b:SetWidth(width)
    b:SetHeight(height)
    b:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    b:SetMinMaxValues(0, 1)
    b:SetValue(0)
    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(b)
    bg:SetTexture(0, 0, 0, 0.55)
    local border = CreateFrame("Frame", nil, b)
    border:SetPoint("TOPLEFT", b, "TOPLEFT", -3, 3)
    border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 3, -3)
    border:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 8 })
    border:SetBackdropBorderColor(0.6, 0.5, 0.3, 0.9)
    return b
end

-- ---- Summary strip: faction emblem, rank, progress, Renown to spend
local emblem = panel:CreateTexture(nil, "ARTWORK")
emblem:SetWidth(40)
emblem:SetHeight(40)
emblem:SetPoint("TOPLEFT", panel, "TOPLEFT", 22, -30)
emblem:SetTexture("Interface\\Icons\\INV_BannerPVP_02")
local emblemBorder = panel:CreateTexture(nil, "OVERLAY")
emblemBorder:SetWidth(70)
emblemBorder:SetHeight(70)
emblemBorder:SetPoint("CENTER", emblem, "CENTER", 0, 0)
emblemBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
emblemBorder:SetBlendMode("ADD")
emblemBorder:SetVertexColor(0.9, 0.7, 0.2, 0.7)

local rankText = Label(panel, "GameFontNormalLarge", "Renown")
rankText:SetPoint("TOPLEFT", emblem, "TOPRIGHT", 12, -1)
local rankSub = Label(panel, "GameFontHighlightSmall", "Waiting for the server...")
rankSub:SetPoint("TOPLEFT", rankText, "BOTTOMLEFT", 0, -3)

local rankBar = Bar(panel, 186, 9)
rankBar:SetPoint("TOPLEFT", rankSub, "BOTTOMLEFT", 2, -6)
rankBar:SetStatusBarColor(0.85, 0.6, 0.12)

local spendLabel = Label(panel, "GameFontDisableSmall", "TO SPEND")
spendLabel:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -24, -34)
spendLabel:SetJustifyH("RIGHT")
local spendText = Label(panel, "GameFontNormalLarge", "-")
spendText:SetPoint("TOPRIGHT", spendLabel, "BOTTOMRIGHT", 0, -3)
spendText:SetJustifyH("RIGHT")

local summaryLine = Divider(panel, emblem, -14)

-- ---- Tabs
local tabs, pages = {}, {}
local function SelectTab(index)
    for i = 1, table.getn(tabs) do
        if i == index then
            tabs[i]:LockHighlight()
            tabs[i].text:SetTextColor(1, 0.82, 0)
            pages[i]:Show()
        else
            tabs[i]:UnlockHighlight()
            tabs[i].text:SetTextColor(0.7, 0.7, 0.7)
            pages[i]:Hide()
        end
    end
    RenownPvPDB.tab = index
end

local function Tab(index, label)
    local t = CreateFrame("Button", "RenownPvPTab" .. index, panel)
    t:SetWidth(156)
    t:SetHeight(24)
    t:SetPoint("TOPLEFT", summaryLine, "BOTTOMLEFT", (index - 1) * 162, -8)
    t:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
    local bg = t:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(t)
    bg:SetTexture(1, 1, 1, 0.06)
    t.text = Label(t, "GameFontNormal", label)
    t.text:SetPoint("CENTER", t, "CENTER", 0, 0)
    t:SetScript("OnClick", function() SelectTab(index) end)
    tabs[index] = t
    local p = CreateFrame("Frame", nil, panel)
    p:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, -8)
    p:SetWidth(PANEL_W - 36)
    p:SetHeight(270)
    pages[index] = p
    return p
end

local bgPage = Tab(1, "Battlegrounds")
local frontPage = Tab(2, "Fronts")

-- ---- Battlegrounds page
local bracketText = Label(bgPage, "GameFontDisableSmall", "")
bracketText:SetPoint("TOPLEFT", bgPage, "TOPLEFT", 2, 0)
local BG_ICONS = { wsg = "Interface\\Icons\\INV_Misc_Rune_07", ab = "Interface\\Icons\\INV_Jewelry_Amulet_07", av = "Interface\\Icons\\INV_Jewelry_Necklace_21" }
local bgRows = {}
for i = 1, table.getn(BATTLEGROUNDS) do
    local def = BATTLEGROUNDS[i]
    local card = Card(bgPage, PANEL_W - 36, 52)
    card:SetPoint("TOPLEFT", bgPage, "TOPLEFT", 0, -16 - (i - 1) * 58)
    local icon = card:CreateTexture(nil, "ARTWORK")
    icon:SetWidth(32)
    icon:SetHeight(32)
    icon:SetPoint("LEFT", card, "LEFT", 10, 0)
    icon:SetTexture(BG_ICONS[def.key])
    local row = { card = card }
    row.name = Label(card, "GameFontNormal", def.name)
    row.name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, -2)
    row.status = Label(card, "GameFontHighlightSmall", "")
    row.status:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -4)
    row.button = Button(card, "RenownPvPQueue" .. i, "Join Queue", 92, function() Command(".renown queue " .. this.key) end,
        "Queue for " .. def.name .. " from anywhere (levels " .. def.levels .. "). You are bolstered to the top of your bracket.")
    row.button.key = def.key
    row.button:SetPoint("RIGHT", card, "RIGHT", -10, 0)
    bgRows[i] = row
end
local bgHint = Label(bgPage, "GameFontDisableSmall", "Battlegrounds pay Renown, PvP experience and loot bags.")
bgHint:SetPoint("TOPLEFT", bgRows[table.getn(BATTLEGROUNDS)].card, "BOTTOMLEFT", 2, -8)

-- ---- Fronts page: Barrens (tier 1) and Plaguelands (tier 4)
local barrensCard = Card(frontPage, PANEL_W - 36, 172)
barrensCard:SetPoint("TOPLEFT", frontPage, "TOPLEFT", 0, 0)
local barrensTitle = Label(barrensCard, "GameFontNormal", "Barrens Front")
barrensTitle:SetPoint("TOPLEFT", barrensCard, "TOPLEFT", 10, -9)
local barrensTier = Label(barrensCard, "GameFontDisableSmall", "TIER 1  |  LEVELS 1-19")
barrensTier:SetPoint("TOPRIGHT", barrensCard, "TOPRIGHT", -10, -11)
barrensTier:SetJustifyH("RIGHT")

local frontRows = {}
for i = 1, 3 do
    local row = {}
    row.swatch = barrensCard:CreateTexture(nil, "ARTWORK")
    row.swatch:SetWidth(10)
    row.swatch:SetHeight(10)
    row.swatch:SetPoint("TOPLEFT", barrensCard, "TOPLEFT", 12, -32 - (i - 1) * 17)
    row.swatch:SetTexture(0.6, 0.6, 0.6)
    row.label = Label(barrensCard, "GameFontHighlightSmall", OBJECTIVES[i])
    row.label:SetPoint("LEFT", row.swatch, "RIGHT", 7, 0)
    row.owner = Label(barrensCard, "GameFontDisableSmall", "")
    row.owner:SetPoint("LEFT", row.swatch, "LEFT", 130, 0)
    row.progress = Bar(barrensCard, 90, 7)
    row.progress:SetPoint("RIGHT", barrensCard, "RIGHT", -14, 0)
    row.progress:SetPoint("TOP", row.swatch, "TOP", 0, -1)
    row.progress:SetMinMaxValues(0, 100)
    row.progress:Hide()
    frontRows[i] = row
end

local frontStatus = Label(barrensCard, "GameFontHighlightSmall", "")
frontStatus:SetPoint("TOPLEFT", barrensCard, "TOPLEFT", 12, -88)
frontStatus:SetWidth(PANEL_W - 60)

local frontJoin = Button(barrensCard, "RenownPvPFrontJoin", "Go to the Front", 120, function() Command(".renown rvr join") end,
    "Travel to the Crossroads (Horde) or Northwatch Hold (Alliance). You are bolstered to 19 on the front.")
frontJoin:SetPoint("BOTTOMLEFT", barrensCard, "BOTTOMLEFT", 10, 36)
local frontLeave = Button(barrensCard, "RenownPvPFrontLeave", "Leave", 70, function() Command(".renown rvr leave") end,
    "Return to where you were before going to the front.")
frontLeave:SetPoint("LEFT", frontJoin, "RIGHT", 6, 0)
local frontInfo = Button(barrensCard, "RenownPvPFrontInfo", "Status", 70, function() Command(".renown rvr status") end,
    "Print the state of the front in chat.")
frontInfo:SetPoint("LEFT", frontLeave, "RIGHT", 6, 0)
local frontWarband = Button(barrensCard, "RenownPvPWarband", "Warband", 120, function() Command(".renown warband") end,
    "Call up to four soldiers of your side into your party. They follow and fight with you while you are on a front.")
frontWarband:SetPoint("BOTTOMLEFT", barrensCard, "BOTTOMLEFT", 10, 10)
local frontDismiss = Button(barrensCard, "RenownPvPWarbandDismiss", "Dismiss", 70, function() Command(".renown warband dismiss") end,
    "Send your warband back to the front lines.")
frontDismiss:SetPoint("LEFT", frontWarband, "RIGHT", 6, 0)

local t4Card = Card(frontPage, PANEL_W - 36, 92)
t4Card:SetPoint("TOPLEFT", barrensCard, "BOTTOMLEFT", 0, -8)
local t4Title = Label(t4Card, "GameFontNormal", "Plaguelands Front")
t4Title:SetPoint("TOPLEFT", t4Card, "TOPLEFT", 10, -9)
local t4Tier = Label(t4Card, "GameFontDisableSmall", "TIER 4  |  LEVELS 55-60")
t4Tier:SetPoint("TOPRIGHT", t4Card, "TOPRIGHT", -10, -11)
t4Tier:SetJustifyH("RIGHT")
local t4Text = Label(t4Card, "GameFontHighlightSmall", "Take the four towers, hold three to besiege the enemy keep. The winners claim Stratholme (Darkness Falls).")
t4Text:SetPoint("TOPLEFT", t4Card, "TOPLEFT", 12, -28)
t4Text:SetWidth(PANEL_W - 60)
local t4Join = Button(t4Card, "RenownPvPT4Join", "Go to the Plaguelands", 150, function() Command(".renown t4 join") end,
    "Travel to your keep: Darrowshire (Alliance) or Northdale (Horde). Levels 55-59 are bolstered to 60.")
t4Join:SetPoint("BOTTOMLEFT", t4Card, "BOTTOMLEFT", 10, 10)
local t4Status = Button(t4Card, "RenownPvPT4Status", "Status", 70, function() Command(".renown t4 status") end,
    "Towers, sieges and who holds Darkness Falls.")
t4Status:SetPoint("LEFT", t4Join, "RIGHT", 6, 0)

-- ---- Footer: field mount and session report
local footerLine = panel:CreateTexture(nil, "ARTWORK")
footerLine:SetTexture(1, 0.82, 0, 0.25)
footerLine:SetHeight(1)
footerLine:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 18, 46)
footerLine:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -18, 46)
local mountButton = Button(panel, "RenownPvPMount", "Field Mount", 104, function() RenownPvP_Mount() end,
    "Your racial mount at +30% speed for levels 1-39. Bind a key under Key Bindings > Renown, or type /fm.")
mountButton:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 20, 18)
local sessionButton = Button(panel, "RenownPvPSession", "My Session", 104, function() Command(".renown session") end,
    "Kills, captures, Renown and levels since you arrived on a front.")
sessionButton:SetPoint("LEFT", mountButton, "RIGHT", 6, 0)
local mountText = Label(panel, "GameFontDisableSmall", "")
mountText:SetPoint("LEFT", sessionButton, "RIGHT", 10, 0)
mountText:SetWidth(100)

-- ---------------------------------------------------------------- refresh
local function RefreshRenown()
    local s = RenownBar_State
    if not s then return end
    rankText:SetText("Rank " .. s.rank .. "  |cffffffff" .. (s.title or "") .. "|r")
    if s.maxed then
        rankSub:SetText("|cff88ff88Highest rank reached|r")
        rankBar:SetMinMaxValues(0, 1)
        rankBar:SetValue(1)
    else
        rankBar:SetMinMaxValues(0, math.max(s.needed or 1, 1))
        rankBar:SetValue(s.current or 0)
        rankSub:SetText((s.current or 0) .. " / " .. (s.needed or "?") .. " to rank " .. (s.nextRank or (s.rank + 1)))
    end
    spendText:SetText(s.spendable or 0)
end

local function FormatWait(ms)
    if not ms or ms <= 0 then return "" end
    local secs = math.floor(ms / 1000)
    return string.format(" %d:%02d", math.floor(secs / 60), math.mod(secs, 60))
end

local function RefreshQueues()
    bracketText:SetText("YOUR BRACKET: " .. MyBracket())
    local level = UnitLevel("player") or 1
    for i = 1, table.getn(BATTLEGROUNDS) do
        local def = BATTLEGROUNDS[i]
        local row = bgRows[i]
        local text, queued, active = "", false, false
        for q = 1, (MAX_BATTLEFIELD_QUEUES or 3) do
            local status, mapName = GetBattlefieldStatus(q)
            if mapName == def.name then
                if status == "queued" then
                    queued = true
                    local waited = GetBattlefieldTimeWaited and GetBattlefieldTimeWaited(q) or 0
                    text = "|cffffd100In queue" .. FormatWait(waited) .. "|r"
                elseif status == "confirm" then
                    queued = true
                    text = "|cff00ff00Ready - enter from the popup|r"
                elseif status == "active" then
                    active = true
                    text = "|cff00ff00In battle|r"
                end
            end
        end
        if text == "" then
            if level < def.minLevel then
                text = "|cff888888Requires level " .. def.minLevel .. "|r"
            else
                text = "Levels " .. def.levels
            end
        end
        row.status:SetText(text)
        if queued or active or level < def.minLevel then row.button:Disable() else row.button:Enable() end
    end
end

local function RefreshFront()
    for i = 1, 3 do
        local row = frontRows[i]
        local owner = front.owners[i]
        local c = TEAM_COLOR[owner] or TEAM_COLOR[0]
        row.swatch:SetTexture(c[1], c[2], c[3])
        local fortified = math.mod(math.floor((front.fort or 0) / ({ 1, 2, 4 })[i]), 2) == 1
        row.owner:SetText((TEAM_NAME[owner] or "?") .. (fortified and "  |cffffd100fortified|r" or ""))
        if front.cap[i] > 0 and front.pct[i] > 0 then
            local cc = TEAM_COLOR[front.cap[i]]
            row.progress:SetStatusBarColor(cc[1], cc[2], cc[3])
            row.progress:SetValue(front.pct[i])
            row.progress:Show()
        else
            row.progress:Hide()
        end
    end
    if front.lock > 0 then
        frontStatus:SetText("|cff88ff88" .. TEAM_NAME[front.lock] .. " victory.|r The front reopens in " .. math.ceil(front.lockSecs / 60) .. " min.")
    elseif front.siege > 0 then
        frontStatus:SetText("|cffff8000Siege!|r The " .. TEAM_NAME[front.siege] .. " is assaulting the enemy commander.")
    elseif front.underdog and front.underdog > 0 then
        frontStatus:SetText("|cffffd100The " .. TEAM_NAME[front.underdog] .. " rallies:|r +25% Renown and faster captures.")
    elseif front.inLake then
        frontStatus:SetText("|cff00ff00You are on the front.|r Push the lane: your tower, the Oasis, then theirs.")
    else
        frontStatus:SetText("Push the lane: your tower, the Oasis, then theirs.")
    end
    local level = UnitLevel("player") or 1
    if level > 19 then frontJoin:Disable() else frontJoin:Enable() end
    if level >= 55 then t4Join:Enable() else t4Join:Disable() end
    if (front.inLake and level <= 19) or level >= 55 then frontWarband:Enable() else frontWarband:Disable() end
end

local function RefreshMount()
    local level = UnitLevel("player") or 1
    if level > 39 then
        mountButton:Disable()
        mountText:SetText("Levels 1-39")
    else
        mountButton:Enable()
        mountText:SetText("")
    end
end

function RenownPvP_Refresh()
    if panel:IsVisible() then
        RefreshRenown()
        RefreshQueues()
        RefreshFront()
        RefreshMount()
    end
end

function RenownPvP_Toggle()
    if panel:IsVisible() then
        panel:Hide()
    else
        PlacePanel()
        if UnitFactionGroup and UnitFactionGroup("player") == "Horde" then
            emblem:SetTexture("Interface\\Icons\\INV_BannerPVP_01")
        end
        SelectTab(RenownPvPDB.tab or ((UnitLevel("player") or 1) <= 19 and 2 or 1))
        panel:Show()
        RenownPvP_Refresh()
    end
end

function RenownPvP_Mount()
    Command(".renown mount")
end

function RenownPvP_Front()
    if (UnitLevel("player") or 1) >= 55 then
        Command(".renown t4 join")
    else
        Command(".renown rvr join")
    end
end

launcher:SetScript("OnClick", function()
    if arg1 == "RightButton" then RenownPvP_Mount() else RenownPvP_Toggle() end
end)

local refreshTimer = 0
panel:SetScript("OnUpdate", function()
    refreshTimer = refreshTimer + arg1
    if refreshTimer > 1 then
        refreshTimer = 0
        RefreshQueues()   -- queue timers tick
    end
end)

-- ---------------------------------------------------------------- front HUD (top of the screen while on the front)
-- Domination bar (tug of war: Alliance fills from the left, Horde from the right), the three objectives and the
-- front state with live countdowns. Shift-drag to move; /rpvp hudreset puts it back.
local HUD_W = 330
local tracker = CreateFrame("Frame", "RenownFrontHUD", UIParent)
tracker:SetWidth(HUD_W)
tracker:SetHeight(124)
tracker:SetFrameStrata("MEDIUM")
tracker:SetMovable(true)
tracker:EnableMouse(true)
tracker:RegisterForDrag("LeftButton")
tracker:SetScript("OnDragStart", function() if IsShiftKeyDown() then this:StartMoving() end end)
tracker:SetScript("OnDragStop", function()
    this:StopMovingOrSizing()
    local _, _, _, x, y = this:GetPoint()
    RenownPvPDB.hud = { x = x, y = y }
end)
Backdrop(tracker)
tracker:SetBackdropColor(0, 0, 0, 0.6)
tracker:Hide()

local function PlaceHUD()
    tracker:ClearAllPoints()
    if RenownPvPDB.hud then
        tracker:SetPoint("TOP", UIParent, "TOP", RenownPvPDB.hud.x, RenownPvPDB.hud.y)
    else
        tracker:SetPoint("TOP", UIParent, "TOP", 0, -24)
    end
end

local hudTitle = tracker:CreateFontString(nil, "OVERLAY", "GameFontNormal")
hudTitle:SetPoint("TOP", tracker, "TOP", 0, -8)
hudTitle:SetText("BARRENS FRONT")

-- domination bar
local DOM_W = HUD_W - 30
local domBg = tracker:CreateTexture(nil, "BACKGROUND")
domBg:SetTexture(0.05, 0.05, 0.05, 0.9)
domBg:SetWidth(DOM_W)
domBg:SetHeight(14)
domBg:SetPoint("TOP", tracker, "TOP", 0, -26)
local domA = tracker:CreateTexture(nil, "ARTWORK")
domA:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
domA:SetVertexColor(TEAM_COLOR[1][1], TEAM_COLOR[1][2], TEAM_COLOR[1][3])
domA:SetHeight(14)
domA:SetPoint("LEFT", domBg, "LEFT", 0, 0)
local domH = tracker:CreateTexture(nil, "ARTWORK")
domH:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
domH:SetVertexColor(TEAM_COLOR[2][1], TEAM_COLOR[2][2], TEAM_COLOR[2][3])
domH:SetHeight(14)
domH:SetPoint("RIGHT", domBg, "RIGHT", 0, 0)
local domMid = tracker:CreateTexture(nil, "OVERLAY")
domMid:SetTexture(1, 1, 1, 0.6)
domMid:SetWidth(1)
domMid:SetHeight(18)
domMid:SetPoint("CENTER", domBg, "CENTER", 0, 0)
local domBorder = CreateFrame("Frame", nil, tracker)
domBorder:SetPoint("TOPLEFT", domBg, "TOPLEFT", -3, 3)
domBorder:SetPoint("BOTTOMRIGHT", domBg, "BOTTOMRIGHT", 3, -3)
domBorder:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10 })
domBorder:SetBackdropBorderColor(0.85, 0.65, 0.20, 1)
local domText = domBorder:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
domText:SetPoint("CENTER", domBg, "CENTER", 0, 0)
local domLeft = tracker:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
domLeft:SetPoint("BOTTOMLEFT", domBg, "TOPLEFT", 0, 2)
local domRight = tracker:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
domRight:SetPoint("BOTTOMRIGHT", domBg, "TOPRIGHT", 0, 2)

-- objectives
local trackerRows = {}
for i = 1, 3 do
    local row = CreateFrame("Frame", nil, tracker)
    row:SetWidth(DOM_W / 3)
    row:SetHeight(34)
    row:SetPoint("TOPLEFT", domBg, "BOTTOMLEFT", (i - 1) * DOM_W / 3, -6)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetWidth(22)
    row.icon:SetHeight(22)
    row.icon:SetPoint("TOP", row, "TOP", 0, 0)
    row.shield = row:CreateTexture(nil, "OVERLAY")
    row.shield:SetTexture("Interface\\Icons\\INV_Shield_06")
    row.shield:SetWidth(11)
    row.shield:SetHeight(11)
    row.shield:SetPoint("BOTTOMRIGHT", row.icon, "BOTTOMRIGHT", 4, -2)
    row.label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.label:SetPoint("TOP", row.icon, "BOTTOM", 0, -1)
    row.label:SetText(OBJECTIVES[i])
    row.state = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.state:SetPoint("TOP", row.label, "BOTTOM", 0, 0)
    trackerRows[i] = row
end

local hudState = tracker:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
hudState:SetPoint("BOTTOM", tracker, "BOTTOM", 0, 25)

-- influence bar (Warhammer style): fills from front activity, three reward tiers at the Rally Master
local influence = { points = 0, claimed = 0, tiers = { 300, 900, 1800 } }
local infBar = CreateFrame("StatusBar", nil, tracker)
infBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
infBar:SetStatusBarColor(0.85, 0.65, 0.2)
infBar:SetWidth(DOM_W)
infBar:SetHeight(9)
infBar:SetPoint("BOTTOM", tracker, "BOTTOM", 0, 9)
infBar:SetMinMaxValues(0, 1800)
local infBg = infBar:CreateTexture(nil, "BACKGROUND")
infBg:SetAllPoints(infBar)
infBg:SetTexture(0.08, 0.06, 0.02, 0.9)
local infTicks = {}
for t = 1, 2 do
    local tick = infBar:CreateTexture(nil, "OVERLAY")
    tick:SetTexture(1, 1, 1, 0.7)
    tick:SetWidth(1)
    tick:SetHeight(11)
    infTicks[t] = tick
end
local infText = infBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
infText:SetPoint("CENTER", infBar, "CENTER", 0, 0)
local function RefreshInfluence()
    local top = influence.tiers[3]
    infBar:SetMinMaxValues(0, top)
    infBar:SetValue(influence.points)
    for t = 1, 2 do
        infTicks[t]:ClearAllPoints()
        infTicks[t]:SetPoint("CENTER", infBar, "LEFT", DOM_W * influence.tiers[t] / top, 0)
    end
    local unclaimed = 0
    for t = 1, 3 do
        if influence.points >= influence.tiers[t] and math.mod(math.floor(influence.claimed / math.pow(2, t - 1)), 2) == 0 then
            unclaimed = unclaimed + 1
        end
    end
    local text = "Influence " .. influence.points .. " / " .. top
    if unclaimed > 0 then
        text = text .. "  |cff00ff00(reward ready at the Rally Master)|r"
    end
    infText:SetText(text)
end

-- personal capture bar (middle of the screen while you stand on an objective)
local capFrame = CreateFrame("Frame", "RenownCaptureBar", UIParent)
capFrame:SetWidth(240)
capFrame:SetHeight(46)
capFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
Backdrop(capFrame)
capFrame:SetBackdropColor(0, 0, 0, 0.7)
capFrame:Hide()
local capName = capFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
capName:SetPoint("TOP", capFrame, "TOP", 0, -7)
local capBar = CreateFrame("StatusBar", nil, capFrame)
capBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
capBar:SetMinMaxValues(0, 100)
capBar:SetWidth(210)
capBar:SetHeight(12)
capBar:SetPoint("BOTTOM", capFrame, "BOTTOM", 0, 8)
local capBarBg = capBar:CreateTexture(nil, "BACKGROUND")
capBarBg:SetAllPoints(capBar)
capBarBg:SetTexture(0.1, 0.1, 0.1, 0.9)
local capText = capBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
capText:SetPoint("CENTER", capBar, "CENTER", 0, 0)

local function Clock(secs)
    secs = math.max(0, math.floor(secs))
    return string.format("%d:%02d", math.floor(secs / 60), math.mod(secs, 60))
end

local function MyTeam()
    return (UnitFactionGroup and UnitFactionGroup("player") == "Horde") and 2 or 1
end

-- Lane order: own tower (Kolkar for the Horde, Raptor for the Alliance) -> Oasis -> enemy tower.
-- Returns the objective that must be held first, or nil when this one can be captured.
local function NeedFirst(i)
    local team = MyTeam()
    local own = team == 2 and 1 or 3
    if i == own then return nil end
    local need = (i == 2) and own or 2
    if front.owners[need] == team then return nil end
    return OBJECTIVES[need]
end

local function RefreshCapture()
    local i = front.near or 0
    if i < 1 or i > 3 or not front.inLake or front.lock > 0 then
        capFrame:Hide()
        return
    end
    capName:SetText(OBJECTIVES[i])
    local owner, cap, pct = front.owners[i], front.cap[i], front.pct[i]
    if cap > 0 and pct > 0 and cap ~= owner then
        local c = TEAM_COLOR[cap]
        capBar:SetStatusBarColor(c[1], c[2], c[3])
        capBar:SetValue(pct)
        capText:SetText(TEAM_NAME[cap] .. " capturing  " .. pct .. "%")
    elseif owner > 0 then
        local c = TEAM_COLOR[owner]
        capBar:SetStatusBarColor(c[1], c[2], c[3])
        capBar:SetValue(100)
        if owner == MyTeam() then
            capText:SetText("Held by the " .. TEAM_NAME[owner] .. " - defend it")
        elseif NeedFirst(i) then
            capText:SetText("Take " .. NeedFirst(i) .. " first")
        else
            capText:SetText("Held by the " .. TEAM_NAME[owner] .. " - clear it to capture")
        end
    else
        capBar:SetStatusBarColor(0.6, 0.6, 0.6)
        capBar:SetValue(0)
        if NeedFirst(i) then
            capText:SetText("Take " .. NeedFirst(i) .. " first")
        else
            capText:SetText("Neutral - stand here to capture")
        end
    end
    capFrame:Show()
end

local function RefreshHUDState()
    local now = GetTime()
    if front.lock > 0 then
        hudState:SetText("|cff88ff88" .. TEAM_NAME[front.lock] .. " victory|r - the front reopens in " .. Clock((front.lockAt or now) - now))
    elseif front.siege > 0 then
        local target = front.siege == 1 and "Crossroads Warlord" or "Northwatch Field Commander"
        hudState:SetText("|cffff8000SIEGE!|r " .. TEAM_NAME[front.siege] .. " assault the " .. target)
    elseif front.underdog > 0 then
        hudState:SetText("The " .. TEAM_NAME[front.underdog] .. " rallies: +25% Renown, faster captures")
    else
        hudState:SetText("|cffaaaaaaObjectives, kills, battlegrounds and war boards push the bar|r")
    end
end

local function RefreshTracker()
    -- domination bar
    local dom = front.dom or 0
    local aW = math.max(0.01, (dom + 100) / 200 * DOM_W)
    domA:SetWidth(aW)
    domH:SetWidth(math.max(0.01, DOM_W - aW))
    if dom > 0 then
        domText:SetText("Alliance " .. dom .. "%")
    elseif dom < 0 then
        domText:SetText("Horde " .. (-dom) .. "%")
    else
        domText:SetText("Contested")
    end
    domLeft:SetText(dom >= 100 and "|cff3399ffSIEGE|r" or "|cff3399ffAlliance|r")
    domRight:SetText(dom <= -100 and "|cffff3333SIEGE|r" or "|cffff3333Horde|r")

    for i = 1, 3 do
        local row = trackerRows[i]
        local owner = front.owners[i]
        if owner == 2 then
            row.icon:SetTexture("Interface\\Icons\\INV_BannerPVP_01"); row.icon:SetVertexColor(1, 1, 1)
        elseif owner == 1 then
            row.icon:SetTexture("Interface\\Icons\\INV_BannerPVP_02"); row.icon:SetVertexColor(1, 1, 1)
        else
            row.icon:SetTexture("Interface\\Icons\\INV_BannerPVP_02"); row.icon:SetVertexColor(0.4, 0.4, 0.4)
        end
        local fortified = math.mod(math.floor((front.fort or 0) / math.pow(2, i - 1)), 2) == 1
        if fortified then row.shield:Show() else row.shield:Hide() end
        if front.cap[i] > 0 and front.pct[i] > 0 and front.cap[i] ~= owner then
            row.state:SetText((front.cap[i] == 1 and "|cff3399ff" or "|cffff3333") .. "capturing " .. front.pct[i] .. "%|r")
        elseif owner > 0 then
            row.state:SetText((fortified and "fortified - " or "") .. "held")
        else
            row.state:SetText("neutral")
        end
    end

    RefreshHUDState()
    RefreshCapture()
    if front.inLake then
        if not tracker:IsVisible() then PlaceHUD() end
        tracker:Show()
    else
        tracker:Hide()
    end
end

-- live countdown for the lock timer
local hudElapsed = 0
tracker:SetScript("OnUpdate", function()
    hudElapsed = hudElapsed + arg1
    if hudElapsed >= 1 then
        hudElapsed = 0
        RefreshHUDState()
    end
end)


-- ---------------------------------------------------------------- world map banners
-- Barrens map bounds (WorldMapArea.dbc): left/right are world Y, top/bottom are world X
local BARRENS = { left = 2622.917, right = -7510.417, top = 1612.5, bottom = -5143.75 }
local PIN_POS = {
    { x = -849,  y = -2858 },   -- Kolkar Watch
    { x = -1255, y = -3150 },   -- Stagnant Oasis
    { x = -1790, y = -3280 },   -- Raptor Grounds
    { x = -680,  y = -2740 },   -- Crossroads Warlord (siege target for the Alliance)
    { x = -1965, y = -3395 },   -- Northwatch Field Commander (siege target for the Horde)
}
local PIN_NAME = { OBJECTIVES[1], OBJECTIVES[2], OBJECTIVES[3], "Crossroads Warlord", "Northwatch Field Commander" }
local pins = {}

local function UpdatePins()
    if not WorldMapButton then return end
    local onBarrens = GetMapInfo and GetMapInfo() == "Barrens"
    local w, h = WorldMapButton:GetWidth(), WorldMapButton:GetHeight()
    for i = 1, 5 do
        local pin = pins[i]
        if not pin then
            pin = CreateFrame("Frame", "RenownFrontPin" .. i, WorldMapButton)
            pin:SetWidth(i <= 3 and 22 or 18)
            pin:SetHeight(i <= 3 and 22 or 18)
            pin:SetFrameLevel(WorldMapButton:GetFrameLevel() + 5)
            pin.icon = pin:CreateTexture(nil, "OVERLAY")
            pin.icon:SetAllPoints(pin)
            pin.index = i
            pin:EnableMouse(true)
            pin:SetScript("OnEnter", function()
                local tip = WorldMapTooltip or GameTooltip
                tip:SetOwner(this, "ANCHOR_RIGHT")
                tip:AddLine(PIN_NAME[this.index], 1, 0.82, 0)
                if this.index <= 3 then
                    tip:AddLine("Held by: " .. TEAM_NAME[front.owners[this.index]], 1, 1, 1)
                else
                    tip:AddLine("Siege target - kill him to win the Barrens Front!", 1, 0.5, 0.2)
                end
                tip:AddLine("Barrens Front (tier 1 RvR)", 0.6, 0.6, 0.6)
                tip:Show()
            end)
            pin:SetScript("OnLeave", function() (WorldMapTooltip or GameTooltip):Hide() end)
            pins[i] = pin
        end

        local show = onBarrens and (i <= 3 or (i == 4 and front.siege == 1) or (i == 5 and front.siege == 2))
        if show then
            local p = PIN_POS[i]
            local mx = (BARRENS.left - p.y) / (BARRENS.left - BARRENS.right)
            local my = (BARRENS.top - p.x) / (BARRENS.top - BARRENS.bottom)
            pin:ClearAllPoints()
            pin:SetPoint("CENTER", WorldMapButton, "TOPLEFT", mx * w, -my * h)
            if i <= 3 then
                local owner = front.owners[i]
                if owner == 2 then
                    pin.icon:SetTexture("Interface\\Icons\\INV_BannerPVP_01")
                    pin.icon:SetVertexColor(1, 1, 1)
                elseif owner == 1 then
                    pin.icon:SetTexture("Interface\\Icons\\INV_BannerPVP_02")
                    pin.icon:SetVertexColor(1, 1, 1)
                else
                    pin.icon:SetTexture("Interface\\Icons\\INV_BannerPVP_02")
                    pin.icon:SetVertexColor(0.45, 0.45, 0.45)
                end
            else
                pin.icon:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Skull")
                pin.icon:SetVertexColor(1, 1, 1)
            end
            pin:Show()
        else
            pin:Hide()
        end
    end
end

-- ---------------------------------------------------------------- server messages
-- "owner,capTeam,pct;owner,capTeam,pct;owner,capTeam,pct/siege/lock/lockSeconds/inLake[/underdog/fortifiedMask/domination/nearObjective]"
local function ParseInfluence(msg)
    local _, _, pts, claimed, t1, t2, t3 = string.find(msg or "", "^(%d+)/(%d+)/(%d+)/(%d+)/(%d+)")
    if not pts then return end
    influence.points, influence.claimed = tonumber(pts), tonumber(claimed)
    influence.tiers = { tonumber(t1), tonumber(t2), tonumber(t3) }
    RefreshInfluence()
end

local function ParseFront(msg)
    local _, _, objs, siege, lock, lockSecs, member, rest = string.find(msg or "", "^(.-)/(%d)/(%d)/(%d+)/(%d)(.*)$")
    if not objs then return end
    local _, _, underdog, fort, dom, near = string.find(rest or "", "^/(%d)/(%d+)/?(%-?%d*)/?(%d*)")
    front.underdog, front.fort = tonumber(underdog or 0), tonumber(fort or 0)
    front.dom, front.near = tonumber(dom) or 0, tonumber(near) or 0
    local i = 0
    for owner, cap, pct in string.gfind(objs, "(%d),(%d),(%d+)") do
        i = i + 1
        if i <= 3 then
            front.owners[i], front.cap[i], front.pct[i] = tonumber(owner), tonumber(cap), tonumber(pct)
        end
    end
    front.siege, front.lock, front.lockSecs = tonumber(siege), tonumber(lock), tonumber(lockSecs)
    front.lockAt = GetTime() + front.lockSecs
    front.inLake = (tonumber(member) == 1)

    UpdatePins()
    RefreshTracker()
    if panel:IsVisible() then RefreshFront() end
end

-- ---------------------------------------------------------------- announcer (big text for front events)
local fx = CreateFrame("Frame", "RenownFrontFX", UIParent)
fx:SetWidth(800)
fx:SetHeight(60)
fx:SetPoint("TOP", UIParent, "TOP", 0, -150)
fx:SetFrameStrata("HIGH")
local fxLines = {}
for i = 1, 2 do
    local line = fx:CreateFontString(nil, "OVERLAY", "ZoneTextFont")
    line:SetPoint("TOP", fx, "TOP", 0, -(i - 1) * 30)
    line:SetTextColor(1, 0.82, 0)
    line:SetText("")
    line.age = 99
    fxLines[i] = line
end
local function ShowFX(text)
    -- newest on top, the previous one moves down
    fxLines[2]:SetText(fxLines[1]:GetText() or "")
    fxLines[2].age = fxLines[1].age
    fxLines[1]:SetText(text)
    fxLines[1].age = 0
    fx:Show()
end
fx:SetScript("OnUpdate", function()
    for i = 1, 2 do
        local line = fxLines[i]
        line.age = line.age + arg1
        if line.age > 5 then
            line:SetAlpha(0)
        elseif line.age > 4 then
            line:SetAlpha(5 - line.age)
        else
            line:SetAlpha(1)
        end
    end
end)

-- ---------------------------------------------------------------- events
local events = CreateFrame("Frame")
events:RegisterEvent("VARIABLES_LOADED")
events:RegisterEvent("CHAT_MSG_ADDON")
events:RegisterEvent("WORLD_MAP_UPDATE")
events:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
events:RegisterEvent("PLAYER_LEVEL_UP")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        RestoreLauncher()
        if RenownPvPDB.hidden then launcher:Hide() end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if UnitFactionGroup and UnitFactionGroup("player") == "Horde" then
            launcherIcon:SetTexture("Interface\\Icons\\INV_BannerPVP_01")
        end
        RenownPvP_Refresh()
    elseif event == "CHAT_MSG_ADDON" then
        if arg1 == "RENOWNRVR" and arg4 == UnitName("player") then ParseFront(arg2)
        elseif arg1 == "RENOWNINF" and arg4 == UnitName("player") then ParseInfluence(arg2)
        elseif arg1 == "RENOWNFX" and arg4 == UnitName("player") then ShowFX(arg2) end
    elseif event == "WORLD_MAP_UPDATE" then
        UpdatePins()
    else
        RenownPvP_Refresh()
    end
end)

-- ---------------------------------------------------------------- slash commands
SLASH_RENOWNPVP1 = "/rpvp"
SlashCmdList["RENOWNPVP"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "hide" then
        launcher:Hide(); panel:Hide(); RenownPvPDB.hidden = true
    elseif msg == "show" then
        launcher:Show(); RenownPvPDB.hidden = nil
    elseif msg == "hudreset" then
        RenownPvPDB.hud = nil; if tracker:IsVisible() then PlaceHUD() end
    elseif msg == "reset" then
        RenownPvPDB.point = nil; RestoreLauncher()
    elseif msg == "" then
        RenownPvP_Toggle()
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffffd100RenownPvP:|r /rpvp (panel) | show | hide | reset    /front [join|leave|status]    /warband [dismiss]    /bgq wsg|ab|av    /fm (mount)")
    end
end

SLASH_RENOWNFRONT1 = "/front"
SlashCmdList["RENOWNFRONT"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "" then msg = "join" end
    Command(".renown rvr " .. msg)
end

SLASH_RENOWNBGQ1 = "/bgq"
SlashCmdList["RENOWNBGQ"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffffd100RenownPvP:|r /bgq wsg | ab | av")
        return
    end
    Command(".renown queue " .. msg)
end

SLASH_RENOWNMOUNT1 = "/fm"
SlashCmdList["RENOWNMOUNT"] = function() RenownPvP_Mount() end

SLASH_RENOWNWARBAND1 = "/warband"
SlashCmdList["RENOWNWARBAND"] = function(msg)
    msg = string.lower(msg or "")
    Command(".renown warband " .. msg)
end

SLASH_RENOWNT4_1 = "/t4"
SlashCmdList["RENOWNT4_"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "" then msg = "join" end
    Command(".renown t4 " .. msg)
end
