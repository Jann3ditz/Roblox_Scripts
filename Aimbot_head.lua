-- 📱 GUI Button with Proper Drag Support
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Name = "AimbotGUI"
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

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

-- 🧲 Dragging Function (works better on mobile)
local dragging
local dragInput
local dragStart
local startPos

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

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- 🔘 Toggle Logic
local aimbotEnabled = false
button.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	button.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
	button.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
