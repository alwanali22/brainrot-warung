-- Steal: touch a brainrot on someone else's plot to carry it home; if you
-- reach your own plot it is yours. The victim's base auto-locks 30 seconds
-- after a theft, and a slap (F) knocks the catch loose and sends it home.
-- Steal watches by distance, not Touched: a carried model moves with the
-- thief, so a touch connection on it would fire for its own carrier.
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local State = require(script.Parent.State)
local Plots = require(script.Parent.Plots)

local Steal = {}

function Steal.isLocked(player)
	local d = State.get(player)
	return d and os.clock() < d.lockedUntil
end

function Steal.lockBase(player, manual)
	local d = State.get(player)
	if not d then
		return false
	end
	if manual and os.clock() < d.lockReadyAt then
		return false
	end
	d.lockedUntil = os.clock() + Config.LockDuration
	if manual then
		d.lockReadyAt = os.clock() + Config.LockCooldown
	end
	return true
end

function Steal.trySteal(thief, item)
	local d = State.get(thief)
	if not item or not d or item.owner == thief or item.carriedBy or not item.plotId then
		return
	end
	if Steal.isLocked(item.owner) then
		return
	end
	if d.carrying then
		return
	end
	local victim = item.owner
	d.carrying = item
	item.carriedBy = thief
	Plots.removeFromPlot(item)
	task.spawn(function()
		while item.carriedBy == thief and item.model.Parent do
			local char = thief.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				item.model:PivotTo(root.CFrame * CFrame.new(0, 3, 0))
				local home = Plots.padCenter(State.get(thief).plotId)
				if (root.Position - home).Magnitude < 8 then
					Steal.deliver(thief, item, victim)
					break
				end
			end
			task.wait(0.1)
		end
	end)
end

function Steal.deliver(thief, item, victim)
	local d = State.get(thief)
	if not d or item.carriedBy ~= thief then
		return
	end
	item.carriedBy = nil
	d.carrying = nil
	item.owner = thief
	-- Buku Warung: a stolen brainrot counts as owned once it lands home —
	-- the thief earned it by carrying it all the way back.
	State.markOwned(thief, item.charKey)
	Plots.placeBrainrot(thief, item)
	if victim then
		Steal.lockBase(victim, false)
	end
end

function Steal.returnToOwner(item)
	local owner = item.owner
	local thief = item.carriedBy
	item.carriedBy = nil
	if thief then
		local td = State.get(thief)
		if td then
			td.carrying = nil
		end
	end
	if owner and State.get(owner) then
		Plots.placeBrainrot(owner, item)
	end
end

function Steal.slap(player)
	local d = State.get(player)
	if not d or os.clock() < d.slapReadyAt then
		return
	end
	d.slapReadyAt = os.clock() + Config.SlapCooldown
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	for _, item in pairs(State.Conveyor) do
		if item.carriedBy and item.carriedBy ~= player then
			local thiefChar = item.carriedBy.Character
			local thiefRoot = thiefChar and thiefChar:FindFirstChild("HumanoidRootPart")
			if thiefRoot and (thiefRoot.Position - root.Position).Magnitude < Config.SlapRange then
				thiefRoot.AssemblyLinearVelocity = (thiefRoot.Position - root.Position).Unit * 40 + Vector3.new(0, 20, 0)
				Steal.returnToOwner(item)
			end
		end
	end
end

-- Distance watch: a non-owner standing next to a plot brainrot grabs it.
-- The 3-stud grab range matches the distance the label stays readable at.
function Steal.start()
	task.spawn(function()
		while true do
			for _, item in pairs(State.Conveyor) do
				if item.plotId and not item.carriedBy then
					for player, _ in pairs(State.Players) do
						if player ~= item.owner then
							local char = player.Character
							local root = char and char:FindFirstChild("HumanoidRootPart")
							if root and (root.Position - item.model:GetPivot().Position).Magnitude < 3 then
								Steal.trySteal(player, item)
							end
						end
					end
				end
			end
			task.wait(0.5)
		end
	end)
end

return Steal
