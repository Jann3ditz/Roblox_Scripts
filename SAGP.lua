local player = game.Players.LocalPlayer
local players = game:GetService("Players")

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Logo
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 100, 0, 40)
logo.Position = UDim2.new(0.5, -50, 0.5, -20) -- center of screen
logo.Text = "JANN"
logo.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
logo.TextColor3 = Color3.fromRGB(0, 0, 0)
logo.Font = Enum.Font.SourceSansBold
logo.TextSize = 22
logo.Parent = gui
logo.Active = true
logo.Draggable = true

-- Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = gui

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = frame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.Parent = frame

-- LockTP button
local lockTPBtn = Instance.new("TextButton")
lockTPBtn.Size = UDim2.new(0, 200, 0, 40)
lockTPBtn.Position = UDim2.new(0, 25, 0, 50)
lockTPBtn.Text = "LockTP: OFF"
lockTPBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
lockTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockTPBtn.Font = Enum.Font.SourceSansBold
lockTPBtn.TextSize = 18
lockTPBtn.Parent = frame

-- Hitbox input
local hitboxInput = Instance.new("TextBox")
hitboxInput.Size = UDim2.new(0, 120, 0, 30)
hitboxInput.Position = UDim2.new(0, 25, 0, 110)
hitboxInput.PlaceholderText = "Hitbox Size"
hitboxInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxInput.Parent = frame

local applyHitboxBtn = Instance.new("TextButton")
applyHitboxBtn.Size = UDim2.new(0, 80, 0, 30)
applyHitboxBtn.Position = UDim2.new(0, 155, 0, 110)
applyHitboxBtn.Text = "Apply"
applyHitboxBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
applyHitboxBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
applyHitboxBtn.Parent = frame

-- Toggle state
local isToggled = false

-- Get lock
local function getMyLock()
    local basesFolder = workspace:WaitForChild("Bases")
    for _, base in ipairs(basesFolder:GetChildren()) do
        if base:IsA("Model") then
            local owner = base:FindFirstChild("Owner")
            if owner and owner:FindFirstChild("OwnerGui") then
                local displayNameLabel = owner.OwnerGui:FindFirstChild("DisplayName")
                if displayNameLabel and displayNameLabel:IsA("TextLabel") then
                    if displayNameLabel.Text == player.DisplayName then
                        local lockPart = base:FindFirstChild("Lock")
                        if lockPart and lockPart:IsA("BasePart") then
                            return lockPart
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Auto TP loop
task.spawn(function()
    while task.wait(0.5) do
        if isToggled then
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local lockPart = getMyLock()

            if hrp and lockPart then
                hrp.CFrame = lockPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end)

-- LockTP Toggle
lockTPBtn.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    lockTPBtn.Text = isToggled and "LockTP: ON" or "LockTP: OFF"
    lockTPBtn.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 150, 250)
end)

-- Apply Hitbox (only other players)
applyHitboxBtn.MouseButton1Click:Connect(function()
    local size = tonumber(hitboxInput.Text)
    if size then
        task.spawn(function()
            while task.wait(1) do
                for _, plr in ipairs(players:GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = plr.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(size, size, size)
                        hrp.Transparency = 1 -- invisible hitbox
                        hrp.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Logo toggles frame
logo.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Minimize button
minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)
