-- Settings
local hitboxSize = Vector3.new(40, 40, 40)
local player = game.Players.LocalPlayer

-- Create Draggable Button
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "HitboxGUI"

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 140, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 100)
Button.Text = "Expand Hitboxes"
Button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.Active = true
Button.Draggable = true

-- Function to resize hitboxes (other players only)
local function resizeOthers()
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			root.Size = hitboxSize
			root.CanCollide = false
			root.Transparency = 0.4 -- Slightly visible (white-ish ghost look)
			root.BrickColor = BrickColor.White()
			root.Material = Enum.Material.ForceField -- Cool glowing white-ish style
		end
	end
end

-- Auto resize on spawn for others
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if plr ~= player then
			char:WaitForChild("HumanoidRootPart")
			task.wait(1)
			resizeOthers()
		end
	end)
end)

-- Button Click
Button.MouseButton1Click:Connect(function()
	resizeOthers()
end)

-- 🛡️ Anti-Kick System
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if method == "Kick" and self == player then
		warn("[ANTI-KICK] Prevented Kick attempt!")
		return nil
	end
	return oldNamecall(self, ...)
end)

setreadonly(mt, true)
