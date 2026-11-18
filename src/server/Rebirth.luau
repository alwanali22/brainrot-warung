-- Rebirth ("Naik Kelas Warung"): cash + at least 3 brainrots buys a reset —
-- cash and brainrots go, a permanent +0.5 income multiplier stays, and the
-- plot re-skins into the next warung tier (Kayu, Bata, Neon, Istana Dodol).
-- Rebirth never touches the conveyor: belt brainrots keep walking.
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local State = require(script.Parent.State)
local Plots = require(script.Parent.Plots)

local Rebirth = {}

function Rebirth.canRebirth(player)
	local d = State.get(player)
	if not d then
		return false
	end
	return d.cash >= Config.RebirthCash and #State.plotBrainrots(player) >= Config.RebirthMinBrainrots
end

function Rebirth.doRebirth(player)
	if not Rebirth.canRebirth(player) then
		return false
	end
	local d = State.get(player)
	for _, item in ipairs(State.plotBrainrots(player)) do
		item.model:Destroy()
		State.Conveyor[item.id] = nil
	end
	d.cash = Config.StartCash
	d.multiplier += Config.RebirthBonus
	d.rebirths += 1
	Plots.applySkin(player)
	return true
end

function Rebirth.skinName(player)
	local d = State.get(player)
	local n = d and d.rebirths or 0
	return Config.RebirthSkins[math.min(n + 1, #Config.RebirthSkins)]
end

return Rebirth
