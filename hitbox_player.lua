-- Settings
local hitboxSize = Vector3.new(80, 80, 80)
local targetClass = "Model" -- Can be "Player", "NPC", etc. (adjust if needed)
local checkInterval = 1 -- seconds between checks

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function to resize HumanoidRootPart
local function resizeHitbox(char)
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		root.Size = hitboxSize
		root.CanCollide = false
	end
end

-- Loop for all existing and new players
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(1) -- wait to ensure character loads
		resizeHitbox(char)
	end)
end)

-- Apply to players already in-game
for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		resizeHitbox(player.Character)
	end
	player.CharacterAdded:Connect(function(char)
		wait(1)
		resizeHitbox(char)
	end)
end

-- Optional: Loop for NPCs (assuming they're in workspace and use HumanoidRootPart)
task.spawn(function()
	while true do
		for _, model in ipairs(workspace:GetDescendants()) do
			if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
				resizeHitbox(model)
			end
		end
		task.wait(checkInterval)
	end
end)
