-- Rebirth ("Naik Kelas Warung"): cash + at least 3 brainrots buys a reset —
-- cash and brainrots go, a permanent +0.5 income multiplier stays, and the
-- plot re-skins into the next warung tier (Kayu, Bata, Neon, Istana Dodol).
-- Rebirth never touches the conveyor: belt brainrots keep walking.
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local State = require(script.Parent.State)
local Plots = require(script.Parent.Plots)
local World = require(script.Parent.World)

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
	-- Rebirth feedback: gold confetti over the player's plot pad, plus a
	-- chime. The confetti part is invisible and gone in two seconds.
	local pad = d.plotId and Plots.padCenter(d.plotId)
	if pad then
		local confetti = Instance.new("Part")
		confetti.Name = "RebirthConfetti"
		confetti.Size = Vector3.new(1, 1, 1)
		confetti.Position = pad + Vector3.new(0, 3, 0)
		confetti.Transparency = 1
		confetti.Anchored = true
		confetti.CanCollide = false
		confetti.Parent = workspace
		local emitter = Instance.new("ParticleEmitter")
		emitter.Color = ColorSequence.new(Color3.fromRGB(255, 210, 60))
		emitter.Size = NumberSequence.new(1)
		emitter.Lifetime = NumberRange.new(1.5)
		emitter.Speed = NumberRange.new(20)
		emitter.SpreadAngle = Vector2.new(180, 180)
		emitter.Rate = 150
		emitter.Parent = confetti
		game:GetService("Debris"):AddItem(confetti, 2)
		World.playSound("ChimeSfx")
	end
	return true
end

function Rebirth.skinName(player)
	local d = State.get(player)
	local n = d and d.rebirths or 0
	return Config.RebirthSkins[math.min(n + 1, #Config.RebirthSkins)]
end

return Rebirth
