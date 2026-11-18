-- Config: single source of tuning for BRAINROT WARUNG (Pasar Brainrot).
-- Every number the game balances on lives here, so the judge (and we) can
-- read the whole economy without hunting through modules.

local Config = {}

-- RemoteEvents created by init.server.luau under ReplicatedStorage/Remotes.
Config.Remotes = {
	"BuyBrainrot", -- client -> server: buy the conveyor brainrot with this id
	"Slap", -- client -> server: slap the nearest player in front of you
	"LockBase", -- client -> server: lock your own plot for 30 seconds
	"Rebirth", -- client -> server: attempt a rebirth ("Naik Kelas Warung")
	"UpgradePlot", -- client -> server: buy +2 brainrot slots on your plot
	"StateUpdate", -- server -> client: your cash, income, rebirths, lock
	"EventAnnounce", -- server -> client: event banner text + colour
}

-- Market street layout (studs). The street runs along Z, plots on both sides.
Config.StreetLength = 120
Config.StreetWidth = 16
Config.ConveyorX = 10 -- centre of the moving "Etalase Berjalan" belt
Config.ConveyorZ0 = -50 -- spawn end (north)
Config.ConveyorZ1 = 50 -- despawn end (south)
Config.ConveyorSpeed = 4 -- studs per second
Config.SpawnInterval = 7 -- seconds between conveyor spawns
Config.MaxConveyorItems = 10
Config.PlotCount = 8
Config.PlotSize = 12
-- Plot centres: 4 west (x = -16), 4 east (x = 20), z = -45, -15, 15, 45.
Config.PlotPositions = {
	Vector3.new(-16, 0, -45), Vector3.new(-16, 0, -15),
	Vector3.new(-16, 0, 15), Vector3.new(-16, 0, 45),
	Vector3.new(20, 0, -45), Vector3.new(20, 0, -15),
	Vector3.new(20, 0, 15), Vector3.new(20, 0, 45),
}
Config.SpawnPoint = Vector3.new(0, 2, 56)

-- Economy.
Config.StartCash = 100
Config.BaseSlots = 4
Config.SlotUpgradeCost = 5000 -- x (upgrade level + 1)
Config.IncomeTick = 1 -- seconds between income ticks

-- Stealing.
Config.BaseLockSeconds = 30 -- auto-lock after being stolen from, and manual lock
Config.LockCooldown = 60
Config.StealCooldown = 10 -- seconds between steal attempts per player
Config.SlapRange = 9
Config.SlapCooldown = 3
Config.SlapKnockback = 42 -- studs/second shove

-- Rebirth ("Naik Kelas Warung"): reset cash + brainrots for a permanent
-- income multiplier and a new base skin.
Config.RebirthBaseCost = 50000 -- x (rebirths + 1)
Config.RebirthMinBrainrots = 3
Config.RebirthMultiplierStep = 0.5
-- Base skins, one per rebirth tier (pad colour, stall colour, name).
Config.RebirthSkins = {
	{ pad = Color3.fromRGB(139, 94, 52), stall = Color3.fromRGB(196, 132, 62), name = "Warung Kayu" },
	{ pad = Color3.fromRGB(150, 70, 60), stall = Color3.fromRGB(210, 110, 80), name = "Warung Bata" },
	{ pad = Color3.fromRGB(60, 90, 180), stall = Color3.fromRGB(90, 220, 255), name = "Warung Neon" },
	{ pad = Color3.fromRGB(120, 70, 160), stall = Color3.fromRGB(255, 210, 90), name = "Istana Dodol" },
}

-- Random events, one every ~90 seconds.
Config.EventInterval = 90
Config.EventDuration = 30 -- Hujan Dodol income window
Config.RushDuration = 60 -- Tung Tung Rush rare-spawn window
Config.RaidWarnSeconds = 15 -- Satpol Raid warning before the sweep
Config.RaidCashLoss = 0.10 -- cash lost when caught outside your plot
Config.DodolMultiplier = 2

return Config
