-- Events: one random event every ~90 seconds. Four kinds: Hujan Dodol doubles
-- income, Tung Tung Rush floods the belt with rare spawns, Satpol Raid
-- punishes anyone caught off their plot, and Tamu Istimewa walks a Secret
-- down the belt alone. Every event announces itself on the HUD banner.
local Shared = game:GetService("ReplicatedStorage").Shared
local Config = require(Shared.Config)
local BrainrotData = require(Shared.BrainrotData)
local Mutations = require(Shared.Mutations)
local State = require(script.Parent.State)
local Factory = require(script.Parent.BrainrotFactory)
local Conveyor = require(script.Parent.Conveyor)
local Plots = require(script.Parent.Plots)

local Events = {}
local announceRemote = nil

local function announce(text, color)
	if not announceRemote then
		local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
		announceRemote = remotes:WaitForChild("EventAnnounce")
	end
	announceRemote:FireAllClients(text, color)
end

-- One belt spawn, shared by the rush and the special guest: roll a mutation,
-- build the model, wire the buy prompt, register the item like a normal spawn.
local function spawnBeltBrainrot(char, z)
	local mutation = Mutations.rollMutation()
	local id = State.nextId()
	local position = Vector3.new(Config.ConveyorX, 1.2, z)
	local model = Factory.buildCharacter(char, position, mutation)
	model.Parent = workspace
	local prompt = Factory.attachBuyPrompt(model, id, char.price)
	prompt.Triggered:Connect(function(player)
		Conveyor.buyBrainrot(player, id)
	end)
	State.Conveyor[id] = {
		id = id, charKey = char.key, name = char.name, tier = char.tier,
		price = char.price, income = Mutations.mutatedIncome(char, mutation),
		mutation = mutation, model = model, owner = nil, plotId = nil,
		slotIndex = nil, carriedBy = nil, z = z,
	}
end

local function hujanDodol()
	State.EventMultiplier = Config.DodolMultiplier
	announce("HUJAN DODOL! Income 2x selama 30 detik!", Color3.fromRGB(255, 210, 60))
	for i = 1, 20 do
		local p = Instance.new("Part")
		p.Name = "DodolRain"
		p.Shape = Enum.PartType.Ball
		p.Size = Vector3.new(1, 1, 1)
		p.Position = Vector3.new(math.random(-30, 30), 40 + i, math.random(-50, 50))
		p.Color = Color3.fromRGB(150, 90, 40)
		p.Anchored = false
		p.Parent = workspace
		game:GetService("Debris"):AddItem(p, 8)
	end
	task.delay(Config.DodolDuration, function()
		State.EventMultiplier = 1
	end)
end

local function tungTungRush()
	announce("TUNG TUNG RUSH! Brainrot langka membanjiri etalase!", Color3.fromRGB(255, 120, 60))
	State.RushUntil = os.clock() + Config.RushDuration
	for _ = 1, 3 do
		spawnBeltBrainrot(BrainrotData.pickCharacter(true), Config.ConveyorZ0 - 12)
	end
end

local function satpolRaid()
	announce("SATPOL RAID! Kembali ke plotmu dalam 15 detik atau kehilangan 10% cash!", Color3.fromRGB(255, 60, 60))
	task.delay(Config.RaidWarn, function()
		for player, d in pairs(State.Players) do
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local home = d.plotId and Plots.padCenter(d.plotId)
			if root and home and (root.Position - home).Magnitude > 10 then
				d.cash = math.floor(d.cash * (1 - Config.RaidLoss))
			end
		end
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

-- Four pickers, equal odds; the scheduler draws one every EventInterval.
local EVENT_PICKERS = { hujanDodol, tungTungRush, satpolRaid, tamuIstimewa }

function Events.start()
	task.spawn(function()
		while true do
			task.wait(Config.EventInterval)
			EVENT_PICKERS[math.random(1, #EVENT_PICKERS)]()
		end
	end)
end

return Events
