-- ⚡ Auto Buy + Player Speed + Quest GUI (Mobile-Optimized v3)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")
local petEggBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")

local autoBuySeeds, autoBuyGear, autoBuyEgg = false, false, false
local selectedSeed, selectedGear, selectedEgg = nil, nil, nil

local seedItems = {"Strawberry", "Orange Tulip", "Tomato", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone Seed"}
local gearItems = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Friendship Pot", "Harvest Tool", "Tanning Mirror", "Levelup Lollipop", "Medium Treat", "Medium Toy"}
local eggItems = {"Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg", "Bee Egg", "Bug Egg", "Common Summer Egg", "Rare Summer Egg", "Paradise Egg", "Oasis Egg"}

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0.9, 0, 0.9, 0)
main.Position = UDim2.new(0.05, 0, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

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

local questTab = Instance.new("TextButton", main)
questTab.Size = UDim2.new(0, 100, 0, 30)
questTab.Position = UDim2.new(0, 230, 0, 10)
questTab.Text = "Quest"
questTab.Font = Enum.Font.GothamBold
questTab.TextColor3 = Color3.new(1, 1, 1)
questTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

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

local questFrame = Instance.new("Frame", main)
questFrame.Size = autoBuyFrame.Size
questFrame.Position = autoBuyFrame.Position
questFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
questFrame.Visible = false

local dinoUI = player.PlayerGui:FindFirstChild("DinoQuests_UI")
local dailyUI = player.PlayerGui:FindFirstChild("DailyQuests_UI")
local merchantUI = player.PlayerGui:FindFirstChild("TravelingMerchantShop_UI")

local function createQuestButton(text, order, targetUI)
    local btn = Instance.new("TextButton", questFrame)
    btn.Size = UDim2.new(0.6, 0, 0, 32)
    btn.Position = UDim2.new(0.2, 0, 0, 10 + order * 40)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60, 100, 120)
    btn.MouseButton1Click:Connect(function()
        if targetUI then
            targetUI.Enabled = not targetUI.Enabled
        end
    end)
end

createQuestButton("Dino Quest", 0, dinoUI)
createQuestButton("Daily Quest", 1, dailyUI)
createQuestButton("Travelling Merchant", 2, merchantUI)

local speedToggle = Instance.new("TextButton", playerFrame)
speedToggle.Size = UDim2.new(0, 200, 0, 30)
speedToggle.Position = UDim2.new(0, 20, 0, 20)
speedToggle.Text = "Speed: OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 14
speedToggle.BackgroundColor3 = Color3.fromRGB(80, 60, 90)
speedToggle.TextColor3 = Color3.new(1, 1, 1)

local speedEnabled = false
local customSpeed = 32

speedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedToggle.Text = speedEnabled and "Speed: ON ✅" or "Speed: OFF"
end)

spawn(function()
    while true do
        if speedEnabled then
            pcall(function()
                player.Character.Humanoid.WalkSpeed = customSpeed
            end)
        end
        task.wait(0.5)
    end
end)

local function createList(name, items, parent, onSelect)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1/3, -10, 1, -50)
    holder.BackgroundTransparency = 1
    local list = Instance.new("ScrollingFrame", holder)
    list.Size = UDim2.new(1, 0, 1, -50)
    list.CanvasSize = UDim2.new(0, 0, 0, #items * 30)
    list.ScrollBarThickness = 4
    list.BackgroundTransparency = 0.4
    list.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local layout = Instance.new("UIListLayout", list)
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    for _, item in ipairs(items) do
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Text = item
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.MouseButton1Click:Connect(function()
            for _, sibling in ipairs(list:GetChildren()) do
                if sibling:IsA("TextButton") then
                    sibling.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            onSelect(item)
        end)
    end

    local toggle = Instance.new("TextButton", holder)
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.Position = UDim2.new(0, 0, 1, -30)
    toggle.BackgroundColor3 = Color3.fromRGB(90, 90, 120)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.Text = "Toggle " .. name
    return holder, toggle
end

local seedSection, seedToggle = createList("AutoBuy Seeds", seedItems, autoBuyFrame, function(name)
    selectedSeed = name
end)
local gearSection, gearToggle = createList("AutoBuy Gear", gearItems, autoBuyFrame, function(name)
    selectedGear = name
end)
local eggSection, eggToggle = createList("AutoBuy Egg", eggItems, autoBuyFrame, function(name)
    selectedEgg = name
end)

seedSection.Position = UDim2.new(0/3, 0, 0, 0)
gearSection.Position = UDim2.new(1/3, 5, 0, 0)
eggSection.Position = UDim2.new(2/3, 10, 0, 0)

seedToggle.MouseButton1Click:Connect(function()
    autoBuySeeds = not autoBuySeeds
    seedToggle.Text = (autoBuySeeds and "✅ AutoBuy Seeds") or "Toggle AutoBuy Seeds"
end)
gearToggle.MouseButton1Click:Connect(function()
    autoBuyGear = not autoBuyGear
    gearToggle.Text = (autoBuyGear and "✅ AutoBuy Gear") or "Toggle AutoBuy Gear"
end)
eggToggle.MouseButton1Click:Connect(function()
    autoBuyEgg = not autoBuyEgg
    eggToggle.Text = (autoBuyEgg and "✅ AutoBuy Egg") or "Toggle AutoBuy Egg"
end)

logo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

autoBuyTab.MouseButton1Click:Connect(function()
    autoBuyFrame.Visible = true
    playerFrame.Visible = false
    questFrame.Visible = false
    autoBuyTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    playerTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    questTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

playerTab.MouseButton1Click:Connect(function()
    autoBuyFrame.Visible = false
    playerFrame.Visible = true
    questFrame.Visible = false
    playerTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    autoBuyTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    questTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

questTab.MouseButton1Click:Connect(function()
    autoBuyFrame.Visible = false
    playerFrame.Visible = false
    questFrame.Visible = true
    questTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    autoBuyTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    playerTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

spawn(function()
    while true do
        if autoBuySeeds and selectedSeed then
            seedBuy:FireServer(selectedSeed)
        end
        if autoBuyGear and selectedGear then
            gearBuy:FireServer(selectedGear)
        end
        if autoBuyEgg and selectedEgg then
            petEggBuy:FireServer(selectedEgg)
        end
        task.wait(1.5)
    end
end)
