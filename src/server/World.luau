-- World: builds the 3D night market of BRAINROT WARUNG at runtime, from
-- primitive Parts only (street, conveyor, plot pads are static in
-- default.project.json). V = Vector3.new, C = Color3.fromRGB.

local Config = require(game:GetService("ReplicatedStorage").Shared.Config)

local V = Vector3.new
local C = Color3.fromRGB

local World = {}

local function part(parent, name, size, pos, color, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = true
	p.Parent = parent
	return p
end

local function buildStall(plotId, centre)
	-- A warung stall: back wall, counter, striped awning, owner sign.
	local folder = Instance.new("Folder")
	folder.Name = "Stall" .. tostring(plotId)
	folder.Parent = workspace

	local backZ = centre.Z - 4.5
	part(folder, "BackWall", V(11, 5, 0.6), V(centre.X, 3, backZ),
		C(120, 80, 50), Enum.Material.WoodPlanks)
	part(folder, "Counter", V(10, 1.2, 2), V(centre.X, 1.1, centre.Z - 3),
		C(160, 110, 60), Enum.Material.WoodPlanks)
	-- Striped awning: alternating red/cream slats.
	for i = 0, 6 do
		local x = centre.X - 5.4 + i * 1.55
		local c = (i % 2 == 0) and C(200, 60, 60) or C(250, 240, 210)
		part(folder, "Awning" .. i, V(1.55, 0.3, 4.5), V(x, 5.6, centre.Z - 2.5), c, Enum.Material.Fabric)
	end
	part(folder, "PostL", V(0.4, 5.4, 0.4), V(centre.X - 5.2, 2.7, centre.Z - 0.4),
		C(90, 60, 35), Enum.Material.Wood)
	part(folder, "PostR", V(0.4, 5.4, 0.4), V(centre.X + 5.2, 2.7, centre.Z - 0.4),
		C(90, 60, 35), Enum.Material.Wood)

	-- Owner sign: a board with a BillboardGui the Plots module fills in.
	local sign = part(folder, "Sign", V(7, 1.6, 0.4), V(centre.X, 6.6, backZ + 0.4),
		C(40, 30, 20), Enum.Material.WoodPlanks)
	local gui = Instance.new("BillboardGui")
	gui.Name = "OwnerSign"
	gui.Size = UDim2.fromOffset(320, 70)
	gui.StudsOffsetWorldSpace = V(0, 0, 0.4)
	gui.Parent = sign
	local label = Instance.new("TextLabel")
	label.Name = "OwnerName"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "WARUNG KOSONG"
	label.TextColor3 = C(255, 220, 120)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = gui

	-- Lock shield: a transparent wall that appears while the plot is locked.
	local shield = part(folder, "LockShield", V(11.6, 6, 11.6),
		V(centre.X, 3.5, centre.Z), C(80, 200, 255), Enum.Material.Glass)
	shield.Transparency = 1
	shield.CanCollide = false
	shield.CanQuery = false
	return folder
end

local function buildLamp(x, z)
	local folder = Instance.new("Folder")
	folder.Name = "Lamp"
	folder.Parent = workspace
	part(folder, "Pole", V(0.4, 7, 0.4), V(x, 3.5, z),
		C(50, 50, 55), Enum.Material.Metal)
	local bulb = part(folder, "Bulb", V(1.2, 1.2, 1.2), V(x, 7.2, z),
		C(255, 220, 130), Enum.Material.Neon)
	bulb.Shape = Enum.PartType.Ball
	local light = Instance.new("PointLight")
	light.Color = C(255, 210, 120)
	light.Range = 18
	light.Brightness = 2
	light.Parent = bulb
end

local function buildTree(x, z)
	local folder = Instance.new("Folder")
	folder.Name = "Tree"
	folder.Parent = workspace
	part(folder, "Trunk", V(1, 4, 1), V(x, 2, z),
		C(110, 70, 40), Enum.Material.Wood)
	local top = part(folder, "Leaves", V(4, 4, 4), V(x, 6, z),
		C(40, 140, 60), Enum.Material.SmoothPlastic)
	top.Shape = Enum.PartType.Ball
end

local function buildCart(x, z)
	local folder = Instance.new("Folder")
	folder.Name = "Cart"
	folder.Parent = workspace
	part(folder, "Body", V(4, 1.4, 2.4), V(x, 1.4, z),
		C(180, 90, 40), Enum.Material.WoodPlanks)
	part(folder, "Roof", V(4.4, 0.3, 2.8), V(x, 3.4, z),
		C(240, 220, 150), Enum.Material.Fabric)
	for _, dx in ipairs({ -1.6, 1.6 }) do
		local wheel = part(folder, "Wheel", V(0.4, 1.2, 1.2), V(x + dx, 0.6, z + 1.1),
			C(40, 40, 40), Enum.Material.SmoothPlastic)
		wheel.Shape = Enum.PartType.Cylinder
	end
end

function World.build()
	-- One stall on every plot.
	for plotId = 1, Config.PlotCount do
		local centre = Config.PlotPositions[plotId]
		local stall = buildStall(plotId, centre)
		World.Stalls = World.Stalls or {}
		World.Stalls[plotId] = stall
	end

	-- Lamps down both sides of the street, every 20 studs.
	for _, z in ipairs({ -50, -30, -10, 10, 30, 50 }) do
		buildLamp(-9.5, z)
		buildLamp(9.5, z)
	end

	-- Dodol crates at the street corners, alternating brown shades.
	local crateColors = { C(120, 70, 30), C(150, 90, 40) }
	for i, xz in ipairs({ { -27, 0 }, { 27, 0 }, { -27, 36 }, { 27, 36 } }) do
		part(workspace, "DodolCrate" .. i, V(1.2, 1.2, 1.2), V(xz[1], 0.6, xz[2]), crateColors[(i % 2) + 1])
	end

	-- Trees and carts dressing the street ends and corners.
	buildTree(-24, -52)
	buildTree(28, -52)
	buildTree(-24, 52)
	buildTree(28, 52)
	buildCart(-12, 58)
	buildCart(14, -58)

	-- Market gate at the north end: two pillars, a beam, and the sign.
	local gate = Instance.new("Folder")
	gate.Name = "MarketGate"
	gate.Parent = workspace
	part(gate, "PillarL", V(1.5, 10, 1.5), V(-9, 5, -58),
		C(150, 60, 60), Enum.Material.WoodPlanks)
	part(gate, "PillarR", V(1.5, 10, 1.5), V(9, 5, -58),
		C(150, 60, 60), Enum.Material.WoodPlanks)
	part(gate, "Beam", V(20, 1.5, 1.5), V(0, 10.5, -58),
		C(150, 60, 60), Enum.Material.WoodPlanks)
	local sign = part(gate, "GateSign", V(14, 2.4, 0.5), V(0, 8.6, -58),
		C(40, 30, 20), Enum.Material.WoodPlanks)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(560, 90)
	gui.StudsOffsetWorldSpace = V(0, 0, 0.4)
	gui.Parent = sign
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "PASAR BRAINROT"
	label.TextColor3 = C(255, 220, 120)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = gui

	-- Conveyor sign: what the belt is, floating above its middle.
	local beltSign = part(workspace, "ConveyorSign", V(10, 2, 0.5),
		V(Config.ConveyorX, 7.5, 0), C(40, 30, 20), Enum.Material.WoodPlanks)
	local beltGui = Instance.new("BillboardGui")
	beltGui.Size = UDim2.fromOffset(420, 80)
	beltGui.StudsOffsetWorldSpace = V(0, 0, 0.4)
	beltGui.Parent = beltSign
	local beltLabel = Instance.new("TextLabel")
	beltLabel.Size = UDim2.fromScale(1, 1)
	beltLabel.BackgroundTransparency = 1
	beltLabel.Text = "ETALASE BERJALAN — TEKAN E UNTUK BELI"
	beltLabel.TextColor3 = C(140, 255, 140)
	beltLabel.TextScaled = true
	beltLabel.Font = Enum.Font.GothamBold
	beltLabel.Parent = beltGui
end

return World
