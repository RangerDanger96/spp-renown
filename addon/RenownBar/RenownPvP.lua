-- RenownPvP: queue battlegrounds from anywhere and travel to the Barrens Front (tier 1 RvR lake).
-- Part of the RenownBar addon for the spp-renown server module (WoW 1.12 / Lua 5.0).

RenownPvPDB = RenownPvPDB or {}

local OBJECTIVES = { "Kolkar Watch", "Stagnant Oasis", "Raptor Grounds" }
local TEAM_COLOR = {
    [0] = { 0.6, 0.6, 0.6 },   -- neutral
    [1] = { 0.2, 0.6, 1.0 },   -- Alliance
    [2] = { 1.0, 0.2, 0.2 },   -- Horde
}
local TEAM_NAME = { [0] = "Neutral", [1] = "Alliance", [2] = "Horde" }

local function Command(text)
    SendChatMessage(text, "SAY")
end

-- ---------------------------------------------------------------- button bar
local bar = CreateFrame("Frame", "RenownPvPFrame", UIParent)
bar:SetWidth(262)
bar:SetHeight(30)
bar:SetMovable(true)
bar:EnableMouse(true)
if bar.SetClampedToScreen then bar:SetClampedToScreen(true) end
bar:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
})
bar:SetBackdropColor(0, 0, 0, 0.7)
bar:SetBackdropBorderColor(0.85, 0.65, 0.20, 0.9)

local function SavePosition()
    local point, _, relPoint, x, y = bar:GetPoint()
    RenownPvPDB.point, RenownPvPDB.relPoint, RenownPvPDB.x, RenownPvPDB.y = point, relPoint, x, y
end

local function RestorePosition()
    bar:ClearAllPoints()
    if RenownPvPDB.point then
        bar:SetPoint(RenownPvPDB.point, UIParent, RenownPvPDB.relPoint, RenownPvPDB.x, RenownPvPDB.y)
    else
        bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -190, -10)
    end
end

bar:SetScript("OnMouseDown", function()
    if IsShiftKeyDown() then this:StartMoving() end
end)
bar:SetScript("OnMouseUp", function()
    this:StopMovingOrSizing()
    SavePosition()
end)

local buttons = {
    { "WSG",   ".renown queue wsg",  "Queue for Warsong Gulch" },
    { "AB",    ".renown queue ab",   "Queue for Arathi Basin" },
    { "AV",    ".renown queue av",   "Queue for Alterac Valley" },
    { "Front", ".renown rvr join",   "Travel to the Barrens Front (tier 1 RvR lake, levels 1-19)" },
    { "Leave", ".renown rvr leave",  "Leave the Barrens Front and return to where you were" },
}

local x = 6
for i = 1, table.getn(buttons) do
    local def = buttons[i]
    local button = CreateFrame("Button", "RenownPvPButton" .. i, bar, "UIPanelButtonTemplate")
    local width = (def[1] == "Front" or def[1] == "Leave") and 54 or 44
    button:SetWidth(width)
    button:SetHeight(20)
    button:SetPoint("LEFT", bar, "LEFT", x, 0)
    button:SetText(def[1])
    button.command = def[2]
    button.tip = def[3]
    button:SetScript("OnClick", function() Command(this.command) end)
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_BOTTOM")
        GameTooltip:AddLine(this.tip, 1, 1, 1)
        GameTooltip:AddLine("Shift-drag the bar to move it. /rpvp for options.", 0.6, 0.6, 0.6)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    x = x + width + 6
end
bar:SetWidth(x)

-- ---------------------------------------------------------------- Barrens Front status
local status = CreateFrame("Frame", "RenownFrontFrame", bar)
status:SetWidth(262)
status:SetHeight(86)
status:SetPoint("TOP", bar, "BOTTOM", 0, -2)
status:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
})
status:SetBackdropColor(0, 0, 0, 0.7)
status:SetBackdropBorderColor(0.85, 0.65, 0.20, 0.9)
status:Hide()

local title = status:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
title:SetPoint("TOPLEFT", status, "TOPLEFT", 8, -6)
title:SetText("Barrens Front")

local footer = status:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
footer:SetPoint("BOTTOMLEFT", status, "BOTTOMLEFT", 8, 6)
footer:SetText("")

local rows = {}
for i = 1, 3 do
    local row = {}
    row.swatch = status:CreateTexture(nil, "ARTWORK")
    row.swatch:SetWidth(10)
    row.swatch:SetHeight(10)
    row.swatch:SetPoint("TOPLEFT", status, "TOPLEFT", 10, -8 - i * 15)
    row.swatch:SetTexture(0.6, 0.6, 0.6)

    row.label = status:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.label:SetPoint("LEFT", row.swatch, "RIGHT", 6, 0)
    row.label:SetText(OBJECTIVES[i])

    row.progress = CreateFrame("StatusBar", nil, status)
    row.progress:SetWidth(90)
    row.progress:SetHeight(8)
    row.progress:SetPoint("LEFT", row.swatch, "LEFT", 150, 0)
    row.progress:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    row.progress:SetMinMaxValues(0, 100)
    row.progress:SetValue(0)
    row.progress:Hide()
    rows[i] = row
end

local inLake = false
local lastNews = 0

