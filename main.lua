--[[
    █████╗ ██╗  ██╗██╗  ██╗    ██████╗ ██████╗  ██████╗
    ██╔══██╗╚██╗██╔╝██║ ██╔╝    ██╔══██╗██╔══██╗██╔═══██╗
    ███████║ ╚███╔╝ █████╔╝     ██████╔╝██████╔╝██║   ██║
    ██╔══██║ ██╔██╗ ██╔═██╗     ██╔═══╝ ██╔══██╗██║   ██║
    ██║  ██║██╔╝ ██╗██║  ██╗    ██║     ██║  ██║╚██████╔╝
    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝

    AXK Pro v1.0
    Author: Redz
--]]

-- ═══════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ═══════════════════════════════════════════════════
-- CONFIG
-- ═══════════════════════════════════════════════════
local Config = {
    NAME = "AXK Pro",
    VERSION = "1.0",
    KEY = "z_14",
    LOADING_TIME = 3,
    COLORS = {
        PRIMARY = Color3.fromRGB(88, 166, 255),
        SUCCESS = Color3.fromRGB(35, 134, 54),
        DANGER = Color3.fromRGB(218, 54, 51),
        WARNING = Color3.fromRGB(210, 153, 34),
        BG = Color3.fromRGB(15, 15, 25),
        BG2 = Color3.fromRGB(20, 20, 30),
        BG3 = Color3.fromRGB(13, 17, 23),
        TEXT = Color3.fromRGB(230, 237, 243),
        MUTED = Color3.fromRGB(139, 148, 158),
    },
}

-- ═══════════════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════════════
local State = {
    Logged = false,
    Speed = false,
    SpeedValue = 100,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    GodMode = true,
    InfiniteJump = true,
    AntiAFK = true,
    KillAura = false,
    ESP = false,
    AutoEat = false,
}

local FlyBV, FlyBG
local ESPObjects = {}

-- ═══════════════════════════════════════════════════
-- HELPERS
-- ═══════════════════════════════════════════════════
local function getH()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHRPOf(plr)
    local c = plr.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function Notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or Config.NAME,
            Text = text or "",
            Duration = dur or 3,
        })
    end)
end

-- ═══════════════════════════════════════════════════
-- UI SETUP
-- ═══════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AXK_Pro"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════
-- LOADING SCREEN
-- ═══════════════════════════════════════════════════
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingFrame.BackgroundTransparency = 0.3
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 999
LoadingFrame.Parent = ScreenGui

local LoadingLogo = Instance.new("TextLabel")
LoadingLogo.Size = UDim2.new(1, 0, 0, 60)
LoadingLogo.Position = UDim2.new(0, 0, 0.4, -30)
LoadingLogo.BackgroundTransparency = 1
LoadingLogo.Text = "AXK PRO"
LoadingLogo.TextColor3 = Config.COLORS.PRIMARY
LoadingLogo.Font = Enum.Font.GothamBlack
LoadingLogo.TextSize = 48
LoadingLogo.ZIndex = 1000
LoadingLogo.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 30)
LoadingSub.Position = UDim2.new(0, 0, 0.5, 20)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "جاري التحميل..."
LoadingSub.TextColor3 = Config.COLORS.MUTED
LoadingSub.Font = Enum.Font.Gotham
LoadingSub.TextSize = 16
LoadingSub.ZIndex = 1000
LoadingSub.Parent = LoadingFrame

local LoadingBarBg = Instance.new("Frame")
LoadingBarBg.Size = UDim2.new(0.4, 0, 0, 6)
LoadingBarBg.Position = UDim2.new(0.3, 0, 0.6, 0)
LoadingBarBg.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
LoadingBarBg.BorderSizePixel = 0
LoadingBarBg.ZIndex = 1000
LoadingBarBg.Parent = LoadingFrame

local LoadingBarBgC = Instance.new("UICorner")
LoadingBarBgC.CornerRadius = UDim.new(1, 0)
LoadingBarBgC.Parent = LoadingBarBg

local LoadingBarFill = Instance.new("Frame")
LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadingBarFill.BackgroundColor3 = Config.COLORS.PRIMARY
LoadingBarFill.BorderSizePixel = 0
LoadingBarFill.ZIndex = 1001
LoadingBarFill.Parent = LoadingBarBg

local LoadingBarFillC = Instance.new("UICorner")
LoadingBarFillC.CornerRadius = UDim.new(1, 0)
LoadingBarFillC.Parent = LoadingBarFill

-- ═══════════════════════════════════════════════════
-- LOGIN SCREEN
-- ═══════════════════════════════════════════════════
local LoginFrame = Instance.new("Frame")
LoginFrame.Size = UDim2.new(0, 300, 0, 240)
LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -120)
LoginFrame.BackgroundColor3 = Config.COLORS.BG
LoginFrame.BorderSizePixel = 0
LoginFrame.Visible = false
LoginFrame.ZIndex = 1000
LoginFrame.Parent = ScreenGui

