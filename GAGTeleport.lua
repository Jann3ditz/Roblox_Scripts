local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "TPMenu"
screenGui.ResetOnSpawn = false

-- Sound on Teleport
local tpSound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
tpSound.SoundId = "rbxassetid://9118823105" -- Alien sound
tpSound.Volume = 1

-- TELEPORT LOCATIONS
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

-- BUTTON ORDER BY CATEGORY
local groupedButtons = {
	["🌱 Shop Area"] = { "Garden", "Seed Shop", "Sell" },
	["🦕 Prehistoric Area"] = { "Prehistoric Quest", "Prehistoric Exchange", "Prehistoric Crafting" },
	["🧰 Gear & Craft"] = { "Gear Shop", "Pet Shop", "Crafting Area", "Cosmetic Shop" },
}

-- MAIN MENU FRAME (DRAGGABLE)
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 280, 0, 400)
menuFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BorderSizePixel = 0
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Visible = false

-- MENU TITLE
local title = Instance.new("TextLabel", menuFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🧭 Teleport Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- SCROLLING FRAME
local scroll = Instance.new("ScrollingFrame", menuFrame)
scroll.Size = UDim2.new(1, 0, 1, -80)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6

-- UI Layout
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- CREDIT LABEL
local credit = Instance.new("TextLabel", menuFrame)
credit.Size = UDim2.new(1, 0, 0, 40)
credit.Position = UDim2.new(0, 0, 1, -40)
credit.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
credit.Text = "👤 Credits to JannPlays"
credit.TextColor3 = Color3.new(1, 1, 1)
credit.Font = Enum.Font.GothamBold
credit.TextScaled = true

-- FUNCTION: CREATE CATEGORY HEADER
local function createHeader(text)
	local header = Instance.new("TextLabel", scroll)
	header.Size = UDim2.new(1, -10, 0, 30)
	header.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	header.TextColor3 = Color3.new(0, 0, 0)
	header.Font = Enum.Font.GothamBold
	header.TextScaled = true
	header.Text = text
	header.BorderSizePixel = 0
end

-- FUNCTION: CREATE BUTTON
local function createButton(name)
	local btn = Instance.new("TextButton", scroll)
	btn.Text = name
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BorderSizePixel = 0

	btn.MouseButton1Click:Connect(function()
		local pos = teleportPositions[name]
		if pos then
			tpSound:Play()
			character:MoveTo(pos)
		end
	end)
end

-- BUILD MENU
for section, buttons in pairs(groupedButtons) do
	createHeader(section)
	for _, name in ipairs(buttons) do
		createButton(name)
	end
end

-- AUTO-UPDATE CANVAS SIZE
scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- FLOATING LOGO BUTTON (TOGGLE MENU)
local logoBtn = Instance.new("TextButton", screenGui)
logoBtn.Size = UDim2.new(0, 60, 0, 60)
logoBtn.Position = UDim2.new(0, 20, 0, 20)
logoBtn.BackgroundTransparency = 1
logoBtn.Text = "⚡Jann"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
logoBtn.Font = Enum.Font.GothamBold
logoBtn.TextScaled = true

logoBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)
