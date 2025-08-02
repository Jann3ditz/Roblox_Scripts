-- ⚡ Auto Buy + Player Speed + Jump + Quest GUI (Mobile-Optimized MultiSelect v4)

-- [SERVICES]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")
local petEggBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")

-- [ENSURE PETS & GEAR GUI VISIBILITY IN Teleport_UI]
task.spawn(function()
	local success, err = pcall(function()
		local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
		local teleportUI = playerGui:WaitForChild("Teleport_UI")
		local frame = teleportUI:WaitForChild("Frame")
		frame:WaitForChild("Pets").Visible = true
		frame:WaitForChild("Gear").Visible = true
	end)
	if not success then
		warn("Failed to show Pets or Gear UI:", err)
	end
end)

-- [STATES]
local autoBuySeeds, autoBuyGear, autoBuyEgg = false, false, false
local selectedSeeds, selectedGears, selectedEggs = {}, {}, {}
local customSpeed, customJump = 32, 50

-- [DATA]
local seedItems = { "Carrot", "Strawberry", "Blueberry" ,"Orange Tulip", "Tomato", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone Seed"}
local gearItems = {"Watering Can", "Trading Ticket", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Friendship Pot", "Harvest Tool", "Tanning Mirror", "Levelup Lollipop", "Medium Treat", "Medium Toy"}
local eggItems = {"Common Egg", "Common Summer Egg", "Rare Summer Egg", "Mythical Egg", "Paradise Egg" , "Bug Egg"}

-- [GUI ROOT]
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"
gui.ResetOnSpawn = false

-- [LOGO BUTTON (DRAGGABLE)]
local logo = Instance.new("TextButton")
logo.Name = "logo"
logo.Parent = gui
logo.Position = UDim2.new(0, 10, 0, 10)
logo.Size = UDim2.new(0, 0, 0, 30)
logo.AutomaticSize = Enum.AutomaticSize.X
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "ᴊᴀɴɴ"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20
logo.TextXAlignment = Enum.TextXAlignment.Center
logo.TextYAlignment = Enum.TextYAlignment.Center
logo.BackgroundTransparency = 0

local padding = Instance.new("UIPadding")
padding.Parent = logo
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)

-- [DRAG HANDLE ICON]
local dragIcon = Instance.new("ImageLabel", logo)
dragIcon.Name = "DragHandle"
dragIcon.Size = UDim2.new(0, 16, 0, 16)
dragIcon.Position = UDim2.new(1, 4, 0.5, -8)
dragIcon.BackgroundTransparency = 1
dragIcon.Image = "rbxassetid://15190075990"
dragIcon.ScaleType = Enum.ScaleType.Fit

-- [DRAG LOGO ON HOLD]
do
	local dragging = false
	local dragStart, startPos
	local longPressActive = false
	local longPressTime = 0.5

	logo.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			longPressActive = true
			dragStart = input.Position
			startPos = logo.Position
			task.delay(longPressTime, function()
				if longPressActive then
					dragging = true
				end
			end)
		end
	end)

	logo.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			longPressActive = false
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			logo.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- [MAIN GUI WINDOW]
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0.9, 0, 0.9, 0)
main.Position = UDim2.new(0.05, 0, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

-- [TABS]
local function createTab(name, x)
	local tab = Instance.new("TextButton", main)
	tab.Size = UDim2.new(0, 100, 0, 30)
	tab.Position = UDim2.new(0, x, 0, 10)
	tab.Text = name
	tab.Font = Enum.Font.GothamBold
	tab.TextColor3 = Color3.new(1, 1, 1)
	tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	return tab
end

local autoBuyTab = createTab("Auto Buy", 10)
local playerTab = createTab("Player", 120)
local questTab = createTab("Quest", 230)

-- [FRAMES]
local autoBuyFrame = Instance.new("Frame", main)
autoBuyFrame.Size = UDim2.new(1, -20, 1, -50)
autoBuyFrame.Position = UDim2.new(0, 10, 0, 50)
autoBuyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoBuyFrame.Visible = true

local playerFrame = autoBuyFrame:Clone()
playerFrame.Parent = main
playerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerFrame.Visible = false

local questFrame = autoBuyFrame:Clone()
questFrame.Parent = main
questFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
questFrame.Visible = false

-- [PLAYER SPEED & JUMP]
local speedBox = Instance.new("TextBox", playerFrame)
speedBox.Size = UDim2.new(0, 140, 0, 30)
speedBox.Position = UDim2.new(0, 20, 0, 20)
speedBox.PlaceholderText = "Enter speed (e.g. 32)"
speedBox.Text = ""
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.BackgroundColor3 = Color3.fromRGB(90, 90, 120)
speedBox.TextColor3 = Color3.new(1, 1, 1)

local applySpeed = Instance.new("TextButton", playerFrame)
applySpeed.Size = UDim2.new(0, 100, 0, 30)
applySpeed.Position = UDim2.new(0, 170, 0, 20)
applySpeed.Text = "Apply Speed"
applySpeed.Font = Enum.Font.GothamBold
applySpeed.TextSize = 14
applySpeed.BackgroundColor3 = Color3.fromRGB(80, 60, 90)
applySpeed.TextColor3 = Color3.new(1, 1, 1)

local jumpBox = speedBox:Clone()
jumpBox.PlaceholderText = "Enter jump (e.g. 50)"
jumpBox.Position = UDim2.new(0, 20, 0, 60)
jumpBox.Text = ""
jumpBox.Parent = playerFrame

-- [NOCLIP TOGGLE]
local noclip = false

local noclipBtn = Instance.new("TextButton", playerFrame)
noclipBtn.Size = UDim2.new(0, 120, 0, 30)
noclipBtn.Position = UDim2.new(0, 20, 0, 100)
noclipBtn.Text = "Toggle Noclip"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 14
noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 100)
noclipBtn.TextColor3 = Color3.new(1, 1, 1)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "✅ Noclip On" or "Toggle Noclip"
end)

