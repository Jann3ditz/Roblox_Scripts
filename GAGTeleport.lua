-- ✅ Updated Teleport Menu with "Farm" Tab containing integrated AutoBuy Seeds + Gear (Side-by-Side Layout)

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local tpSound = Instance.new("Sound")
tpSound.SoundId = "rbxassetid://9118823105"
tpSound.Volume = 1
tpSound.Parent = screenGui

local teleportPositions = {
	["Seed Shop"] = Vector3.new(87, 3, -27),
	["Sell"] = Vector3.new(87, 3, 0),
	["Prehistoric Quest"] = Vector3.new(-92, 4, -12),
	["Prehistoric Exchange"] = Vector3.new(-109, 4, -20),
	["Prehistoric Crafting"] = Vector3.new(-94, 4, -22),
	["Gear Shop"] = Vector3.new(-285, 3, -14),
	["Pet Shop"] = Vector3.new(-286, 3, -2),
	["Crafting Area"] = Vector3.new(-284, 3, -31),
	["Cosmetic Shop"] = Vector3.new(-287, 3, -25),
}

local groupedButtons = {
	["Teleport"] = {
		"Garden", "Seed Shop", "Sell", "Prehistoric Quest", "Prehistoric Exchange",
		"Prehistoric Crafting", "Gear Shop", "Pet Shop", "Crafting Area", "Cosmetic Shop"
	},
	["Access Shops"] = {
		"🗿Travelling Merchant Shop🗿",
		"🛒Gear Shop",
		"🌱Seed Shop",
		"🎨Cosmetic Shop"
	},
	["Quests"] = {
		"🦖Dino Quests",
		"📅Daily Quests"
	},
	["Farm"] = {}
}

local gearBuy = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuySeeds = false
local autoBuyGear = false
local selectedSeeds = {}
local selectedGears = {}

local seedItems = {
	"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Daffodil",
	"Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus",
	"Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao",
	"Beanstalk", "Sugar Apple", "Burning Bud"
}

local gearItems = {
	"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler",
	"Advance Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler",
	"Cleaning Spray", "Favorite Tool", "Friendship Pot"
}

-- UI Setup
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 360, 0, 280)
menuFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BorderSizePixel = 0
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Visible = false
menuFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🌀 Teleport Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BorderSizePixel = 0
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = menuFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.Text = "✖"
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BorderSizePixel = 0
closeBtn.Parent = menuFrame
closeBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
end)

local categoryFrame = Instance.new("Frame")
categoryFrame.Size = UDim2.new(0, 100, 1, -80)
categoryFrame.Position = UDim2.new(0, 0, 0, 40)
categoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
categoryFrame.BorderSizePixel = 0
categoryFrame.Parent = menuFrame

local catLayout = Instance.new("UIListLayout")
catLayout.SortOrder = Enum.SortOrder.LayoutOrder
catLayout.Padding = UDim.new(0, 5)
catLayout.Parent = categoryFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -100, 1, -80)
contentFrame.Position = UDim2.new(0, 100, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = menuFrame

local leftScroll = Instance.new("ScrollingFrame", contentFrame)
leftScroll.Size = UDim2.new(0.48, -5, 1, -30)
leftScroll.Position = UDim2.new(0, 0, 0, 0)
leftScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
leftScroll.ScrollBarThickness = 4
leftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
leftScroll.ScrollingDirection = Enum.ScrollingDirection.Y
leftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local leftLayout = Instance.new("UIListLayout", leftScroll)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0, 2)

local rightScroll = Instance.new("ScrollingFrame", contentFrame)
rightScroll.Size = UDim2.new(0.48, -5, 1, -30)
rightScroll.Position = UDim2.new(0.52, 0, 0, 0)
rightScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rightScroll.ScrollBarThickness = 4
rightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
rightScroll.ScrollingDirection = Enum.ScrollingDirection.Y
rightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local rightLayout = Instance.new("UIListLayout", rightScroll)
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
rightLayout.Padding = UDim.new(0, 2)

local function makeItem(name, list, scroll)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 24)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.BorderSizePixel = 0

	local selected = false
	btn.MouseButton1Click:Connect(function()
		selected = not selected
		btn.BackgroundColor3 = selected and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
		if selected then
			table.insert(list, name)
		else
			for i, v in ipairs(list) do
				if v == name then table.remove(list, i) break end
			end
		end
	end)

	btn.Parent = scroll
end

local function makeToggle(label, isSeed)
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, -6, 0, 26)
	toggle.Text = label .. ": OFF"
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 13
	toggle.TextColor3 = Color3.new(1, 1, 1)
	toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	toggle.BorderSizePixel = 0
	
toggle.MouseButton1Click:Connect(function()
		if isSeed then
			autoBuySeeds = not autoBuySeeds
			toggle.Text = label .. ": " .. (autoBuySeeds and "ON" or "OFF")
			toggle.BackgroundColor3 = autoBuySeeds and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
		else
			autoBuyGear = not autoBuyGear
			toggle.Text = label .. ": " .. (autoBuyGear and "ON" or "OFF")
			toggle.BackgroundColor3 = autoBuyGear and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
		end
	end)

	return toggle
end

local function renderFarm()
	leftScroll:ClearAllChildren()
	rightScroll:ClearAllChildren()

	for _, seed in ipairs(seedItems) do
		makeItem(seed, selectedSeeds, leftScroll)
	end
	makeToggle("Auto Buy Seeds", true).Parent = leftScroll

	for _, gear in ipairs(gearItems) do
		makeItem(gear, selectedGears, rightScroll)
	end
	makeToggle("Auto Buy Gear", false).Parent = rightScroll
end

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 40)
credit.Position = UDim2.new(0, 0, 1, -40)
credit.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
credit.Text = "👤 Credits to JannPlays"
credit.TextColor3 = Color3.new(1, 1, 1)
credit.Font = Enum.Font.GothamBold
credit.TextScaled = true
credit.Parent = menuFrame

for categoryName, _ in pairs(groupedButtons) do
	local catBtn = Instance.new("TextButton")
	catBtn.Size = UDim2.new(1, -10, 0, 30)
	catBtn.Text = categoryName
	catBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	catBtn.TextColor3 = Color3.new(1, 1, 1)
	catBtn.Font = Enum.Font.GothamBold
	catBtn.TextScaled = true
	catBtn.BorderSizePixel = 0
	catBtn.Parent = categoryFrame

	catBtn.MouseButton1Click:Connect(function()
		if categoryName == "Farm" then
			renderFarm()
		else
			leftScroll:ClearAllChildren()
			rightScroll:ClearAllChildren()
			-- put original category logic here if needed
		end
	end)
end

local logoDrag = Instance.new("TextButton")
logoDrag.Size = UDim2.new(0, 60, 0, 60)
logoDrag.Position = UDim2.new(0.5, -30, 0.1, 0)
logoDrag.BackgroundTransparency = 1
logoDrag.Text = "⚡Jann"
logoDrag.TextColor3 = Color3.fromRGB(255, 255, 0)
logoDrag.Font = Enum.Font.GothamBold
logoDrag.TextScaled = true
logoDrag.Active = true
logoDrag.Draggable = true
logoDrag.Parent = screenGui

logoDrag.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- AutoBuy loop
while true do
	task.wait(1)
	if autoBuySeeds then
		for _, seed in ipairs(selectedSeeds) do
			seedBuy:FireServer(seed)
		end
	end
	if autoBuyGear then
		for _, gear in ipairs(selectedGears) do
			gearBuy:FireServer(gear)
		end
	end
end
