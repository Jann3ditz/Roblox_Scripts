local player = game:GetService("Players").LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetMoverMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🧸 Pet Mover"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BorderSizePixel = 0
title.Parent = mainFrame

-- Input field generator
local function createInput(name, position)
	local label = Instance.new("TextLabel")
	label.Text = name .. ":"
	label.Size = UDim2.new(0, 40, 0, 25)
	label.Position = UDim2.new(0, 10, 0, position)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextScaled = true
	label.Parent = mainFrame

	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(0, 200, 0, 25)
	box.Position = UDim2.new(0, 60, 0, position)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = "Enter "..name
	box.TextScaled = true
	box.BorderSizePixel = 0
	box.Parent = mainFrame
	return box
end

local xInput = createInput("X", 50)
local yInput = createInput("Y", 85)
local zInput = createInput("Z", 120)

-- Move Button
local moveBtn = Instance.new("TextButton")
moveBtn.Size = UDim2.new(1, -20, 0, 35)
moveBtn.Position = UDim2.new(0, 10, 0, 160)
moveBtn.Text = "📍 Move & Freeze Moon Cat"
moveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
moveBtn.TextColor3 = Color3.new(1, 1, 1)
moveBtn.Font = Enum.Font.GothamBold
moveBtn.TextScaled = true
moveBtn.BorderSizePixel = 0
moveBtn.Parent = mainFrame

-- Pet Moving Logic
moveBtn.MouseButton1Click:Connect(function()
	local x = tonumber(xInput.Text)
	local y = tonumber(yInput.Text)
	local z = tonumber(zInput.Text)
	if not (x and y and z) then
		warn("❌ Invalid coordinates.")
		return
	end

	local pets = workspace:WaitForChild("PetsPhysical"):GetChildren()
	for _, pet in ipairs(pets) do
		local root = pet:FindFirstChild("HumanoidRootPart") or pet.PrimaryPart
		if root and (pet.Name:lower():find("moon") or pet:FindFirstChild("Mooncat")) then
			for _, obj in ipairs(pet:GetDescendants()) do
				if obj:IsA("Weld") or obj:IsA("Motor6D") then
					obj:Destroy()
				end
			end
			root.Anchored = true
			root.CFrame = CFrame.new(x, y, z)
			print("✅ Moon Cat moved to:", x, y, z)
			break
		end
	end
end)
