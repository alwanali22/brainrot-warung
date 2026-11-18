-- Plots: the eight warung plots. Owns the geometry of a plot (slot
-- positions, owner sign, lock shield, rebirth skin) and the bookkeeping of
-- putting a brainrot on a slot, taking one off, and sending a stolen one
-- home. The economy never touches plot geometry; it asks Plots.

local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local State = require(script.Parent.State)
local Factory = require(script.Parent.BrainrotFactory)

local Plots = {}

-- Slot offsets on a plot pad (2 rows x 3 columns, room for 6; upgrades
-- add a second row of positions through the same grid, capped at 8).
local SLOT_OFFSETS = {
	Vector3.new(-3.5, 0, 1.5), Vector3.new(0, 0, 1.5), Vector3.new(3.5, 0, 1.5),
	Vector3.new(-3.5, 0, 3.5), Vector3.new(0, 0, 3.5), Vector3.new(3.5, 0, 3.5),
	Vector3.new(-3.5, 0, -1.5), Vector3.new(3.5, 0, -1.5),
}

function Plots.init()
	for plotId = 1, Config.PlotCount do
		local centre = Config.PlotPositions[plotId]
		local pad = workspace:FindFirstChild("PlotPad" .. tostring(plotId))
		State.Plots[plotId] = {
			owner = nil,
			centre = centre,
			pad = pad,
			stall = nil, -- filled in by World.build's Stalls table
		}
	end
end

function Plots.linkStalls(stalls)
	for plotId, stall in pairs(stalls) do
		if State.Plots[plotId] then
			State.Plots[plotId].stall = stall
		end
	end
end

function Plots.slotPosition(plotId, slotIndex)
	local plot = State.Plots[plotId]
	local offset = SLOT_OFFSETS[slotIndex] or SLOT_OFFSETS[1]
	return Vector3.new(plot.centre.X + offset.X, 1.2, plot.centre.Z + offset.Z)
end

function Plots.freeSlot(record)
	local used = {}
	for _, item in pairs(record.brainrots) do
		used[item.slotIndex] = true
	end
	for i = 1, State.slotCount(record) do
		if not used[i] then
			return i
		end
	end
	return nil
end

-- Put an owned item on its owner's plot (used by buying and by stealing
-- home). Returns true, or false when the plot is full.
function Plots.placeOnPlot(item, owner)
	local record = State.get(owner)
	if not record then
		return false
	end
	local slot = Plots.freeSlot(record)
	if not slot then
		return false
	end
	item.owner = owner
	item.plotId = record.plotId
	item.slotIndex = slot
	item.carriedBy = nil
	State.Conveyor[item.id] = nil
	record.brainrots[item.id] = item
	Factory.moveModel(item.model, Plots.slotPosition(record.plotId, slot))
	local prompt = item.model.PrimaryPart:FindFirstChild("BuyPrompt")
	if prompt then
		prompt:Destroy()
	end
	-- Owned brainrots can be stolen by touch (Steal.bindTouch, wired by
	-- init through Plots.TouchBinder to avoid a require cycle).
	if Plots.TouchBinder then
		Plots.TouchBinder(item)
	end
	return true
end

-- Send a carried/stolen item back to its owner's plot, or destroy it when
-- the owner is gone or the plot is full.
function Plots.returnToOwner(item)
	local owner = item.owner
	local record = owner and State.get(owner) or nil
	if not record then
		if item.model then
			item.model:Destroy()
		end
		State.Conveyor[item.id] = nil
		return false
	end
	if not Plots.placeOnPlot(item, owner) then
		if item.model then
			item.model:Destroy()
		end
		record.brainrots[item.id] = nil
		State.Conveyor[item.id] = nil
		return false
	end
	return true
end

-- Refresh the owner sign and the pad/stall colours of a plot.
function Plots.refreshSign(plotId)
	local plot = State.Plots[plotId]
	if not plot or not plot.stall then
		return
	end
	local sign = plot.stall:FindFirstChild("Sign")
	local gui = sign and sign:FindFirstChild("OwnerSign")
	local label = gui and gui:FindFirstChild("OwnerName")
	if label then
		if plot.owner then
			label.Text = "WARUNG " .. string.upper(plot.owner.DisplayName)
		else
			label.Text = "WARUNG KOSONG"
		end
	end
end

function Plots.setLockShield(plotId, visible)
	local plot = State.Plots[plotId]
	if not plot or not plot.stall then
		return
	end
	local shield = plot.stall:FindFirstChild("LockShield")
	if shield then
		shield.Transparency = visible and 0.55 or 1
	end
end

-- Apply a rebirth skin (pad + stall colours) to a plot.
function Plots.applySkin(plotId, rebirths)
	local plot = State.Plots[plotId]
	if not plot then
		return
	end
	local skin = Config.RebirthSkins[math.min(rebirths + 1, #Config.RebirthSkins)]
	if plot.pad then
		plot.pad.Color = skin.pad
	end
	if plot.stall then
		local counter = plot.stall:FindFirstChild("Counter")
		if counter then
			counter.Color = skin.stall
		end
	end
end

-- Is this point inside the given plot's pad?
function Plots.isOnPlot(plotId, position)
	local plot = State.Plots[plotId]
	if not plot then
		return false
	end
	local half = Config.PlotSize / 2 + 1
	return math.abs(position.X - plot.centre.X) <= half
		and math.abs(position.Z - plot.centre.Z) <= half
end

-- Buy +2 slots for cash. Returns true on success.
function Plots.upgradeSlots(player)
	local record = State.get(player)
	if not record then
		return false
	end
	local cost = Config.SlotUpgradeCost * (record.slotUpgrades + 1)
	if record.cash < cost then
		return false
	end
	if State.slotCount(record) >= #SLOT_OFFSETS then
		return false
	end
	record.cash -= cost
	record.slotUpgrades += 1
	return true
end

return Plots
