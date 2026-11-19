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
		seen = {},
		owned = {},
	}
end

function State.removePlayer(player)
	State.Players[player] = nil
end

function State.get(player)
	return State.Players[player]
end

-- Buku Warung: the collection book. seen marks a character the player has
-- watched pass on the belt; owned marks one they have held on their plot.
-- Both are sets keyed by charKey, so the HUD only ever counts keys. A
-- character counts as seen the moment it spawns — the belt is public, so
-- every player in the server watches the same parade.
function State.markSeen(player, charKey)
	local d = State.get(player)
	if d and charKey then
		d.seen[charKey] = true
	end
end

function State.markOwned(player, charKey)
	local d = State.get(player)
	if d and charKey then
		d.owned[charKey] = true
	end
end

-- How many distinct characters this player has seen / owned so far.
function State.bookCounts(player)
	local d = State.get(player)
	if not d then
		return 0, 0
	end
	local seenCount = 0
	for _ in pairs(d.seen) do
		seenCount += 1
	end
	local ownedCount = 0
	for _ in pairs(d.owned) do
		ownedCount += 1
	end
	return ownedCount, seenCount
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
