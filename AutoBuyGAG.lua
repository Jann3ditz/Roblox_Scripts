
-- ⚡ Auto Buy + Player Speed + Quest GUI (Final Integrated)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local autoBuySeeds, autoBuyGear = false, false
local selectedSeeds, selectedGears = {}, {}
local seedItems = {"Strawberry", "Orange Tulip", "Tomato", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone Seed"}
local gearItems = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Friendship Pot", "Harvest Tool", "Tanning Mirror"}

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

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

-- Tabs
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

-- Tab Logic
local currentTab = "auto"
local function showTab(tab)
currentTab = tab
autoBuyFrame.Visible = (tab == "auto")
playerFrame.Visible = (tab == "player")
questFrame.Visible = (tab == "quest")
autoBuyTab.BackgroundColor3 = tab == "auto" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
playerTab.BackgroundColor3 = tab == "player" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
questTab.BackgroundColor3 = tab == "quest" and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
end

logo.MouseButton1Click:Connect(function()
main.Visible = not main.Visible
if main.Visible then showTab(currentTab) end
end)

autoBuyTab.MouseButton1Click:Connect(function() showTab("auto") end)
playerTab.MouseButton1Click:Connect(function() showTab("player") end)
questTab.MouseButton1Click:Connect(function() showTab("quest") end)

-- Quest GUI Buttons
local dinoUI = player.PlayerGui:FindFirstChild("DinoQuests_UI")
local dailyUI = player.PlayerGui:FindFirstChild("DailyQuests_UI")
local merchantUI = player.PlayerGui:FindFirstChild("TravelingMerchantShop_UI")

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

createQuestButton("Dino Quest", 0, dinoUI)
createQuestButton("Daily Quest", 1, dailyUI)
createQuestButton("Travelling Merchant", 2, merchantUI)

-- Auto Buy Shop Lists
local function createMultiSelectSection(titleText, itemList, parent, isSeed)
local frame = Instance.new("ScrollingFrame", parent)
frame.Size = UDim2.new(0.5, -15, 1, -50)
frame.Position = isSeed and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, 5, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.ScrollBarThickness = 6
frame.CanvasSize = UDim2.new(0, 0, 2, 0)

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

createMultiSelectSection("Seed Shop", seedItems, autoBuyFrame, true)
createMultiSelectSection("Gear Shop", gearItems, autoBuyFrame, false)

-- Global Toggles
local function createGlobalToggle(name, pos, isSeed)
local toggle = Instance.new("TextButton", autoBuyFrame)
toggle.Size = UDim2.new(0.25, -10, 0, 26)
toggle.Position = pos
toggle.Text = name .. ": OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local buyAllBtn = Instance.new("TextButton", autoBuyFrame)  
buyAllBtn.Size = UDim2.new(0.25, -10, 0, 26)  
buyAllBtn.Position = UDim2.new(pos.X.Scale + 0.25, pos.X.Offset + 10, pos.Y.Scale, pos.Y.Offset)  
buyAllBtn.Text = "Buy All " .. (isSeed and "Seeds" or "Gear")  
buyAllBtn.Font = Enum.Font.GothamBold  
buyAllBtn.TextSize = 13  
buyAllBtn.TextColor3 = Color3.new(1, 1, 1)  
buyAllBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)  

local loopFlag = false  
buyAllBtn.MouseButton1Click:Connect(function()  
	loopFlag = not loopFlag  
	buyAllBtn.Text = (loopFlag and "Looping " or "Buy All ") .. (isSeed and "Seeds" or "Gear")  
end)  

task.spawn(function()  
	while true do  
		task.wait(3)  
		if loopFlag then  
			local list = isSeed and seedItems or gearItems  
			local event = isSeed and seedBuy or gearBuy  
			for _, item in ipairs(list) do  
				event:FireServer(item)  
			end  
		end  
	end  
end)  

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

createGlobalToggle("Auto Buy Seeds", UDim2.new(0, 0, 1, -30), true)
createGlobalToggle("Auto Buy Gear", UDim2.new(0.5, 5, 1, -30), false)

-- Player Tab: Speed
local walkSpeed = player.PlayerGui:GetAttribute("SavedSpeed") or 16
local minSpeed, maxSpeed = 16, 999

local speedLabel = Instance.new("TextLabel", playerFrame)
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.Text = "WalkSpeed: " .. walkSpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14

local speedInput = Instance.new("TextBox", playerFrame)
speedInput.Size = UDim2.new(1, -20, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 50)
speedInput.PlaceholderText = "Enter Speed (" .. minSpeed .. " - " .. maxSpeed .. ")"
speedInput.Text = tostring(walkSpeed)
speedInput.ClearTextOnFocus = false
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14

speedInput.FocusLost:Connect(function()
local val = tonumber(speedInput.Text)
if val and val >= minSpeed and val <= maxSpeed then
walkSpeed = val
player.PlayerGui:SetAttribute("SavedSpeed", walkSpeed)
speedLabel.Text = "WalkSpeed: " .. walkSpeed
else
speedInput.Text = tostring(walkSpeed)
end
end)

local applyToggle = Instance.new("TextButton", playerFrame)
applyToggle.Size = UDim2.new(0, 140, 0, 30)
applyToggle.Position = UDim2.new(0.5, -70, 0, 90)
applyToggle.Text = "Apply Speed: OFF"
applyToggle.Font = Enum.Font.GothamBold
applyToggle.TextSize = 14
applyToggle.TextColor3 = Color3.new(1, 1, 1)
applyToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local speedApplyOn = false

applyToggle.MouseButton1Click:Connect(function()
speedApplyOn = not speedApplyOn
applyToggle.Text = "Apply Speed: " .. (speedApplyOn and "ON" or "OFF")
applyToggle.BackgroundColor3 = speedApplyOn and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Runtime

-- Auto Buy Loop
task.spawn(function()
while true do
task.wait(1)
if autoBuySeeds then for _, seed in ipairs(selectedSeeds) do seedBuy:FireServer(seed) end end
if autoBuyGear then for _, gear in ipairs(selectedGears) do gearBuy:FireServer(gear) end end
end
end)

-- Speed Apply Loop
task.spawn(function()
while true do
task.wait(3)
if speedApplyOn then
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = walkSpeed end
end
end
end)

-- Default
showTab("auto")

