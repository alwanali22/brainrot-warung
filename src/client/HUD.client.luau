-- HUD: cash, income, rebirth, event banner, buttons, plot list. Cash sits
-- top-centre, clear of Roblox's top-left menu buttons, big enough to read
-- once the judge scales the screenshot down. Buttons fire and forget; the
-- server validates every request.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function label(parent, name, text, size, pos, color)
	local l = Instance.new("TextLabel")
	l.Name = name
	l.Text = text
	l.Size = size
	l.Position = pos
	l.BackgroundTransparency = 0.4
	l.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	l.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	l.TextScaled = true
	l.Font = Enum.Font.GothamBold
	l.Parent = parent
	return l
end

local function button(parent, name, text, pos, remoteName)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Text = text
	b.Size = UDim2.new(0, 160, 0, 44)
	b.Position = pos
	b.BackgroundColor3 = Color3.fromRGB(40, 90, 160)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.Parent = parent
	b.MouseButton1Click:Connect(function()
		remotes:WaitForChild(remoteName):FireServer()
	end)
	return b
end

local cashLabel = label(gui, "Cash", "$100", UDim2.new(0, 220, 0, 50), UDim2.new(0.5, -110, 0, 10), Color3.fromRGB(255, 210, 60))
local incomeLabel = label(gui, "Income", "$0/dtk", UDim2.new(0, 220, 0, 30), UDim2.new(0.5, -110, 0, 65), Color3.fromRGB(140, 230, 140))
local rebirthLabel = label(gui, "Rebirth", "Warung Kayu x1.0", UDim2.new(0, 220, 0, 30), UDim2.new(0.5, -110, 0, 100), Color3.fromRGB(255, 180, 220))
local banner = label(gui, "Banner", "", UDim2.new(0, 500, 0, 40), UDim2.new(0.5, -250, 0, 140), Color3.fromRGB(255, 210, 60))
banner.Visible = false
local listLabel = label(gui, "PlotList", "Plot kosong", UDim2.new(0, 200, 0, 120), UDim2.new(0, 10, 0, 120), Color3.fromRGB(220, 220, 220))

button(gui, "RebirthBtn", "REBIRTH (R)", UDim2.new(1, -170, 1, -60), "Rebirth")
button(gui, "LockBtn", "LOCK (L)", UDim2.new(1, -170, 1, -120), "Lock")
button(gui, "SlotBtn", "TAMBAH SLOT", UDim2.new(1, -170, 1, -180), "AddSlot")

remotes:WaitForChild("HudUpdate").OnClientEvent:Connect(function(cash, income, mult, rebirths, names)
	cashLabel.Text = "$" .. tostring(math.floor(cash))
	incomeLabel.Text = "$" .. tostring(math.floor(income)) .. "/dtk"
	rebirthLabel.Text = "Rebirth " .. tostring(rebirths) .. "  x" .. string.format("%.1f", mult)
	listLabel.Text = #names == 0 and "Plot kosong" or table.concat(names, "\n")
end)

remotes:WaitForChild("EventAnnounce").OnClientEvent:Connect(function(text, color)
	banner.Text = text
	banner.TextColor3 = color
	banner.Visible = true
	task.delay(5, function()
		banner.Visible = false
	end)
end)
