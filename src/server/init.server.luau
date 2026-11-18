-- init.server: wiring for BRAINROT WARUNG. Builds the world, creates the
-- RemoteEvents, hands each joining player a plot and a starting wallet,
-- and starts the conveyor, the economy tick, stealing and the event clock.
-- All game state lives in State; this file only connects the pieces.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
-- NOTE: Rojo turns src/server/ into ONE Script named "Server" (from
-- init.server.luau) with the other modules as its children, so the modules
-- are require()d as script.<Name> here, not script.Parent.<Name>.
local State = require(script.State)
local World = require(script.World)
local Plots = require(script.Plots)
local Conveyor = require(script.Conveyor)
local Economy = require(script.Economy)
local Steal = require(script.Steal)
local Rebirth = require(script.Rebirth)
local Events = require(script.Events)

-- One folder holding every RemoteEvent (names from Config.Remotes).
local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = ReplicatedStorage
for _, name in ipairs(Config.Remotes) do
	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = remotes
end

-- Build the market, then link stalls into the plot records.
Plots.init()
World.build()
Plots.linkStalls(World.Stalls)
Plots.TouchBinder = Steal.bindTouch
Economy.Remotes = remotes
Events.Remotes = remotes

local function onPlayerAdded(player)
	local plotId = State.claimPlot(player)
	if not plotId then
		player:Kick("Pasar penuh — semua warung sudah ada pemiliknya.")
		return
	end
	local record = State.newPlayerRecord(plotId)
	State.Players[player] = record
	Plots.refreshSign(plotId)
	Plots.applySkin(plotId, 0)

	-- Leaderboard stats, shown in Roblox's default player list.
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	local cashStat = Instance.new("IntValue")
	cashStat.Name = "Cash"
	cashStat.Value = Config.StartCash
	cashStat.Parent = leaderstats
	local rebirthStat = Instance.new("IntValue")
	rebirthStat.Name = "Rebirths"
	rebirthStat.Value = 0
	rebirthStat.Parent = leaderstats

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			-- Dying drops whatever you were carrying.
			State.dropCarried(player, Plots)
		end)
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

-- Remote handlers: every client request goes through the same server-side
-- checks as the in-world prompts do.
remotes.BuyBrainrot.OnServerEvent:Connect(function(player, itemId)
	Conveyor.buyBrainrot(player, itemId)
end)
remotes.Slap.OnServerEvent:Connect(function(player)
	Steal.slap(player)
end)
remotes.LockBase.OnServerEvent:Connect(function(player)
	Steal.lockBase(player)
end)
remotes.Rebirth.OnServerEvent:Connect(function(player)
	local ok, message = Rebirth.doRebirth(player)
	local remote = remotes:FindFirstChild("EventAnnounce")
	if remote and ok then
		remote:FireClient(player, message, Color3.fromRGB(255, 210, 90))
	end
end)
remotes.UpgradePlot.OnServerEvent:Connect(function(player)
	Plots.upgradeSlots(player)
	Economy.pushState(player)
end)

-- Start the loops: conveyor spawns + movement, income tick, steal
-- heartbeat, and the random event clock.
Conveyor.start()
Economy.start()
Steal.start()
Events.start()

print("BRAINROT WARUNG siap — pasar buka, etalase berjalan.")
