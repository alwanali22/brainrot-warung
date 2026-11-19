-- init: wiring only. Creates the Remotes folder, assigns a plot on join,
-- frees it on leave, pushes HUD numbers every second, and starts the
-- conveyor, economy, steal and event loops. (Rojo makes src/server/ one
-- Script "Server", so modules are require(script.X), not script.Parent.X.)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local State = require(script.State)
local World = require(script.World)
local Plots = require(script.Plots)
local Conveyor = require(script.Conveyor)
local Economy = require(script.Economy)
local Steal = require(script.Steal)
local Rebirth = require(script.Rebirth)
local Events = require(script.Events)

local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = ReplicatedStorage
for _, name in ipairs(Config.Remotes) do
	local ev = Instance.new("RemoteEvent")
	ev.Name = name
	ev.Parent = remotes
end

World.build()

local function onJoin(player)
	State.newPlayer(player)
	Plots.assignPlot(player)
	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = CFrame.new(0, 3, -50)
		end
	end)
end

local function onLeave(player)
	local d = State.get(player)
	if d and d.carrying then
		Steal.returnToOwner(d.carrying)
	end
	for _, item in pairs(State.Conveyor) do
		if item.owner == player then
			item.model:Destroy()
			State.Conveyor[item.id] = nil
		end
	end
	Plots.freePlot(player)
	State.removePlayer(player)
end

Players.PlayerAdded:Connect(onJoin)
Players.PlayerRemoving:Connect(onLeave)
for _, p in ipairs(Players:GetPlayers()) do
	onJoin(p)
end

-- HUD push, once a second: cash, income, multiplier, rebirths, plot list,
-- plus the Buku Warung counts (owned, seen) as extra args. The counts ride
-- the same remote so the book never needs its own round trip.
-- One remote, one push: the client never asks for numbers.
task.spawn(function()
	while true do
		for player, d in pairs(State.Players) do
			local names = {}
			for _, item in ipairs(State.plotBrainrots(player)) do
				table.insert(names, item.name)
			end
			local ownedCount, seenCount = State.bookCounts(player)
			remotes.HudUpdate:FireClient(player, d.cash, State.totalIncome(player), d.multiplier, d.rebirths, names, ownedCount, seenCount)
		end
		task.wait(1)
	end
end)

remotes.Rebirth.OnServerEvent:Connect(function(player)
	Rebirth.doRebirth(player)
end)
remotes.Lock.OnServerEvent:Connect(function(player)
	Steal.lockBase(player, true)
end)
remotes.Slap.OnServerEvent:Connect(function(player)
	Steal.slap(player)
end)
remotes.AddSlot.OnServerEvent:Connect(function(player)
	Plots.upgradeSlots(player)
end)
remotes.Sell.OnServerEvent:Connect(function(player, id)
	Economy.sellBrainrot(player, id)
end)

Conveyor.start()
Economy.start()
Steal.start()
Events.start()