-- ---------------------------------------------------------------- world map banners
-- Barrens map bounds (WorldMapArea.dbc): left/right are world Y, top/bottom are world X
local BARRENS = { left = 2622.917, right = -7510.417, top = 1612.5, bottom = -5143.75 }
local PIN_POS = {
    { x = -849,  y = -2858 },   -- Kolkar Watch
    { x = -1255, y = -3150 },   -- Stagnant Oasis
    { x = -1790, y = -3280 },   -- Raptor Grounds
    { x = -680,  y = -2740 },   -- Crossroads Warlord (siege)
    { x = -1965, y = -3395 },   -- Northwatch Field Commander (siege)
}
local PIN_NAME = { OBJECTIVES[1], OBJECTIVES[2], OBJECTIVES[3], "Crossroads Warlord", "Northwatch Field Commander" }
local frontOwners = { 0, 0, 0 }
local frontSiege = 0
local pins = {}

local function MapPos(i)
    local p = PIN_POS[i]
    return (BARRENS.left - p.y) / (BARRENS.left - BARRENS.right), (BARRENS.top - p.x) / (BARRENS.top - BARRENS.bottom)
end

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
                WorldMapTooltip = WorldMapTooltip or GameTooltip
                local tip = WorldMapTooltip
                tip:SetOwner(this, "ANCHOR_RIGHT")
                tip:AddLine(PIN_NAME[this.index], 1, 0.82, 0)
                if this.index <= 3 then
                    tip:AddLine("Held by: " .. TEAM_NAME[frontOwners[this.index]], 1, 1, 1)
                else
                    tip:AddLine("Siege target - kill him to win the Barrens Front!", 1, 0.5, 0.2)
                end
                tip:AddLine("Barrens Front (tier 1 RvR)", 0.6, 0.6, 0.6)
                tip:Show()
            end)
            pin:SetScript("OnLeave", function() (WorldMapTooltip or GameTooltip):Hide() end)
            pins[i] = pin
        end

        local show = onBarrens and (i <= 3 or (i == 4 and frontSiege == 1) or (i == 5 and frontSiege == 2))
        if show then
            local mx, my = MapPos(i)
            pin:ClearAllPoints()
            pin:SetPoint("CENTER", WorldMapButton, "TOPLEFT", mx * w, -my * h)
            if i <= 3 then
                local owner = frontOwners[i]
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

-- "owner,capTeam,pct;owner,capTeam,pct;owner,capTeam,pct/siege/lock/lockSeconds/inLake"
local function ParseFront(msg)
    local _, _, objs, siege, lock, lockSecs, member = string.find(msg or "", "^(.-)/(%d)/(%d)/(%d+)/(%d)$")
    if not objs then return end
    local i = 0
    for owner, cap, pct in string.gfind(objs, "(%d),(%d),(%d+)") do
        i = i + 1
        local row = rows[i]
        if row then
            owner, cap, pct = tonumber(owner), tonumber(cap), tonumber(pct)
            frontOwners[i] = owner
            local c = TEAM_COLOR[owner] or TEAM_COLOR[0]
            row.swatch:SetTexture(c[1], c[2], c[3])
            row.label:SetText(OBJECTIVES[i] .. "  |cffaaaaaa(" .. (TEAM_NAME[owner] or "?") .. ")|r")
            if cap > 0 and pct > 0 then
                local cc = TEAM_COLOR[cap]
                row.progress:SetStatusBarColor(cc[1], cc[2], cc[3])
                row.progress:SetValue(pct)
                row.progress:Show()
            else
                row.progress:Hide()
            end
        end
    end

    siege, lock, lockSecs, member = tonumber(siege), tonumber(lock), tonumber(lockSecs), tonumber(member)
    if lock > 0 then
        footer:SetText(TEAM_NAME[lock] .. " victory! Front reopens in " .. math.ceil(lockSecs / 60) .. " min")
    elseif siege > 0 then
        footer:SetText("|cffff8000Siege!|r " .. TEAM_NAME[siege] .. " is assaulting the enemy commander")
    else
        footer:SetText("Hold both towers to take the Oasis")
    end

    frontSiege = siege   -- 1: Alliance assaults the Crossroads Warlord (pin 4), 2: Horde assaults the Northwatch commander (pin 5)
    UpdatePins()
    inLake = (member == 1)
    lastNews = GetTime()
    if inLake or RenownPvPDB.alwaysStatus then status:Show() else status:Hide() end
end

-- ---------------------------------------------------------------- events
local events = CreateFrame("Frame")
events:RegisterEvent("VARIABLES_LOADED")
events:RegisterEvent("CHAT_MSG_ADDON")
events:RegisterEvent("WORLD_MAP_UPDATE")
events:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        RestorePosition()
        if RenownPvPDB.hidden then bar:Hide() end
    elseif event == "CHAT_MSG_ADDON" then
        if arg1 == "RENOWNRVR" and arg4 == UnitName("player") then ParseFront(arg2) end
    elseif event == "WORLD_MAP_UPDATE" then
        UpdatePins()
    end
end)

-- ---------------------------------------------------------------- slash commands
SLASH_RENOWNPVP1 = "/rpvp"
SlashCmdList["RENOWNPVP"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "hide" then
        bar:Hide(); RenownPvPDB.hidden = true
    elseif msg == "show" then
        bar:Show(); RenownPvPDB.hidden = nil
    elseif msg == "reset" then
        RenownPvPDB.point = nil; RestorePosition()
    elseif msg == "status" then
        RenownPvPDB.alwaysStatus = not RenownPvPDB.alwaysStatus
        Command(".renown rvr status")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffffd100RenownPvP:|r /rpvp show | hide | reset | status   /front join | leave   /bgq wsg | ab | av")
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
