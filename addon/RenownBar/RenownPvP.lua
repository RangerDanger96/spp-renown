-- RenownPvP: a pop-out PvP panel for the spp-renown server module (WoW 1.12 / Lua 5.0).
--   * a small banner button (shift-drag to move) opens the panel
--   * Renown summary, battleground queues from anywhere, the Barrens Front, the field mount
--   * a compact Barrens Front tracker while you are on the front, and banners on the Barrens world map

RenownPvPDB = RenownPvPDB or {}

BINDING_HEADER_RENOWN = "Renown"
BINDING_NAME_RENOWN_PANEL = "Toggle the PvP panel"
BINDING_NAME_RENOWN_MOUNT = "Field mount (summon / dismount)"
BINDING_NAME_RENOWN_FRONT = "Travel to the Barrens Front"

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
local panel = CreateFrame("Frame", "RenownPvPPanel", UIParent)
panel:SetWidth(300)
panel:SetHeight(420)
panel:SetFrameStrata("MEDIUM")
panel:EnableMouse(true)
Backdrop(panel)
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

local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -2, -2)

local header = Label(panel, "GameFontNormalLarge", "Renown PvP")
header:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)

-- Renown summary
local rankText = Label(panel, "GameFontHighlight", "Renown: waiting for the server...")
rankText:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)

local rankBar = CreateFrame("StatusBar", nil, panel)
rankBar:SetWidth(270)
rankBar:SetHeight(10)
rankBar:SetPoint("TOPLEFT", rankText, "BOTTOMLEFT", 0, -4)
rankBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
rankBar:SetStatusBarColor(0.80, 0.55, 0.10)
rankBar:SetMinMaxValues(0, 1)
rankBar:SetValue(0)
local rankBarBg = rankBar:CreateTexture(nil, "BACKGROUND")
rankBarBg:SetAllPoints(rankBar)
rankBarBg:SetTexture(0, 0, 0, 0.6)

local pointsText = Label(panel, "GameFontHighlightSmall", "")
pointsText:SetPoint("TOPLEFT", rankBar, "BOTTOMLEFT", 0, -4)

-- Battlegrounds
local bgHeader = Label(panel, "GameFontNormal", "Battlegrounds")
bgHeader:SetPoint("TOPLEFT", pointsText, "BOTTOMLEFT", 0, -12)
local bracketText = Label(panel, "GameFontDisableSmall", "")
bracketText:SetPoint("LEFT", bgHeader, "RIGHT", 8, 0)

local bgRows = {}
for i = 1, table.getn(BATTLEGROUNDS) do
    local def = BATTLEGROUNDS[i]
    local row = {}
    row.name = Label(panel, "GameFontHighlightSmall", def.name)
    row.name:SetPoint("TOPLEFT", bgHeader, "BOTTOMLEFT", 4, -8 - (i - 1) * 24)
    row.status = Label(panel, "GameFontDisableSmall", "")
    row.status:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -1)
    row.button = Button(panel, "RenownPvPQueue" .. i, "Queue", 64, function() Command(".renown queue " .. this.key) end,
        "Queue for " .. def.name .. " from anywhere (levels " .. def.levels .. ")")
    row.button.key = def.key
    row.button:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -14, -118 - (i - 1) * 24)
    bgRows[i] = row
end

-- Barrens Front
local frontHeader = Label(panel, "GameFontNormal", "Barrens Front")
frontHeader:SetPoint("TOPLEFT", bgHeader, "BOTTOMLEFT", 0, -84)
local frontSub = Label(panel, "GameFontDisableSmall", "tier 1 RvR, levels 1-19")
frontSub:SetPoint("LEFT", frontHeader, "RIGHT", 8, 0)

local frontRows = {}
for i = 1, 3 do
    local row = {}
    row.swatch = panel:CreateTexture(nil, "ARTWORK")
    row.swatch:SetWidth(10)
    row.swatch:SetHeight(10)
    row.swatch:SetPoint("TOPLEFT", frontHeader, "BOTTOMLEFT", 4, -8 - (i - 1) * 16)
    row.swatch:SetTexture(0.6, 0.6, 0.6)
    row.label = Label(panel, "GameFontHighlightSmall", OBJECTIVES[i])
    row.label:SetPoint("LEFT", row.swatch, "RIGHT", 6, 0)
    row.progress = CreateFrame("StatusBar", nil, panel)
    row.progress:SetWidth(80)
    row.progress:SetHeight(8)
    row.progress:SetPoint("LEFT", row.swatch, "LEFT", 186, 0)
    row.progress:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    row.progress:SetMinMaxValues(0, 100)
    row.progress:Hide()
    frontRows[i] = row
end

local frontStatus = Label(panel, "GameFontHighlightSmall", "Hold both towers to take the Oasis")
frontStatus:SetPoint("TOPLEFT", frontHeader, "BOTTOMLEFT", 4, -60)
frontStatus:SetWidth(270)

