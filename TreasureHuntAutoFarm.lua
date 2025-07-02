local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rs = game:GetService("RunService")
local chests = workspace:WaitForChild("Chests")
local sellPad = workspace:FindFirstChild("SellPad") or workspace:FindFirstChild("SellSpot") -- varies by map

-- Settings
local sellCooldown = 1
local checkBackpack = true

-- Function to teleport
function tpTo(pos)
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(pos)
    end
end

-- Check if backpack full
function isBackpackFull()
    local stats = player:FindFirstChild("leaderstats")
    if not stats then return false end
    local sand = stats:FindFirstChild("Sand")
    local capacity = stats:FindFirstChild("Capacity")
    return sand and capacity and sand.Value >= capacity.Value
end

-- Farm loop
spawn(function()
    while task.wait(0.2) do
        if isBackpackFull() then
            tpTo(sellPad.Position + Vector3.new(0, 3, 0))
            wait(sellCooldown)
        else
            for _, chest in pairs(chests:GetChildren()) do
                if chest:IsA("Model") and chest:FindFirstChild("TouchInterest") then
                    tpTo(chest.PrimaryPart.Position + Vector3.new(0, 3, 0))
                    wait(0.4) -- simulate touch and pickup
                end
            end
        end
    end
end)
