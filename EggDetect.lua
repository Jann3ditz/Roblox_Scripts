-- 🥚 Egg Detector Buddy (Custom by Jann + ChatGPT)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 🟩 UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "EggDetectorBuddy"

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "Egg Detector: OFF"
toggleButton.Parent = screenGui

-- 🥚 Settings
local enabled = false
local eggNameKeywords = {
	"Anti Bee Egg",
	"Bee Egg",
	"Mythical Egg",
	"Primal Egg",
	"Dinosaur Egg",
	"Legendary Egg",
	"Paradise Egg"
}
local highlights = {}

-- 🔍 Highlight Eggs
local function highlightEgg(egg)
	if highlights[egg] then return end

	local tag = Instance.new("BillboardGui")
	tag.Name = "EggHighlight"
	tag.Size = UDim2.new(0, 100, 0, 40)
	tag.Adornee = egg
	tag.AlwaysOnTop = true
	tag.Parent = egg

	local label = Instance.new("TextLabel", tag)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "🥚 EGG"
	label.TextColor3 = Color3.fromRGB(255, 255, 0)
	label.TextStrokeTransparency = 0.3
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true

	highlights[egg] = tag
end

-- 🧹 Clear Highlights
local function clearHighlights()
	for egg, tag in pairs(highlights) do
		if tag then tag:Destroy() end
	end
	highlights = {}
end

-- 🌀 Detection Loop
RunService.RenderStepped:Connect(function()
	if not enabled then return end

	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj:IsDescendantOf(Workspace) then
			for _, keyword in ipairs(eggNameKeywords) do
				if string.find(string.lower(obj.Name), string.lower(keyword)) then
					highlightEgg(obj)
					break
				end
			end
		end
	end
end)

-- 🔘 Toggle logic
toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleButton.Text = "Egg Detector: " .. (enabled and "ON" or "OFF")
	toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 255)
	if not enabled then
		clearHighlights()
	end
end)

-- 🛡️ Anti-AFK
player.Idled:Connect(function()
	local vu = game:GetService("VirtualUser")
	vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)
