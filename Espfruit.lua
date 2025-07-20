local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local targetVariants = { "Tranquil", "Gold" }

-- Create toggle state
local running = false

-- GUI Setup
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "TranquilGoldCollectorUI"
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 50)
toggleButton.Position = UDim2.new(1, -160, 0, 20) -- ⬅️ Top-right corner
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Text = "ESP: OFF"
toggleButton.Parent = screenGui

-- ESP Creation
local function makeESP(part, color)
    local esp = Instance.new("BoxHandleAdornment")
    esp.Name = "ESP"
    esp.Adornee = part
    esp.AlwaysOnTop = true
    esp.ZIndex = 10
    esp.Size = part.Size
    esp.Color3 = color
    esp.Transparency = 0.5
    esp.Parent = part
end

-- Collect via touch
local function collect(part)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        firetouchinterest(hrp, part, 0)
        task.wait(0.1)
        firetouchinterest(hrp, part, 1)
    end
end

-- Main scan function
local function scanAndCollect()
    for _, mango in pairs(workspace:GetChildren()) do
        if mango.Name == "Mango" and mango:IsA("Model") then
            local variant = mango:FindFirstChild("Variant")
            if variant and table.find(targetVariants, variant.Value) then
                local part = mango:FindFirstChildWhichIsA("BasePart")
                if part and not part:FindFirstChild("ESP") then
                    makeESP(part, Color3.fromRGB(255, 255, 0)) -- Yellow ESP for both
                    collect(part)
                end
            end
        end
    end
end

-- Toggle Button Action
toggleButton.MouseButton1Click:Connect(function()
    running = not running
    toggleButton.Text = running and "ESP: ON" or "ESP: OFF"
    toggleButton.BackgroundColor3 = running and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 255)
end)

-- Main loop
task.spawn(function()
    while true do
        if running then
            scanAndCollect()
        end
        task.wait(1)
    end
end)
