local player = game.Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, 0)
button.Text = "Teleport to Lock"
button.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = gui

-- Find my base's lock
local function getMyLock()
    local basesFolder = workspace:WaitForChild("Bases")

    for _, base in ipairs(basesFolder:GetChildren()) do
        if base:IsA("Model") then
            local ownerGui = base:FindFirstChild("Owner")
            if ownerGui and ownerGui:FindFirstChild("OwnerGui") then
                local displayNameLabel = ownerGui.OwnerGui:FindFirstChild("DisplayName")
                if displayNameLabel and displayNameLabel:IsA("TextLabel") then
                    if displayNameLabel.Text == player.DisplayName then
                        local lockPart = base:FindFirstChild("Lock")
                        if lockPart and lockPart:IsA("BasePart") then
                            return lockPart
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Teleport when button is clicked
button.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local lockPart = getMyLock()

    if lockPart then
        hrp.CFrame = lockPart.CFrame + Vector3.new(0, 3, 0)
        print("✅ Teleported to your lock:", lockPart:GetFullName())
    else
        warn("⚠ Could not find your base lock!")
    end
end)
