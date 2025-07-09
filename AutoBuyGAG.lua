local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

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

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

-- Floating buttons
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

local playerTab = Instance.new("TextButton", gui)
playerTab.Size = UDim2.new(0, 80, 0, 30)
playerTab.Position = UDim2.new(0, 140, 0, 10)
playerTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
playerTab.Text = "Player"
playerTab.Font = Enum.Font.GothamBold
playerTab.TextColor3 = Color3.new(1, 1, 1)
playerTab.TextSize = 14

-- Main GUI
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

-- Speed Frame
local speedFrame = Instance.new("Frame", gui)
speedFrame.Size = UDim2.new(0, 220, 0, 100)
speedFrame.Position = UDim2.new(0.5, -110, 0.5, 170)
speedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedFrame.Visible = false
speedFrame.Active = true
speedFrame.Draggable = true

local walkSpeed = player.PlayerGui:GetAttribute("SavedSpeed") or 16
local minSpeed, maxSpeed = 16, 100

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.Text = "WalkSpeed: " .. walkSpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14

local UISlider = Instance.new("Frame", speedFrame)
UISlider.Size = UDim2.new(1, -20, 0, 40)
UISlider.Position = UDim2.new(0, 10, 0, 40)
UISlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local bar = Instance.new("Frame", UISlider)
bar.Size = UDim2.new(1, 0, 0, 6)
bar.Position = UDim2.new(0, 0, 0.5, -3)
bar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local knob = Instance.new("Frame", bar)
knob.Size = UDim2.new(0, 10, 0, 20)
knob.Position = UDim2.new((walkSpeed - minSpeed) / (maxSpeed - minSpeed), 0, 0.5, 0)
knob.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
knob.BorderSizePixel = 0
knob.AnchorPoint = Vector2.new(0.5, 0.5)

local dragging = false

bar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)

bar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		knob.Position = UDim2.new(relX, 0, 0.5, 0)
		walkSpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * relX)
		speedLabel.Text = "WalkSpeed: " .. walkSpeed
		player.PlayerGui:SetAttribute("SavedSpeed", walkSpeed)
	end
end)

-- Toggles
logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	speedFrame.Visible = false
end)

playerTab.MouseButton1Click:Connect(function()
	speedFrame.Visible = not speedFrame.Visible
	main.Visible = false
end)

-- Multi-Select Sections
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
			local list = isSeed and selectedSeeds or selectedGears
			if selected then
				table.insert(list, itemName)
			else
				for i, v in ipairs(list) do
					if v == itemName then table.remove(list, i) break end
				end
			end
		end)
	end
end

createMultiSelectSection("Seed Shop", seedItems, UDim2.new(0, 10, 0, 10), true)
createMultiSelectSection("Gear Shop", gearItems, UDim2.new(0, 230, 0, 10), false)

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

-- Loops
task.spawn(function()
	while true do
		task.wait(1)
		if autoBuySeeds then for _, seed in ipairs(selectedSeeds) do seedBuy:FireServer(seed) end end
		if autoBuyGear then for _, gear in ipairs(selectedGears) do gearBuy:FireServer(gear) end end
	end
end)

task.spawn(function()
	while true do
		task.wait(3)
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.WalkSpeed = walkSpeed end
	end
end)
