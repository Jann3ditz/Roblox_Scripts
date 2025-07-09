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

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

local walkSpeed = player.PlayerGui:GetAttribute("SavedSpeed") or 16
local minSpeed, maxSpeed = 16, 100

-- Main Menu Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 320)
main.Position = UDim2.new(0.5, -250, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = true
main.Active = true
main.Draggable = true
main.ZIndex = 3

-- Top Bar with Logo
local topBar = Instance.new("TextLabel", main)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
topBar.Text = "⚡ Jann Menu"
topBar.Font = Enum.Font.FredokaOne
topBar.TextColor3 = Color3.new(1, 1, 1)
topBar.TextSize = 20
topBar.ZIndex = 4

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 100, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Content Area
local contentFrame = Instance.new("Frame", main)
contentFrame.Size = UDim2.new(1, -100, 1, -30)
contentFrame.Position = UDim2.new(0, 100, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

-- Tab Buttons
local function createTabButton(name, order)
	local button = Instance.new("TextButton", sidebar)
	button.Size = UDim2.new(1, 0, 0, 30)
	button.Position = UDim2.new(0, 0, 0, (order - 1) * 35)
	button.Text = name
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.Name = name .. "Tab"
	return button
end

local autoBuyTab = createTabButton("Auto Buy", 1)
local playerTab = createTabButton("Player", 2)

-- Auto Buy Page
local autoBuyFrame = Instance.new("Frame", contentFrame)
autoBuyFrame.Size = UDim2.new(1, 0, 1, 0)
autoBuyFrame.BackgroundTransparency = 1
autoBuyFrame.Visible = true

local function createMultiSelectSection(titleText, itemList, position, isSeed)
	local frame = Instance.new("ScrollingFrame", autoBuyFrame)
	frame.Size = UDim2.new(0, 190, 1, -50)
	frame.Position = position
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	frame.ScrollBarThickness = 6
	frame.ScrollingDirection = Enum.ScrollingDirection.Y
	frame.ClipsDescendants = true

	local layout = Instance.new("UIListLayout", frame)
	layout.Padding = UDim.new(0, 4)

	local title = Instance.new("TextLabel", frame)
	title.Text = titleText
	title.Size = UDim2.new(1, 0, 0, 20)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.BackgroundTransparency = 1

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
createMultiSelectSection("Gear Shop", gearItems, UDim2.new(0, 210, 0, 10), false)

-- Auto Buy Toggles
local function createGlobalToggle(name, pos, isSeed)
	local toggle = Instance.new("TextButton", autoBuyFrame)
	toggle.Size = UDim2.new(0, 190, 0, 26)
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

createGlobalToggle("Auto Buy Seeds", UDim2.new(0, 10, 1, -35), true)
createGlobalToggle("Auto Buy Gear", UDim2.new(0, 210, 1, -35), false)

-- Player Page
local playerFrame = Instance.new("Frame", contentFrame)
playerFrame.Size = UDim2.new(1, 0, 1, 0)
playerFrame.BackgroundTransparency = 1
playerFrame.Visible = false

local speedLabel = Instance.new("TextLabel", playerFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.Text = "WalkSpeed: " .. walkSpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14

local UISlider = Instance.new("Frame", playerFrame)
UISlider.Size = UDim2.new(0, 300, 0, 40)
UISlider.Position = UDim2.new(0, 20, 0, 40)
UISlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local bar = Instance.new("Frame", UISlider)
bar.Size = UDim2.new(1, 0, 0, 6)
bar.Position = UDim2.new(0, 0, 0.5, -3)
bar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local knob = Instance.new("Frame", bar)
knob.Size = UDim2.new(0, 10, 0, 20)
knob.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
knob.BorderSizePixel = 0
knob.AnchorPoint = Vector2.new(0.5, 0.5)

local dragging = false
local percent = (walkSpeed - minSpeed) / (maxSpeed - minSpeed)
knob.Position = UDim2.new(percent, 0, 0.5, 0)
knob.Parent = bar

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
		player.PlayerGui:SetAttribute("SavedSpeed", walkSpeed)
		speedLabel.Text = "WalkSpeed: " .. walkSpeed
	end
end)

-- Tab Switching
autoBuyTab.MouseButton1Click:Connect(function()
	autoBuyFrame.Visible = true
	playerFrame.Visible = false
end)

playerTab.MouseButton1Click:Connect(function()
	autoBuyFrame.Visible = false
	playerFrame.Visible = true
end)

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
