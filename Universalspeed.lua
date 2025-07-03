local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local DEFAULT_SPEED = 16
local currentSpeed = DEFAULT_SPEED
local speedOn = false

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SpeedAdjuster"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 150)
main.Position = UDim2.new(0, 100, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Speed Adjuster"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.Size = UDim2.new(0, 200, 0, 30)
toggleBtn.Text = "Speed: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18

local speedBox = Instance.new("TextBox", main)
speedBox.Position = UDim2.new(0, 10, 0, 80)
speedBox.Size = UDim2.new(0, 200, 0, 30)
speedBox.Text = tostring(DEFAULT_SPEED)
speedBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 18
speedBox.ClearTextOnFocus = false

-- Speed Loop
local function startSpeedLoop()
    while speedOn do
        local char = lp.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = currentSpeed
        end
        wait(0.5)
    end
end

-- Toggle button
toggleBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if speedOn then
        toggleBtn.Text = "Speed: ON"
        startSpeedLoop()
    else
        toggleBtn.Text = "Speed: OFF"
        local char = lp.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = DEFAULT_SPEED
        end
    end
end)

-- Update speed when user types a value
speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and val > 0 and val <= 99999 then
        currentSpeed = val
    else
        speedBox.Text = tostring(currentSpeed)
    end
end)

-- Respawn handler
lp.CharacterAdded:Connect(function(char)
    repeat wait() until char:FindFirstChild("Humanoid")
    if speedOn then
        wait(3)
        startSpeedLoop()
    end
end)

-- Apply default if already loaded
if lp.Character and lp.Character:FindFirstChild("Humanoid") then
    lp.Character.Humanoid.WalkSpeed = DEFAULT_SPEED
end
