-- hitbox_aura_orionlib.lua local hitboxSize = Vector3.new(25, 15, 15) local normalSize = Vector3.new(2,1,1) local auraRange = 500 local onlyAffectNPCs = true

local toggleHitbox = false local toggleAura = false

local Players = game:GetService("Players") local lp = Players.LocalPlayer

-- OrionLib setup local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))() local Window = OrionLib:MakeWindow({Name = "JANN3DITZ", HidePremium = false, SaveConfig = false, IntroEnabled = false})

-- Functions local function isPlayerModel(m) for _, p in ipairs(Players:GetPlayers()) do if p.Character == m then return true end end return false end

local function setHeadHitboxes(size, transparency) for _, m in ipairs(game:GetDescendants()) do if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("Head") then if onlyAffectNPCs and isPlayerModel(m) then continue end local head = m.Head head.Size = size head.Transparency = transparency head.Material = Enum.Material.SmoothPlastic head.CanCollide = false head.BrickColor = BrickColor.new("Bright red") end end end

local function doAutoAimToHead() local char = lp.Character if not char or not char:FindFirstChild("HumanoidRootPart") then return end local hrp = char.HumanoidRootPart

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

-- Hitbox thread coroutine.wrap(function() while true do task.wait(5) if toggleHitbox then setHeadHitboxes(hitboxSize, 0.5) end end end)()

-- Auto Aim thread coroutine.wrap(function() while true do task.wait(0.25) if toggleAura then doAutoAimToHead() end end end)()

-- UI Tabs & Toggles local mainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})

mainTab:AddToggle({ Name = "Head Hitbox", Default = false, Callback = function(v) toggleHitbox = v if not v then setHeadHitboxes(normalSize, 1) end end })

mainTab:AddToggle({ Name = "Auto Aim to Head", Default = false, Callback = function(v) toggleAura = v end })

OrionLib:Init()

