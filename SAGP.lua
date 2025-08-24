--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--// Lock TP Settings
local lockTarget = nil
local lockEnabled = false

--// Noclip Settings
local noclipEnabled = false

--// Functions
local function getNearestPlayer()
    local nearest, distance = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = plr.Character.HumanoidRootPart
            local dist = (humanoidRootPart.Position - targetHRP.Position).Magnitude
            if dist < distance then
                distance = dist
                nearest = plr
            end
        end
    end
    return nearest
end

local function autoLockTP()
    if lockEnabled and lockTarget and lockTarget.Character and lockTarget.Character:FindFirstChild("HumanoidRootPart") then
        humanoidRootPart.CFrame = lockTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
    end
end

--// Toggle lock TP with "L"
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.L then
        lockEnabled = not lockEnabled
        if lockEnabled then
            lockTarget = getNearestPlayer()
            print("Lock TP Enabled on:", lockTarget and lockTarget.Name or "None")
        else
            lockTarget = nil
            print("Lock TP Disabled")
        end
    elseif input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        print("Noclip:", noclipEnabled and "Enabled" or "Disabled")
    end
end)

--// Noclip Loop
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

--// Auto TP Loop
RunService.Heartbeat:Connect(autoLockTP)
