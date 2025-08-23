local player = game.Players.LocalPlayer
local playerName = player.DisplayName  -- or use player.Name if needed

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(1, -160, 0, 20) -- top right corner
button.Text = "AutoTP: OFF"
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = gui

-- State
local autoTP = false
local myBase = nil
local timerLabel = nil
local lockPart = nil

-- Find your base by owner display name
local function findMyBase()
    for _, base in pairs(workspace:WaitForChild("Bases"):GetChildren()) do
        local ownerGui = base:FindFirstChild("Owner") and base.Owner:FindFirstChild("OwnerGui")
        if ownerGui and ownerGui:FindFirstChild("DisplayName") then
            if ownerGui.DisplayName.Text == playerName then
                return base
            end
        end
    end
    return nil
end

-- Teleport
local function teleportToLock()
    if lockPart then
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = lockPart.CFrame + Vector3.new(0, 3, 0)
        print("✅ AutoTP: Teleported to lock")
    end
end

-- Watch timer
task.spawn(function()
    while true do
        if autoTP then
            if not myBase then
                myBase = findMyBase()
                if myBase then
                    lockPart = myBase:WaitForChild("Lock")
                    timerLabel = lockPart.LockAttachment.LockGui.Timer
                end
            end

            if timerLabel then
                local timerText = tonumber(timerLabel.Text)
                if timerText and timerText <= 0 then
                    teleportToLock()
                    task.wait(1)
                end
            end
        end
        task.wait(0.5)
    end
end)

-- Button toggle
button.MouseButton1Click:Connect(function()
    autoTP = not autoTP
    if autoTP then
        myBase = findMyBase()
        if myBase then
            lockPart = myBase:WaitForChild("Lock")
            timerLabel = lockPart.LockAttachment.LockGui.Timer
        end
        button.Text = "AutoTP: ON"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        button.Text = "AutoTP: OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