game:GetService("RunService").Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

local applyJump = applySpeed:Clone()
applyJump.Text = "Apply Jump"
applyJump.Position = UDim2.new(0, 170, 0, 60)
applyJump.Parent = playerFrame

applySpeed.MouseButton1Click:Connect(function()
	local val = tonumber(speedBox.Text)
	if val then customSpeed = val end
end)

applyJump.MouseButton1Click:Connect(function()
	local val = tonumber(jumpBox.Text)
	if val then customJump = val end
end)

spawn(function()
	while true do
		pcall(function()
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = customSpeed
				hum.JumpPower = customJump
			end
		end)
		task.wait(0.5)
	end
end)

-- 🛒 One-Time Auto Sell Inventory Button
-- AUTO SELL INVENTORY BUTTON (One-time Sell)
local autoSellButton = Instance.new("TextButton")
autoSellButton.Name = "AutoSellInventoryButton"
autoSellButton.Parent = playerFrame
autoSellButton.Size = UDim2.new(0, 180, 0, 35)
autoSellButton.Position = UDim2.new(0, 10, 0, 170) -- adjust Y (170) as needed to avoid overlap
autoSellButton.Text = "Sell Inventory"
autoSellButton.Font = Enum.Font.GothamBold
autoSellButton.TextSize = 14
autoSellButton.TextColor3 = Color3.new(1, 1, 1)
autoSellButton.BackgroundColor3 = Color3.fromRGB(85, 90, 120)
autoSellButton.BorderSizePixel = 0
autoSellButton.AutoButtonColor = true

autoSellButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("GameEvents")
            :WaitForChild("Sell_Inventory")
            :FireServer()
    end)
    if success then
        autoSellButton.Text = "Sold!"
        task.wait(1)
        autoSellButton.Text = "Sell Inventory"
    else
        autoSellButton.Text = "Error"
        warn("Sell failed:", err)
        task.wait(1)
        autoSellButton.Text = "Sell Inventory"
    end
end)