local frontJoin = Button(panel, "RenownPvPFrontJoin", "Go to the Front", 126, function() Command(".renown rvr join") end,
    "Travel to the Crossroads (Horde) or Northwatch Hold (Alliance). Levels 1-19; you are bolstered to 19 on the front.")
frontJoin:SetPoint("TOPLEFT", frontStatus, "BOTTOMLEFT", -4, -8)
local frontLeave = Button(panel, "RenownPvPFrontLeave", "Leave", 70, function() Command(".renown rvr leave") end,
    "Return to where you were before going to the front.")
frontLeave:SetPoint("LEFT", frontJoin, "RIGHT", 6, 0)
local frontInfo = Button(panel, "RenownPvPFrontInfo", "Status", 64, function() Command(".renown rvr status") end,
    "Print the current state of the front in chat.")
frontInfo:SetPoint("LEFT", frontLeave, "RIGHT", 6, 0)
local frontWarband = Button(panel, "RenownPvPWarband", "Warband", 90, function() Command(".renown warband") end,
    "Call up to four front soldiers of your side into your party. They follow and fight with you while you are on the front.")
frontWarband:SetPoint("TOPLEFT", frontJoin, "BOTTOMLEFT", 0, -4)
local frontDismiss = Button(panel, "RenownPvPWarbandDismiss", "Dismiss", 70, function() Command(".renown warband dismiss") end,
    "Send your warband back to the front lines.")
frontDismiss:SetPoint("LEFT", frontWarband, "RIGHT", 6, 0)
local frontSession = Button(panel, "RenownPvPSession", "My session", 100, function() Command(".renown session") end,
    "Kills, captures, Renown and levels earned since you arrived on the front.")
frontSession:SetPoint("LEFT", frontDismiss, "RIGHT", 6, 0)

-- Field mount
local mountHeader = Label(panel, "GameFontNormal", "Field mount")
mountHeader:SetPoint("TOPLEFT", frontWarband, "BOTTOMLEFT", 4, -14)
local mountText = Label(panel, "GameFontDisableSmall", "Your racial mount at +30% speed, levels 1-39")
mountText:SetPoint("TOPLEFT", mountHeader, "BOTTOMLEFT", 0, -3)
local mountButton = Button(panel, "RenownPvPMount", "Mount", 70, function() RenownPvP_Mount() end,
    "Summon or dismiss your field mount. You can also bind a key (Key Bindings > Renown) or type /fm.")
mountButton:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -14, -368)

local function RefreshRenown()
    local s = RenownBar_State
    if not s then return end
    if s.maxed then
        rankText:SetText("Rank " .. s.rank .. " - " .. s.title .. "  |cff88ff88(max)|r")
        rankBar:SetMinMaxValues(0, 1)
        rankBar:SetValue(1)
    else
        rankText:SetText("Rank " .. s.rank .. " - " .. s.title)
        rankBar:SetMinMaxValues(0, math.max(s.needed or 1, 1))
        rankBar:SetValue(s.current or 0)
    end
    local line = ""
    if not s.maxed and s.needed then
        line = (s.current or 0) .. " / " .. s.needed .. " to rank " .. (s.nextRank or (s.rank + 1)) .. "    "
    end
    if s.spendable then
        line = line .. "|cffffd100" .. s.spendable .. " Renown to spend|r"
    end
    pointsText:SetText(line)
end

local function FormatWait(ms)
    if not ms or ms <= 0 then return "" end
    local secs = math.floor(ms / 1000)
    return string.format(" %d:%02d", math.floor(secs / 60), math.mod(secs, 60))
end

local function RefreshQueues()
    bracketText:SetText("your bracket: " .. MyBracket())
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
                    text = "|cffffd100Queued" .. FormatWait(waited) .. "|r"
                elseif status == "confirm" then
                    queued = true
                    text = "|cff00ff00Ready! Enter from the popup|r"
                elseif status == "active" then
                    active = true
                    text = "|cff00ff00In battle|r"
                end
            end
        end
        if text == "" then
            if level < def.minLevel then
                text = "Level " .. def.minLevel .. "+"
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
        row.label:SetText(OBJECTIVES[i] .. "  |cffaaaaaa" .. (TEAM_NAME[owner] or "?") .. "|r" .. (fortified and "  |cffffd100fortified|r" or ""))
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
        frontStatus:SetText(TEAM_NAME[front.lock] .. " victory! The front reopens in " .. math.ceil(front.lockSecs / 60) .. " min.")
    elseif front.siege > 0 then
        frontStatus:SetText("|cffff8000Siege!|r The " .. TEAM_NAME[front.siege] .. " is assaulting the enemy commander.")
    elseif front.underdog and front.underdog > 0 then
        frontStatus:SetText("|cffffd100The " .. TEAM_NAME[front.underdog] .. " rallies:|r +25% Renown and faster captures.")
    elseif front.inLake then
        frontStatus:SetText("|cff00ff00You are on the front.|r Hold both towers to take the Oasis.")
    else
        frontStatus:SetText("Hold both towers to take the Oasis.")
    end
    local level = UnitLevel("player") or 1
    if level > 19 then frontJoin:Disable() else frontJoin:Enable() end
    if front.inLake and level <= 19 then frontWarband:Enable() else frontWarband:Disable() end
