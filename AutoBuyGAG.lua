-- ⚡ Auto Buy + Player Speed + Quest GUI (Final Integrated)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuySeeds, autoBuyGear = false, false
local selectedSeeds, selectedGears = {}, {}
local seedItems = {"Strawberry", "Orange Tulip", "Tomato", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone Seed"}
local gearItems = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Friendship Pot", "Harvest Tool", "Tanning Mirror", "Levelup Lollipop", "Medium Treat", "Medium Toy"}

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

---------------------------------------------------------------------
-- GUI header
---------------------------------------------------------------------
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

---------------------------------------------------------------------
-- Main draggable frame
---------------------------------------------------------------------
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

---------------------------------------------------------------------
-- Tabs (Auto Buy / Player / Quest / NEW Pet)
---------------------------------------------------------------------
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

-- 🔹 NEW PET TAB BUTTON
local petTab = Instance.new("TextButton", main)
petTab.Size = UDim2.new(0, 100, 0, 30)
petTab.Position = UDim2.new(0, 340, 0, 10)
petTab.Text = "Pet"
petTab.Font = Enum.Font.GothamBold
petTab.TextColor3 = Color3.new(1, 1, 1)
petTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

---------------------------------------------------------------------
-- Content Frames
---------------------------------------------------------------------
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

-- 🔹 NEW PET CONTENT FRAME
local petFrame = Instance.new("Frame", main)
petFrame.Size = autoBuyFrame.Size
petFrame.Position = autoBuyFrame.Position
petFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 45)
petFrame.Visible = false

---------------------------------------------------------------------
-- Tab switching logic (now with "pet")
---------------------------------------------------------------------
local currentTab = "auto"
local function showTab(tab)
	currentTab = tab
	autoBuyFrame.Visible = (tab == "auto")
	playerFrame.Visible  = (tab == "player")
	questFrame.Visible   = (tab == "quest")
	petFrame.Visible     = (tab == "pet")

	autoBuyTab.BackgroundColor3 = tab == "auto" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
	playerTab.BackgroundColor3  = tab == "player" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
	questTab.BackgroundColor3   = tab == "quest" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
	petTab.BackgroundColor3     = tab == "pet"  and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
end

logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	if main.Visible then showTab(currentTab) end
end)

autoBuyTab.MouseButton1Click:Connect(function() showTab("auto") end)
playerTab.MouseButton1Click:Connect(function() showTab("player") end)
questTab.MouseButton1Click:Connect(function() showTab("quest") end)
petTab.MouseButton1Click:Connect(function() showTab("pet") end)

---------------------------------------------------------------------
-- Quest GUI shortcut buttons
---------------------------------------------------------------------
local dinoUI      = player.PlayerGui:FindFirstChild("DinoQuests_UI")
local dailyUI     = player.PlayerGui:FindFirstChild("DailyQuests_UI")
local merchantUI  = player.PlayerGui:FindFirstChild("TravelingMerchantShop_UI")

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
		if targetUI then targetUI.Enabled = not targetUI.Enabled end
	end)
end

createQuestButton("Dino Quest",        0, dinoUI)
createQuestButton("Daily Quest",       1, dailyUI)
createQuestButton("Travelling Merchant", 2, merchantUI)

---------------------------------------------------------------------
-- Rest of your original Auto-Buy / Player logic continues...
-- (createMultiSelectSection, seed & gear toggles, speed slider, etc.)
---------------------------------------------------------------------



---------------------------------------------------------------------
-- 🔹 NEW PET EGG AUTO-BUY SECTION
---------------------------------------------------------------------
local eggItems = {
	"Common Egg",
	"Uncommon Egg",
	"Rare Egg",
	"Legendary Egg",
	"Mythical Egg",
	"Bug Egg"
}
local selectedEggs = {}
local autoBuyEggs  = false
local eggBuy       = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")

-- Uses the same helper you already defined for seeds/gears
local eggSection = createMultiSelectSection("Egg Shop", eggItems, petFrame, false)

local eggToggle = Instance.new("TextButton", eggSection)
eggToggle.Size  = UDim2.new(1, 0, 0, 24)
eggToggle.Position = UDim2.new(0, 0, 1, -24)
eggToggle.Text  = "▷ Auto Buy Eggs: OFF"
eggToggle.Font  = Enum.Font.GothamBold
eggToggle.TextColor3       = Color3.new(1,1,1)
eggToggle.BackgroundColor3 = Color3.fromRGB(90, 60, 90)

eggToggle.MouseButton1Click:Connect(function()
	autoBuyEggs = not autoBuyEggs
	eggToggle.Text = autoBuyEggs and "▶ Auto Buy Eggs: ON" or "▷ Auto Buy Eggs: OFF"
	eggToggle.BackgroundColor3 = autoBuyEggs and Color3.fromRGB(120,80,120) or Color3.fromRGB(90,60,90)
end)

-- Lightweight loop; buys each selected egg every ~0.1 s
task.spawn(function()
	while true do
		if autoBuyEggs then
			for eggName,_ in pairs(selectedEggs) do
				pcall(function()
					eggBuy:FireServer(eggName)
				end)
				task.wait(0.1)
			end
		end
		task.wait(0.25)
	end
end)
