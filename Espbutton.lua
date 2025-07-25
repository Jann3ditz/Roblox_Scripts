-- 🌿 Tranquil ESP + Auto-Collect Script 🌿
-- Author: Jann3ditz (Full Feature Edition)

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "TranquilESP_GUI"

-- GUI: ESP Toggle
local espButton = Instance.new("TextButton", screenGui)
espButton.Size = UDim2.new(0, 120, 0, 40)
espButton.Position = UDim2.new(0, 10, 0, 100)
espButton.Text = "ESP: OFF"
espButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.BorderSizePixel = 2
espButton.ZIndex = 10

-- GUI: AutoCollect Toggle
local collectButton = Instance.new("TextButton", screenGui)
collectButton.Size = UDim2.new(0, 120, 0, 40)
collectButton.Position = UDim2.new(0, 10, 0, 150)
collectButton.Text = "Collect: OFF"
collectButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
collectButton.TextColor3 = Color3.new(1, 1, 1)
collectButton.BorderSizePixel = 2
collectButton.ZIndex = 10

-- State flags
local isESPEnabled = false
local isAutoCollect = false
local activeESPs = {}

-- Clear ESPs
local function clearESP()
	for _, esp in pairs(activeESPs) do
		if esp and esp:IsA("BillboardGui") then
			esp:Destroy()
		end
	end
	activeESPs = {}
end

-- Create ESP label
local function createESP(fruitModel)
	local bb = Instance.new("BillboardGui")
	bb.Name = "TranquilESP"
	bb.Size = UDim2.new(0, 100, 0, 30)
	bb.AlwaysOnTop = true
	bb.Adornee = fruitModel.PrimaryPart or fruitModel:FindFirstChildWhichIsA("BasePart")
	bb.Parent = screenGui

	local label = Instance.new("TextLabel", bb)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "🍃 TRANQUIL"
	label.TextColor3 = Color3.fromRGB(0, 255, 150)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold

	table.insert(activeESPs, bb)
end

-- Collect the fruit (simulate click or proximity)
local function collectFruit(fruitModel)
	local touchPart = fruitModel:FindFirstChild("TouchInterest") or fruitModel.PrimaryPart
	if touchPart then
		firetouchinterest(player.Character.HumanoidRootPart, fruitModel.PrimaryPart, 0)
		firetouchinterest(player.Character.HumanoidRootPart, fruitModel.PrimaryPart, 1)
	end
end

-- Scan for Tranquil fruits
local function scanFruits()
	clearESP()

	for _, plant in pairs(workspace.Farm.Farm.Important.Plants_Physical:GetChildren()) do
		local fruits = plant:FindFirstChild("Fruits")
		if fruits then
			for _, fruit in pairs(fruits:GetChildren()) do
				local labelFrame = fruit:FindFirstChild("1")
				local zenText = labelFrame and labelFrame:FindFirstChild("zentexts")
				if zenText and zenText:IsA("TextLabel") and zenText.Text:lower():find("tranquil") then
					createESP(fruit)
					if isAutoCollect then
						collectFruit(fruit)
					end
				end
			end
		end
	end
end

-- Button Toggle Logic
espButton.MouseButton1Click:Connect(function()
	isESPEnabled = not isESPEnabled
	espButton.Text = isESPEnabled and "ESP: ON" or "ESP: OFF"
	if not isESPEnabled then
		clearESP()
	end
end)

collectButton.MouseButton1Click:Connect(function()
	isAutoCollect = not isAutoCollect
	collectButton.Text = isAutoCollect and "Collect: ON" or "Collect: OFF"
end)

-- Refresh loop
task.spawn(function()
	while true do
		task.wait(5)
		if isESPEnabled then
			scanFruits()
		end
	end
end)