end

local function RefreshMount()
    local level = UnitLevel("player") or 1
    if level > 39 then
        mountButton:Disable()
        mountText:SetText("Levels 1-39 only. Visit a mount vendor at 40!")
    else
        mountButton:Enable()
        mountText:SetText("Your racial mount at +30% speed, levels 1-39")
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
        panel:Show()
        RenownPvP_Refresh()
    end
end

function RenownPvP_Mount()
    Command(".renown mount")
end

function RenownPvP_Front()
    Command(".renown rvr join")
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

-- ---------------------------------------------------------------- compact front tracker (while on the front)
local tracker = CreateFrame("Frame", "RenownFrontTracker", UIParent)
tracker:SetWidth(190)
tracker:SetHeight(70)
Backdrop(tracker)
tracker:Hide()
local trackerTitle = Label(tracker, "GameFontNormalSmall", "Barrens Front")
trackerTitle:SetPoint("TOPLEFT", tracker, "TOPLEFT", 8, -7)
local trackerRows = {}
for i = 1, 3 do
    local row = {}
    row.swatch = tracker:CreateTexture(nil, "ARTWORK")
    row.swatch:SetWidth(9)
    row.swatch:SetHeight(9)
    row.swatch:SetPoint("TOPLEFT", tracker, "TOPLEFT", 9, -9 - i * 13)
    row.label = Label(tracker, "GameFontHighlightSmall", OBJECTIVES[i])
    row.label:SetPoint("LEFT", row.swatch, "RIGHT", 5, 0)
    row.pct = Label(tracker, "GameFontHighlightSmall", "")
    row.pct:SetPoint("RIGHT", tracker, "RIGHT", -8, 0)
    row.pct:SetPoint("TOP", row.swatch, "TOP", 0, 1)
    trackerRows[i] = row
end

local function PlaceTracker()
    tracker:ClearAllPoints()
    local x = launcher:GetCenter()
    if x and x > GetScreenWidth() / 2 then
        tracker:SetPoint("TOPRIGHT", launcher, "BOTTOMRIGHT", 0, -4)
    else
        tracker:SetPoint("TOPLEFT", launcher, "BOTTOMLEFT", 0, -4)
    end
end

local function RefreshTracker()
    for i = 1, 3 do
        local c = TEAM_COLOR[front.owners[i]] or TEAM_COLOR[0]
        trackerRows[i].swatch:SetTexture(c[1], c[2], c[3])
        if front.cap[i] > 0 and front.pct[i] > 0 then
            trackerRows[i].pct:SetText((front.cap[i] == 1 and "|cff3399ff" or "|cffff3333") .. front.pct[i] .. "%|r")
        else
            trackerRows[i].pct:SetText("")
        end
    end
    if front.siege > 0 then
        trackerTitle:SetText("Barrens Front  |cffff8000SIEGE|r")
    elseif front.lock > 0 then
        trackerTitle:SetText("Barrens Front  |cff88ff88" .. TEAM_NAME[front.lock] .. " won|r")
    else
        trackerTitle:SetText("Barrens Front")
    end
    if front.inLake and not panel:IsVisible() then
        PlaceTracker()
        tracker:Show()
    else
        tracker:Hide()
    end
end

panel:SetScript("OnShow", function() tracker:Hide() end)
panel:SetScript("OnHide", function() RefreshTracker() end)

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
-- "owner,capTeam,pct;owner,capTeam,pct;owner,capTeam,pct/siege/lock/lockSeconds/inLake[/underdog/fortifiedMask]"
local function ParseFront(msg)
    local _, _, objs, siege, lock, lockSecs, member, rest = string.find(msg or "", "^(.-)/(%d)/(%d)/(%d+)/(%d)(.*)$")
    if not objs then return end
    local _, _, underdog, fort = string.find(rest or "", "^/(%d)/(%d+)")
    front.underdog, front.fort = tonumber(underdog or 0), tonumber(fort or 0)
    local i = 0
    for owner, cap, pct in string.gfind(objs, "(%d),(%d),(%d+)") do
        i = i + 1
        if i <= 3 then
            front.owners[i], front.cap[i], front.pct[i] = tonumber(owner), tonumber(cap), tonumber(pct)
        end
    end
    front.siege, front.lock, front.lockSecs = tonumber(siege), tonumber(lock), tonumber(lockSecs)
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
