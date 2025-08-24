local function makeHitbox(plr, size)
    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character.HumanoidRootPart

        -- cleanup old
        if Hitboxes[plr] then
            Hitboxes[plr]:Destroy()
            Hitboxes[plr] = nil
        end

        local box = Instance.new("Part")
        box.Name = "FakeHitbox"
        box.Anchored = false
        box.CanCollide = false
        box.Massless = true
        box.Transparency = 0.5
        box.Color = Color3.fromRGB(255,0,0)
        box.Material = Enum.Material.Neon
        box.Size = Vector3.new(size, size, size)
        box.Parent = hrp

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hrp
        weld.Part1 = box
        weld.Parent = box

        Hitboxes[plr] = box
    end
end

-- Apply hitboxes to all enemies
local function applyAllHitboxes(size)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            makeHitbox(plr, size)
        end
    end
end

-- Reset all hitboxes
local function resetHitboxes()
    for plr, part in pairs(Hitboxes) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    Hitboxes = {}
    hitboxEnabled = false
end

-- Reapply when new players join
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        if hitboxEnabled then
            makeHitbox(plr, hitboxSize)
        end
    end)
end)

-- Reapply on respawn
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("HumanoidRootPart")
            if hitboxEnabled then
                makeHitbox(plr, hitboxSize)
            end
        end)
    end
end   this one
