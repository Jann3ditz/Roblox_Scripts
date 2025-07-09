-- ⚡ Auto Buy + Player Speed TextBox GUI (with Apply Toggle)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuySeeds, autoBuyGear = false, false
local selectedSeeds, selectedGears = {}, {}
local seedItems = {"Strawberry", "Orange Tulip", "Tomato", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Sugar Apple", "Burning Bud"}
local gearItems = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advance Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Friendship Pot"}

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

-- Open Button
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

-- Main Frame (container)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

-- Tab Buttons
local autoBuyTab = Instance.new("TextButton", main)
autoBuyTab.Size = UDim2.new(0, 100, 0, 30)
autoBuyTab.Position = UDim2.new(0, 10, 0, 10)
autoBuyTab.Text = "Auto Buy"
autoBuyTab.Font = Enum.Font.GothamBold
autoBuyTab.TextColor3 = Color3.new(1, 1, 1)
autoBuyTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

local playerTab = Instance.new("TextButton", main)
playerTab.Size = UDim2.new(0, 100, 0, 30)
playerTab.Position = UDim2.new(0, 120, 0, 10)
playerTab.Text = "Player"
playerTab.Font = Enum.Font.GothamBold
playerTab.TextColor3 = Color3.new(1, 1, 1)
playerTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Content Frames
local autoBuyFrame = Instance.new("Frame", main)
autoBuyFrame.Size = UDim2.new(1, -20, 1, -50)
autoBuyFrame.Position = UDim2.new(0, 10, 0, 50)
autoBuyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoBuyFrame.Visible = true

local playerFrame = Instance.new("Frame", main)
playerFrame.Size = autoBuyFrame.Size
playerFrame.Position = autoBuyFrame.Position
playerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerFrame.Visible = false

-- Tab Switch Logic
local function showTab(tab)
    autoBuyFrame.Visible = (tab == "auto")
    playerFrame.Visible = (tab == "player")
    autoBuyTab.BackgroundColor3 = tab == "auto" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
    playerTab.BackgroundColor3 = tab == "player" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
end

logo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
autoBuyTab.MouseButton1Click:Connect(function() showTab("auto") end)
playerTab.MouseButton1Click:Connect(function() showTab("player") end)

-- Multi-select sections
local function createMultiSelectSection(titleText, itemList, parent, isSeed)
    local frame = Instance.new("ScrollingFrame", parent)
    frame.Size = UDim2.new(0.5, -15, 1, -100)
    frame.Position = isSeed and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, 5, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.ScrollBarThickness = 6
    frame.CanvasSize = UDim2.new(0, 0, 2, 0)

    local layout = Instance.new("UIListLayout", frame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)

    local label = Instance.new("TextLabel", frame)
    label.Text = titleText
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14

    for _, itemName in ipairs(itemList) do
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -10, 0, 24)
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.Text = itemName
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.BorderSizePixel = 0

        local sel = false
        btn.MouseButton1Click:Connect(function()
            sel = not sel
            btn.BackgroundColor3 = sel and Color3.fromRGB(0,170,0) or Color3.fromRGB(70,70,70)
            local list = isSeed and selectedSeeds or selectedGears
            if sel then table.insert(list, itemName)
            else
                for i,v in ipairs(list) do
                    if v == itemName then table.remove(list,i); break
                end
            end
        end)
    end
end

createMultiSelectSection("Seed Shop", seedItems, autoBuyFrame, true)
createMultiSelectSection("Gear Shop", gearItems, autoBuyFrame, false)

-- Auto Buy Toggles + Buy All
local function createGlobalToggle(name, posX, isSeed)
    local btn = Instance.new("TextButton", autoBuyFrame)
    btn.Size = UDim2.new(0.25, -10, 0, 26)
    btn.Position = UDim2.new(posX, 0, 1, -60)
    btn.Text = name .. ": OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    btn.MouseButton1Click:Connect(function()
        if isSeed then
            autoBuySeeds = not autoBuySeeds
            btn.Text = name .. ": " .. (autoBuySeeds and "ON" or "OFF")
            btn.BackgroundColor3 = autoBuySeeds and Color3.fromRGB(0,170,0) or Color3.fromRGB(150,0,0)
        else
            autoBuyGear = not autoBuyGear
            btn.Text = name .. ": " .. (autoBuyGear and "ON" or "OFF")
            btn.BackgroundColor3 = autoBuyGear and Color3.fromRGB(0,170,0) or Color3.fromRGB(150,0,0)
        end
    end)
end

local function createBuyAllButton(text, posX, isSeed)
    local btn = Instance.new("TextButton", autoBuyFrame)
    btn.Size = UDim2.new(0.25, -10, 0, 26)
    btn.Position = UDim2.new(posX, 0, 1, -30)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(0,120,180)
    btn.MouseButton1Click:Connect(function()
        local list = isSeed and seedItems or gearItems
        local remote = isSeed and seedBuy or gearBuy
        for _, item in ipairs(list) do
            remote:FireServer(item)
        end
    end)
end

-- Toggles and Buy All Buttons
createGlobalToggle("Auto Buy Seeds", 0, true)
createBuyAllButton("Buy All Seeds", 0.25, true)

createGlobalToggle("Auto Buy Gear", 0.5, false)
createBuyAllButton("Buy All Gear", 0.75, false)

-- Player Tab: Speed Input + Toggle
local walkSpeed = player.PlayerGui:GetAttribute("SavedSpeed") or 16
local minSpeed, maxSpeed = 16, 999

local speedLabel = Instance.new("TextLabel", playerFrame)
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.Text = "WalkSpeed: " .. walkSpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14

local speedInput = Instance.new("TextBox", playerFrame)
speedInput.Size = UDim2.new(1, -20, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 50)
speedInput.PlaceholderText = "Enter Speed ("..minSpeed.."–"..maxSpeed..")"
speedInput.Text = tostring(walkSpeed)
speedInput.ClearTextOnFocus = false
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val >= minSpeed and val <= maxSpeed then
        walkSpeed = val
        player.PlayerGui:SetAttribute("SavedSpeed", walkSpeed)
        speedLabel.Text = "WalkSpeed: " .. walkSpeed
    else
        speedInput.Text = tostring(walkSpeed)
    end
end)

local applyToggle = Instance.new("TextButton", playerFrame)
applyToggle.Size = UDim2.new(0, 140, 0, 30)
applyToggle.Position = UDim2.new(0.5, -70, 0, 90)
applyToggle.Text = "Apply Speed: OFF"
applyToggle.Font = Enum.Font.GothamBold
applyToggle.TextSize = 14
applyToggle.TextColor3 = Color3.new(1,1,1)
applyToggle.BackgroundColor3 = Color3.fromRGB(150,0,0)

local speedApplyOn = false
applyToggle.MouseButton1Click:Connect(function()
    speedApplyOn = not speedApplyOn
    applyToggle.Text = "Apply Speed: " .. (speedApplyOn and "ON" or "OFF")
    applyToggle.BackgroundColor3 = speedApplyOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(150,0,0)
end)

-- Loops
task.spawn(function()
    while true do
        task.wait(1)
        if autoBuySeeds then
            for _, seed in ipairs(selectedSeeds) do seedBuy:FireServer(seed) end
        end
        if autoBuyGear then
            for _, gear in ipairs(selectedGears) do gearBuy:FireServer(gear) end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(3)
        if speedApplyOn then
            local char = player.Character or player.CharacterAdded:Wait()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = walkSpeed end
        end
    end
end)

-- Show default tab
showTab("auto")
