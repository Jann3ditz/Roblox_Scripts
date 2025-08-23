local player = game.Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100) -- Centered on screen
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = gui

-- Logo Button
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 100, 0, 40)
logo.Position = UDim2.new(0.5, -50, 0, 10)
logo.Text = "JANN"
logo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.Font = Enum.Font.SourceSansBold
logo.TextSize = 20
logo.Active = true
logo.Draggable = true
logo.Parent = gui

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 5)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
minimizeButton.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = frame

-- LockTP Toggle Button
local locktpButton = Instance.new("TextButton")
locktpButton.Size = UDim2.new(0, 120, 0, 40)
locktpButton.Position = UDim2.new(0, 20, 0, 60)
locktpButton.Text = "LockTP: OFF"
locktpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
locktpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
locktpButton.Font = Enum.Font.SourceSansBold
locktpButton.TextSize = 18
locktpButton.Parent = frame

-- Hitbox Label
local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Size = UDim2.new(0, 120, 0, 20)
hitboxLabel.Position = UDim2.new(0, 20, 0, 110)
hitboxLabel.Text = "Hitbox Size:"
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxLabel.Font = Enum.Font.SourceSans
hitboxLabel.TextSize = 16
hitboxLabel.Parent = frame

-- Hitbox Input
local hitboxInput = Instance.new("TextBox")
hitboxInput.Size = UDim2.new(0, 80, 0, 30)
hitboxInput.Position = UDim2.new(0, 140, 0, 105)
hitboxInput.PlaceholderText = "Size"
hitboxInput.Text = ""
hitboxInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
hitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxInput.Font = Enum.Font.SourceSans
hitboxInput.TextSize = 16
hitboxInput.Parent = frame

-- Apply Hitbox Button
local applyHitbox = Instance.new("TextButton")
applyHitbox.Size = UDim2.new(0, 80, 0, 30)
applyHitbox.Position = UDim2.new(0, 230, 0, 105)
applyHitbox.Text = "Apply"
applyHitbox.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
applyHitbox.TextColor3 = Color3.fromRGB(255, 255, 255)
applyHitbox.Font = Enum.Font.SourceSansBold
applyHitbox.TextSize = 16
applyHitbox.Parent = frame

-- State Variables
local isToggled = false
local hitboxSize = 5

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

-- Hitbox loop
task.spawn(function()
    while task.wait(0.5) do
        local char = player.Character or player.CharacterAdded:Wait()
        if char then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
                    part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    part.Transparency = 0.7
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Button connections
logo.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

minimizeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

locktpButton.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    locktpButton.Text = isToggled and "LockTP: ON" or "LockTP: OFF"
    locktpButton.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 150, 250)
end)

applyHitbox.MouseButton1Click:Connect(function()
    local val = tonumber(hitboxInput.Text)
    if val and val > 0 then
        hitboxSize = val
    end
end)
