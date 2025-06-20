-- hitbox_aura.lua
local hitboxSize = Vector3.new(12, 8, 8)
local normalSize = Vector3.new(2,1,1)
local auraRange = 500
local onlyAffectNPCs = true

local toggleHitbox = true
local toggleAura = true
local toggleShield = true
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function isPlayerModel(m)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character == m then return true end
    end
    return false
end

local function setHeadHitboxes(size, transparency)
    for _, m in ipairs(game:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then
            if onlyAffectNPCs and isPlayerModel(m) then continue end
            local head = m.Head
            head.Size = size
            head.Transparency = transparency
            head.Material = Enum.Material.SmoothPlastic
            head.CanCollide = false
            head.BrickColor = BrickColor.new("Bright red")
        end
    end
end

local function doAutoAimToHead()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local closestHead = nil
    local shortestDistance = math.huge

    for _, m in ipairs(game:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then
            if onlyAffectNPCs and isPlayerModel(m) then continue end
            local head = m.Head
            local dist = (head.Position - hrp.Position).Magnitude
            if dist < shortestDistance and dist <= auraRange then
                closestHead = head
                shortestDistance = dist
            end
        end
    end

    if closestHead then
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, closestHead.Position)
    end
end

-- Auto threads
task.spawn(function()
    while true do
        task.wait(5)
        if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.25)
        if toggleAura then doAutoAimToHead() end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if toggleShield then
            local char = lp.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = char.Humanoid.MaxHealth
            end
        end
    end
end)

-- 🛡️ Create Invisible Physical Shield Around Player
local function createShieldBarrier()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local shield = Instance.new("Part")
    shield.Name = "InvisibleShield"
    shield.Size = Vector3.new(10, 10, 10) -- Bigger than character
    shield.Transparency = 1
    shield.CanCollide = true
    shield.Anchored = false
    shield.Massless = true
    shield.Parent = workspace

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = shield
    weld.Part1 = hrp
    weld.Parent = shield
end

-- Create shield when character spawns
lp.CharacterAdded:Connect(function()
    task.wait(1)
    createShieldBarrier()
end)

if lp.Character then
    createShieldBarrier()
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Name = "CustomGUI"
gui.Parent = game.CoreGui

local function createButton(name, yPos, color, defaultText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,130,0,40)
    btn.Position = UDim2.new(1, -150, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = defaultText
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.ZIndex = 9999
    btn.Parent = gui
    return btn
end

local hitboxBtn = createButton("Hitbox", 20, Color3.fromRGB(255,50,50), "Hitbox: ON")
local auraBtn   = createButton("Auto Aim", 70, Color3.fromRGB(50,50,255), "Auto Aim: ON")
local shieldBtn = createButton("Shield", 120, Color3.fromRGB(50,200,50), "Shield: ON")

hitboxBtn.MouseButton1Click:Connect(function()
    toggleHitbox = not toggleHitbox
    if toggleHitbox then
        setHeadHitboxes(hitboxSize, 0.5)
        hitboxBtn.Text = "Hitbox: ON"
        hitboxBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
    else
        setHeadHitboxes(normalSize, 1)
        hitboxBtn.Text = "Hitbox: OFF"
        hitboxBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    end
end)

auraBtn.MouseButton1Click:Connect(function()
    toggleAura = not toggleAura
    auraBtn.Text = "Auto Aim: " .. (toggleAura and "ON" or "OFF")
    auraBtn.BackgroundColor3 = toggleAura and Color3.fromRGB(50,50,255) or Color3.fromRGB(80,80,80)
end)

shieldBtn.MouseButton1Click:Connect(function()
    toggleShield = not toggleShield
    shieldBtn.Text = "Shield: " .. (toggleShield and "ON" or "OFF")
    shieldBtn.BackgroundColor3 = toggleShield and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)
end)
