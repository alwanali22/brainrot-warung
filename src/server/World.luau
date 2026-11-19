-- World: the night market itself, built at runtime — street lamps, carts,
-- trees, the gate arch, and dodol crates at the street corners. Static
-- market parts (fence, stalls, stage, string lights) live in the Place.
local V = Vector3.new
local C = Color3.fromRGB

local World = {}

local function part(parent, name, size, pos, color, material, shape)
	local p = Instance.new("Part")
	p.Name = name
	p.Shape = shape or Enum.PartType.Block
	p.Size = size
	p.Position = pos
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.Parent = parent
	return p
end

local function lamp(x, z)
	part(workspace, "LampPole", V(0.4, 6, 0.4), V(x, 3, z), C(40, 40, 45), Enum.Material.Metal)
	part(workspace, "LampHead", V(1.4, 1.4, 1.4), V(x, 6.4, z), C(255, 220, 130), Enum.Material.Neon, Enum.PartType.Ball)
	part(workspace, "LampBase", V(1.2, 0.5, 1.2), V(x, 0.25, z), C(60, 60, 65), Enum.Material.Concrete)
end

local function cart(x, z, color)
	part(workspace, "CartBox", V(3, 1.4, 2), V(x, 1.1, z), color, Enum.Material.WoodPlanks)
	part(workspace, "CartRoof", V(3.4, 0.2, 2.4), V(x, 2.6, z), C(240, 220, 150), Enum.Material.Fabric)
	part(workspace, "CartWheel", V(0.3, 1, 1), V(x - 1.2, 0.5, z), C(30, 30, 30), Enum.Material.Metal, Enum.PartType.Cylinder)
	part(workspace, "CartWheel", V(0.3, 1, 1), V(x + 1.2, 0.5, z), C(30, 30, 30), Enum.Material.Metal, Enum.PartType.Cylinder)
	part(workspace, "CartHandle", V(1.4, 0.2, 0.2), V(x, 1.4, z + 1.6), C(90, 60, 35), Enum.Material.Wood)
end

local function tree(x, z)
	part(workspace, "TreeTrunk", V(0.8, 4, 0.8), V(x, 2, z), C(90, 60, 35), Enum.Material.Wood)
	part(workspace, "TreeTop", V(3.4, 3.4, 3.4), V(x, 5.4, z), C(40, 130, 60), Enum.Material.SmoothPlastic, Enum.PartType.Ball)
	part(workspace, "TreeTop", V(2.2, 2.2, 2.2), V(x + 1, 7, z), C(55, 150, 70), Enum.Material.SmoothPlastic, Enum.PartType.Ball)
end

local function gate()
	part(workspace, "GatePillarL", V(1, 9, 1), V(-6, 4.5, -58), C(170, 60, 60), Enum.Material.Wood)
	part(workspace, "GatePillarR", V(1, 9, 1), V(6, 4.5, -58), C(170, 60, 60), Enum.Material.Wood)
	part(workspace, "GateBeam", V(13, 1.2, 1), V(0, 9.4, -58), C(200, 70, 70), Enum.Material.WoodPlanks)
	part(workspace, "GateSign", V(8, 1.6, 0.4), V(0, 8, -58), C(255, 210, 60), Enum.Material.Neon)
end

local function bushes()
	local spots = { { -30, -20 }, { -30, 20 }, { 30, -20 }, { 30, 20 }, { -8, -56 }, { 8, 56 } }
	for i, xz in ipairs(spots) do
		part(workspace, "Bush" .. i, V(2, 1.4, 2), V(xz[1], 0.7, xz[2]), C(45, 120, 60), Enum.Material.Grass, Enum.PartType.Ball)
	end
end

function World.build()
	lamp(-8, -40)
	lamp(8, -10)
	lamp(-8, 20)
	lamp(8, 50)
	cart(-6, -25, C(180, 120, 60))
	cart(6, 25, C(140, 90, 50))
	tree(-26, -56)
	tree(26, 56)
	tree(-26, 56)
	tree(26, -56)
	gate()
	bushes()

	-- Dodol crates at the street corners, alternating brown shades.
	local crateColors = { C(120, 70, 30), C(150, 90, 40) }
	for i, xz in ipairs({ { -27, 0 }, { 27, 0 }, { -27, 36 }, { 27, 36 } }) do
		part(workspace, "DodolCrate" .. i, V(1.2, 1.2, 1.2), V(xz[1], 0.6, xz[2]), crateColors[(i % 2) + 1])
	end

	-- Sound effects: one folder, one Sound each, played by World.playSound.
	local sfx = Instance.new("Folder")
	sfx.Name = "Sfx"
	sfx.Parent = workspace
	local slap = Instance.new("Sound")
	slap.Name = "SlapSfx"
	slap.SoundId = "rbxasset://sounds/button.wav"
	slap.Volume = 0.7
	slap.Parent = sfx
	local chime = Instance.new("Sound")
	chime.Name = "ChimeSfx"
	chime.SoundId = "rbxasset://sounds/electronicpingshort.wav"
	chime.Volume = 0.7
	chime.Parent = sfx

	-- Dodol rain cloud: an invisible slab high over the street with a
	-- brown particle emitter. Off by default; Hujan Dodol turns it on, and
	-- the event turns it off again when the income bonus ends.
	local cloud = part(workspace, "DodolRainCloud", V(60, 1, 100), V(0, 45, 0), C(150, 90, 40))
	cloud.Transparency = 1
	cloud.CanCollide = false
	local rain = Instance.new("ParticleEmitter")
	rain.Color = ColorSequence.new(C(150, 90, 40))
	rain.Size = NumberSequence.new(0.8)
	rain.Lifetime = NumberRange.new(2, 3)
	rain.Speed = NumberRange.new(25)
	rain.EmissionDirection = Enum.NormalId.Bottom
	rain.Rate = 0
	rain.Parent = cloud
end

-- Banjir Bandang wall: a big translucent sheet of flood water at the north
-- end of the street. The event sweeps it south; it never collides, so it
-- can pass through players and stalls while the penalty check runs in code.
-- The wall spans the whole street width (70 studs) so there is no safe
-- lane to walk around it — the only escape is getting back to your plot.
function World.spawnFloodWall()
	local wall = Instance.new("Part")
	wall.Name = "BanjirWall"
	wall.Shape = Enum.PartType.Block
	wall.Size = V(70, 8, 2)
	wall.Position = V(0, 4, -52)
	wall.Color = C(40, 120, 255)
	wall.Transparency = 0.35
	wall.Material = Enum.Material.SmoothPlastic
	wall.Anchored = true
	wall.CanCollide = false
	wall.Parent = workspace
	return wall
end

-- Play one of the Sfx sounds by name; silently does nothing if it is missing.
function World.playSound(name)
	local sfx = workspace:FindFirstChild("Sfx")
	local sound = sfx and sfx:FindFirstChild(name)
	if sound then
		sound:Play()
	end
end

-- Turn the dodol rain on (80/s) or off (0). The cloud stays invisible;
-- only the falling brown particles show.
function World.setDodolRain(on)
	local cloud = workspace:FindFirstChild("DodolRainCloud")
	local emitter = cloud and cloud:FindFirstChildOfClass("ParticleEmitter")
	if emitter then
		emitter.Rate = on and 80 or 0
	end
end

-- World end: everything here is Anchored, so nothing drifts at runtime.

return World
