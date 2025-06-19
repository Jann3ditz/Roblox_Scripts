-- Draggable UI with Switches for Each Function (Hitbox / Kill Aura) -- Mobile Friendly, Toggle Each Feature, Minimizable GUI

local Players = game:GetService("Players") local lp = Players.LocalPlayer local hitboxSize = Vector3.new(5,5,5) local normalSize = Vector3.new(2,1,1) local auraRange = 10 local onlyAffectNPCs = true local toggleHitbox = false local toggleAura = false

-- UTILITY local function isPlayerModel(m) for _, p in ipairs(Players:GetPlayers()) do if p.Character == m then return true end end return false end

-- FUNCTIONS local function setHeadHitboxes(size, transparency) for _, m in ipairs(game:GetDescendants()) do if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then if onlyAffectNPCs and isPlayerModel(m) then continue end local head = m.Head head.Size = size head.Transparency = transparency head.Material = Enum.Material.SmoothPlastic head.CanCollide = false head.BrickColor = BrickColor.new("Bright red") end end end

local function doKillAura() local char = lp.Character if not char or not char:FindFirstChild("HumanoidRootPart") then return end local tool = char:FindFirstChildOfClass("Tool") if not tool then return end

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

-- BACKGROUND TASKS spawn(function() while true do wait(5) if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) end end end)

spawn(function() while true do wait(0.25) if toggleAura then doKillAura() end end end)

-- GUI SETUP local gui = Instance.new("ScreenGui") gui.Name = "ModGUI" gui.ResetOnSpawn = false gui.IgnoreGuiInset = true gui.Parent = game.CoreGui

local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 200, 0, 150) frame.Position = UDim2.new(0, 50, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) frame.BorderSizePixel = 0 frame.Active = true frame.Draggable = true frame.Parent = gui

-- TITLE local title = Instance.new("TextLabel") title.Text = "Mod Menu" title.Size = UDim2.new(1, 0, 0, 30) title.BackgroundColor3 = Color3.fromRGB(50, 50, 50) title.TextColor3 = Color3.new(1,1,1) title.TextScaled = true title.Parent = frame

-- HITBOX TOGGLE local hitboxToggle = Instance.new("TextButton") hitboxToggle.Size = UDim2.new(1, -20, 0, 30) hitboxToggle.Position = UDim2.new(0, 10, 0, 40) hitboxToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60) hitboxToggle.Text = "Hitbox: OFF" hitboxToggle.TextColor3 = Color3.new(1,1,1) hitboxToggle.TextScaled = true hitboxToggle.Parent = frame

hitboxToggle.MouseButton1Click:Connect(function() toggleHitbox = not toggleHitbox hitboxToggle.Text = toggleHitbox and "Hitbox: ON" or "Hitbox: OFF" hitboxToggle.BackgroundColor3 = toggleHitbox and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(80, 80, 80) if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) else setHeadHitboxes(normalSize, 1) end end)

-- AURA TOGGLE local auraToggle = Instance.new("TextButton") auraToggle.Size = UDim2.new(1, -20, 0, 30) auraToggle.Position = UDim2.new(0, 10, 0, 80) auraToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 200) auraToggle.Text = "Kill Aura: OFF" auraToggle.TextColor3 = Color3.new(1,1,1) auraToggle.TextScaled = true auraToggle.Parent = frame

auraToggle.MouseButton1Click:Connect(function() toggleAura = not toggleAura auraToggle.Text = toggleAura and "Kill Aura: ON" or "Kill Aura: OFF" auraToggle.BackgroundColor3 = toggleAura and Color3.fromRGB(60, 60, 255) or Color3.fromRGB(80, 80, 80) end)

-- MINIMIZE BUTTON local minimizeBtn = Instance.new("TextButton") minimizeBtn.Size = UDim2.new(0, 30, 0, 30) minimizeBtn.Position = UDim2.new(1, -35, 0, 0) minimizeBtn.Text = "-" minimizeBtn.TextColor3 = Color3.new(1,1,1) minimizeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70) minimizeBtn.Parent = frame

local isMinimized = false minimizeBtn.MouseButton1Click:Connect(function() isMinimized = not isMinimized for _, child in ipairs(frame:GetChildren()) do if child:IsA("TextButton") and child ~= minimizeBtn then child.Visible = not isMinimized end end end)

