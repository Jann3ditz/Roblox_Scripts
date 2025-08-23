local player = game.Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LockTPGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Logo Button (draggable)
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 80, 0, 40)
logo.Position = UDim2.new(0, 20, 0, 200)
logo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logo.Text = "JANN"
logo.TextColor3 = Color3.fromRGB(255,255,255)
logo.Font = Enum.Font.SourceSansBold
logo.TextScaled = true
logo.Parent = gui
logo.Draggable = true -- makes the logo movable

-- Menu Frame
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 250, 0, 300)
menu.Position = UDim2.new(0, 100, 0, 150)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu)

-- Toggle Menu
logo.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "LockTP + Hitbox"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Parent = menu

--// LockTP Section
local locktpBtn = Instance.new("TextButton")
locktpBtn.Size = UDim2.new(1, -20, 0, 40)
locktpBtn.Position = UDim2.new(0, 10, 0, 60)
locktpBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
locktpBtn.Text = "LockTP: OFF"
locktpBtn.TextColor3 = Color3.fromRGB(255,255,255)
locktpBtn.TextScaled = true
locktpBtn.Parent = menu

-- LockTP Logic
local isToggled = false
local function getMyLock()
	local basesFolder = workspace:WaitForChild("Bases")
	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") then
			local owner = base:FindFirstChild("Owner")
			if owner and owner:FindFirstChild("OwnerGui") then
				local displayNameLabel = owner.OwnerGui:FindFirstChild("DisplayName")
				if displayNameLabel and displayNameLabel:IsA("TextLabel") then
					if displayNameLabel.Text == player.DisplayName then
						local lockPart = base:FindFirstChild("Lock")
						if lockPart and lockPart:IsA("BasePart") then
							return lockPart
						end
					end
				end
			end
		end
	end
	return nil
end

-- Auto TP loop
task.spawn(function()
	while task.wait(0.5) do
		if isToggled then
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local lockPart = getMyLock()
			if hrp and lockPart then
				hrp.CFrame = lockPart.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end
end)

-- Button click toggle
locktpBtn.MouseButton1Click:Connect(function()
	isToggled = not isToggled
	locktpBtn.Text = isToggled and "LockTP: ON" or "LockTP: OFF"
	locktpBtn.BackgroundColor3 = isToggled and Color3.fromRGB(0,200,100) or Color3.fromRGB(50,150,250)
end)

--// Hitbox Section
local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Size = UDim2.new(1, -20, 0, 30)
hitboxLabel.Position = UDim2.new(0, 10, 0, 120)
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.Text = "Hitbox Size:"
hitboxLabel.TextColor3 = Color3.fromRGB(255,255,255)
hitboxLabel.TextScaled = true
hitboxLabel.Parent = menu

local hitboxInput = Instance.new("TextBox")
hitboxInput.Size = UDim2.new(1, -20, 0, 40)
hitboxInput.Position = UDim2.new(0, 10, 0, 150)
hitboxInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hitboxInput.Text = "5"
hitboxInput.TextColor3 = Color3.fromRGB(255,255,255)
hitboxInput.TextScaled = true
hitboxInput.ClearTextOnFocus = false
hitboxInput.Parent = menu

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1, -20, 0, 40)
applyBtn.Position = UDim2.new(0, 10, 0, 200)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
applyBtn.Text = "Apply Hitbox"
applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
applyBtn.TextScaled = true
applyBtn.Parent = menu

-- Hitbox Handler
local hitboxLooping = false
applyBtn.MouseButton1Click:Connect(function()
	local size = tonumber(hitboxInput.Text)
	if size then
		hitboxLooping = true
		print("Hitbox set to: "..size)
		task.spawn(function()
			while hitboxLooping do
				for _,v in pairs(game.Players:GetPlayers()) do
					if v.Character and v ~= player then
						local hrp = v.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							hrp.Size = Vector3.new(size, size, size)
							hrp.Transparency = 0.8
							hrp.BrickColor = BrickColor.new("Really red")
							hrp.Material = Enum.Material.Neon
							hrp.CanCollide = false
						end
					end
				end
				task.wait(0.5)
			end
		end)
	end
end)
