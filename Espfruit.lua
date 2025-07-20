-- CONFIG
local MUTATIONS = { "Tranquil", "Pollinated" }
local VARIANTS = { "Gold", "Rainbow" }
local SCAN_DELAY = 1

-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")

-- MUTATION HANDLER (optional use)
local MutationHandler = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MutationHandler"))

-- STATE FLAGS
local espEnabled = false
local collectEnabled = false

-- CREATE GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local function createButton(name, posY)
    local btn = Instance.new("TextButton", screenGui)
    btn.Name = name
    btn.Size = UDim2.new(0, 140, 0, 50)
    btn.Position = UDim2.new(1, -160, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = name .. ": OFF"
    return btn
end

local espBtn = createButton("ESP", 20)
local collectBtn = createButton("AutoCollect", 80)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,200,255)
end)
collectBtn.MouseButton1Click:Connect(function()
    collectEnabled = not collectEnabled
    collectBtn.Text = "AutoCollect: " .. (collectEnabled and "ON" or "OFF")
    collectBtn.BackgroundColor3 = collectEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,200,255)
end)

-- HELPERS
local function isTarget(nameList, value)
    for _, v in ipairs(nameList) do
        if v == value then return true end
    end
    return false
end

local function labelMaker(variantOrMutation, weight)
    return string.format("Mango [%s] (%.1fkg)", variantOrMutation, weight or 0)
end

local function applyESP(part, text)
    if part:FindFirstChild("FruitESP") then return end
    local gui = Instance.new("BillboardGui")
    gui.Name = "FruitESP"
    gui.Size = UDim2.new(0,100,0,40)
    gui.StudsOffset = Vector3.new(0,3,0)
    gui.AlwaysOnTop = true
    gui.Parent = part
    local lbl = Instance.new("TextLabel", gui)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextStrokeTransparency = 0
    lbl.TextColor3 = Color3.fromRGB(255,255,0)
    lbl.TextScaled = true
    lbl.Text = text
end

local function collectFruit(fruit)
    local prompt = fruit:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt and collectEnabled then
        fireproximityprompt(prompt)
    end
end

-- SCAN LOOP
rs.Heartbeat:Connect(function()
    if not (espEnabled or collectEnabled) then return end
    local plants = workspace:FindFirstChild("Farm") and workspace.Farm:FindFirstChild("Farm")
    local phys = plants and plants:FindFirstChild("Important") and plants.Important:FindFirstChild("Plants_Physical")
    if not phys then return end

    for _, plant in ipairs(phys:GetChildren()) do
        local fruitsFolder = plant:FindFirstChild("Fruits")
        if fruitsFolder then
            for _, fg in ipairs(fruitsFolder:GetChildren()) do
                for _, fruit in ipairs(fg:GetChildren()) do
                    -- Get weight
                    local weightVal = fruit:FindFirstChild("Weight")
                    local weight = weightVal and weightVal.Value or 0

                    -- Check mutation
                    local mut = fruit:FindFirstChild("Mutation")
                    if mut then
                        local scriptObj = mut:FindFirstChildWhichIsA("Script")
                        if scriptObj then
                            local name = scriptObj.Name
                            if isTarget(MUTATIONS, name) then
                                if espEnabled then applyESP(fruit:FindFirstChildWhichIsA("BasePart"), labelMaker(name, weight)) end
                                collectFruit(fruit)
                                continue
                            end
                        end
                    end

                    -- Check variant
                    local var = fruit:FindFirstChild("Variant")
                    if var then
                        local scriptObj = var:FindFirstChildWhichIsA("Script")
                        if scriptObj then
                            local name = scriptObj.Name
                            if isTarget(VARIANTS, name) then
                                if espEnabled then applyESP(fruit:FindFirstChildWhichIsA("BasePart"), labelMaker(name, weight)) end
                                collectFruit(fruit)
                                continue
                            end
                        end
                    end
                end
            end
        end
    end
end)
