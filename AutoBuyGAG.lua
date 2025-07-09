-- ⚡ Auto Buy + Player Speed TextBox GUI (with Apply Toggle)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuySeeds, autoBuyGear = false, false
local selectedSeeds, selectedGears = {}, {}
local seedItems = {"Strawberry", "Orange Tulip", "Tomato", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Sugar Apple", "Burning Bud"}
local gearItems = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advance Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Friendship Pot"}

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

-- Open Button
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

-- Main Frame (container)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

-- Tab Buttons
local autoBuyTab = Instance.new("TextButton", main)
autoBuyTab.Size = UDim2.new(0, 100, 0, 30)
autoBuyTab.Position = UDim2.new(0, 10, 0, 10)
autoBuyTab.Text = "Auto Buy"
autoBuyTab.Font = Enum.Font.GothamBold
autoBuyTab.TextColor3 = Color3.new(1, 1, 1)
autoBuyTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

local playerTab = Instance.new("TextButton", main)
playerTab.Size = UDim2.new(0, 100, 0, 30)
playerTab.Position = UDim2.new(0, 120, 0, 10)
playerTab.Text = "Player"
playerTab.Font = Enum.Font.GothamBold
playerTab.TextColor3 = Color3.new(1, 1, 1)
playerTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local questTab = Instance.new("TextButton", main)
questTab.Size = UDim2.new(0, 100, 0, 30)
questTab.Position = UDim2.new(0, 230, 0, 10)
questTab.Text = "Quest"
questTab.Font = Enum.Font.GothamBold
questTab.TextColor3 = Color3.new(1, 1, 1)
questTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Content Frames
local autoBuyFrame = Instance.new("Frame", main)
autoBuyFrame.Size = UDim2.new(1, -20, 1, -50)
autoBuyFrame.Position = UDim2.new(0, 10, 0, 50)
autoBuyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoBuyFrame.Visible = true

local playerFrame = Instance.new("Frame", main)
playerFrame.Size = autoBuyFrame.Size
playerFrame.Position = autoBuyFrame.Position
playerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerFrame.Visible = false

local questFrame = Instance.new("Frame", main)
questFrame.Size = autoBuyFrame.Size
questFrame.Position = autoBuyFrame.Position
questFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
questFrame.Visible = false

-- Toggle Tabs
local function showTab(tab)
	autoBuyFrame.Visible = (tab == "auto")
	playerFrame.Visible = (tab == "player")
	questFrame.Visible = (tab == "quest")
	autoBuyTab.BackgroundColor3 = tab == "auto" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
	playerTab.BackgroundColor3 = tab == "player" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
	questTab.BackgroundColor3 = tab == "quest" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
end

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

autoBuyTab.MouseButton1Click:Connect(function() showTab("auto") end)
playerTab.MouseButton1Click:Connect(function() showTab("player") end)
questTab.MouseButton1Click:Connect(function() showTab("quest") end)

-- Quest Frame Buttons
local playerGui = player:WaitForChild("PlayerGui")
local dinoUI = playerGui:WaitForChild("DinoQuests_UI")
local dailyUI = playerGui:WaitForChild("DailyQuests_UI")
local merchantUI = playerGui:WaitForChild("TravelingMerchantShop_UI")

local function createQuestButton(text, order, targetUI)
	local btn = Instance.new("TextButton", questFrame)
	btn.Size = UDim2.new(0.6, 0, 0, 32)
	btn.Position = UDim2.new(0.2, 0, 0, 10 + order * 40)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(60, 100, 120)
	btn.MouseButton1Click:Connect(function()
		if targetUI then
			targetUI.Enabled = true
		end
	end)
end

createQuestButton("Dino Quest", 0, dinoUI)
createQuestButton("Daily Quest", 1, dailyUI)
createQuestButton("Travelling Merchant", 2, merchantUI)
