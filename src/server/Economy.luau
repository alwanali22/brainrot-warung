-- Economy: the one-second income tick and selling. Every brainrot on a
-- player's plot pays its money per second, multiplied by the player's
-- rebirth multiplier and the current event multiplier. The tick is the
-- only place cash is created; buying, upgrades and rebirth only spend it.

local Players = game:GetService("Players")
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local State = require(script.Parent.State)

local Economy = {}
Economy.Remotes = nil -- set by init.server.luau

-- Push one player's numbers to their HUD.
function Economy.pushState(player)
	if not Economy.Remotes then
		return
	end
	local record = State.get(player)
	if not record then
		return
	end
	local remote = Economy.Remotes:FindFirstChild("StateUpdate")
	if remote then
		remote:FireClient(player, {
			cash = math.floor(record.cash),
			income = State.incomePerSecond(record),
			rebirths = record.rebirths,
			multiplier = record.multiplier,
			brainrots = State.brainrotCount(record),
			slots = State.slotCount(record),
			locked = State.isLocked(record),
			lockSeconds = math.max(0, math.floor(record.lockUntil - os.clock())),
			event = State.CurrentEvent,
		})
	end
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local cashStat = leaderstats:FindFirstChild("Cash")
		if cashStat then
			cashStat.Value = math.floor(record.cash)
		end
		local rebirthStat = leaderstats:FindFirstChild("Rebirths")
		if rebirthStat then
			rebirthStat.Value = record.rebirths
		end
	end
end

function Economy.tick()
	for _, player in ipairs(Players:GetPlayers()) do
		local record = State.get(player)
		if record then
			record.cash += State.incomePerSecond(record) * Config.IncomeTick
			Economy.pushState(player)
		end
	end
end

function Economy.start()
	task.spawn(function()
		while true do
			task.wait(Config.IncomeTick)
			Economy.tick()
		end
	end)
end

return Economy
