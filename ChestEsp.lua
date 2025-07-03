-- SETTINGS
local chestName = "Rainbow Chest"

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChestESP_UI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 50)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "Toggle Rainbow Chest ESP (ON)"
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16

-- Function to create ESP on chest
local function createESP(part)
    if part:FindFirstChild("ChestESP_Label") then return end

    -- BillboardGui
    local gui = Instance.new("BillboardGui", part)
    gui.Name = "ChestESP_Label"
    gui.Size = UDim2.new(0, 100, 0, 30)
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0, 3, 0)

    local text = Instance.new("TextLabel", gui)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Rainbow Chest"
    text.TextColor3 = Color3.fromRGB(255, 0, 255)
    text.TextScaled = true

    -- Highlight
    local hl = Instance.new("Highlight", part)
    hl.Name = "ChestESP_Highlight"
    hl.FillColor = Color3.fromRGB(255, 0, 255)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

-- Scan function
local function scan()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == chestName then
            local main = obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart
            if main then createESP(main) end
        end
    end
end

-- Toggle logic
local enabled = true
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and "Toggle Rainbow Chest ESP (ON)" or "Toggle Rainbow Chest ESP (OFF)"

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == chestName then
            local part = obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart
            if part then
                local label = part:FindFirstChild("ChestESP_Label")
                local hl = part:FindFirstChild("ChestESP_Highlight")
                if label then label.Enabled = enabled end
                if hl then hl.Enabled = enabled end
            end
        end
    end
end)

-- Watch for new chests
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") and obj.Name == chestName then
        task.wait(0.5)
        local main = obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart
        if main then createESP(main) end
    end
end)

-- Initial run
scan()
