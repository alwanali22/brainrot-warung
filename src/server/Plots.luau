-- Plots: 8 warung plots, one per player. A plot is its PlotPad part in the
-- Place; pad positions are read from the Place at runtime, never hardcoded.
-- Slots fill in a 3x3 grid; rebirth re-skins the pad in the new warung colour.
-- A slot is the first free grid cell, so selling frees the earliest slot.
local Shared = game:GetService("ReplicatedStorage").Shared
local Config = require(Shared.Config)
local State = require(script.Parent.State)

local Plots = {}

function Plots.padCenter(plotId)
	local pad = workspace:FindFirstChild("PlotPad" .. plotId)
	if pad then
		return pad.Position
	end
	return Vector3.new(0, 0, 0)
end

function Plots.assignPlot(player)
	for i = 1, Config.PlotCount do
		if not State.Plots[i] then
			State.Plots[i] = player
			State.get(player).plotId = i
			Plots.buildNameBoard(player, i)
			return i
		end
	end
	return nil
end

function Plots.freePlot(player)
	local d = State.get(player)
	if not d or not d.plotId then
		return
	end
	local board = workspace:FindFirstChild("NameBoard" .. d.plotId)
	if board then
		board:Destroy()
	end
	State.Plots[d.plotId] = nil
	d.plotId = nil
end

function Plots.slotPosition(plotId, slotIndex)
	local c = Plots.padCenter(plotId)
	local off = Config.SlotOffsets[slotIndex] or Vector3.zero
	return Vector3.new(c.X + off.X, 1.2, c.Z + off.Z)
end

function Plots.placeBrainrot(player, item)
	local d = State.get(player)
	if not d or not d.plotId then
		return
	end
	local slot = #State.plotBrainrots(player) + 1
	item.plotId = d.plotId
	item.slotIndex = slot
	item.model:PivotTo(CFrame.new(Plots.slotPosition(d.plotId, slot)))
	for _, desc in ipairs(item.model:GetDescendants()) do
		if desc:IsA("ProximityPrompt") then
			desc:Destroy()
		end
	end
end

function Plots.removeFromPlot(item)
	item.plotId = nil
	item.slotIndex = nil
end

function Plots.upgradeSlots(player)
	local d = State.get(player)
	if not d or d.slots >= Config.PlotSlotMax or d.cash < Config.PlotSlotCost then
		return false
	end
	d.cash -= Config.PlotSlotCost
	d.slots += 2
	return true
end

function Plots.buildNameBoard(player, plotId)
	local c = Plots.padCenter(plotId)
	local board = Instance.new("Part")
	board.Name = "NameBoard" .. plotId
	board.Size = Vector3.new(10, 0.4, 2)
	board.Position = Vector3.new(c.X, 4.5, c.Z - 6)
	board.Color = Color3.fromRGB(60, 40, 25)
	board.Anchored = true
	board.Parent = workspace
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.new(0, 220, 0, 40)
	gui.StudsOffset = Vector3.new(0, 2, 0)
	gui.AlwaysOnTop = true
	gui.Parent = board
	local label = Instance.new("TextLabel")
	label.Text = "WARUNG " .. player.Name
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 220, 130)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = gui
end

function Plots.applySkin(player)
	local d = State.get(player)
	if not d or not d.plotId then
		return
	end
	local pad = workspace:FindFirstChild("PlotPad" .. d.plotId)
	if pad then
		pad.Color = Config.SkinColors[math.min(d.rebirths + 1, #Config.SkinColors)]
	end
end

return Plots
