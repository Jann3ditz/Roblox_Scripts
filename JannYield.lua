-- JannYield (Infinite Yield Custom Wrapper)
-- Credits: Original by EdgeIY | Custom Wrapper by Jann3ditz

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Load original Infinite Yield source
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

if not success then
    warn("JannYield failed to load Infinite Yield:", err)
    return
end

-- Wait for the GUI to fully load
repeat wait() until player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("InfiniteYield")

local IY = player.PlayerGui:FindFirstChild("InfiniteYield")
if IY then
    -- Rename GUI
    IY.Name = "JannYield"

    -- Look for the Topbar and logo button
    local Topbar = IY:FindFirstChild("Topbar", true)
    if Topbar then
        for _, v in ipairs(Topbar:GetDescendants()) do
            if v:IsA("TextButton") and v.Text == "IY" then
                -- Customize logo appearance
                v.Text = "JY"
                v.Name = "JannLogo"
                v.BackgroundColor3 = Color3.new(1, 1, 1) -- White
                v.TextColor3 = Color3.new(0, 0, 0) -- Black

                -- Keep original click behavior (opens command bar)
                break
            end
        end
    end
end
