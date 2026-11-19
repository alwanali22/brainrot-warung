-- Conveyor: the "Etalase Berjalan". Spawns a brainrot every few seconds,
-- walks it 100 studs down the belt, and sells it on the E prompt — cash and
-- plot-slot checks first, then the model moves to the buyer's plot.
local Shared = game:GetService("ReplicatedStorage").Shared
local Config = require(Shared.Config)
local BrainrotData = require(Shared.BrainrotData)
local Mutations = require(Shared.Mutations)
local State = require(script.Parent.State)
local Factory = require(script.Parent.BrainrotFactory)

local Conveyor = {}

function Conveyor.spawnOne()
	local rare = State.RushUntil > os.clock() and math.random() < 0.5
	local char = BrainrotData.pickCharacter(rare)
	local mutation = Mutations.rollMutation()
	local id = State.nextId()
	local position = Vector3.new(Config.ConveyorX, 1.2, Config.ConveyorZ0)
	local model = Factory.buildCharacter(char, position, mutation)
	model.Parent = workspace
	local prompt = Factory.attachBuyPrompt(model, id, char.price)
	prompt.Triggered:Connect(function(player)
		Conveyor.buyBrainrot(player, id)
	end)
	-- Buku Warung: the belt is public, so every player in the server has
	-- now seen this character walk past.
	for player in pairs(State.Players) do
		State.markSeen(player, char.key)
	end
	State.Conveyor[id] = {
		id = id, charKey = char.key, name = char.name, tier = char.tier,
		price = char.price, income = Mutations.mutatedIncome(char, mutation),
		mutation = mutation, model = model, owner = nil, plotId = nil,
		slotIndex = nil, carriedBy = nil, z = Config.ConveyorZ0,
	}
end

-- One step of the belt: walk unowned models forward, despawn past the end.
-- Carried and owned models never move here.
function Conveyor.step(dt)
	for id, item in pairs(State.Conveyor) do
		if not item.owner and not item.carriedBy then
			item.z += Config.ConveyorSpeed * dt
			if item.z > Config.ConveyorZ1 then
				item.model:Destroy()
				State.Conveyor[id] = nil
			else
				item.model:PivotTo(CFrame.new(Config.ConveyorX, 1.2, item.z))
			end
		end
	end
end

function Conveyor.buyBrainrot(player, id)
	local item = State.Conveyor[id]
	local d = State.get(player)
	if not item or not d or item.owner then
		return
	end
	if d.cash < item.price then
		return
	end
	if #State.plotBrainrots(player) >= d.slots then
		return
	end
	d.cash -= item.price
	item.owner = player
	-- Buku Warung: buying is owning — the character joins the buyer's book.
	State.markOwned(player, item.charKey)
	require(script.Parent.Plots).placeBrainrot(player, item)
end

function Conveyor.start()
	task.spawn(function()
		while true do
			Conveyor.spawnOne()
			task.wait(Config.SpawnInterval)
		end
	end)
	task.spawn(function()
		while true do
			Conveyor.step(0.1)
			task.wait(0.1)
		end
	end)
end

return Conveyor
