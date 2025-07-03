local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local DEFAULT_SPEED = 16
local currentSpeed = DEFAULT_SPEED
local speedOn = false
local isGuiOpen = false

-- GUI Container
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "SpeedAdjuster"
screenGui.ResetOnSpawn = false

-- ⚡ Toggle Button (always visible)
local logoBtn = Instance.new("TextButton", screenGui)
logoBtn.Size = UDim2.new(0, 80, 0, 40)
logoBtn.Position = UDim2.new(0, 20, 0, 20)
logoBtn.Text = "⚡"
logoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
logoBtn.TextColor3 = Color3.new(1, 1, 1)
logoBtn.Font = Enum.Font.SourceSansBold
logoBtn.TextSize = 22
logoBtn.Name = "LogoToggle"

-- Main speed panel (start offscreen)
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 220, 0, 150)
main.Position = UDim2.new(0, -250, 0, 20)  -- hidden left
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Title bar
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Speed Adjuster"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Speed toggle button
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.Size = UDim2.new(0, 200, 0, 30)
toggleBtn.Text = "Speed: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18

-- Speed input box
local speedBox = Instance.new("TextBox", main)
speedBox.Position = UDim2.new(0, 10, 0, 80)
speedBox.Size = UDim2.new(0, 200, 0, 30)
speedBox.Text = tostring(DEFAULT_SPEED)
speedBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 18
speedBox.ClearTextOnFocus = false

-- Tween animation targets
local visiblePos = UDim2.new(0, 120, 0, 20)
local hiddenPos = UDim2.new(0, -250, 0, 20)

-- Speed loop
local function startSpeedLoop()
	while speedOn do
		local char = lp.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = currentSpeed
		end
		wait(0.5)
	end
end

-- Toggle speed
toggleBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	if speedOn then
		toggleBtn.Text = "Speed: ON"
		startSpeedLoop()
	else
		toggleBtn.Text = "Speed: OFF"
		local char = lp.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = DEFAULT_SPEED
		end
	end
end)

-- Speed change from input
speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val > 0 and val <= 99999 then
		currentSpeed = val
	else
		speedBox.Text = tostring(currentSpeed)
	end
end)

-- Respawn handling
lp.CharacterAdded:Connect(function(char)
	repeat wait() until char:FindFirstChild("Humanoid")
	if speedOn then
		wait(3)
		startSpeedLoop()
	end
end)

-- Initial walk speed
if lp.Character and lp.Character:FindFirstChild("Humanoid") then
	lp.Character.Humanoid.WalkSpeed = DEFAULT_SPEED
end

-- ⚡ Toggle GUI visibility with animation
logoBtn.MouseButton1Click:Connect(function()
	isGuiOpen = not isGuiOpen
	logoBtn.Text = isGuiOpen and "⚡ Jann" or "⚡"

	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goal = { Position = isGuiOpen and visiblePos or hiddenPos }
	TweenService:Create(main, tweenInfo, goal):Play()
end)
