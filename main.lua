-- AXK Script
print("[AXK] Loading...")

local LP = game.Players.LocalPlayer
local RS = game:GetService("RunService")

local sg = Instance.new("ScreenGui")
sg.Name = "AXK"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

pcall(function()
    sg.Parent = game:GetService("CoreGui")
end)
if not sg.Parent then
    sg.Parent = LP:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 200)
Main.Position = UDim2.new(0, 15, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = sg

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 12)
mc.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(88, 166, 255)
Title.Text = "AXK Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Main

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 12)
tc.Parent = Title

local function getH()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local SpeedOn = false
local GodMode = true

local function btn(text, y, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = Main
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = b
    b.MouseButton1Click:Connect(cb)
    return b
end

btn("⚡ Speed: OFF", 50, function(b)
    SpeedOn = not SpeedOn
    b.Text = SpeedOn and "⚡ Speed: ON" or "⚡ Speed: OFF"
    b.BackgroundColor3 = SpeedOn and Color3.fromRGB(35, 134, 54) or Color3.fromRGB(40, 40, 55)
end)

btn("🛡️ God Mode: ON", 90, function(b)
    GodMode = not GodMode
    b.Text = GodMode and "🛡️ God Mode: ON" or "🛡️ God Mode: OFF"
    b.BackgroundColor3 = GodMode and Color3.fromRGB(35, 134, 54) or Color3.fromRGB(40, 40, 55)
end).BackgroundColor3 = Color3.fromRGB(35, 134, 54)

btn("❌ إغلاق", 130, function()
    sg:Destroy()
end)

RS.Heartbeat:Connect(function()
    local h = getH()
    if not h then return end
    if SpeedOn then h.WalkSpeed = 100 end
    if GodMode then
        h.MaxHealth = math.huge
        h.Health = math.huge
    end
end)

print("[AXK] Loaded ✓")