local LoginC = Instance.new("UICorner")
LoginC.CornerRadius = UDim.new(0, 16)
LoginC.Parent = LoginFrame

local LoginS = Instance.new("UIStroke")
LoginS.Color = Config.COLORS.PRIMARY
LoginS.Thickness = 2
LoginS.Parent = LoginFrame

local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, 0, 0, 50)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "AXK PRO"
LoginTitle.TextColor3 = Config.COLORS.PRIMARY
LoginTitle.Font = Enum.Font.GothamBlack
LoginTitle.TextSize = 26
LoginTitle.ZIndex = 1001
LoginTitle.Parent = LoginFrame

local LoginHint = Instance.new("TextLabel")
LoginHint.Size = UDim2.new(1, 0, 0, 20)
LoginHint.Position = UDim2.new(0, 0, 0, 55)
LoginHint.BackgroundTransparency = 1
LoginHint.Text = "ادخل الكود للدخول"
LoginHint.TextColor3 = Config.COLORS.MUTED
LoginHint.Font = Enum.Font.Gotham
LoginHint.TextSize = 13
LoginHint.ZIndex = 1001
LoginHint.Parent = LoginFrame

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(0.8, 0, 0, 40)
CodeBox.Position = UDim2.new(0.1, 0, 0, 90)
CodeBox.BackgroundColor3 = Config.COLORS.BG3
CodeBox.TextColor3 = Config.COLORS.TEXT
CodeBox.PlaceholderText = "اكتب الكود..."
CodeBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
CodeBox.Font = Enum.Font.Gotham
CodeBox.TextSize = 14
CodeBox.Text = ""
CodeBox.ClearTextOnFocus = false
CodeBox.ZIndex = 1001
CodeBox.Parent = LoginFrame

local CodeC = Instance.new("UICorner")
CodeC.CornerRadius = UDim.new(0, 8)
CodeC.Parent = CodeBox

local LoginBtn = Instance.new("TextButton")
LoginBtn.Size = UDim2.new(0.8, 0, 0, 40)
LoginBtn.Position = UDim2.new(0.1, 0, 0, 150)
LoginBtn.BackgroundColor3 = Config.COLORS.SUCCESS
LoginBtn.Text = "دخول"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.TextSize = 14
LoginBtn.ZIndex = 1001
LoginBtn.Parent = LoginFrame

local LoginBtnC = Instance.new("UICorner")
LoginBtnC.CornerRadius = UDim.new(0, 8)
LoginBtnC.Parent = LoginBtn

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, 0, 0, 20)
StatusLbl.Position = UDim2.new(0, 0, 0, 200)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = ""
StatusLbl.TextColor3 = Config.COLORS.MUTED
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = 12
StatusLbl.ZIndex = 1001
StatusLbl.Parent = LoginFrame

-- ═══════════════════════════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════════════════════════
local MainWindow = Instance.new("Frame")
MainWindow.Size = UDim2.new(0, 550, 0, 400)
MainWindow.Position = UDim2.new(0.5, -275, 0.5, -200)
MainWindow.BackgroundColor3 = Config.COLORS.BG
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.Draggable = true
MainWindow.Visible = false
MainWindow.Parent = ScreenGui

local MWC = Instance.new("UICorner")
MWC.CornerRadius = UDim.new(0, 14)
MWC.Parent = MainWindow

local MWS = Instance.new("UIStroke")
MWS.Color = Config.COLORS.PRIMARY
MWS.Thickness = 1
MWS.Parent = MainWindow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Config.COLORS.PRIMARY
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local TitleBarC = Instance.new("UICorner")
TitleBarC.CornerRadius = UDim.new(0, 14)
TitleBarC.Parent = TitleBar

local TitleBarCover = Instance.new("Frame")
TitleBarCover.Size = UDim2.new(1, 0, 0.5, 0)
TitleBarCover.Position = UDim2.new(0, 0, 0.5, 0)
TitleBarCover.BackgroundColor3 = Config.COLORS.PRIMARY
TitleBarCover.BorderSizePixel = 0
TitleBarCover.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ AXK PRO v" .. Config.VERSION
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Config.COLORS.DANGER
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

local CloseC = Instance.new("UICorner")
CloseC.CornerRadius = UDim.new(0, 6)
CloseC.Parent = CloseBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Config.COLORS.WARNING
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.Parent = TitleBar

local MinC = Instance.new("UICorner")
MinC.CornerRadius = UDim.new(0, 6)
MinC.Parent = MinBtn

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Config.COLORS.BG3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainWindow

local SidebarC = Instance.new("UICorner")
SidebarC.CornerRadius = UDim.new(0, 14)
SidebarC.Parent = Sidebar

local SidebarCover = Instance.new("Frame")
SidebarCover.Size = UDim2.new(0.5, 0, 1, 0)
SidebarCover.Position = UDim2.new(0.5, 0, 0, 0)
SidebarCover.BackgroundColor3 = Config.COLORS.BG3
SidebarCover.BorderSizePixel = 0
SidebarCover.Parent = Sidebar

