-- ⚡ Auto Buy + Player Speed + Quest GUI (Mobile-Optimized MultiSelect v4)

-- [SERVICES]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")
local petEggBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg")

-- [STATES]
local autoBuySeeds, autoBuyGear, autoBuyEgg = false, false, false
local selectedSeeds, selectedGears, selectedEggs = {}, {}, {}
local customSpeed = 32

-- [DATA]
local seedItems = {"Strawberry", "Orange Tulip", "Tomato", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone Seed"}
local gearItems = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Friendship Pot", "Harvest Tool", "Tanning Mirror", "Levelup Lollipop", "Medium Treat", "Medium Toy"}
local eggItems = {"Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg", "Bee Egg", "Bug Egg", "Common Summer Egg", "Rare Summer Egg", "Paradise Egg", "Oasis Egg"}

-- [GUI ROOT]
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

-- [OPEN BUTTON]
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

-- [MAIN FRAME]
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0.9, 0, 0.9, 0)
main.Position = UDim2.new(0.05, 0, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

-- [TABS]
local function createTab(name, x)
	local tab = Instance.new("TextButton", main)
	tab.Size = UDim2.new(0, 100, 0, 30)
	tab.Position = UDim2.new(0, x, 0, 10)
	tab.Text = name
	tab.Font = Enum.Font.GothamBold
	tab.TextColor3 = Color3.new(1, 1, 1)
	tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	return tab
end

local autoBuyTab = createTab("Auto Buy", 10)
local playerTab = createTab("Player", 120)
local questTab = createTab("Quest", 230)

-- [FRAMES]
local autoBuyFrame = Instance.new("Frame", main)
autoBuyFrame.Size = UDim2.new(1, -20, 1, -50)
autoBuyFrame.Position = UDim2.new(0, 10, 0, 50)
autoBuyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoBuyFrame.Visible = true

local playerFrame = autoBuyFrame:Clone()
playerFrame.Parent = main
playerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerFrame.Visible = false

local questFrame = autoBuyFrame:Clone()
questFrame.Parent = main
questFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
questFrame.Visible = false

-- [NOTIFICATION SYSTEM]
local notificationYOffset = 0
local function showPurchaseNotification(itemName, category)
	local notifHolder = Instance.new("Frame")
	notifHolder.Size = UDim2.new(0, 300, 0, 60)
	notifHolder.Position = UDim2.new(1, -320, 1, -80 - notificationYOffset)
	notifHolder.AnchorPoint = Vector2.new(1, 1)
	notifHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	notifHolder.BackgroundTransparency = 0.05
	notifHolder.BorderSizePixel = 0
	notifHolder.ClipsDescendants = true
	notifHolder.Parent = gui
	notifHolder.ZIndex = 10
	notifHolder.Name = "PurchaseNotif"

	local corner = Instance.new("UICorner", notifHolder)
	corner.CornerRadius = UDim.new(0, 14)

	local icon = Instance.new("TextLabel", notifHolder)
	icon.Size = UDim2.new(0, 40, 0, 40)
	icon.Position = UDim2.new(0, 10, 0.5, -20)
	icon.BackgroundTransparency = 1
	icon.TextScaled = true
	icon.TextColor3 = Color3.new(1, 1, 1)
	icon.Font = Enum.Font.GothamBold
	icon.Text = category == "Seed" and "🌱" or category == "Gear" and "🛠" or category == "Egg" and "🥚" or "❓"

	local label = Instance.new("TextLabel", notifHolder)
	label.Position = UDim2.new(0, 60, 0, 0)
	label.Size = UDim2.new(1, -70, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = string.format("✓ %s: %s", category, itemName)
	label.TextSize = 16

	notifHolder.Position = notifHolder.Position + UDim2.new(0, 100, 0, 0)
	TweenService:Create(notifHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -320, 1, -80 - notificationYOffset)
	}):Play()

	notificationYOffset += 65
	task.delay(2.5, function()
		TweenService:Create(notifHolder, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 300, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		for _, child in ipairs(notifHolder:GetChildren()) do
			if child:IsA("TextLabel") then
				TweenService:Create(child, TweenInfo.new(0.3), { Transparency = 1 }):Play()
			end
		end
		task.wait(0.3)
		notifHolder:Destroy()
		notificationYOffset -= 65
	end)
end

-- [QUEST BUTTONS]
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

local dinoUI = player.PlayerGui:FindFirstChild("DinoQuests_UI")
local dailyUI = player.PlayerGui:FindFirstChild("DailyQuests_UI")
local merchantUI = player.PlayerGui:FindFirstChild("TravelingMerchantShop_UI")

createQuestButton("Dino Quest", 0, dinoUI)
createQuestButton("Daily Quest", 1, dailyUI)
createQuestButton("Travelling Merchant", 2, merchantUI)

-- [PLAYER SPEED UI]
local speedBox = Instance.new("TextBox", playerFrame)
speedBox.Size = UDim2.new(0, 140, 0, 30)
speedBox.Position = UDim2.new(0, 20, 0, 20)
speedBox.PlaceholderText = "Enter speed (e.g. 32)"
speedBox.Text = ""
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.BackgroundColor3 = Color3.fromRGB(90, 90, 120)
speedBox.TextColor3 = Color3.new(1, 1, 1)

local applySpeed = Instance.new("TextButton", playerFrame)
applySpeed.Size = UDim2.new(0, 100, 0, 30)
applySpeed.Position = UDim2.new(0, 170, 0, 20)
applySpeed.Text = "Apply Speed"
applySpeed.Font = Enum.Font.GothamBold
applySpeed.TextSize = 14
applySpeed.BackgroundColor3 = Color3.fromRGB(80, 60, 90)
applySpeed.TextColor3 = Color3.new(1, 1, 1)

applySpeed.MouseButton1Click:Connect(function()
	local val = tonumber(speedBox.Text)
	if val then customSpeed = val end
end)

spawn(function()
	while true do
		pcall(function()
			player.Character.Humanoid.WalkSpeed = customSpeed
		end)
		task.wait(0.5)
	end
end)

-- [MULTISELECT SECTION FUNCTION]
-- [UNTOUCHED — CONTINUES AS IS]

-- [AUTO BUY LOOP]
spawn(function()
	while true do
		if autoBuySeeds then
			for name in pairs(selectedSeeds) do
				seedBuy:FireServer(name)
				showPurchaseNotification(name, "Seed")
			end
		end
		if autoBuyGear then
			for name in pairs(selectedGears) do
				gearBuy:FireServer(name)
				showPurchaseNotification(name, "Gear")
			end
		end
		if autoBuyEgg then
			for name in pairs(selectedEggs) do
				petEggBuy:FireServer(name)
				showPurchaseNotification(name, "Egg")
			end
		end
		task.wait(1.5)
	end
end)

-- [TAB SWITCHING]
local function showTab(which)
	autoBuyFrame.Visible = which == "auto"
	playerFrame.Visible = which == "player"
	questFrame.Visible = which == "quest"
	autoBuyTab.BackgroundColor3 = which == "auto" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
	playerTab.BackgroundColor3 = which == "player" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
	questTab.BackgroundColor3 = which == "quest" and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
end

logo.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
autoBuyTab.MouseButton1Click:Connect(function() showTab("auto") end)
playerTab.MouseButton1Click:Connect(function() showTab("player") end)
questTab.MouseButton1Click:Connect(function() showTab("quest") end)
