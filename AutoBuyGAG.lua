-- ⚡Jann Final Auto Buy GUI - Multi-Select Button Edition (Grow a Garden)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")
local eggBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")

local autoBuySeeds = false
local autoBuyGear = false
local autoBuyEggs = false

local selectedSeeds = {} -- Persisted seed selection
local selectedGears = {} -- Persisted gear selection
local selectedEggName = nil -- Persisted egg name

-- Load previous selections from attributes
local function loadPreviousSelections()
	local attr = player:FindFirstChild("AutoBuySettings")
	if not attr then return end
	local data = game.HttpService:JSONDecode(attr.Value)
	selectedSeeds = data.seeds or {}
	selectedGears = data.gears or {}
	selectedEggName = data.egg or nil
	autoBuySeeds = data.autoSeeds or false
	autoBuyGear = data.autoGear or false
	autoBuyEggs = data.autoEgg or false
end

-- Save selections to attribute
local function saveSelections()
	local settings = {
		seeds = selectedSeeds,
		gears = selectedGears,
		egg = selectedEggName,
		autoSeeds = autoBuySeeds,
		autoGear = autoBuyGear,
		autoEgg = autoBuyEggs
	}
	local attr = player:FindFirstChild("AutoBuySettings")
	if not attr then
		attr = Instance.new("StringValue")
		attr.Name = "AutoBuySettings"
		attr.Parent = player
	end
	attr.Value = game.HttpService:JSONEncode(settings)
end

-- Item Lists
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

local eggItems = {
	"Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg",
	"Bee Egg", "Bug Egg", "Common Summer Egg", "Rare Summer Egg",
	"Paradise Egg", "Oasis Egg"
}

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
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	saveSelections()
end)

-- UI Section Builder
local function createMultiSelectSection(titleText, itemList, position, selectedTable, isEgg)
	local frame = Instance.new("ScrollingFrame", main)
	frame.Size = UDim2.new(0, 200, 1, -40)
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
	title.TextColor3 = Color3.new(1, 1, 1)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14

	for _, itemName in ipairs(itemList) do
		local button = Instance.new("TextButton", frame)
		button.Size = UDim2.new(1, -10, 0, 24)
		button.Position = UDim2.new(0, 5, 0, 0)
		button.Text = itemName
		button.Font = Enum.Font.Gotham
		button.TextSize = 12
		button.TextColor3 = Color3.new(1, 1, 1)
		button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		button.BorderSizePixel = 0

		local selected = false
		if isEgg and itemName == selectedEggName then
			selected = true
			button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		elseif selectedTable then
			for _, v in ipairs(selectedTable) do
				if v == itemName then
					selected = true
					button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
					break
				end
			end
		end

		button.MouseButton1Click:Connect(function()
			selected = not selected
			button.BackgroundColor3 = selected and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
			if isEgg then
				selectedEggName = selected and itemName or nil
			else
				if selected then
					table.insert(selectedTable, itemName)
				else
					for i, v in ipairs(selectedTable) do
						if v == itemName then table.remove(selectedTable, i) break end
					end
				end
			end
			saveSelections()
		end)
	end
end

createMultiSelectSection("Seed Shop", seedItems, UDim2.new(0, 10, 0, 10), selectedSeeds)
createMultiSelectSection("Gear Shop", gearItems, UDim2.new(0, 230, 0, 10), selectedGears)
createMultiSelectSection("Egg Shop", eggItems, UDim2.new(0, 10, 0.5, 0), nil, true)

local function createGlobalToggle(name, pos, toggleType)
	local toggle = Instance.new("TextButton", main)
	toggle.Size = UDim2.new(0, 200, 0, 26)
	toggle.Position = pos
	toggle.Text = name .. ": OFF"
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 13
	toggle.TextColor3 = Color3.new(1, 1, 1)
	toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	toggle.MouseButton1Click:Connect(function()
		if toggleType == "seed" then
			autoBuySeeds = not autoBuySeeds
			toggle.Text = name .. ": " .. (autoBuySeeds and "ON" or "OFF")
			toggle.BackgroundColor3 = autoBuySeeds and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
		elseif toggleType == "gear" then
			autoBuyGear = not autoBuyGear
			toggle.Text = name .. ": " .. (autoBuyGear and "ON" or "OFF")
			toggle.BackgroundColor3 = autoBuyGear and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
		elseif toggleType == "egg" then
			autoBuyEggs = not autoBuyEggs
			toggle.Text = name .. ": " .. (autoBuyEggs and "ON" or "OFF")
			toggle.BackgroundColor3 = autoBuyEggs and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
		end
		saveSelections()
	end)
end

createGlobalToggle("Auto Buy Seeds", UDim2.new(0, 10, 1, -30), "seed")
createGlobalToggle("Auto Buy Gear", UDim2.new(0, 230, 1, -30), "gear")
createGlobalToggle("Auto Buy Egg", UDim2.new(0, 120, 1, -60), "egg")

local function getSlotByEggName(name)
	local shopUI = player:FindFirstChild("PlayerGui"):FindFirstChild("PetEggShop")
	if not shopUI then return nil end
	for i = 1, 3 do
		local slot = shopUI:FindFirstChild("Slot" .. i)
		if slot and slot:FindFirstChild("Name") and slot.Name.Text == name then
			return i
		end
	end
	return nil
end

-- Initial load from previous saved data
loadPreviousSelections()

-- Loop
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
		if autoBuyEggs and selectedEggName then
			local slot = getSlotByEggName(selectedEggName)
			if slot then
				eggBuy:FireServer(slot)
			end
		end
	end
end)
