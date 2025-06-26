-- ⚙️ Settings
local hitboxSize = Vector3.new(30, 30, 30) -- Stealthy hitbox
local player = game.Players.LocalPlayer
local isEnabled = false

-- 🖱️ Draggable GUI Button
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "HitboxGUI"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0, 20, 0, 100)
button.Text = "Hitbox: OFF"
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Active = true
button.Draggable = true

-- 🛡️ Anti-Kick Hook
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if tostring(self) == "Kick" or method == "Kick" then
		warn("[ANTI-KICK] Blocked kick attempt")
		return nil
	end
	return old(self, ...)
end)
setreadonly(mt, true)

-- 🔁 Apply or Reset Hitboxes
local function updateHitboxes(enable)
	for _, plr in ipairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			if enable then
				root.Size = hitboxSize
				root.CanCollide = false
				root.CanTouch = false
				root.Massless = true
			else
				root.Size = Vector3.new(2, 2, 1) -- default size
				root.CanCollide = true
				root.CanTouch = true
				root.Massless = false
			end
			task.wait(0.05)
		end
	end
end

-- 🧠 Watch for new players joining
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if isEnabled then updateHitboxes(true) end
	end)
end)

-- 🖱️ Button Click to Toggle ON/OFF
button.MouseButton1Click:Connect(function()
	isEnabled = not isEnabled
	updateHitboxes(isEnabled)
	if isEnabled then
		button.Text = "Hitbox: ON"
		button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	else
		button.Text = "Hitbox: OFF"
		button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)
