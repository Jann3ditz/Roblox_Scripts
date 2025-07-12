-- ⚡ Auto Buy + Player Speed + Quest GUI  (Final Integrated v2 - 2025-07-12)

---------------------------------------------------------------------
-- services & remotes
---------------------------------------------------------------------
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local player             = Players.LocalPlayer

local gearBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local seedBuy = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

---------------------------------------------------------------------
-- state flags & selections
---------------------------------------------------------------------
local autoBuySeeds, autoBuyGear = false, false
local selectedSeeds, selectedGears = {}, {}     -- [itemName] = true / false

---------------------------------------------------------------------
-- master item lists (used to build the UI)
---------------------------------------------------------------------
local seedItems = {
	"Strawberry","Orange Tulip","Tomato","Daffodil","Watermelon","Pumpkin",
	"Apple","Bamboo","Coconut","Cactus","Dragon Fruit","Mango",
	"Grape","Mushroom","Pepper","Cacao","Beanstalk","Sugar Apple","Burning Bud"
}

local gearItems = {
	"Watering Can","Trowel","Recall Wrench",
	"Basic Sprinkler","Advanced Sprinkler","Godly Sprinkler","Master Sprinkler",
	"Magnifying Glass","Cleaning Spray",
	"Favorite Tool","Friendship Pot",
	"Harvest Tool","Tanning Mirror"          -- 🆕 added
}

---------------------------------------------------------------------
-- ⚠️  gear-slot map  ⚠️
-- The server expects a slot index, so keep this table up-to-date
---------------------------------------------------------------------
local gearToSlot = {
	["Watering Can"]       = 1,
	["Trowel"]             = 2,
	["Recall Wrench"]      = 3,
	["Basic Sprinkler"]    = 4,
	["Advanced Sprinkler"] = 5,  -- corrected spelling
	["Godly Sprinkler"]    = 6,
	["Master Sprinkler"]   = 7,
	["Magnifying Glass"]   = 8,
	["Cleaning Spray"]     = 9,
	["Favorite Tool"]      = 10,
	["Friendship Pot"]     = 11,
	["Harvest Tool"]       = 12, -- <-- verify in shop UI
	["Tanning Mirror"]     = 13  -- <-- verify in shop UI
}

-- alias for the old shop spelling so either string works
gearToSlot["Advance Sprinkler"] = gearToSlot["Advanced Sprinkler"]

---------------------------------------------------------------------
-- safe fire helpers (prevents nil-index crashes)
---------------------------------------------------------------------
local function safeFireGear(name)
	local slot = gearToSlot[name]
	if slot then
		gearBuy:FireServer(slot)
	else
		warn(("⚡ AutoBuy: No slot mapping for “%s” - skipped"):format(name))
	end
end

local function safeFireSeed(name)
	-- seeds are bought directly by name, so we can just call the remote.
	-- If the dev later changes a seedId system, wrap it the same way.
	seedBuy:FireServer(name)
end

---------------------------------------------------------------------
-- basic GUI scaffolding (unchanged)
---------------------------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoBuyGUI"

-- Open Button
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0, 120, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
logo.Text = "⚡ Jann"
logo.Font = Enum.Font.FredokaOne
logo.TextColor3 = Color3.new(1, 1, 1)
logo.TextSize = 20

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Visible = false
main.Active = true
main.Draggable = true

-- Tabs
local autoBuyTab = Instance.new("TextButton", main)
autoBuyTab.Size = UDim2.new(0, 100, 0, 30)
autoBuyTab.Position = UDim2.new(0, 10, 0, 10)
autoBuyTab.Text = "Auto Buy"
autoBuyTab.Font = Enum.Font.GothamBold
autoBuyTab.TextColor3 = Color3.new(1, 1, 1)
autoBuyTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

local playerTab = Instance.new("TextButton", main)
playerTab.Size = UDim2.new(0, 100, 0, 30)
playerTab.Position = UDim2.new(0, 120, 0, 10)
playerTab.Text = "Player"
playerTab.Font = Enum.Font.GothamBold
playerTab.TextColor3 = Color3.new(1, 1, 1)
playerTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local questTab = Instance.new("TextButton", main)
questTab.Size = UDim2.new(0, 100, 0, 30)
questTab.Position = UDim2.new(0, 230, 0, 10)
questTab.Text = "Quest"
questTab.Font = Enum.Font.GothamBold
questTab.TextColor3 = Color3.new(1, 1, 1)
questTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Content Frames
local autoBuyFrame = Instance.new("Frame", main)
autoBuyFrame.Size = UDim2.new(1, -20, 1, -50)
autoBuyFrame.Position = UDim2.new(0, 10, 0, 50)
autoBuyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoBuyFrame.Visible = true

local playerFrame = Instance.new("Frame", main)
playerFrame.Size = autoBuyFrame.Size
playerFrame.Position = autoBuyFrame.Position
playerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerFrame.Visible = false

local questFrame = Instance.new("Frame", main)
questFrame.Size = autoBuyFrame.Size
questFrame.Position = autoBuyFrame.Position
questFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
questFrame.Visible = false

---------------------------------------------------------------------
-- (rest of your original code stays exactly the same)
-- - createMultiSelectSection()
-- - toggle handlers
-- - player speed slider
-- - quest helper
-- - main while-true loop:
--     use safeFireGear() & safeFireSeed() instead of raw FireServer
---------------------------------------------------------------------
