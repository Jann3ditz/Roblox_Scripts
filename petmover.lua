local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PetsPhysical = workspace:WaitForChild("PetsPhysical")
local GetFarm = require(ReplicatedStorage.Modules:WaitForChild("GetFarm"))

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetMoverMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 270)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🧸 Pet Mover (Equipped Only)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BorderSizePixel = 0
title.Parent = mainFrame

-- Dropdown Frame
local dropdownLabel = Instance.new("TextLabel")
dropdownLabel.Text = "Select Pet:"
dropdownLabel.Size = UDim2.new(0, 80, 0, 25)
dropdownLabel.Position = UDim2.new(0, 10, 0, 50)
dropdownLabel.TextColor3 = Color3.new(1, 1, 1)
dropdownLabel.BackgroundTransparency = 1
dropdownLabel.Font = Enum.Font.Gotham
dropdownLabel.TextScaled = true
dropdownLabel.Parent = mainFrame

local petDropdown = Instance.new("TextButton")
petDropdown.Size = UDim2.new(0, 240, 0, 25)
petDropdown.Position = UDim2.new(0, 100, 0, 50)
petDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
petDropdown.TextColor3 = Color3.new(1, 1, 1)
petDropdown.Font = Enum.Font.Gotham
petDropdown.TextScaled = true
petDropdown.Text = "Click to Select Pet"
petDropdown.Parent = mainFrame

-- Pet dropdown list container
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Visible = false
dropdownFrame.Size = UDim2.new(0, 240, 0, 100)
dropdownFrame.Position = UDim2.new(0, 100, 0, 75)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = true
dropdownFrame.Parent = mainFrame

local dropdownScroll = Instance.new("ScrollingFrame")
dropdownScroll.Size = UDim2.new(1, 0, 1, 0)
dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownScroll.ScrollBarThickness = 4
dropdownScroll.BackgroundTransparency = 1
dropdownScroll.Parent = dropdownFrame

local dropdownLayout = Instance.new("UIListLayout")
dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
dropdownLayout.Padding = UDim.new(0, 2)
dropdownLayout.Parent = dropdownScroll

-- Inputs
local function createInput(name, yOffset)
	local label = Instance.new("TextLabel")
	label.Text = name .. ":"
	label.Size = UDim2.new(0, 40, 0, 25)
	label.Position = UDim2.new(0, 10, 0, yOffset)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextScaled = true
	label.Parent = mainFrame

	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(0, 240, 0, 25)
	box.Position = UDim2.new(0, 100, 0, yOffset)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = "Enter " .. name
	box.TextScaled = true
	box.BorderSizePixel = 0
	box.Parent = mainFrame

	return box
end

local xInput = createInput("X", 120)
local yInput = createInput("Y", 155)
local zInput = createInput("Z", 190)

-- Move Button
local moveBtn = Instance.new("TextButton")
moveBtn.Size = UDim2.new(1, -20, 0, 35)
moveBtn.Position = UDim2.new(0, 10, 0, 230)
moveBtn.Text = "📍 Move & Freeze Selected Pet"
moveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
moveBtn.TextColor3 = Color3.new(1, 1, 1)
moveBtn.Font = Enum.Font.GothamBold
moveBtn.TextScaled = true
moveBtn.BorderSizePixel = 0
moveBtn.Parent = mainFrame

-- Detect equipped pets from player's farm
local equippedPets = {}
local selectedPetName = nil

local function loadEquippedPets()
	equippedPets = {}
	local farm = GetFarm(player)
	if farm and farm.PetArea then
		for _, model in ipairs(PetsPhysical:GetChildren()) do
			if model:IsA("Model") and model.PrimaryPart and model:IsDescendantOf(PetsPhysical) then
				if farm.PetArea:IsAncestorOf(model) or (model.PrimaryPart.Position - farm.PetArea.Position).Magnitude < 80 then
					table.insert(equippedPets, model)
				end
			end
		end
	end
end

local function populateDropdown()
	dropdownScroll:ClearAllChildren()
	for _, pet in ipairs(equippedPets) do
		local petBtn = Instance.new("TextButton")
		petBtn.Size = UDim2.new(1, 0, 0, 25)
		petBtn.Text = pet.Name
		petBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		petBtn.TextColor3 = Color3.new(1, 1, 1)
		petBtn.Font = Enum.Font.Gotham
		petBtn.TextScaled = true
		petBtn.Parent = dropdownScroll

		petBtn.MouseButton1Click:Connect(function()
			selectedPetName = pet.Name
			petDropdown.Text = pet.Name
			dropdownFrame.Visible = false
		end)
	end
	dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y)
end

-- Toggle dropdown visibility
petDropdown.MouseButton1Click:Connect(function()
	dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Move & freeze selected pet
moveBtn.MouseButton1Click:Connect(function()
	if not selectedPetName then warn("❌ No pet selected") return end

	local x = tonumber(xInput.Text)
	local y = tonumber(yInput.Text)
	local z = tonumber(zInput.Text)
	if not (x and y and z) then warn("❌ Invalid coordinates") return end

	local target = PetsPhysical:FindFirstChild(selectedPetName)
	if target and target:IsA("Model") and target.PrimaryPart then
		for _, desc in ipairs(target:GetDescendants()) do
			if desc:IsA("Weld") or desc.Name == "RootPart_PetMover_WELD" then
				desc:Destroy()
			end
		end
		target.PrimaryPart.Anchored = true
		target:SetPrimaryPartCFrame(CFrame.new(x, y, z))
		print("✅ Moved:", selectedPetName)
	else
		warn("❌ Pet not found or invalid model")
	end
end)

-- Initialize
loadEquippedPets()
populateDropdown()
