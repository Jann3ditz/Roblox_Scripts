--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local isToggled = false
local noclipEnabled = false
local hitboxEnabled = false
local hitboxSize = 5

-- Table to store enemy hitboxes
local Hitboxes = {}

--// Function to make hitbox (Infinite Yield style)
local function makeHitbox(plr, size)
    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character.HumanoidRootPart

        -- cleanup old
        if Hitboxes[plr] then
            Hitboxes[plr]:Destroy()
            Hitboxes[plr] = nil
        end

        local box = Instance.new("Part")
        box.Name = "FakeHitbox"
        box.Anchored = false
        box.CanCollide = false
        box.Massless = true
        box.Transparency = 0.5
        box.Color = Color3.fromRGB(255,0,0)
        box.Material = Enum.Material.Neon
        box.Size = Vector3.new(size, size, size)
        box.Parent = hrp

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hrp
        weld.Part1 = box
        weld.Parent = box

        Hitboxes[plr] = box
    end
end

-- Apply hitboxes to all enemies
local function applyAllHitboxes(size)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            makeHitbox(plr, size)
        end
    end
end

-- Reapply when new players join
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        if hitboxEnabled then
            makeHitbox(plr, hitboxSize)
        end
    end)
end)

-- Reapply on respawn
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("HumanoidRootPart")
            if hitboxEnabled then
                makeHitbox(plr, hitboxSize)
            end
        end)
    end
end

--// GUI Builder
local function createGUI()
    if player.PlayerGui:FindFirstChild("LockTPGui") then
        return player.PlayerGui.LockTPGui
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LockTPGui"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local logo = Instance.new("TextButton")
    logo.Size = UDim2.new(0, 120, 0, 40)
    logo.Position = UDim2.new(0.5, -60, 0.5, -20)
    logo.Text = "JANN"
    logo.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.Font = Enum.Font.SourceSansBold
    logo.TextSize = 20
    logo.Active = true
    logo.Draggable = true
    logo.Parent = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 260)
    frame.Position = UDim2.new(0.5, -150, 0.5, -130)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Visible = false
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Parent = frame

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
    minimizeBtn.Text = "-"
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
    minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    minimizeBtn.Parent = frame

    local lockTpBtn = Instance.new("TextButton")
    lockTpBtn.Size = UDim2.new(0, 120, 0, 40)
    lockTpBtn.Position = UDim2.new(0, 10, 0, 40)
    lockTpBtn.Text = "LockTP: OFF"
    lockTpBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    lockTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockTpBtn.Font = Enum.Font.SourceSansBold
    lockTpBtn.TextSize = 18
    lockTpBtn.Parent = frame

    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 120, 0, 40)
    noclipBtn.Position = UDim2.new(0, 160, 0, 40)
    noclipBtn.Text = "Noclip: OFF"
    noclipBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipBtn.Font = Enum.Font.SourceSansBold
    noclipBtn.TextSize = 18
    noclipBtn.Parent = frame

    local hitboxLabel = Instance.new("TextLabel")
    hitboxLabel.Size = UDim2.new(0, 120, 0, 20)
    hitboxLabel.Position = UDim2.new(0, 10, 0, 100)
    hitboxLabel.Text = "Hitbox Size:"
    hitboxLabel.BackgroundTransparency = 1
    hitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    hitboxLabel.Parent = frame

    local hitboxInput = Instance.new("TextBox")
    hitboxInput.Size = UDim2.new(0, 100, 0, 25)
    hitboxInput.Position = UDim2.new(0, 140, 0, 95)
    hitboxInput.PlaceholderText = "Enter size"
    hitboxInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    hitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    hitboxInput.Parent = frame

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0, 80, 0, 30)
    applyBtn.Position = UDim2.new(0, 100, 0, 130)
    applyBtn.Text = "Apply"
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.Parent = frame

    logo.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)
    closeBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)
    minimizeBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    lockTpBtn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        lockTpBtn.Text = isToggled and "LockTP: ON" or "LockTP: OFF"
        lockTpBtn.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 150, 250)
    end)

    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        noclipBtn.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
        noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(150, 50, 200)
    end)

    applyBtn.MouseButton1Click:Connect(function()
        local size = tonumber(hitboxInput.Text)
        if size then
            hitboxSize = size
            hitboxEnabled = true
            applyAllHitboxes(hitboxSize)
        end
    end)

    return gui
end

--// Auto TP loop
task.spawn(function()
    while task.wait(0.5) do
        if isToggled then
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local basesFolder = workspace:FindFirstChild("Bases")
            if basesFolder and hrp then
                for _, base in ipairs(basesFolder:GetChildren()) do
                    local owner = base:FindFirstChild("Owner")
                    if owner and owner:FindFirstChild("OwnerGui") then
                        local displayNameLabel = owner.OwnerGui:FindFirstChild("DisplayName")
                        if displayNameLabel and displayNameLabel.Text == player.DisplayName then
                            local lockPart = base:FindFirstChild("Lock")
                            if lockPart then
                                hrp.CFrame = lockPart.CFrame + Vector3.new(0, 3, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end)

--// Noclip loop (respawn safe)
RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if noclipEnabled then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Ensure GUI always exists
task.spawn(function()
    while true do
        if not player.PlayerGui:FindFirstChild("LockTPGui") then
            createGUI()
        end
        task.wait(2)
    end
end)

-- Build once
createGUI()     merge it here
