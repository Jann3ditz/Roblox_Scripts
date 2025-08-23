local player = game.Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.Parent = player:WaitForChild("PlayerGui")

-- Logo (JANN)
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 120, 0, 40)
logo.Position = UDim2.new(0.5, -60, 0.5, -20) -- center screen
logo.Text = "JANN"
logo.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.Font = Enum.Font.SourceSansBold
logo.TextSize = 20
logo.Active = true
logo.Draggable = true
logo.Parent = gui

-- Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110) -- center screen
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = frame

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.Parent = frame

-- LockTP Button
local lockTpBtn = Instance.new("TextButton")
lockTpBtn.Size = UDim2.new(0, 120, 0, 40)
lockTpBtn.Position = UDim2.new(0, 10, 0, 40)
lockTpBtn.Text = "LockTP: OFF"
lockTpBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
lockTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockTpBtn.Font = Enum.Font.SourceSansBold
lockTpBtn.TextSize = 18
lockTpBtn.Parent = frame

-- Hitbox Label
local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Size = UDim2.new(0, 120, 0, 20)
hitboxLabel.Position = UDim2.new(0, 10, 0, 100)
hitboxLabel.Text = "Hitbox Size:"
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxLabel.Parent = frame

-- Hitbox Input
local hitboxInput = Instance.new("TextBox")
hitboxInput.Size = UDim2.new(0, 100, 0, 25)
hitboxInput.Position = UDim2.new(0, 140, 0, 95)
hitboxInput.PlaceholderText = "Enter size"
hitboxInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxInput.Parent = frame

-- Apply Button
local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0, 80, 0, 30)
applyBtn.Position = UDim2.new(0, 100, 0, 130)
applyBtn.Text = "Apply"
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.Parent = frame

-- Toggle state
local isToggled = false

-- Find my base's lock
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

-- Button click toggle
lockTpBtn.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    lockTpBtn.Text = isToggled and "LockTP: ON" or "LockTP: OFF"
    lockTpBtn.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 150, 250)
end)

-- Apply Hitbox
applyBtn.MouseButton1Click:Connect(function()
    local size = tonumber(hitboxInput.Text)
    if size then
        task.spawn(function()
            while task.wait(0.5) do
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = plr.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(size, size, size)
                        hrp.Transparency = 0.5
                        hrp.BrickColor = BrickColor.new("Bright red")
                        hrp.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Logo click to toggle frame
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
