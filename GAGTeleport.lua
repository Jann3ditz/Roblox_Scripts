local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Sound
local tpSound = Instance.new("Sound")
tpSound.SoundId = "rbxassetid://9118823105"
tpSound.Volume = 60
tpSound.Parent = screenGui

-- Teleport positions
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
	["🌱 Shop Area"] = { "Garden", "Seed Shop", "Sell" },
	["🦕 Prehistoric Area"] = { "Prehistoric Quest", "Prehistoric Exchange", "Prehistoric Crafting" },
	["🧰 Gear & Craft"] = { "Gear Shop", "Pet Shop", "Crafting Area", "Cosmetic Shop" },
}

-- Main menu frame
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 320, 0, 260)
menuFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BorderSizePixel = 0
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- Title header with emoji + label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🌀 Teleport Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BorderSizePixel = 0
title.Parent = menuFrame

-- Scroll Frame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -80)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.Parent = menuFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

-- Credits
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 40)
credit.Position = UDim2.new(0, 0, 1, -40)
credit.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
credit.Text = "👤 Credits to JannPlays"
credit.TextColor3 = Color3.new(1, 1, 1)
credit.Font = Enum.Font.GothamBold
credit.TextScaled = true
credit.Parent = menuFrame

-- Functions
local function createHeader(text)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -10, 0, 24)
	header.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	header.TextColor3 = Color3.new(0, 0, 0)
	header.Font = Enum.Font.GothamBold
	header.TextScaled = true
	header.Text = text
	header.BorderSizePixel = 0
	header.Parent = scroll
end

local function createButton(name)
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(1, -10, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.Parent = scroll

	btn.MouseButton1Click:Connect(function()
		local pos = teleportPositions[name]
		if pos then
			tpSound:Play()
			character:MoveTo(pos)
		end
	end)
end

-- Build menu
for section, buttons in pairs(groupedButtons) do
	createHeader(section)
	for _, name in ipairs(buttons) do
		createButton(name)
	end
end

scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- Floating draggable ⚡ logo
local logoDrag = Instance.new("Frame")
logoDrag.Size = UDim2.new(0, 60, 0, 60)
logoDrag.Position = UDim2.new(0, 20, 0, 20)
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
