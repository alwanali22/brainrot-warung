-- State: the one store every server module reads and writes. No module keeps
-- its own copy of a player's cash, plot or brainrots, so the numbers the HUD
-- shows and the numbers the economy ticks can never drift apart.
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)

local State = {}

State.Players = {} -- [player] = { cash, multiplier, rebirths, plotId, slots, carrying, locks }
State.Conveyor = {} -- [id] = belt/plot brainrot item (see Conveyor.spawnOne)
State.Plots = {} -- [plotId] = player or nil
State.NextId = 0
State.EventMultiplier = 1
State.RushUntil = 0

function State.nextId()
	State.NextId += 1
	return State.NextId
end

function State.newPlayer(player)
	State.Players[player] = {
		cash = Config.StartCash,
		multiplier = 1,
		rebirths = 0,
		plotId = nil,
		slots = Config.PlotSlotsStart,
		carrying = nil,
		lockedUntil = 0,
		lockReadyAt = 0,
		slapReadyAt = 0,
	}
end

function State.removePlayer(player)
	State.Players[player] = nil
end

function State.get(player)
	return State.Players[player]
end

-- Every brainrot this player owns that sits on their plot.
function State.plotBrainrots(player)
	local out = {}
	for _, item in pairs(State.Conveyor) do
		if item.owner == player and item.plotId then
			table.insert(out, item)
		end
	end
	return out
end

function State.baseIncome(player)
	local sum = 0
	for _, item in ipairs(State.plotBrainrots(player)) do
		sum += item.income
	end
	return sum
end

-- Income per second after rebirth and event multipliers. Events set
-- State.EventMultiplier; rebirth sets d.multiplier; this function only reads.
function State.totalIncome(player)
	local d = State.get(player)
	if not d then
		return 0
	end
	return State.baseIncome(player) * d.multiplier * State.EventMultiplier
end

return State
