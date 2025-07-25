local espEnabled = true

local function createESP(part, text)
	local gui = Instance.new("BillboardGui")
	gui.Adornee = part
	gui.Size = UDim2.new(0, 100, 0, 40)
	gui.AlwaysOnTop = true
	gui.Name = "ESP_Tracker"

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 150)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.TextScaled = true

	gui.Parent = part
end

local function clearOldESP()
	for _, plant in ipairs(workspace:GetDescendants()) do
		if plant:IsA("BillboardGui") and plant.Name == "ESP_Tracker" then
			plant:Destroy()
		end
	end
end

local function scanFruits()
	if not espEnabled then return end
	clearOldESP()

	local plantsFolder = workspace:FindFirstChild("Farm")
	if not plantsFolder then return end
	plantsFolder = plantsFolder:FindFirstChild("Farm")
	if not plantsFolder then return end
	plantsFolder = plantsFolder:FindFirstChild("Important")
	if not plantsFolder then return end
	plantsFolder = plantsFolder:FindFirstChild("Plants_Physical")
	if not plantsFolder then return end

	for _, plant in pairs(plantsFolder:GetChildren()) do
		local fruitsFolder = plant:FindFirstChild("Fruits")
		if fruitsFolder then
			for _, fruit in pairs(fruitsFolder:GetChildren()) do
				local zentexts = fruit:FindFirstChild("1") and fruit["1"]:FindFirstChild("zentexts")
				local prim = fruit:FindFirstChild("PrimaryPart")
				if zentexts and prim and zentexts:IsA("TextLabel") then
					if zentexts.Text == "Tranquil" then
						createESP(prim, zentexts.Text)
					end
				end
			end
		end
	end
end

game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower() == "/toggleesp" then
		espEnabled = not espEnabled
		if not espEnabled then
			clearOldESP()
			warn("ESP Disabled")
		else
			warn("ESP Enabled")
			scanFruits()
		end
	end
end)

while true do
	task.wait(3)
	scanFruits()
end
