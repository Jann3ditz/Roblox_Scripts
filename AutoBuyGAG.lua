-- ⚡Jann Auto Buy GUI (Grow a Garden)
-- Auto-buys specific Seed and Gear items every 1 second with toggle switches and compact layout

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuyEnabled = false
local selectedSeedItems = {}
local selectedGearItems = {}

-- Complete Item Lists
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
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 280)
main.Position = UDim2.new(0, 10, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Name = "MainFrame"

-- Logo ⚡Jann
local logo = Instance.new("TextLabel", main)
logo.Size = UDim2.new(1, 0, 0, 30)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

-- Scrollable seed/gear selector
local function createItemList(titleText, items, xOffset, selectedTable)
	local title = Instance.new("TextLabel", main)
	title.Position = UDim2.new(0, xOffset, 0, 35)
	title.Size = UDim2.new(0, 180, 0, 18)
	title.Text = titleText
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 12

	local holder = Instance.new("ScrollingFrame", main)
	holder.Position = UDim2.new(0, xOffset, 0, 55)
	holder.Size = UDim2.new(0, 180, 0, 170)
	holder.CanvasSize = UDim2.new(0, 0, 0, #items * 22)
	holder.ScrollBarThickness = 4
	holder.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

	for i, name in ipairs(items) do
		local button = Instance.new("TextButton", holder)
		button.Size = UDim2.new(1, -4, 0, 20)
		button.Position = UDim2.new(0, 2, 0, (i - 1) * 22)
		button.Text = name
		button.Font = Enum.Font.Gotham
		button.TextSize = 11
		button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		button.TextColor3 = Color3.new(1, 1, 1)

		button.MouseButton1Click:Connect(function()
			if selectedTable[name] then
				selectedTable[name] = nil
				button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			else
				selectedTable[name] = true
				button.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
			end
		end)
	end
end

createItemList("Seed Items", seedItems, 10, selectedSeedItems)
createItemList("Gear Items", gearItems, 210, selectedGearItems)

-- Toggle Auto Buy Switch
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 120, 0, 30)
toggle.Position = UDim2.new(0.5, -60, 1, -40)
toggle.AnchorPoint = Vector2.new(0.5, 1)
toggle.Text = "Auto Buy: OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

toggle.MouseButton1Click:Connect(function()
	autoBuyEnabled = not autoBuyEnabled
	toggle.Text = autoBuyEnabled and "Auto Buy: ON" or "Auto Buy: OFF"
	toggle.BackgroundColor3 = autoBuyEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Main Buy Loop
task.spawn(function()
	while true do
		task.wait(1) -- every 1 second
		if autoBuyEnabled then
			for itemName in pairs(selectedSeedItems) do
				seedBuy:FireServer(itemName)
			end
			for itemName in pairs(selectedGearItems) do
				gearBuy:FireServer(itemName)
			end
		end
	end
end)
