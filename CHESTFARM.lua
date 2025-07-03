local RS = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- SETTINGS
local chestNameToESP = "Rainbow Chest" -- Only this one will be shown
local chestsFolder = ReplicatedStorage:WaitForChild("Chests")

-- ESP container
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "ChestESP_RainbowOnly"

-- Function to add highlight + label
local function makeESP(part, labelText)
    if not part:IsA("BasePart") or part:FindFirstChild("Highlight") then return end

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Name = "Highlight"
    hl.FillColor = Color3.fromRGB(255, 0, 255) -- Rainbow color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.4
    hl.Parent = part

    -- Billboard label
    local billboard = Instance.new("BillboardGui", espFolder)
    billboard.Name = "ChestLabel"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 0, 255)
    label.TextStrokeTransparency = 0.3
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
end

-- Loop through only the Rainbow Chest folder
local rainbowFolder = chestsFolder:FindFirstChild(chestNameToESP)
if rainbowFolder then
    for _, item in pairs(rainbowFolder:GetChildren()) do
        if item:IsA("BasePart") then
            makeESP(item, chestNameToESP)
        end
    end
else
    warn("No chest named:", chestNameToESP)
end
