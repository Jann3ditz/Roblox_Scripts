local player = game.Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, 0)
button.Text = "Teleport OFF"
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = gui

-- State variable
local teleportEnabled = false
local loopThread

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

-- Toggle teleport loop
button.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled

    if teleportEnabled then
        button.Text = "Teleport ON"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

        loopThread = task.spawn(function()
            while teleportEnabled do
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                local lockPart = getMyLock()

                if lockPart then
                    hrp.CFrame = lockPart.CFrame + Vector3.new(0, 3, 0)
                else
                    warn("⚠ Could not find your base lock!")
                end

                task.wait(1) -- Teleport every 1 second
            end
        end)

    else
        button.Text = "Teleport OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

