local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Screen GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "TPMenu"
screenGui.ResetOnSpawn = false

-- Sound for teleport
local tpSound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
tpSound.SoundId = "rbxassetid://9118823105" -- Alien sound
tpSound.Volume = 1

-- Teleport Coordinates
local teleportPositions = {
	["Garden"] = Vector3.new(33, 3, -65),
	["Seed Shop"] = Vector3.new(87, 3, -27),
	["Sell"] = Vector3.new(87, 3, 0),
	["Prehistoric Quest"] = Vector3.new(-92, 4, -12),
	["Prehistoric Exchange"] = Vector3.new(-109, 4, -20),
	["Gear Shop"] = Vector3.new(-285, 3, -14),
	["Pet Shop"] = Vector3.new(-286, 3, -2),
	["Crafting Area"] = Vector3.new(-284, 3, -31),
	["Cosmetic Shop"] = Vector3.new(-287, 3, -25),
	["Prehistoric Crafting"] = Vector3.new(-94, 4, -22),
}

-- Teleport Button Names
local buttonNames = {
	"Garden",
	"Seed Shop",
	"Sell",
	"Prehistoric Quest",
	"Prehistoric Exchange",
	"Gear Shop",
	"Pet Shop",
	"Crafting Area",
	"Cosmetic Shop",
	"Prehistoric Crafting",
}

-- Create draggable teleport menu
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 260, 0, 560)
menuFrame.Position = UDim2.new(0.5, -130, 0.5, -280) -- Centered
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true

-- Title Bar
local sectionTitle = Instance.new("TextLabel", menuFrame)
sectionTitle.Size = UDim2.new(1, 0, 0, 40)
sectionTitle.Position = UDim2.new(0, 0, 0, 0)
sectionTitle.Text = "🧭 Teleport Menu"
sectionTitle.TextColor3 = Color3.new(1, 1, 1)
sectionTitle.Font = Enum.Font.GothamBold
sectionTitle.TextScaled = true
sectionTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sectionTitle.BorderSizePixel = 0

-- Function to create teleport buttons
local function createButton(name, index)
	local btn = Instance.new("TextButton", menuFrame)
	btn.Name = name:gsub(" ", "") .. "Button"
	btn.Text = name
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, (index - 1) * 45 + 50)
	btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true

	btn.MouseButton1Click:Connect(function()
		local pos = teleportPositions[name]
		if pos then
			tpSound:Play()
			character:MoveTo(pos)
		else
			warn("Missing teleport location for:", name)
		end
	end)
end

-- Create buttons in menu
for i, name in ipairs(buttonNames) do
	createButton(name, i)
end

-- Small logo button (⚡Jann)
local logoBtn = Instance.new("TextButton", screenGui)
logoBtn.Size = UDim2.new(0, 60, 0, 60)
logoBtn.Position = UDim2.new(0, 20, 0, 20)
logoBtn.BackgroundTransparency = 1
logoBtn.Text = "⚡Jann"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
logoBtn.Font = Enum.Font.GothamBold
logoBtn.TextScaled = true

-- Logo click toggles the menu
logoBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)