local player = game:GetService("Players").LocalPlayer
local touchGui = player:WaitForChild("PlayerGui"):FindFirstChild("TouchGui")

if touchGui then
	touchGui.Enabled = true -- Ensure TouchGui itself is enabled

	-- Optional: Force-enable jump button if it exists
	local jumpButton = touchGui:FindFirstChild("JumpButton", true) -- search deep
	if jumpButton then
		jumpButton.Visible = true
		jumpButton.Active = true
	end
end


-- [QUEST SHORTCUTS]
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
		if targetUI then targetUI.Enabled = not targetUI.Enabled end
	end)
end

local player = game:GetService("Players").LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local EventShopUI = PlayerGui:FindFirstChild("EventShop_UI")
local dailyUI = PlayerGui:FindFirstChild("DailyQuests_UI")
local merchantUI = PlayerGui:FindFirstChild("TravelingMerchantShop_UI")

-- ✅ Correct UI names for Seed and Gear Shop
local SeedShopUI = PlayerGui:FindFirstChild("Seed_Shop")
local GearShopUI = PlayerGui:FindFirstChild("Gear_Shop")

-- 🔒 Hide all shop UIs by default
if EventShopUI then EventShopUI.Enabled = false end
if dailyUI then dailyUI.Enabled = false end
if merchantUI then merchantUI.Enabled = false end
if SeedShopUI then SeedShopUI.Enabled = false end
if GearShopUI then GearShopUI.Enabled = false end

-- 🧭 Create toggle buttons in Quest tab
createQuestButton("Tranquil Treasures", 0, EventShopUI)
createQuestButton("Daily Quest", 1, dailyUI)
createQuestButton("Travelling Merchant", 2, merchantUI)
createQuestButton("Seed Shop", 3, SeedShopUI)
createQuestButton("Gear Shop", 4, GearShopUI)

