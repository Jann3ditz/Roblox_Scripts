--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

--========================================================--
-- GUI
--========================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "JANN_GUI"

-- Logo Button
local LogoButton = Instance.new("TextButton")
LogoButton.Text = "JANN"
LogoButton.Size = UDim2.new(0, 100, 0, 40)
LogoButton.Position = UDim2.new(0.5, -50, 0.5, -20) -- ✅ Center on screen
LogoButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
LogoButton.TextColor3 = Color3.new(1,1,1)
LogoButton.Font = Enum.Font.SourceSansBold
LogoButton.TextSize = 22
LogoButton.Parent = ScreenGui
LogoButton.Active = true
LogoButton.Draggable = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 5, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "JANN Menu"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(150,150,0)
MinimizeButton.TextColor3 = Color3.new(1,1,1)
MinimizeButton.Parent = TitleBar

-- Content
local AutoTPButton = Instance.new("TextButton")
AutoTPButton.Size = UDim2.new(0.9, 0, 0, 30)
AutoTPButton.Position = UDim2.new(0.05, 0, 0, 50)
AutoTPButton.Text = "Lock TP"
AutoTPButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
AutoTPButton.TextColor3 = Color3.new(1,1,1)
AutoTPButton.Parent = MainFrame

-- Hitbox Input
local HitboxBox = Instance.new("TextBox")
HitboxBox.Size = UDim2.new(0.6, 0, 0, 30)
HitboxBox.Position = UDim2.new(0.05, 0, 0, 90)
HitboxBox.PlaceholderText = "Hitbox Size"
HitboxBox.Text = ""
HitboxBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
HitboxBox.TextColor3 = Color3.new(1,1,1)
HitboxBox.Parent = MainFrame

local ApplyHitbox = Instance.new("TextButton")
ApplyHitbox.Size = UDim2.new(0.25, 0, 0, 30)
ApplyHitbox.Position = UDim2.new(0.7, 0, 0, 90)
ApplyHitbox.Text = "Apply"
ApplyHitbox.BackgroundColor3 = Color3.fromRGB(0,120,0)
ApplyHitbox.TextColor3 = Color3.new(1,1,1)
ApplyHitbox.Parent = MainFrame

--========================================================--
-- Auto TP SCRIPT (your original one here, unchanged)
--========================================================--
-- Example (replace this with your working auto tp functions)
local AutoTPEnabled = false
AutoTPButton.MouseButton1Click:Connect(function()
    AutoTPEnabled = not AutoTPEnabled
    if AutoTPEnabled then
        AutoTPButton.Text = "Lock TP: ON"
        -- your TP code start
    else
        AutoTPButton.Text = "Lock TP: OFF"
        -- your TP code stop
    end
end)

--========================================================--
-- HITBOX SCRIPT (only affects other players)
--========================================================--
local chosenSize = 2
local function resizeHitboxes(size)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then -- ✅ exclude yourself
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(size, size, size)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                end
            end
        end
    end
end

ApplyHitbox.MouseButton1Click:Connect(function()
    local size = tonumber(HitboxBox.Text)
    if size then
        chosenSize = size
    end
end)

task.spawn(function()
    while task.wait(1) do
        resizeHitboxes(chosenSize)
    end
end)

--========================================================--
-- GUI TOGGLE
--========================================================--
LogoButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

MinimizeButton.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset > 30 then
        MainFrame.Size = UDim2.new(0, 300, 0, 30)
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 200)
    end
end)
