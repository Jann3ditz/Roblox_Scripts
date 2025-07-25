-- 🍃 Only ESP Tranquil Fruits (Grow a Garden)

-- SETTINGS:
local targetMutation = "Tranquil"

-- STATE
local fruitESPEnabled = false
local fruitESPConnections = {}

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedAssets = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ReplicatedAssets")

-- UTILS
local function isTranquil(fruit)
	return fruit.Name:lower():find(targetMutation:lower()) ~= nil
end

local function addESP(fruit)
	if fruit:FindFirstChild("ESP") then return end
	local part = fruit:FindFirstChildWhichIsA("BasePart")
	if not part then return end

	local gui = Instance.new("BillboardGui")
	gui.Name = "ESP"
	gui.Adornee = part
	gui.Size = UDim2.new(0, 100, 0, 40)
	gui.StudsOffset = Vector3.new(0, 2, 0)
	gui.AlwaysOnTop = true

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "🍃 " .. fruit.Name
	label.TextColor3 = Color3.fromRGB(85, 255, 85)
	label.TextStrokeTransparency = 0.4
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold

	gui.Parent = fruit
end

local function clearAllESP()
	for _, fruit in pairs(ReplicatedAssets:GetChildren()) do
		local esp = fruit:FindFirstChild("ESP")
		if esp then esp:Destroy() end
	end
end

local function toggleFruitESP(state)
	fruitESPEnabled = state

	if fruitESPEnabled then
		for _, fruit in pairs(ReplicatedAssets:GetChildren()) do
			if fruit:IsA("Model") and fruit:GetAttribute("FruitDebris") and isTranquil(fruit) then
				addESP(fruit)
			end
		end

		local conn = ReplicatedAssets.ChildAdded:Connect(function(fruit)
			if fruit:IsA("Model") and fruit:GetAttribute("FruitDebris") and isTranquil(fruit) then
				addESP(fruit)
			end
		end)

		table.insert(fruitESPConnections, conn)
	else
		clearAllESP()
		for _, conn in ipairs(fruitESPConnections) do
			conn:Disconnect()
		end
		table.clear(fruitESPConnections)
	end
end

-- UI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "TranquilFruitESP"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(0, 30, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, -20, 1, -20)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(85, 255, 85)
toggleButton.Text = "ESP: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.BorderSizePixel = 0

-- TOGGLE
local enabled = false
toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleButton.Text = "ESP: " .. (enabled and "ON" or "OFF")
	toggleFruitESP(enabled)
end)
