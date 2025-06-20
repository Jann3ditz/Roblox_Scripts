-- hitbox_head_only.lua local hitboxSize = Vector3.new(25, 15, 15) local normalSize = Vector3.new(2,1,1) local onlyAffectNPCs = true

local toggleHitbox = false local Players = game:GetService("Players") local lp = Players.LocalPlayer

local function isPlayerModel(m) for _, p in ipairs(Players:GetPlayers()) do if p.Character == m then return true end end return false end

local function setHeadHitboxes(size, transparency) for _, m in ipairs(game:GetDescendants()) do if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then if onlyAffectNPCs and isPlayerModel(m) then continue end local head = m.Head head.Size = size head.Transparency = transparency head.Material = Enum.Material.SmoothPlastic head.CanCollide = false head.BrickColor = BrickColor.new("Bright red") end end end

-- Auto thread task.spawn(function() while true do task.wait(5) if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) end end end)

-- GUI local gui = Instance.new("ScreenGui") gui.ResetOnSpawn = false gui.IgnoreGuiInset = true gui.Name = "CustomGUI" gui.Parent = game.CoreGui

local function createButton(name, yPos, color, defaultText) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0,130,0,40) btn.Position = UDim2.new(1, -150, 0, yPos) btn.BackgroundColor3 = color btn.Text = defaultText btn.TextColor3 = Color3.new(1,1,1) btn.TextScaled = true btn.ZIndex = 9999 btn.Parent = gui return btn end

local hitboxBtn = createButton("Hitbox", 20, Color3.fromRGB(255,50,50), "Hitbox: OFF")

hitboxBtn.MouseButton1Click:Connect(function() toggleHitbox = not toggleHitbox if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) hitboxBtn.Text = "Hitbox: ON" hitboxBtn.BackgroundColor3 = Color3.fromRGB(255,50,50) else setHeadHitboxes(normalSize, 1) hitboxBtn.Text = "Hitbox: OFF" hitboxBtn.BackgroundColor3 = Color3.fromRGB(80,80,80) end end)

