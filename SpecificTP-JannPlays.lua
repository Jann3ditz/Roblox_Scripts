-- LocalScript for teleport button (put inside StarterPlayerScripts)

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create the teleport button
local button = Instance.new("TextButton")
button.Name = "TeleportButton"
button.Parent = screenGui
button.Size = UDim2.new(0, 130, 0, 45)
button.Position = UDim2.new(0, 10, 0, 10) -- Top-left corner
button.Text = "Teleport"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 22
button.BorderSizePixel = 0
button.BackgroundTransparency = 0.1
button.Active = true
button.Draggable = true

-- Teleport destination
local targetPosition = Vector3.new(138, 355, 206)

-- On button click, teleport the player
button.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	if character then
		character:MoveTo(targetPosition)
	end
end)
