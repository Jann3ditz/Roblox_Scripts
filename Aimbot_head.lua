-- ✅ MOBILE AIMBOT + DRAGGABLE GUI | by Jann3ditz
-- Only use in private games for testing!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Wait for character
repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local Camera = workspace.CurrentCamera
local aimbotEnabled = false
local maxDistance = 15

-- 📱 GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AimbotGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 45)
button.Position = UDim2.new(0, 50, 0, 150)
button.Text = "Aimbot: OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.new(1,1,1)
button.Parent = gui
button.Active = true

-- 🧲 Dragging (Mobile Friendly)
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
	                            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = button.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- 🔘 Toggle Button
button.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	button.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
	button.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- 🧠 Aimbot Logic
RunService.RenderStepped:Connect(function()
	if not aimbotEnabled then return end
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

	local closest, shortest = nil, math.huge
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Hum
