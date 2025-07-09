-- ⚡Jann Final Auto Buy GUI - ComboBox Edition (Grow a Garden)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuySeeds = false
local autoBuyGear = false
local selectedSeed = nil
local selectedGear = nil

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

-- Floating logo
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

-- Main menu frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Section creator
local function createComboBoxSection(titleText, itemList, position, isSeed)
	local frame = Instance.new("ScrollingFrame", main)
	frame.Size = UDim2.new(0, 200, 1, -20)
	frame.Position = position
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	frame.ScrollBarThickness = 6
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	frame.ScrollingDirection = Enum.ScrollingDirection.Y
	frame.ClipsDescendants = true

	local layout = Instance.new("UIListLayout", frame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)

	local title = Instance.new("TextLabel", frame)
	title.Text = titleText
	title.Size = UDim2.new(1, 0, 0, 20)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.LayoutOrder = 0

	local combo = Instance.new("TextButton", frame)
	combo.Size = UDim2.new(1, -10, 0, 24)
	combo.Position = UDim2.new(0, 5, 0, 0)
	combo.Text = "Select Item"
	combo.TextSize = 12
	combo.Font = Enum.Font.Gotham
	combo.TextColor3 = Color3.new(1, 1, 1)
	combo.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	combo.LayoutOrder = 1

	local dropdown = Instance.new("Frame", frame)
	dropdown.Size = UDim2.new(1, -10, 0, math.min(#itemList, 5) * 20)
	dropdown.Position = UDim2.new(0, 5, 0, 0)
	dropdown.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	dropdown.Visible = false
	dropdown.LayoutOrder = 2

	local dropLayout = Instance.new("UIListLayout", dropdown)
	dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
	dropLayout.Padding = UDim.new(0, 2)

	for i, itemName in ipairs(itemList) do
		local item = Instance.new("TextButton", dropdown)
		item.Size = UDim2.new(1, 0, 0, 20)
		item.Text = itemName
		item.Font = Enum.Font.Gotham
		item.TextSize = 11
		item.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		item.TextColor3 = Color3.new(1, 1, 1)
		item.LayoutOrder = i
		item.MouseButton1Click:Connect(function()
			combo.Text = itemName
			dropdown.Visible = false
			if isSeed then
				selectedSeed = itemName
			else
				selectedGear = itemName
			end
		end)
	end

	combo.MouseButton1Click:Connect(function()
		dropdown.Visible = not dropdown.Visible
	end)
	dropdown.Parent = frame

	-- Auto Buy Toggle
	local toggle = Instance.new("TextButton", frame)
	toggle.Size = UDim2.new(1, -10, 0, 26)
	toggle.Text = "Auto Buy: OFF"
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 13
	toggle.TextColor3 = Color3.new(1, 1, 1)
	toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	toggle.LayoutOrder = 999

	toggle.MouseButton1Click:Connect(function()
		if isSeed then
			autoBuySeeds = not autoBuySeeds
			toggle.Text = autoBuySeeds and "Auto Buy: ON" or "Auto Buy: OFF"
			toggle.BackgroundColor3 = autoBuySeeds and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
		else
			autoBuyGear = not autoBuyGear
			toggle.Text = autoBuyGear and "Auto Buy: ON" or "Auto Buy: OFF"
			toggle.BackgroundColor3 = autoBuyGear and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
		end
	end)
	toggle.Parent = frame
end

createComboBoxSection("Seed Shop", seedItems, UDim2.new(0, 10, 0, 10), true)
createComboBoxSection("Gear Shop", gearItems, UDim2.new(0, 230, 0, 10), false)

-- Loop
task.spawn(function()
	while true do
		task.wait(1)
		if autoBuySeeds and selectedSeed then
			seedBuy:FireServer(selectedSeed)
		end
		if autoBuyGear and selectedGear then
			gearBuy:FireServer(selectedGear)
		end
	end
end)
