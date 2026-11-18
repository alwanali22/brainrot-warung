-- Rebirth: "Naik Kelas Warung". Trade cash and every brainrot on your
-- plot for a permanent +0.5x income multiplier and a new base skin. The
-- cost grows with each rebirth, so the ladder never runs out.

local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local State = require(script.Parent.State)
local Plots = require(script.Parent.Plots)
local Economy = require(script.Parent.Economy)

local Rebirth = {}

function Rebirth.cost(record)
	return Config.RebirthBaseCost * (record.rebirths + 1)
end

function Rebirth.canRebirth(record)
	return record.cash >= Rebirth.cost(record)
		and State.brainrotCount(record) >= Config.RebirthMinBrainrots
end

function Rebirth.doRebirth(player)
	local record = State.get(player)
	if not record then
		return false, "no state"
	end
	if not Rebirth.canRebirth(record) then
		return false, "need $" .. tostring(Rebirth.cost(record)) .. " + "
			.. tostring(Config.RebirthMinBrainrots) .. " brainrot"
	end
	-- A stolen brainrot you are still carrying goes home first.
	State.dropCarried(player, Plots)
	-- Sell off every brainrot on the plot.
	for _, item in pairs(record.brainrots) do
		if item.model then
			item.model:Destroy()
		end
		if item.touchConnection then
			item.touchConnection:Disconnect()
		end
	end
	table.clear(record.brainrots)
	record.cash = 0
	record.rebirths += 1
	record.multiplier += Config.RebirthMultiplierStep
	Plots.applySkin(record.plotId, record.rebirths)
	Economy.pushState(player)
	return true, "Naik Kelas! Multiplier x" .. tostring(record.multiplier)
end

return Rebirth
