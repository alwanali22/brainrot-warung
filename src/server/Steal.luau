-- Steal: the threat of BRAINROT WARUNG. Touch a brainrot on another
-- player's plot and you carry it off; reach your own plot and it is yours.
-- The victim's plot locks for 30 seconds after a theft, a player can lock
-- their own plot manually (L, 60s cooldown), and a slap (F) knocks a thief
-- down and drops whatever they are carrying.

local Players = game:GetService("Players")
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local State = require(script.Parent.State)
local Factory = require(script.Parent.BrainrotFactory)
local Plots = require(script.Parent.Plots)

local Steal = {}

-- Is `player` allowed to steal right now (cooldown expired, hands empty)?
local function canSteal(player)
	local record = State.get(player)
	if not record then
		return false
	end
	if record.carrying ~= nil then
		return false
	end
	return os.clock() >= record.stealCooldownUntil
end

-- Bind the touch-steal on an owned brainrot's PrimaryPart.
function Steal.bindTouch(item)
	local primary = item.model and item.model.PrimaryPart
	if not primary then
		return
	end
	local connection
	connection = primary.Touched:Connect(function(hit)
		local character = hit.Parent
		local thief = character and Players:GetPlayerFromCharacter(character)
		if not thief or thief == item.owner then
			return
		end
		if item.carriedBy ~= nil then
			return
		end
		local victimRecord = item.owner and State.get(item.owner) or nil
		if victimRecord and State.isLocked(victimRecord) then
			return -- a locked base cannot be stolen from.
		end
		if not canSteal(thief) then
			return
		end
		Steal.steal(thief, item)
	end)
	item.touchConnection = connection
end

-- Carry the item off. The model follows the thief until it reaches home,
-- is dropped by a slap, or the thief leaves/dies.
function Steal.steal(thief, item)
	local thiefRecord = State.get(thief)
	local victimRecord = item.owner and State.get(item.owner) or nil
	if not thiefRecord or not victimRecord then
		return false
	end
	if victimRecord.brainrots[item.id] == nil then
		return false
	end
	victimRecord.brainrots[item.id] = nil
	if item.touchConnection then
		item.touchConnection:Disconnect()
		item.touchConnection = nil
	end
	item.carriedBy = thief
	-- item.owner stays the victim until the thief reaches home: dropping
	-- the goods (slap, death, leave) sends them back to the victim.
	item.plotId = nil
	item.slotIndex = nil
	thiefRecord.carrying = item.id
	thiefRecord.stealCooldownUntil = os.clock() + Config.StealCooldown
	State.Conveyor[item.id] = item
	-- The victim's base locks for 30 seconds after a theft.
	victimRecord.lockUntil = os.clock() + Config.BaseLockSeconds
	Plots.setLockShield(victimRecord.plotId, true)
	task.delay(Config.BaseLockSeconds, function()
		if victimRecord.lockUntil <= os.clock() then
			Plots.setLockShield(victimRecord.plotId, false)
		end
	end)
	return true
end

-- Heartbeat: carried models hover above their carrier; reaching the
-- carrier's own plot completes the theft.
function Steal.step()
	for _, item in pairs(State.Conveyor) do
		local carrier = item.carriedBy
		if carrier ~= nil then
			local record = State.get(carrier)
			local character = carrier.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not record or not root then
				-- Carrier left or died: the goods go home.
				State.dropCarried(carrier, Plots)
			elseif record.carrying ~= item.id then
				State.dropCarried(carrier, Plots)
			else
				Factory.moveModel(item.model, root.Position + Vector3.new(0, 4, 0))
				if Plots.isOnPlot(record.plotId, root.Position) then
					record.carrying = nil
					-- placeOnPlot binds the steal touch through TouchBinder.
					if not Plots.placeOnPlot(item, carrier) then
						-- Thief's plot is full: the goods go back home.
						Plots.returnToOwner(item)
					end
				end
			end
		end
	end
end

-- Slap: shove the nearest player in front of you; if they carry a stolen
-- brainrot, it drops and goes home.
function Steal.slap(player)
	local record = State.get(player)
	if not record then
		return false
	end
	if os.clock() < record.slapCooldownUntil then
		return false
	end
	record.slapCooldownUntil = os.clock() + Config.SlapCooldown
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return false
	end
	local target = nil
	local best = Config.SlapRange
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			local otherRoot = other.Character and other.Character:FindFirstChild("HumanoidRootPart")
			if otherRoot then
				local delta = otherRoot.Position - root.Position
				local dist = delta.Magnitude
				local facing = root.CFrame.LookVector:Dot(delta.Unit)
				if dist < best and facing > 0.3 then
					best = dist
					target = other
				end
			end
		end
	end
	if not target then
		return false
	end
	local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
	if targetRoot then
		targetRoot.AssemblyLinearVelocity = root.CFrame.LookVector * Config.SlapKnockback
			+ Vector3.new(0, 18, 0)
	end
	local targetRecord = State.get(target)
	if targetRecord and targetRecord.carrying ~= nil then
		State.dropCarried(target, Plots)
	end
	return true
end

-- Lock your own plot for 30 seconds (manual, 60s cooldown).
function Steal.lockBase(player)
	local record = State.get(player)
	if not record then
		return false
	end
	if os.clock() < record.lockCooldownUntil then
		return false
	end
	record.lockUntil = os.clock() + Config.BaseLockSeconds
	record.lockCooldownUntil = os.clock() + Config.LockCooldown
	Plots.setLockShield(record.plotId, true)
	task.delay(Config.BaseLockSeconds, function()
		if record.lockUntil <= os.clock() then
			Plots.setLockShield(record.plotId, false)
		end
	end)
	return true
end

function Steal.start()
	local RunService = game:GetService("RunService")
	RunService.Heartbeat:Connect(function()
		Steal.step()
	end)
end

return Steal
