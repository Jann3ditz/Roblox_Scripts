-- ⚡ Auto Buy + Player Speed + Jump + Quest GUI (Mobile-Optimized MultiSelect v4) + Select All / Unselect All

-- [SERVICES]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- [PLAYER]
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- [UI CREATION]
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoBuyGUI"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Position = UDim2.new(0, 100, 0.5, -200)
mainFrame.Size = UDim2.new(0, 400, 0, 400)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0

-- [TABS SIDEBAR]
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local tabButtons = {}
local tabContents = {}

local function createTab(name)
    local button = Instance.new("TextButton", sidebar)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Text = name

    local content = Instance.new("Frame", mainFrame)
    content.Position = UDim2.new(0, 100, 0, 0)
    content.Size = UDim2.new(1, -100, 1, 0)
    content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    content.Visible = false

    button.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabContents) do tab.Visible = false end
        content.Visible = true
    end)

    tabButtons[name] = button
    tabContents[name] = content
    return content
end

-- [AUTO BUY TAB]
local autoBuyTab = createTab("Auto Buy")

local seedSection = Instance.new("Frame", autoBuyTab)
seedSection.Position = UDim2.new(0, 10, 0, 10)
seedSection.Size = UDim2.new(0.3, -15, 1, -20)
seedSection.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local gearSection = Instance.new("Frame", autoBuyTab)
gearSection.Position = UDim2.new(0.35, 0, 0, 10)
gearSection.Size = UDim2.new(0.3, -15, 1, -20)
gearSection.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local eggSection = Instance.new("Frame", autoBuyTab)
eggSection.Position = UDim2.new(0.7, 0, 0, 10)
eggSection.Size = UDim2.new(0.3, -15, 1, -20)
eggSection.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local selectedSeeds, selectedGears, selectedEggs = {}, {}, {}

-- [DUMMY ITEM BUTTONS]
local seedNames = {"Carrot", "Potato", "Corn"}
local gearNames = {"Shovel", "Watering Can", "Fertilizer"}
local eggNames = {"Common Egg", "Rare Egg", "Legendary Egg"}

local function createItemButtons(list, section, selectedTable)
    for i, name in ipairs(list) do
        local btn = Instance.new("TextButton", section)
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Text = name

        btn.MouseButton1Click:Connect(function()
            selectedTable[name] = not selectedTable[name]
            btn.BackgroundColor3 = selectedTable[name] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
        end)
    end
end

createItemButtons(seedNames, seedSection, selectedSeeds)
createItemButtons(gearNames, gearSection, selectedGears)
createItemButtons(eggNames, eggSection, selectedEggs)

-- [SELECT ALL TOGGLE BUTTON FUNCTION]
local function toggleSelectAll(section, selectedTable)
	local allSelected = true
	local buttons = {}
	for _, btn in pairs(section:GetChildren()) do
		if btn:IsA("TextButton") then
			table.insert(buttons, btn)
			if not selectedTable[btn.Text] then
				allSelected = false
			end
		end
	end
	for _, btn in pairs(buttons) do
		local isSelecting = not allSelected
		selectedTable[btn.Text] = isSelecting or nil
		btn.BackgroundColor3 = isSelecting and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
	end
end

local selectAllSeeds = Instance.new("TextButton", seedSection)
selectAllSeeds.Size = UDim2.new(1, 0, 0, 25)
selectAllSeeds.Position = UDim2.new(0, 0, 1, -25)
selectAllSeeds.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
selectAllSeeds.Text = "Select All Seeds"
selectAllSeeds.TextColor3 = Color3.new(1, 1, 1)
selectAllSeeds.Font = Enum.Font.GothamBold
selectAllSeeds.TextSize = 12
selectAllSeeds.MouseButton1Click:Connect(function()
	toggleSelectAll(seedSection, selectedSeeds)
end)

local selectAllGears = Instance.new("TextButton", gearSection)
selectAllGears.Size = UDim2.new(1, 0, 0, 25)
selectAllGears.Position = UDim2.new(0, 0, 1, -25)
selectAllGears.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
selectAllGears.Text = "Select All Gears"
selectAllGears.TextColor3 = Color3.new(1, 1, 1)
selectAllGears.Font = Enum.Font.GothamBold
selectAllGears.TextSize = 12
selectAllGears.MouseButton1Click:Connect(function()
	toggleSelectAll(gearSection, selectedGears)
end)

local selectAllEggs = Instance.new("TextButton", eggSection)
selectAllEggs.Size = UDim2.new(1, 0, 0, 25)
selectAllEggs.Position = UDim2.new(0, 0, 1, -25)
selectAllEggs.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
selectAllEggs.Text = "Select All Eggs"
selectAllEggs.TextColor3 = Color3.new(1, 1, 1)
selectAllEggs.Font = Enum.Font.GothamBold
selectAllEggs.TextSize = 12
selectAllEggs.MouseButton1Click:Connect(function()
	toggleSelectAll(eggSection, selectedEggs)
end)

-- [PLAYER TAB]
local playerTab = createTab("Player")

local speedLabel = Instance.new("TextLabel", playerTab)
speedLabel.Size = UDim2.new(0, 100, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

local speedBox = Instance.new("TextBox", playerTab)
speedBox.Size = UDim2.new(0, 100, 0, 25)
speedBox.Position = UDim2.new(0, 10, 0, 40)
speedBox.Text = tostring(humanoid.WalkSpeed)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

speedBox.FocusLost:Connect(function()
	local newSpeed = tonumber(speedBox.Text)
	if newSpeed then humanoid.WalkSpeed = newSpeed end
end)

-- [QUEST TAB]
local questTab = createTab("Quest")
local questLabel = Instance.new("TextLabel", questTab)
questLabel.Size = UDim2.new(1, -20, 1, -20)
questLabel.Position = UDim2.new(0, 10, 0, 10)
questLabel.Text = "Coming soon: Auto Questing..."
questLabel.TextColor3 = Color3.new(1, 1, 1)
questLabel.BackgroundTransparency = 1
questLabel.TextWrapped = true
questLabel.TextSize = 16

-- [DEFAULT TAB OPEN]
tabContents["Auto Buy"].Visible = true
