-- ⚙️ Settings
local hitboxSize = Vector3.new(30, 30, 30) -- safer size
local player = game.Players.LocalPlayer

-- 🖱️ Draggable GUI Button
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "HitboxGUI"

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 140, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 100)
Button.Text = "Apply Hitboxes"
Button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.Active = true
Button.Draggable = true

-- 🛡️ Advanced Anti-Kick
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if tostring(self) == "Kick" or method == "Kick" then
		warn("[ANTI-KICK] Blocked kick attempt")
		return nil
	end
	return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- 🔁 Hitbox Apply Function (Other players only)
local function resizeOthers()
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			root.Size = hitboxSize
			root.CanCollide = false
			-- 👇 Delayed to reduce server stress
			task.wait(math.random(0.15, 0.35))
		end
	end
end

-- 🧠 Hook into new players spawning
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if plr ~= player then
			char:WaitForChild("HumanoidRootPart")
			task.wait(1)
			resizeOthers()
		end
	end)
end)

-- 🖱️ Button Click = Apply hitboxes
Button.MouseButton1Click:Connect(function()
	resizeOthers()
end)
