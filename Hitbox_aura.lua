-- hitbox_aura.lua local hitboxSize = Vector3.new(25, 15, 15) local normalSize = Vector3.new(2,1,1) local auraRange = 500 local onlyAffectNPCs = true

local toggleHitbox = false local toggleAura = false local Players = game:GetService("Players") local lp = Players.LocalPlayer

local function isPlayerModel(m) for _, p in ipairs(Players:GetPlayers()) do if p.Character == m then return true end end return false end

local function setHeadHitboxes(size, transparency) for _, m in ipairs(game:GetDescendants()) do if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then if onlyAffectNPCs and isPlayerModel(m) then continue end local head = m.Head head.Size = size head.Transparency = transparency head.Material = Enum.Material.SmoothPlastic head.CanCollide = false head.BrickColor = BrickColor.new("Bright red") end end end

local function setNoclip(state) local char = lp.Character if not char then return end

for _, part in ipairs(char:GetDescendants()) do
    if part:IsA("BasePart") then
        part.CanCollide = not state
    end
end

end

local function tpFollowAndKillNPCs() local char = lp.Character if not char or not char:FindFirstChild("HumanoidRootPart") then return end local hrp = char.HumanoidRootPart local tool = char:FindFirstChildOfClass("Tool")

for _, m in ipairs(game:GetDescendants()) do
    if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Head") then
        if onlyAffectNPCs and isPlayerModel(m) then continue end

        local hum = m.Humanoid
        local head = m.Head

        if hum.Health > 0 then
            setNoclip(true)
            hrp.CFrame = CFrame.new(head.Position + Vector3.new(0, 5, 0))

            while hum.Health > 0 and hum.Parent ~= nil do
                task.wait(0.1)
                if tool and tool:FindFirstChild("Handle") then
                    hum:TakeDamage(9999)
                end
            end

            task.wait(0.1)
            setNoclip(false)
        end
    end
end

setNoclip(false)

end

-- Threads

task.spawn(function() while true do task.wait(5) if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) end end end)

task.spawn(function() while true do task.wait(0.25) if toggleAura then tpFollowAndKillNPCs() end end end)

-- GUI local gui = Instance.new("ScreenGui") gui.ResetOnSpawn = false gui.IgnoreGuiInset = true gui.Name = "CustomGUI" gui.Parent = game.CoreGui

local function createButton(name, yPos, color, defaultText) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0,130,0,40) btn.Position = UDim2.new(1, -150, 0, yPos) btn.BackgroundColor3 = color btn.Text = defaultText btn.TextColor3 = Color3.new(1,1,1) btn.TextScaled = true btn.ZIndex = 9999 btn.Parent = gui return btn end

local hitboxBtn = createButton("Hitbox", 20, Color3.fromRGB(255,50,50), "Hitbox: OFF") local auraBtn   = createButton("Auto Aim", 70, Color3.fromRGB(50,50,255), "Auto Aim: OFF")

hitboxBtn.MouseButton1Click:Connect(function() toggleHitbox = not toggleHitbox if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) hitboxBtn.Text = "Hitbox: ON" hitboxBtn.BackgroundColor3 = Color3.fromRGB(255,50,50) else setHeadHitboxes(normalSize, 1) hitboxBtn.Text = "Hitbox: OFF" hitboxBtn.BackgroundColor3 = Color3.fromRGB(80,80,80) end end)

auraBtn.MouseButton1Click:Connect(function() toggleAura = not toggleAura auraBtn.Text = "Auto Aim: " .. (toggleAura and "ON" or "OFF") auraBtn.BackgroundColor3 = toggleAura and Color3.fromRGB(50,50,255) or Color3.fromRGB(80,80,80) end)

