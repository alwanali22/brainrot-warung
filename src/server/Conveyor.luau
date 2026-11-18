-- Conveyor: the "Etalase Berjalan". Brainrots spawn at the north end of the
-- belt, parade south past the stalls, and despawn at the south end. A
-- player buys one with the ProximityPrompt (E) on its model: the server
-- checks distance, cash and a free plot slot before the sale.

local RunService = game:GetService("RunService")
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local BrainrotData = require(game:GetService("ReplicatedStorage").Shared.BrainrotData)
local State = require(script.Parent.State)
local Factory = require(script.Parent.BrainrotFactory)
local Plots = require(script.Parent.Plots)

local Conveyor = {}

local function spawnOne()
	local count = 0
	for _ in pairs(State.Conveyor) do
		count += 1
	end
	if count >= Config.MaxConveyorItems then
		return
	end
	if State.RaidActive then
		return -- Satpol Raid halts the market: nothing new arrives.
	end
	local char = BrainrotData.pickCharacter(State.RushActive)
	local id = State.nextId()
	local position = Vector3.new(Config.ConveyorX, 1.2, Config.ConveyorZ0)
	local model = Factory.buildCharacter(char, position)
	model.Parent = workspace
	local prompt = Factory.attachBuyPrompt(model, id, char.price)
	prompt.Triggered:Connect(function(player)
		Conveyor.buyBrainrot(player, id)
	end)
	local item = {
		id = id,
		charKey = char.key,
		name = char.name,
		tier = char.tier,
		price = char.price,
		income = char.income,
		model = model,
		owner = nil,
		plotId = nil,
		slotIndex = nil,
		carriedBy = nil,
		z = Config.ConveyorZ0,
	}
	State.Conveyor[id] = item
end

-- Move every belt item south; despawn at the end. Carried items are moved
-- by Steal instead, so they are skipped here.
function Conveyor.step(dt)
	for id, item in pairs(State.Conveyor) do
		if item.carriedBy == nil then
			item.z += Config.ConveyorSpeed * dt
			if item.z >= Config.ConveyorZ1 then
				if item.model then
					item.model:Destroy()
				end
				State.Conveyor[id] = nil
			else
				Factory.moveModel(item.model, Vector3.new(Config.ConveyorX, 1.2, item.z))
			end
		end
	end
end

-- The sale. Called by the ProximityPrompt on the model and by the
-- BuyBrainrot RemoteEvent alike; both go through these same checks.
function Conveyor.buyBrainrot(player, itemId)
	local record = State.get(player)
	if not record then
		return false, "no state"
	end
	local item = State.Conveyor[itemId]
	if not item or item.carriedBy ~= nil or item.owner ~= nil then
		return false, "gone"
	end
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return false, "no character"
	end
	if (root.Position - item.model.PrimaryPart.Position).Magnitude > 20 then
		return false, "too far"
	end
	if record.cash < item.price then
		return false, "no cash"
	end
	if Plots.freeSlot(record) == nil then
		return false, "plot full"
	end
	record.cash -= item.price
	Plots.placeOnPlot(item, player)
	return true, "bought"
end

function Conveyor.start()
	-- Spawn loop.
	task.spawn(function()
		while true do
			task.wait(Config.SpawnInterval)
			spawnOne()
		end
	end)
	-- Movement loop, tied to the render heartbeat for smooth motion.
	RunService.Heartbeat:Connect(function(dt)
		Conveyor.step(dt)
	end)
end

return Conveyor
