-- hitbox_aura.lua
local hitboxSize = Vector3.new(25, 15, 15)
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

-- Float + TP Kill
local function tpKillNPCs()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local originalAnchor = hrp.Anchored

    for _, m in ipairs(game:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then
            if onlyAffectNPCs and isPlayerModel(m) then continue end

            local head = m.Head
            local humanoid = m.Humanoid

            if humanoid.Health > 0 then
                -- Float above the enemy
                hrp.CFrame = CFrame.new(head.Position + Vector3.new(0, 5, 0))
                hrp.Anchored = true

                -- Kill enemy and wait until confirmed dead
                humanoid.Health = 0
                repeat task.wait(0.1) until humanoid.Health <= 0 or humanoid.Parent == nil

                task.wait(0.1)
            end
        end
    end

    hrp.Anchored = originalAnchor
end

-- GUI Setup
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
local tpKillBtn = createButton("TPKill", 120, Color3.fromRGB(200, 100, 255), "TP Kill")

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

tpKillBtn.MouseButton1Click:Connect(function()
    task.spawn(tpKillNPCs)
end)
