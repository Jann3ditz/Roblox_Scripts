local player = game.Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Logo
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 120, 0, 40)
logo.Position = UDim2.new(0.5, -60, 0.5, -20) -- Center screen
logo.Text = "JANN"
logo.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.Font = Enum.Font.SourceSansBold
logo.TextSize = 20
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

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = frame

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.Parent = frame

-- LockTP Toggle Button
local locktpBtn = Instance.new("TextButton")
locktpBtn.Size = UDim2.new(0, 200, 0, 40)
locktpBtn.Position = UDim2.new(0, 25, 0, 50)
locktpBtn.Text = "LockTP: OFF"
locktpBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
locktpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
locktpBtn.Font = Enum.Font.SourceSansBold
locktpBtn.TextSize = 18
locktpBtn.Parent = frame

-- Hitbox Input
local hitboxInput = Instance.new("TextBox")
hitboxInput.Size = UDim2.new(0, 120, 0, 30)
hitboxInput.Position = UDim2.new(0, 25, 0, 110)
hitboxInput.PlaceholderText = "Hitbox Size"
hitboxInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxInput.Parent = frame

local hitboxBtn = Instance.new("TextButton")
hitboxBtn.Size = UDim2.new(0, 80, 0, 30)
hitboxBtn.Position = UDim2.new(0, 155, 0, 110)
hitboxBtn.Text = "Apply"
hitboxBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
hitboxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxBtn.Parent = frame

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

-- LockTP Button Toggle
locktpBtn.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    locktpBtn.Text = isToggled and "LockTP: ON" or "LockTP: OFF"
    locktpBtn.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 150, 250)
end)

-- Hitbox Apply
hitboxBtn.MouseButton1Click:Connect(function()
    local size = tonumber(hitboxInput.Text)
    if size and size > 0 then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then -- ✅ exclude myself
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    hrp.Size = Vector3.new(size, size, size)
                    hrp.Massless = true
                    hrp.CanCollide = false
                    hrp.Transparency = 0.7
                end
            end
        end
    end
end)

-- Button Events
logo.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible =
