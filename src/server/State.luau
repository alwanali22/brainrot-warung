-- State: the ONE state store of BRAINROT WARUNG. Every module reads and
-- writes player state through here, never through its own tables, so the
-- economy, stealing, rebirth and events can never disagree about a player.

local Players = game:GetService("Players")
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)

local State = {}
State.Players = {} -- [Player] = record
State.Plots = {} -- [plotId] = { owner = Player|nil, pad, stall, sign }
State.Conveyor = {} -- [itemId] = conveyor item (on the belt, unowned)
State.NextItemId = 1
State.EventMultiplier = 1
State.RushActive = false
State.RaidActive = false
State.CurrentEvent = nil

function State.newPlayerRecord(plotId)
	return {
		cash = Config.StartCash,
		rebirths = 0,
		multiplier = 1,
		plotId = plotId,
		brainrots = {},
		lockUntil = 0,
		lockCooldownUntil = 0,
		stealCooldownUntil = 0,
		slapCooldownUntil = 0,
		slotUpgrades = 0,
		carrying = nil,
	}
end

function State.get(player)
	return State.Players[player]
end

function State.slotCount(record)
	return Config.BaseSlots + record.slotUpgrades * 2
end

function State.brainrotCount(record)
	local n = 0
	for _ in pairs(record.brainrots) do
		n += 1
	end
	return n
end

-- Base income per second before multipliers.
function State.baseIncome(record)
	local sum = 0
	for _, item in pairs(record.brainrots) do
		sum += item.income
	end
	return sum
end

function State.incomePerSecond(record)
	return State.baseIncome(record) * record.multiplier * State.EventMultiplier
end

function State.isLocked(record)
	return os.clock() < record.lockUntil
end

function State.nextId()
	local id = State.NextItemId
	State.NextItemId += 1
	return id
end

-- Free plot for a joining player (first unowned plot, lowest id first).
function State.claimPlot(player)
	for plotId = 1, Config.PlotCount do
		local plot = State.Plots[plotId]
		if plot and plot.owner == nil then
			plot.owner = player
			return plotId
		end
	end
	return nil
end

function State.releasePlot(player)
	for _, plot in pairs(State.Plots) do
		if plot.owner == player then
			plot.owner = nil
		end
	end
end

-- Drop whatever a player is carrying back to its owner's plot.
-- Called when the carrier is slapped, dies, or leaves.
function State.dropCarried(player, Plots)
	local record = State.Players[player]
	if not record or not record.carrying then
		return
	end
	local item = nil
	for _, candidate in pairs(State.Conveyor) do
		if candidate.id == record.carrying then
			item = candidate
			break
		end
	end
	-- Carried items live in State.Conveyor until they reach a plot.
	if item then
		Plots.returnToOwner(item)
	end
	record.carrying = nil
end

-- Remove a player entirely (leave): drop carried goods, free the plot.
function State.removePlayer(player, Plots)
	State.dropCarried(player, Plots)
	State.releasePlot(player)
	State.Players[player] = nil
end

Players.PlayerRemoving:Connect(function(player)
	-- Plots is required lazily to avoid a require cycle at load time.
	local Plots = require(script.Parent.Plots)
	State.removePlayer(player, Plots)
end)

return State
