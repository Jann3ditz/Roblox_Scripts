sition = UDim2.new(0, 20, 0, 20)
logoBtn.BackgroundTransparency = 1
logoBtn.Text = "⚡Jann"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
logoBtn.Font = Enum.Font.GothamBold
logoBtn.TextScaled = true

logoBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "TPMenu"
screenGui.ResetOnSpawn = false

-- Sound for teleport
local tpSound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
tpSound.SoundId = "rbxassetid://9118823105" -- Alien sound
tpSound.Volume = 75

-- Teleport Positions
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

-- Button Groups
local groupedButtons = {
	["🌱 Shop Area"] = { "Garden", "Seed Shop", "Sell" },
	["🦕 Prehistoric Area"] = { "Prehistoric Quest", "Prehistoric Exchange", "Prehistoric Crafting" },
	["🧰 Gear & Craft"] = { "Gear Shop", "Pet Shop", "Crafting Area", "Cosmetic Shop" },
}

-- Main Menu Frame (Draggable + Rectangular)
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 320, 0, 260)
menuFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BorderSizePixel = 0
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Visible = false

-- Title Frame with Icon + Text
local title = Instance.new("Frame", menuFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.BorderSizePixel = 0

local icon = Instance.new("ImageLabel", title)
icon.Size = UDim2.new(0, 24, 0, 24)
icon.Position = UDim2.new(0, 10, 0.5, -12)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://6031075938" -- Blue swirl icon

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 40, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Teleport Menu"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextScaled = true
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- Scrolling Frame
local scroll = Instance.new("ScrollingFrame", menuFrame)
scroll.Size = UDim2.new(1, 0, 1, -80)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6

-- Layout inside scroll
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Credits Footer
local credit = Instance.new("TextLabel", menuFrame)
credit.Size = UDim2.new(1, 0, 0, 40)
credit.Position = UDim2.new(0, 0, 1, -40)
credit.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
credit.Text = "👤 Credits to JannPlays"
credit.TextColor3 = Color3.new(1, 1, 1)
credit.Font = Enum.Font.GothamBold
credit.TextScaled = true

-- Create Category Header
local function createHeader(text)
	local header = Instance.new("TextLabel", scroll)
	header.Size = UDim2.new(1, -10, 0, 24)
	header.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	header.TextColor3 = Color3.new(0, 0, 0)
	header.Font = Enum.Font.GothamBold
	header.TextScaled = true
	header.Text = text
	header.BorderSizePixel = 0
end

-- Create Button
local function createButton(name)
	local btn = Instance.new("TextButton", scroll)
	btn.Text = name
	btn.Size = UDim2.new(1, -10, 0, 28)
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

-- Build the Menu
for section, buttons in pairs(groupedButtons) do
	createHeader(section)
	for _, name in ipairs(buttons) do
		createButton(name)
	end
end

-- Auto-Update Scroll Size
scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- ⚡Jann Logo Draggable Frame
local logoDrag = Instance.new("Frame", screenGui)
logoDrag.Size = UDim2.new(0, 60, 0, 60)
logoDrag.Position = UDim2.new(0, 20, 0, 20)
logoDrag.BackgroundTransparency = 1
logoDrag.Active = true
logoDrag.Draggable = true

-- ⚡Jann Button inside draggable
local logoBtn = Instance.new("TextButton", logoDrag)
logoBtn.Size = UDim2.new(1, 0, 1, 0)
logoBtn.Position = UDim2.new(0, 0, 0, 0)
logoBtn.BackgroundTransparency = 1
logoBtn.Text = "⚡Jann"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
logoBtn.Font = Enum.Font.GothamBold
logoBtn.TextScaled = true

logoBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)
