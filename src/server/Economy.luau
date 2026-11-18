-- Economy: one cash tick a second for every player, plus selling a brainrot
-- back for half its price, rounded down. Income is the single
-- State.totalIncome number, so rebirth and event multipliers apply here and
-- nowhere else.
local State = require(script.Parent.State)

local Economy = {}

function Economy.tick()
	for player, _ in pairs(State.Players) do
		local d = State.get(player)
		if d then
			d.cash += State.totalIncome(player)
		end
	end
end

function Economy.sellBrainrot(player, id)
	local item = State.Conveyor[id]
	local d = State.get(player)
	if not item or not d or item.owner ~= player or not item.plotId then
		return
	end
	d.cash += math.floor(item.price * 0.5)
	item.model:Destroy()
	State.Conveyor[id] = nil
end

function Economy.start()
	task.spawn(function()
		while true do
			Economy.tick()
			task.wait(1)
		end
	end)
end

return Economy
