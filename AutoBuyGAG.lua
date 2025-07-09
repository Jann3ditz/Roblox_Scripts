-- ⚡Jann Auto Buy GUI (Grow a Garden)
-- Auto-buys specific Seed and Gear items every 1 second with selection UI

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
main.Size = UDim2.new(0, 350, 0, 400)
main.Position = UDim2.new(0, 10, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Name = "MainFrame"

-- Logo ⚡Jann
local logo = Instance.new("TextLabel", main)
logo.Size = UDim2.new(1, 0, 0, 40)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 24

-- Scrollable seed/gear selector
local function createItemList(titleText, items, yOffset, selectedTable)
	local title = Instance.new("TextLabel", main)
	title.Position = UDim2.new(0, 10, 0, yOffset)
	title.Size = UDim2.new(0, 160, 0, 20)
	title.Text = titleText
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14

	local holder = Instance.new("ScrollingFrame", main)
	holder.Position = UDim2.new(0, 10, 0, yOffset + 25)
	holder.Size = UDim2.new(0, 160, 0, 120)
	holder.CanvasSize = UDim2.new(0, 0, 0, #items * 25)
	holder.ScrollBarThickness = 4
	holder.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

	for i, name in ipairs(items) do
		local button = Instance.new("TextButton", holder)
		button.Size = UDim2.new(1, -4, 0, 22)
		button.Position = UDim2.new(0, 2, 0, (i - 1) * 25)
		button.Text = name
		button.Font = Enum.Font.Gotham
		button.TextSize = 12
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

createItemList("Seed Items", seedItems, 50, selectedSeedItems)
createItemList("Gear Items", gearItems, 200, selectedGearItems)

-- Start / Stop Buttons
local startBtn = Instance.new("TextButton", main)
startBtn.Size = UDim2.new(0, 160, 0, 30)
startBtn.Position = UDim2.new(0, 10, 0, 340)
startBtn.Text = "Start Auto Buy"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

local stopBtn = Instance.new("TextButton", main)
stopBtn.Size = UDim2.new(0, 160, 0, 30)
stopBtn.Position = UDim2.new(0, 180, 0, 340)
stopBtn.Text = "Stop Auto Buy"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)

startBtn.MouseButton1Click:Connect(function()
	autoBuyEnabled = true
end)

stopBtn.MouseButton1Click:Connect(function()
	autoBuyEnabled = false
end)

-- Main Buy Loop
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
