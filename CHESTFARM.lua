local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local sandFolder = Workspace:WaitForChild("SandBlocks")

-- Toggle state
local espEnabled = false

-- Create ESP container
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "ChestESP"

-- GUI toggle
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "ESP_GUI"
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.Text = "Toggle Chest ESP"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Active = true
toggleButton.Draggable = true

-- Create label above part
local function createLabel(part, chestName)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ChestLabel"
	billboard.Adornee = part
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = espFolder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 215, 0)
	label.TextStrokeTransparency = 0.5
	label.Text = chestName
	label.Font = Enum.Font.SourceSansBold
	label.TextScaled = true
	label.Parent = billboard
end

-- Add ESP to a chest block
local function markChest(part, chestName)
	if part:FindFirstChild("Highlight") then return end

	local hl = Instance.new("Highlight")
	hl.Name = "Highlight"
	hl.FillColor = Color3.fromRGB(255, 200, 0)
	hl.OutlineColor = Color3.new(1, 1, 1)
	hl.FillTransparency = 0.6
	hl.Parent = part

	createLabel(part, chestName)
end

-- Clear all ESP
local function clearESP()
	for _, v in ipairs(espFolder:GetChildren()) do
		v:Destroy()
	end
	for _, block in ipairs(sandFolder:GetChildren()) do
		local hl = block:FindFirstChild("Highlight")
		if hl then hl:Destroy() end
	end
end

-- Toggle button click
toggleButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	toggleButton.Text = espEnabled and "Chest ESP: ON" or "Chest ESP: OFF"
	if not espEnabled then
		clearESP()
	end
end)

-- ESP loop
RunService.RenderStepped:Connect(function()
	if not espEnabled then return end
	for _, block in pairs(sandFolder:GetChildren()) do
		local chest = block:FindFirstChild("Chest")
		if chest and not block:FindFirstChild("Highlight") then
			markChest(block, chest.Value or "Chest")
		end
	end
end)
