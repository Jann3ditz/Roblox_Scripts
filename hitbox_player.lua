-- Settings
local hitboxSize = Vector3.new(50, 50, 50)
local player = game.Players.LocalPlayer

-- Create Draggable Button
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "HitboxGUI"

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 120, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 100)
Button.Text = "Expand Hitboxes"
Button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.Active = true
Button.Draggable = true -- Makes the button draggable

-- Function to Resize Hitbox (excluding self)
local function resizeOthers()
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			root.Size = hitboxSize
			root.CanCollide = false
		end
	end
end

-- Auto resize on new character spawn (for others only)
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if plr ~= player then
			char:WaitForChild("HumanoidRootPart")
			task.wait(1)
			resizeOthers()
		end
	end)
end)

-- Button Click Action
Button.MouseButton1Click:Connect(function()
	resizeOthers()
end)
