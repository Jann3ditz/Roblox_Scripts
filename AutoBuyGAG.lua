-- ⚡Jann Final Auto Buy GUI - Multi-Select Button Edition (Grow a Garden)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuySeeds = false
local autoBuyGear = false
local selectedSeeds = {} -- store multiple seeds
local selectedGears = {} -- store multiple gears

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

-- Section creator for multi-select list
local function createMultiSelectSection(titleText, itemList, position, isSeed)
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
	button.MouseButton1Click:Connect(function()  
		selected = not selected  
		button.BackgroundColor3 = selected and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)  
		if isSeed then  
			if selected then  
				table.insert(selectedSeeds, itemName)  
			else  
				for i, v in ipairs(selectedSeeds) do  
					if v == itemName then table.remove(selectedSeeds, i) break end  
				end  
			end  
		else  
			if selected then  
				table.insert(selectedGears, itemName)  
			else  
				for i, v in ipairs(selectedGears) do  
					if v == itemName then table.remove(selectedGears, i) break end  
				end  
			end  
		end  
	end)  
end

end

createMultiSelectSection("Seed Shop", seedItems, UDim2.new(0, 10, 0, 10), true)
createMultiSelectSection("Gear Shop", gearItems, UDim2.new(0, 230, 0, 10), false)

-- Global toggles in MainFrame
local function createGlobalToggle(name, pos, isSeed)
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 200, 0, 26)
toggle.Position = pos
toggle.Text = name .. ": OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
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

createGlobalToggle("Auto Buy Seeds", UDim2.new(0, 10, 1, -30), true)
createGlobalToggle("Auto Buy Gear", UDim2.new(0, 230, 1, -30), false)

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
end
end)

	
