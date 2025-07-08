local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Screen GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "TPMenu"
screenGui.ResetOnSpawn = false

-- Draggable Frame
local dragFrame = Instance.new("Frame", screenGui)
dragFrame.Size = UDim2.new(0, 260, 0, 60)
dragFrame.Position = UDim2.new(0, 20, 0, 100)
dragFrame.BackgroundTransparency = 1
dragFrame.Active = true
dragFrame.Draggable = true

-- Logo Image Button
local logoBtn = Instance.new("ImageButton", dragFrame)
logoBtn.Size = UDim2.new(0, 60, 0, 60)
logoBtn.Position = UDim2.new(0, 0, 0, 0)
logoBtn.BackgroundTransparency = 1
logoBtn.Image = "rbxassetid://6031075938" -- ⚡ Replace with your own logo ID

-- Logo Label
local label = Instance.new("TextLabel", logoBtn)
label.Size = UDim2.new(0, 180, 1, 0)
label.Position = UDim2.new(1, 0, 0, 0)
label.BackgroundTransparency = 1
label.Text = "⚡Jann"
label.TextColor3 = Color3.fromRGB(255, 255, 0)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextXAlignment = Enum.TextXAlignment.Left

-- Menu Frame
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 260, 0, 570)
menuFrame.Position = UDim2.new(0, 20, 0, 170)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false

-- Menu Title
local sectionTitle = Instance.new("TextLabel", menuFrame)
sectionTitle.Size = UDim2.new(1, 0, 0, 40)
sectionTitle.Position = UDim2.new(0, 0, 0, 0)
sectionTitle.Text = "🧭 Teleport Menu"
sectionTitle.TextColor3 = Color3.new(1, 1, 1)
sectionTitle.Font = Enum.Font.GothamBold
sectionTitle.TextScaled = true
sectionTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sectionTitle.BorderSizePixel = 0

-- Alien TP Sound
local tpSound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
tpSound.SoundId = "rbxassetid://9118823105" -- Alien laser sound
tpSound.Volume = 1

-- Toggle menu
logoBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Teleport positions
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

-- Create teleport buttons
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

-- List of teleport buttons
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

-- Generate all buttons
for i, name in ipairs(buttonNames) do
	createButton(name, i)
end
