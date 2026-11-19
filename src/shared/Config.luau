-- Config: one place for every number the game tunes — cash, conveyor,
-- plots, steal, rebirth and events. Server and client share this module.
local V = Vector3.new
local C = Color3.fromRGB

local Config = {}

Config.StartCash = 100
Config.ConveyorX = 13.2
Config.ConveyorZ0 = -50
Config.ConveyorZ1 = 50
Config.ConveyorSpeed = 4
Config.SpawnInterval = 7
Config.PlotCount = 8
Config.PlotSlotsStart = 4
Config.PlotSlotMax = 10
Config.PlotSlotCost = 500
Config.LockDuration = 30
Config.LockCooldown = 60
Config.SlapCooldown = 3
Config.SlapRange = 12
Config.EventInterval = 90
Config.RushDuration = 60
Config.DodolDuration = 30
Config.DodolMultiplier = 2
Config.RaidWarn = 15
Config.RaidLoss = 0.10
-- Banjir Bandang: the flood wall waits FloodDelay, then sweeps the street
-- over FloodDuration; anyone it catches off-plot loses FloodLoss of cash.
Config.FloodDelay = 3
Config.FloodDuration = 15
Config.FloodLoss = 0.10
Config.RebirthCash = 50000
Config.RebirthMinBrainrots = 3
Config.RebirthBonus = 0.5
Config.RebirthSkins = { "Kayu", "Bata", "Neon", "Istana Dodol" }
Config.SkinColors = { C(150, 100, 55), C(170, 80, 70), C(90, 200, 255), C(255, 210, 60) }
Config.Remotes = { "Rebirth", "Lock", "Slap", "AddSlot", "Sell", "HudUpdate", "EventAnnounce" }
-- 3x3 grid on the pad; the 10th slot tucks into the middle.
Config.SlotOffsets = {
	V(-4, 0, -4), V(0, 0, -4), V(4, 0, -4),
	V(-4, 0, 0), V(0, 0, 0), V(4, 0, 0),
	V(-4, 0, 4), V(0, 0, 4), V(4, 0, 4), V(-2, 0, 2),
}

return Config
