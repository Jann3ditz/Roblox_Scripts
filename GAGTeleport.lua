-- ✅ Updated Teleport Menu with "Farm" Tab containing integrated AutoBuy Seeds + Gear
-- Reuses existing contentFrame (right side) from Teleport GUI to show the AutoBuy UI

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
	["Farm"] = {} -- Placeholder tab for AutoBuy
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

local function renderFarmAutoBuy()
	for _, child in ipairs(contentFrame:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end

	local function createButton(name, isSeed)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 26)
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
			local list = isSeed and selectedSeeds or selectedGears
			if selected then
				table.insert(list, name)
			else
				for i, v in ipairs(list) do
					if v == name then table.remove(list, i) break end
				end
			end
		end)

		btn.Parent = contentFrame
	end

	local function createToggle(name, isSeed)
		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(1, -10, 0, 28)
		toggle.Text = name .. ": OFF"
		toggle.Font = Enum.Font.GothamBold
		toggle.TextSize = 13
		toggle.TextColor3 = Color3.new(1, 1, 1)
		toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
		toggle.BorderSizePixel = 0
		toggle.Parent = contentFrame

		toggle.MouseButton1Click:Connect(function()
			if isSeed then
				autoBuySeeds = not autoBuySeeds
				toggle.Text = name .. ": " .. (autoBuySeeds and "ON" or "OFF")
				toggle.BackgroundColor3 = autoBuySeeds and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
			else
				autoBuyGear = not autoBuyGear
				toggle.Text = name .. ": " .. (autoBuyGear and "ON" or "OFF")
				toggle.BackgroundColor3 = autoBuyGear and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
			end
		end)
	end

	for _, seed in ipairs(seedItems) do
		createButton(seed, true)
	end

	createToggle("Auto Buy Seeds", true)

	for _, gear in ipairs(gearItems) do
		createButton(gear, false)
	end

	createToggle("Auto Buy Gear", false)

	contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
end

task.spawn(function()
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
end)

-- 🔽 inside the for loop that builds tab buttons:
-- catBtn.MouseButton1Click:Connect(function()
--   if categoryName == "Farm" then
--     renderFarmAutoBuy()
--   else
--     showCategory(categoryName)
--   end
-- end)
-- 👆 add that check to load Farm GUI in contentFrame
