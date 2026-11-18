-- HUD.client: the ScreenGui of BRAINROT WARUNG. Cash/income big and centred
-- (clear of Roblox's own top-left menu buttons); state arrives on StateUpdate.
-- C = Color3.fromRGB.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local C = Color3.fromRGB

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local gui = Instance.new("ScreenGui")
gui.Name = "WarungHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local function label(name, parent, size, pos, textSize, color, font)
	local l = Instance.new("TextLabel")
	l.Name = name
	l.Size = size
	l.Position = pos
	l.BackgroundTransparency = 1
	l.Text = ""
	l.TextSize = textSize
	l.TextColor3 = color
	l.Font = font or Enum.Font.GothamBold
	l.TextStrokeTransparency = 0.3
	l.Parent = parent
	return l
end

local function button(name, parent, size, pos, text, color)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Size = size
	b.Position = pos
	b.BackgroundColor3 = color
	b.BorderSizePixel = 0
	b.Text = text
	b.TextSize = 20
	b.TextColor3 = C(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = b
	return b
end

-- Cash panel, top centre.
local cashPanel = Instance.new("Frame")
cashPanel.Name = "CashPanel"
cashPanel.AnchorPoint = Vector2.new(0.5, 0)
cashPanel.Position = UDim2.new(0.5, 0, 0, 12)
cashPanel.Size = UDim2.fromOffset(360, 92)
cashPanel.BackgroundColor3 = C(30, 25, 20)
cashPanel.BackgroundTransparency = 0.25
cashPanel.BorderSizePixel = 0
cashPanel.Parent = gui
local cashCorner = Instance.new("UICorner")
cashCorner.CornerRadius = UDim.new(0, 12)
cashCorner.Parent = cashPanel

local cashLabel = label("Cash", cashPanel, UDim2.new(1, 0, 0.55, 0),
	UDim2.new(0, 0, 0, 4), 40, C(255, 220, 90))
cashLabel.Text = "$100"
local incomeLabel = label("Income", cashPanel, UDim2.new(1, 0, 0.4, 0),
	UDim2.new(0, 0, 0.58, 0), 20, C(120, 255, 120))
incomeLabel.Text = "+$0/dtk"

-- Rebirth + multiplier, top right.
local rebirthLabel = label("Rebirths", gui, UDim2.fromOffset(260, 34),
	UDim2.new(1, -276, 0, 14), 20, C(255, 180, 90))
rebirthLabel.TextXAlignment = Enum.TextXAlignment.Right
rebirthLabel.Text = "Naik Kelas: 0  (x1.0)"

-- Event banner, below the cash panel.
local banner = label("EventBanner", gui, UDim2.new(0.7, 0, 0, 44),
	UDim2.new(0.15, 0, 0, 116), 26, C(255, 220, 90))
banner.Text = "Selamat datang di PASAR BRAINROT!"

-- Plot status, bottom left.
local plotLabel = label("Plot", gui, UDim2.fromOffset(300, 60),
	UDim2.new(0, 16, 1, -76), 20, C(255, 255, 255))
plotLabel.TextXAlignment = Enum.TextXAlignment.Left
plotLabel.Text = "Warungmu: 0/4 brainrot"

-- Controls hint, bottom centre.
local hint = label("Hint", gui, UDim2.new(0.6, 0, 0, 30),
	UDim2.new(0.2, 0, 1, -34), 16, C(230, 230, 230))
hint.Text = "WASD / Panah: jalan   E: beli   F: tampar   L: kunci base   R: naik kelas"

-- Buttons, bottom right.
local rebirthButton = button("RebirthButton", gui, UDim2.fromOffset(150, 48),
	UDim2.new(1, -486, 1, -64), "NAIK KELAS (R)", C(180, 90, 220))
local lockButton = button("LockButton", gui, UDim2.fromOffset(150, 48),
	UDim2.new(1, -322, 1, -64), "KUNCI BASE (L)", C(60, 120, 220))
local slotButton = button("SlotButton", gui, UDim2.fromOffset(150, 48),
	UDim2.new(1, -158, 1, -64), "+2 SLOT", C(60, 180, 90))

rebirthButton.MouseButton1Click:Connect(function()
	remotes.Rebirth:FireServer()
end)
lockButton.MouseButton1Click:Connect(function()
	remotes.LockBase:FireServer()
end)
slotButton.MouseButton1Click:Connect(function()
	remotes.UpgradePlot:FireServer()
end)

-- Live state from the server, once a second.
remotes.StateUpdate.OnClientEvent:Connect(function(state)
	cashLabel.Text = "$" .. tostring(state.cash)
	incomeLabel.Text = "+$" .. tostring(math.floor(state.income)) .. "/dtk"
	rebirthLabel.Text = "Naik Kelas: " .. tostring(state.rebirths)
		.. "  (x" .. string.format("%.1f", state.multiplier) .. ")"
	plotLabel.Text = "Warungmu: " .. tostring(state.brainrots) .. "/"
		.. tostring(state.slots) .. " brainrot"
		.. (state.locked and "  🔒 TERKUNCI " .. tostring(state.lockSeconds) .. " dtk" or "")
end)

remotes.EventAnnounce.OnClientEvent:Connect(function(text, color)
	banner.Text = text
	if color then
		banner.TextColor3 = color
	end
end)
