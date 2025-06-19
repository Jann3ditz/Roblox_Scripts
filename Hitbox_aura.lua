-- Simple Draggable GUI with Kill Aura and Head Hitbox Toggles -- Requires any equipped weapon/tool to activate kill aura

local Players = game:GetService("Players") local lp = Players.LocalPlayer local hitboxSize = Vector3.new(5,5,5) local normalSize = Vector3.new(2,1,1) local auraRange = 50 -- Extended range local onlyAffectNPCs = true

local toggleHitbox = true local toggleAura = true

-- Utility local function isPlayerModel(m) for _, p in ipairs(Players:GetPlayers()) do if p.Character == m then return true end end return false end

local function setHeadHitboxes(size, transparency) for _, m in ipairs(game:GetDescendants()) do if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then if onlyAffectNPCs and isPlayerModel(m) then continue end local head = m.Head head.Size = size head.Transparency = transparency head.Material = Enum.Material.SmoothPlastic head.CanCollide = false head.BrickColor = BrickColor.new("Bright red") end end end

local function doKillAura() local char = lp.Character if not char or not char:FindFirstChild("HumanoidRootPart") then return end

local toolEquipped = char:FindFirstChildOfClass("Tool")
if not toolEquipped then return end

for _, m in ipairs(game:GetDescendants()) do
    if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") then
        if onlyAffectNPCs and isPlayerModel(m) then continue end
        local h = m.Humanoid
        local dist = (m.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
        if dist <= auraRange and h.Health > 0 then
            h.Health = 0
        end
    end
end

end

-- Threads spawn(function() while true do wait(5) if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) end end end)

spawn(function() while true do wait(0.25) if toggleAura then doKillAura() end end end)

-- GUI local gui = Instance.new("ScreenGui") gui.Name = "BasicToggleGUI" gui.ResetOnSpawn = false gui.IgnoreGuiInset = true gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 150, 0, 100) frame.Position = UDim2.new(0, 20, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(35,35,35) frame.BorderSizePixel = 0 frame.Active = true frame.Draggable = true frame.Parent = gui

local hitboxBtn = Instance.new("TextButton") hitboxBtn.Size = UDim2.new(1, -20, 0, 40) hitboxBtn.Position = UDim2.new(0, 10, 0, 10) hitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) hitboxBtn.Text = "Hitbox: ON" hitboxBtn.TextColor3 = Color3.new(1,1,1) hitboxBtn.TextScaled = true hitboxBtn.Parent = frame

hitboxBtn.MouseButton1Click:Connect(function() toggleHitbox = not toggleHitbox if toggleHitbox then hitboxBtn.Text = "Hitbox: ON" hitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) setHeadHitboxes(hitboxSize, 0.5) else hitboxBtn.Text = "Hitbox: OFF" hitboxBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) setHeadHitboxes(normalSize, 1) end end)

local auraBtn = Instance.new("TextButton") auraBtn.Size = UDim2.new(1, -20, 0, 40) auraBtn.Position = UDim2.new(0, 10, 0, 55) auraBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 255) auraBtn.Text = "Kill Aura: ON" auraBtn.TextColor3 = Color3.new(1,1,1) auraBtn.TextScaled = true auraBtn.Parent = frame

auraBtn.MouseButton1Click:Connect(function() toggleAura = not toggleAura auraBtn.Text = toggleAura and "Kill Aura: ON" or "Kill Aura: OFF" auraBtn.BackgroundColor3 = toggleAura and Color3.fromRGB(50, 50, 255) or Color3.fromRGB(80, 80, 80) end)

