-- Events: one random market event every ~90 seconds. Four kinds, each real
-- in the code: Hujan Dodol doubles income, Tung Tung Rush floods the conveyor
-- with rare brainrots, Satpol Raid sweeps the street (caught outside your plot,
-- you lose 10% of your cash), and Tamu Istimewa walks a Secret down the belt.

local Players = game:GetService("Players")
local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local BrainrotData = require(game:GetService("ReplicatedStorage").Shared.BrainrotData)
local Mutations = require(game:GetService("ReplicatedStorage").Shared.Mutations)
local State = require(script.Parent.State)
local Factory = require(script.Parent.BrainrotFactory)
local Plots = require(script.Parent.Plots)

local Events = {}
Events.Remotes = nil -- set by init.server.luau

local function announce(text, color)
	State.CurrentEvent = text
	if Events.Remotes then
		local remote = Events.Remotes:FindFirstChild("EventAnnounce")
		if remote then
			remote:FireAllClients(text, color)
		end
	end
end

local function clearAnnouncement()
	State.CurrentEvent = nil
	if Events.Remotes then
		local remote = Events.Remotes:FindFirstChild("EventAnnounce")
		if remote then
			remote:FireAllClients("", Color3.fromRGB(255, 255, 255))
		end
	end
end

-- Hujan Dodol: income x2 for 30 seconds, dodol pieces rain on the street.
local function hujanDodol()
	State.EventMultiplier = Config.DodolMultiplier
	announce("HUJAN DODOL! Income x2 selama 30 detik!", Color3.fromRGB(255, 200, 80))
	local drops = {}
	for _ = 1, 30 do
		local drop = Instance.new("Part")
		drop.Size = Vector3.new(1.2, 0.8, 1.2)
		drop.Color = Color3.fromRGB(120, 70, 30)
		drop.Material = Enum.Material.SmoothPlastic
		drop.Anchored = true
		drop.CanCollide = false
		drop.Position = Vector3.new(math.random(-24, 28), math.random(25, 40), math.random(-55, 55))
		drop.Parent = workspace
		table.insert(drops, drop)
	end
	task.spawn(function()
		for _ = 1, 60 do
			task.wait(0.5)
			for _, drop in ipairs(drops) do
				if drop.Parent then
					drop.Position -= Vector3.new(0, 1.2, 0)
					if drop.Position.Y <= 1 then
						drop:Destroy()
					end
				end
			end
		end
	end)
	task.delay(Config.EventDuration, function()
		State.EventMultiplier = 1
		clearAnnouncement()
	end)
end

-- Spawn one brainrot on the belt at z (shared by the rush and the guest:
-- one roll, one model, one buy prompt, one conveyor record).
local function spawnBeltBrainrot(char, z)
	local mutation = Mutations.rollMutation()
	local id = State.nextId()
	local position = Vector3.new(Config.ConveyorX, 1.2, z)
	local model = Factory.buildCharacter(char, position, mutation)
	model.Parent = workspace
	local prompt = Factory.attachBuyPrompt(model, id, char.price)
	prompt.Triggered:Connect(function(player)
		require(script.Parent.Conveyor).buyBrainrot(player, id)
	end)
	State.Conveyor[id] = {
		id = id, charKey = char.key, name = char.name, tier = char.tier,
		price = char.price, income = Mutations.mutatedIncome(char, mutation),
		mutation = mutation, model = model,
		owner = nil, plotId = nil, slotIndex = nil, carriedBy = nil,
		z = z,
	}
end

-- Tung Tung Rush: rare spawns flood the conveyor for 60 seconds, and three
-- rare brainrots appear on the belt at once.
local function tungTungRush()
	State.RushActive = true
	announce("TUNG TUNG RUSH! Brainrot langka membanjiri etalase!", Color3.fromRGB(80, 230, 180))
	for _ = 1, 3 do
		spawnBeltBrainrot(BrainrotData.pickCharacter(true), Config.ConveyorZ0 - 12)
	end
	task.delay(Config.RushDuration, function()
		State.RushActive = false
		clearAnnouncement()
	end)
end

-- Tamu Istimewa: one Secret-tier brainrot walks the belt alone, once.
local function tamuIstimewa()
	announce("TAMU ISTIMEWA! Brainrot Secret muncul di etalase!", Color3.fromRGB(80, 230, 180))
	local secrets = {}
	for _, char in ipairs(BrainrotData.Characters) do
		if char.tier == "Secret" then
			table.insert(secrets, char)
		end
	end
	spawnBeltBrainrot(secrets[math.random(1, #secrets)], Config.ConveyorZ0 - 12)
end

-- Satpol Raid: 15 seconds to run home, then the sweep takes 10% of the
-- cash of anyone caught outside their own plot. The conveyor halts.
local function satpolRaid()
	State.RaidActive = true
	announce("SATPOL RAID! Pulang ke warungmu dalam 15 detik!", Color3.fromRGB(255, 80, 80))
	task.delay(Config.RaidWarnSeconds, function()
		for _, player in ipairs(Players:GetPlayers()) do
			local record = State.get(player)
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if record and root and not Plots.isOnPlot(record.plotId, root.Position) then
				record.cash = math.floor(record.cash * (1 - Config.RaidCashLoss))
			end
		end
		announce("Satpol sudah lewat. Etalase buka lagi!", Color3.fromRGB(255, 255, 255))
		task.delay(5, function()
			State.RaidActive = false
			clearAnnouncement()
		end)
	end)
end

local EVENT_PICKERS = { hujanDodol, tungTungRush, satpolRaid, tamuIstimewa }

function Events.start()
	task.spawn(function()
		while true do
			task.wait(Config.EventInterval)
			local pick = EVENT_PICKERS[math.random(1, #EVENT_PICKERS)]
			pick()
		end
	end)
end

return Events