-- [MULTISELECT SYSTEM]
local function createMultiSelectSection(name, items, parent, selectedTable)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1/3, -10, 1, -50)
	holder.BackgroundTransparency = 1

	local list = Instance.new("ScrollingFrame", holder)
	list.Size = UDim2.new(1, 0, 1, -50)
	list.CanvasSize = UDim2.new(0, 0, 0, #items * 30)
	list.ScrollBarThickness = 4
	list.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	list.BackgroundTransparency = 0.4

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
			if selectedTable[item] then
				selectedTable[item] = nil
				btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			else
				selectedTable[item] = true
				btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			end
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

local seedSection, seedToggle = createMultiSelectSection("AutoBuy Seeds", seedItems, autoBuyFrame, selectedSeeds)
local gearSection, gearToggle = createMultiSelectSection("AutoBuy Gear", gearItems, autoBuyFrame, selectedGears)
local eggSection, eggToggle = createMultiSelectSection("AutoBuy Egg", eggItems, autoBuyFrame, selectedEggs)

seedSection.Position = UDim2.new(0/3, 0, 0, 0)
gearSection.Position = UDim2.new(1/3, 5, 0, 0)
eggSection.Position = UDim2.new(2/3, 10, 0, 0)

seedToggle.MouseButton1Click:Connect(function()
	autoBuySeeds = not autoBuySeeds
	seedToggle.Text = autoBuySeeds and "✅ AutoBuy Seeds" or "Toggle AutoBuy Seeds"
end)
local seedsSelected = false
local selectAllSeeds = Instance.new("TextButton", seedSection)
selectAllSeeds.Size = UDim2.new(1, 0, 0, 30)
selectAllSeeds.Position = UDim2.new(0, 0, 1, 0)
selectAllSeeds.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
selectAllSeeds.TextColor3 = Color3.new(1, 1, 1)
selectAllSeeds.Font = Enum.Font.GothamBold
selectAllSeeds.TextSize = 14
selectAllSeeds.Text = "Select All Seeds"

selectAllSeeds.MouseButton1Click:Connect(function()
	seedsSelected = not seedsSelected
	selectAllSeeds.Text = seedsSelected and "Unselect All Seeds" or "Select All Seeds"

	for _, btn in pairs(seedSection:GetDescendants()) do
		if btn:IsA("TextButton") and btn.Text ~= seedToggle.Text and btn.Text ~= selectAllSeeds.Text then
			if seedsSelected then
				selectedSeeds[btn.Text] = true
				btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			else
				selectedSeeds[btn.Text] = nil
				btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			end
		end
	end
end)

gearToggle.MouseButton1Click:Connect(function()
	autoBuyGear = not autoBuyGear
	gearToggle.Text = autoBuyGear and "✅ AutoBuy Gear" or "Toggle AutoBuy Gear"
end)
local gearsSelected = false
local selectAllGears = Instance.new("TextButton", gearSection)
selectAllGears.Size = UDim2.new(1, 0, 0, 30)
selectAllGears.Position = UDim2.new(0, 0, 1, 0)
selectAllGears.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
selectAllGears.TextColor3 = Color3.new(1, 1, 1)
selectAllGears.Font = Enum.Font.GothamBold
selectAllGears.TextSize = 14
selectAllGears.Text = "Select All Gear"

selectAllGears.MouseButton1Click:Connect(function()
	gearsSelected = not gearsSelected
	selectAllGears.Text = gearsSelected and "Unselect All Gear" or "Select All Gear"

	for _, btn in pairs(gearSection:GetDescendants()) do
		if btn:IsA("TextButton") and btn.Text ~= gearToggle.Text and btn.Text ~= selectAllGears.Text then
			if gearsSelected then
				selectedGears[btn.Text] = true
				btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			else
				selectedGears[btn.Text] = nil
				btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			end
		end
	end
end)
eggToggle.MouseButton1Click:Connect(function()
	autoBuyEgg = not autoBuyEgg
	eggToggle.Text = autoBuyEgg and "✅ AutoBuy Egg" or "Toggle AutoBuy Egg"
end)
local eggsSelected = false
local selectAllEggs = Instance.new("TextButton", eggSection)
selectAllEggs.Size = UDim2.new(1, 0, 0, 30)
selectAllEggs.Position = UDim2.new(0, 0, 1, 0)
selectAllEggs.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
selectAllEggs.TextColor3 = Color3.new(1, 1, 1)
selectAllEggs.Font = Enum.Font.GothamBold
selectAllEggs.TextSize = 14
selectAllEggs.Text = "Select All Eggs"

selectAllEggs.MouseButton1Click:Connect(function()
	eggsSelected = not eggsSelected
	selectAllEggs.Text = eggsSelected and "Unselect All Eggs" or "Select All Eggs"

	for _, btn in pairs(eggSection:GetDescendants()) do
		if btn:IsA("TextButton") and btn.Text ~= eggToggle.Text and btn.Text ~= selectAllEggs.Text then
			if eggsSelected then
				selectedEggs[btn.Text] = true
				btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			else
				selectedEggs[btn.Text] = nil
				btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			end
		end
	end
end)

-- [TAB SWITCHING]
local function showTab(which)
	autoBuyFrame.Visible = which == "auto"
	playerFrame.Visible = which == "player"
	questFrame.Visible = which == "quest"
	autoBuyTab.BackgroundColor3 = which == "auto" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
	playerTab.BackgroundColor3 = which == "player" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
	questTab.BackgroundColor3 = which == "quest" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
end

logo.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
autoBuyTab.MouseButton1Click:Connect(function() showTab("auto") end)
playerTab.MouseButton1Click:Connect(function() showTab("player") end)
questTab.MouseButton1Click:Connect(function() showTab("quest") end)

-- [AUTO BUY LOOP]
spawn(function()
	while true do
		if autoBuySeeds then for name in pairs(selectedSeeds) do seedBuy:FireServer(name) end end
		if autoBuyGear then for name in pairs(selectedGears) do gearBuy:FireServer(name) end end
		if autoBuyEgg then for name in pairs(selectedEggs) do petEggBuy:FireServer(name) end end
		task.wait(1.5)
	end
end)
