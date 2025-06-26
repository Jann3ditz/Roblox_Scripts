-- Kill Aura Script (Instant Kill, 20 Studs, Mobile GUI Toggle)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Settings
local auraRange = 20
local auraEnabled = false

-- GUI Toggle Button
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "AuraToggleGui"
local button = Instance.new("TextButton", ScreenGui)
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "Aura: OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.SourceSansBold
button.AutoButtonColor = true

-- Toggle Logic
button.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    button.Text = auraEnabled and "Aura: ON" or "Aura: OFF"
    button.BackgroundColor3 = auraEnabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
end)

-- Aura Logic
RunService.RenderStepped:Connect(function()
    if not auraEnabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local target = player.Character:FindFirstChild("Humanoid")
            if target and target.Health > 0 then
                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance <= auraRange then
                    target.Health = 0
                end
            end
        end
    end
end)
