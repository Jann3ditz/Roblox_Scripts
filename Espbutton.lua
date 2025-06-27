-- FindButtonESP.lua

local espEnabled = true

-- Create Toggle Button GUI
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 100, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "ESP: ON"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20
ToggleBtn.BorderSizePixel = 0

-- Function to create ESP box
local function createESP(part)
	local box = Instance.new("BoxHandleAdornment")
	box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
	box.Adornee = part
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Color3 = Color3.fromRGB(255, 255, 0)
	box.Transparency = 0.3
	box.Name = "ESP_BOX"
	box.Parent = part
end

-- Function to toggle ESP
local function toggleESP()
	espEnabled = not espEnabled
	ToggleBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	ToggleBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Part") and obj.Name == "Button" then
			local existing = obj:FindFirstChild("ESP_BOX")
			if existing then existing:Destroy() end
			if espEnabled then
				createESP(obj)
			end
		end
	end
end

-- Initial ESP
toggleESP()

-- Connect toggle
ToggleBtn.MouseButton1Click:Connect(toggleESP)
