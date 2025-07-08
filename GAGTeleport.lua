local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local tpSound = Instance.new("Sound")
tpSound.SoundId = "rbxassetid://9118823105"
tpSound.Volume = 1000
tpSound.Parent = screenGui

local teleportPositions = {
	["Garden"] = Vector3.new(33, 3, -65),
	["Seed Shop"] = Vector3.new(87, 3, -27),
	["Sell"] = Vector3.new(87, 3, 0),
	["Prehistoric Quest"] = Vector3.new(-92, 4, -12),
	["Prehistoric Exchange"] = Vector3.new(-109, 4, -20),
	["Prehistoric Crafting"] = Vector3.new(-94, 4, -22),
	["Gear Shop"] = Vector3.new(-285, 3, -14),
	["Pet Shop"] = Vector3.new(-286, 3, -2),
	["Crafting Area"] = Vector3.new(-284, 3, -31),
	["Cosmetic Shop"] = Vector3.new(-287, 3, -25),
}

local groupedButtons = {
	["Teleport"] = {
		"Garden", "Seed Shop", "Sell", "Prehistoric Quest", "Prehistoric Exchange",
		"Prehistoric Crafting", "Gear Shop", "Pet Shop", "Crafting Area", "Cosmetic Shop"
	},
	["Access Shops"] = {
		"🗿Travelling Merchant Shop🗿",
		"🛒Gear Shop",
		"🌱Seed Shop",
		"🎨Cosmetic Shop"
	},
	["Quests"] = {
		"🦖Dino Quests",
		"📅Daily Quests"
	}
}

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 360, 0, 280)
menuFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BorderSizePixel = 0
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Visible = false
menuFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🌀 Teleport Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BorderSizePixel = 0
title.Parent = menuFrame

local categoryFrame = Instance.new("Frame")
categoryFrame.Size = UDim2.new(0, 100, 1, -80)
categoryFrame.Position = UDim2.new(0, 0, 0, 40)
categoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
categoryFrame.BorderSizePixel = 0
categoryFrame.Parent = menuFrame

local catLayout = Instance.new("UIListLayout")
catLayout.SortOrder = Enum.SortOrder.LayoutOrder
catLayout.Padding = UDim.new(0, 5)
catLayout.Parent = categoryFrame

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -100, 1, -80)
contentFrame.Position = UDim2.new(0, 100, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = menuFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 4)
contentLayout.Parent = contentFrame

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 40)
credit.Position = UDim2.new(0, 0, 1, -40)
credit.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
credit.Text = "👤 Credits to JannPlays"
credit.TextColor3 = Color3.new(1, 1, 1)
credit.Font = Enum.Font.GothamBold
credit.TextScaled = true
credit.Parent = menuFrame

local function showCategory(category)
	for _, child in ipairs(contentFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, name in ipairs(groupedButtons[category]) do
		local btn = Instance.new("TextButton")
		btn.Text = name
		btn.Size = UDim2.new(1, -10, 0, 28)
		btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.GothamBold
		btn.TextScaled = true
		btn.BorderSizePixel = 0
		btn.Parent = contentFrame

		btn.MouseButton1Click:Connect(function()
			if name == "🗿Travelling Merchant Shop🗿" then
				local merchantGui = player:WaitForChild("PlayerGui"):FindFirstChild("TravelingMerchantShop_UI")
				if merchantGui then
					local newState = not merchantGui.Enabled
					merchantGui.Enabled = newState
					merchantGui.Visible = newState
				end
			elseif name == "🛒Gear Shop" then
				local gui = player:WaitForChild("PlayerGui"):FindFirstChild("Gear_Shop")
				if gui then gui.Enabled = not gui.Enabled end
			elseif name == "🌱Seed Shop" then
				local gui = player:WaitForChild("PlayerGui"):FindFirstChild("Seed_Shop")
				if gui then gui.Enabled = not gui.Enabled end
			elseif name == "🎨Cosmetic Shop" then
				local gui = player:WaitForChild("PlayerGui"):FindFirstChild("CosmeticShop_UI")
				if gui then gui.Enabled = not gui.Enabled end
			elseif name == "🦖Dino Quests" then
				local gui = player:WaitForChild("PlayerGui"):FindFirstChild("DinoQuests_UI")
				if gui then gui.Enabled = not gui.Enabled end
			elseif name == "📅Daily Quests" then
				local gui = player:WaitForChild("PlayerGui"):FindFirstChild("DailyQuests_UI")
				if gui then gui.Enabled = not gui.Enabled end
			elseif teleportPositions[name] then
				tpSound:Play()
				character:MoveTo(teleportPositions[name])
			end
		end)
	end

	contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
end

for categoryName, _ in pairs(groupedButtons) do
	local catBtn = Instance.new("TextButton")
	catBtn.Size = UDim2.new(1, -10, 0, 30)
	catBtn.Text = categoryName
	catBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	catBtn.TextColor3 = Color3.new(1, 1, 1)
	catBtn.Font = Enum.Font.GothamBold
	catBtn.TextScaled = true
	catBtn.BorderSizePixel = 0
	catBtn.Parent = categoryFrame

	catBtn.MouseButton1Click:Connect(function()
		showCategory(categoryName)
	end)
end

local logoDrag = Instance.new("Frame")
logoDrag.Size = UDim2.new(0, 60, 0, 60)
logoDrag.Position = UDim2.new(0.5, -30, 0.1, 0)
logoDrag.BackgroundTransparency = 1
logoDrag.Active = true
logoDrag.Draggable = true
logoDrag.Parent = screenGui

local logoBtn = Instance.new("TextButton")
logoBtn.Size = UDim2.new(1, 0, 1, 0)
logoBtn.Position = UDim2.new(0, 0, 0, 0)
logoBtn.BackgroundTransparency = 1
logoBtn.Text = "⚡Jann"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
logoBtn.Font = Enum.Font.GothamBold
logoBtn.TextScaled = true
logoBtn.Parent = logoDrag

logoBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

showCategory("Teleport")
