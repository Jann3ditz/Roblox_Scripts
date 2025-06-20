-- hitbox_aura.lua
local hitboxSize = Vector3.new(50,50,50)
local normalSize = Vector3.new(2,1,1)
local auraRange = 500
local onlyAffectNPCs = true

local toggleHitbox = true
local toggleAura = true
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

-- ✅ Auto Aim to Closest NPC Head
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

-- Threads
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

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Name = "CustomGUI"
gui.Parent = game.CoreGui

local hitboxBtn = Instance.new("TextButton")
hitboxBtn.Size = UDim2.new(0,130,0,40)
hitboxBtn.Position = UDim2.new(1, -150, 0, 20) -- 📍 Top-right
hitboxBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
hitboxBtn.Text = "Hitbox: ON"
hitboxBtn.TextColor3 = Color3.new(1,1,1)
hitboxBtn.TextScaled = true
hitboxBtn.ZIndex = 9999
hitboxBtn.Parent = gui

local auraBtn = Instance.new("TextButton")
auraBtn.Size = UDim2.new(0,130,0,40)
auraBtn.Position = UDim2.new(1, -150, 0, 70) -- 📍 Below Hitbox
auraBtn.BackgroundColor3 = Color3.fromRGB(50,50,255)
auraBtn.Text = "Auto Aim: ON"
auraBtn.TextColor3 = Color3.new(1,1,1)
auraBtn.TextScaled = true
auraBtn.ZIndex = 9999
auraBtn.Parent = gui

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