-- Content
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -130, 1, -40)
ContentArea.Position = UDim2.new(0, 130, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainWindow

-- Tabs
local TabsData = {
    {id = "home", name = "🏠 الرئيسية"},
    {id = "move", name = "⚡ الحركة"},
    {id = "combat", name = "⚔️ القتال"},
    {id = "esp", name = "📡 ESP"},
    {id = "misc", name = "⚙️ عام"},
}

local TabButtons = {}
local TabContents = {}
local CurrentTab = "home"

for i, tab in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 36)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = "  " .. tab.name
    btn.TextColor3 = Config.COLORS.TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    TabButtons[tab.id] = btn

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -10)
    content.Position = UDim2.new(0, 5, 0, 5)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Config.COLORS.PRIMARY
    content.CanvasSize = UDim2.new(0, 0, 0, 600)
    content.Visible = (tab.id == "home")
    content.Parent = ContentArea

    TabContents[tab.id] = content

    btn.MouseButton1Click:Connect(function()
        CurrentTab = tab.id
        for id, cont in pairs(TabContents) do
            cont.Visible = (id == CurrentTab)
        end
        for id, button in pairs(TabButtons) do
            button.BackgroundColor3 = (id == CurrentTab) and Config.COLORS.PRIMARY or Color3.fromRGB(30, 30, 45)
        end
    end)
end

TabButtons["home"].BackgroundColor3 = Config.COLORS.PRIMARY

-- ═══════════════════════════════════════════════════
-- UI COMPONENTS
-- ═══════════════════════════════════════════════════
local function createToggle(tabId, text, y, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0, 35)
    container.Position = UDim2.new(0.025, 0, 0, y)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.Parent = TabContents[tabId]

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.03, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.COLORS.TEXT
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 24)
    toggle.Position = UDim2.new(1, -60, 0, 5)
    toggle.BackgroundColor3 = default and Config.COLORS.SUCCESS or Color3.fromRGB(48, 54, 61)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 10
    toggle.Parent = container

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 12)
    tc.Parent = toggle

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and Config.COLORS.SUCCESS or Color3.fromRGB(48, 54, 61)
        if callback then pcall(callback, state) end
    end)

    return container
end

local function createButton(tabId, text, y, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.Position = UDim2.new(0.025, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 45)
    btn.Text = text
    btn.TextColor3 = Config.COLORS.TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = TabContents[tabId]

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return btn
end

local function createSlider(tabId, text, y, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0, 50)
    container.Position = UDim2.new(0.025, 0, 0, y)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.Parent = TabContents[tabId]

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Config.COLORS.TEXT
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.9, 0, 0, 8)
    bar.Position = UDim2.new(0.05, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    bar.BorderSizePixel = 0
    bar.Parent = container

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.COLORS.PRIMARY
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default - min) / (max - min), -8, 0, -4)
    knob.BackgroundColor3 = Config.COLORS.PRIMARY
    knob.Text = ""
    knob.Parent = bar

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local dragging = false

    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -8, 0, -4)
        label.Text = text .. ": " .. value
        if callback then pcall(callback, value) end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function createHeader(tabId, text, y)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.95, 0, 0, 22)
    label.Position = UDim2.new(0.025, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.COLORS.PRIMARY
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = TabContents[tabId]
end

-- ═══════════════════════════════════════════════════
-- FEATURES — MOVEMENT
-- ═══════════════════════════════════════════════════
createHeader("move", "⚡ السرعة", 5)
createToggle("move", "تفعيل السرعة", 30, false, function(v)
    State.Speed = v
    if not v then
        local h = getH()
        if h then h.WalkSpeed = 16 end
    end
end)
createSlider("move", "قيمة السرعة", 70, 16, 500, 100, function(v)
    State.SpeedValue = v
end)

createHeader("move", "✈️ الطيران", 130)

local function startFly()
    local hrp = getHRP()
    if not hrp then return end
    if FlyBV then FlyBV:Destroy() end
    if FlyBG then FlyBG:Destroy() end
    FlyBV = Instance.new("BodyVelocity")
    FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBV.Velocity = Vector3.zero
    FlyBV.Parent = hrp
    FlyBG = Instance.new("BodyGyro")
    FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBG.P = 1000
    FlyBG.D = 50
    FlyBG.Parent = hrp
end

local function stopFly()
    if FlyBV then FlyBV:Destroy(); FlyBV = nil end
    if FlyBG then FlyBG:Destroy(); FlyBG = nil end
end

createToggle("move", "تفعيل الطيران", 155, false, function(v)
    State.Fly = v
    if v then startFly() else stopFly() end
end)

createSlider("move", "سرعة الطيران", 195, 10, 500, 50, function(v)
    State.FlySpeed = v
end)

createHeader("move", "🌀 Noclip", 255)
createToggle("move", "اختراق الجدران", 280, false
