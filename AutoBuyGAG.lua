- ⚡ Auto Buy + Player Speed + Jump + Quest GUI (Mobile-Optimized MultiSelect v4)

-- [SERVICES]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- [PLAYER]
local player = Players.LocalPlayer

-- [VARIABLES]
local selectedSeeds = {}
local selectedGears = {}
local selectedEggs = {}
local autoBuyEnabled = {
	Seeds = false,
	Gear = false,
	Eggs = false
}

-- [GUI CREATION]
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AutoBuyGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- [TAB BUTTONS]
local tabList = {"Auto Buy", "Player", "Quest"}
local tabButtons = {}
local currentTab = nil

for i, tabName in ipairs(tabList) do
	local tabButton = Instance.new("TextButton", mainFrame)
	tabButton.Size = UDim2.new(0, 100, 0, 30)
	tabButton.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 10)
	tabButton.Text = tabName
	tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabButton.TextColor3 = Color3.new(1, 1, 1)
	tabButton.Font = Enum.Font.GothamBold
	tabButton.TextSize = 14
	tabButtons[tabName] = tabButton
end

-- [AUTO BUY FRAME]
local autoBuyFrame = Instance.new("Frame", mainFrame)
autoBuyFrame.Size = UDim2.new(1, -20, 1, -50)
autoBuyFrame.Position = UDim2.new(0, 10, 0, 50)
autoBuyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoBuyFrame.BorderSizePixel = 0

autoBuyFrame.Visible = false

-- [FUNCTIONS]
local function toggleSelectAll(section, selectedTable, toggleBtn)
	local allSelected = true
	local buttons = {}

	for _, btn in pairs(section:GetDescendants()) do
		if btn:IsA("TextButton") and btn ~= toggleBtn and not btn.Text:match("^Select All") then
			table.insert(buttons, btn)
			if not selectedTable[btn.Text] then
				allSelected = false
			end
		end
	end

	for _, btn in pairs(buttons) do
		local selecting = not allSelected
		if selecting then
			selectedTable[btn.Text] = true
			btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		else
			selectedTable[btn.Text] = nil
			btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end
end

local function createMultiSelectSection(title, itemList, parent, selectedTable)
	local sectionFrame = Instance.new("Frame", parent)
	sectionFrame.Size = UDim2.new(0.3, -10, 1, -10)
	sectionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	sectionFrame.BorderSizePixel = 0

	local uiList = Instance.new("UIListLayout", sectionFrame)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Padding = UDim.new(0, 2)

	local titleLabel = Instance.new("TextLabel", sectionFrame)
	titleLabel.Size = UDim2.new(1, 0, 0, 30)
	titleLabel.Text = title
	titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14

	local toggleButton = Instance.new("TextButton", sectionFrame)
	toggleButton.Size = UDim2.new(1, 0, 0, 30)
	toggleButton.Text = "Toggle Auto Buy"
	toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	toggleButton.TextColor3 = Color3.new(1, 1, 1)
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextSize = 14

	toggleButton.MouseButton1Click:Connect(function()
		autoBuyEnabled[title] = not autoBuyEnabled[title]
		toggleButton.BackgroundColor3 = autoBuyEnabled[title] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
	end)

	for _, item in ipairs(itemList) do
		local itemButton = Instance.new("TextButton", sectionFrame)
		itemButton.Size = UDim2.new(1, 0, 0, 25)
		itemButton.Text = item
		itemButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		itemButton.TextColor3 = Color3.new(1, 1, 1)
		itemButton.Font = Enum.Font.Gotham
		itemButton.TextSize = 14

		itemButton.MouseButton1Click:Connect(function()
			if selectedTable[item] then
				selectedTable[item] = nil
				itemButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			else
				selectedTable[item] = true
				itemButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
			end
		end)
	end

	return sectionFrame, toggleButton
end

-- [DATA LISTS]
local seedItems = {"Wheat Seed", "Tranquil Seed", "Frosty Seed", "Fire Seed"}
local gearItems = {"Watering Can", "Hoe", "Sprinkler"}
local eggItems = {"Common Egg", "Legendary Egg", "Mythical Egg"}

-- [CREATE MULTISELECT SECTIONS]
local seedSection, seedToggle = createMultiSelectSection("Seeds", seedItems, autoBuyFrame, selectedSeeds)
seedSection.Position = UDim2.new(0, 10, 0, 10)

local gearSection, gearToggle = createMultiSelectSection("Gear", gearItems, autoBuyFrame, selectedGears)
gearSection.Position = UDim2.new(0.33, 5, 0, 10)

local eggSection, eggToggle = createMultiSelectSection("Eggs", eggItems, autoBuyFrame, selectedEggs)
eggSection.Position = UDim2.new(0.66, 5, 0, 10)

-- [SELECT ALL BUTTONS]
local function createSelectAllButton(section, selectedTable, toggleBtn, text)
	local button = Instance.new("TextButton", section)
	button.Size = UDim2.new(1, 0, 0, 30)
	button.Position = UDim2.new(0, 0, 1, 0)
	button.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = text
	button.MouseButton1Click:Connect(function()
		toggleSelectAll(section, selectedTable, toggleBtn)
	end)
end

createSelectAllButton(seedSection, selectedSeeds, seedToggle, "Select All Seeds")
createSelectAllButton(gearSection, selectedGears, gearToggle, "Select All Gear")
createSelectAllButton(eggSection, selectedEggs, eggToggle, "Select All Eggs")

-- [TAB HANDLING]
local function switchTab(tabName)
	autoBuyFrame.Visible = (tabName == "Auto Buy")
	-- Add visibility logic for other tabs later
end

for tabName, button in pairs(tabButtons) do
	button.MouseButton1Click:Connect(function()
		switchTab(tabName)
	end)
end

-- [DEFAULT TAB]
switchTab("Auto Buy")
