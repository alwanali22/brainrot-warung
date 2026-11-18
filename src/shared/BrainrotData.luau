-- BrainrotData: the cast of BRAINROT WARUNG. Twelve named Italian-brainrot
-- characters on a seven-tier rarity ladder. Each entry carries its price,
-- its money per second, its colours, and a small recipe of primitive parts
-- that BrainrotFactory assembles into a 3D model (no unions, no meshes).
-- Part recipe entries: { shape, size (Vector3), offset (Vector3), color }.
-- Shapes: Block, Ball, Wedge, Cylinder.

local BrainrotData = {}

BrainrotData.Tiers = {
	{ name = "Common", color = Color3.fromRGB(180, 180, 180), weight = 40 },
	{ name = "Rare", color = Color3.fromRGB(80, 160, 255), weight = 25 },
	{ name = "Epic", color = Color3.fromRGB(170, 90, 220), weight = 16 },
	{ name = "Legendary", color = Color3.fromRGB(255, 190, 40), weight = 10 },
	{ name = "Mythic", color = Color3.fromRGB(255, 80, 120), weight = 5 },
	{ name = "Brainrot God", color = Color3.fromRGB(255, 60, 60), weight = 3 },
	{ name = "Secret", color = Color3.fromRGB(40, 230, 180), weight = 1 },
}

-- Character list. price and income grow roughly x2.2 per step up the ladder,
-- so every tier is a real purchase goal, never a free upgrade.
BrainrotData.Characters = {
	{
		key = "chimpanzini", name = "Chimpanzini Bananini", tier = "Common",
		price = 50, income = 1,
		body = Color3.fromRGB(120, 80, 40), accent = Color3.fromRGB(255, 220, 60),
		parts = {
			{ "Block", Vector3.new(2.4, 2, 2), Vector3.new(0, 1.6, 0), Color3.fromRGB(120, 80, 40) },
			{ "Ball", Vector3.new(1.8, 1.8, 1.8), Vector3.new(0, 3.2, 0), Color3.fromRGB(120, 80, 40) },
			{ "Ball", Vector3.new(2.2, 1.2, 0.6), Vector3.new(0, 1.2, 1), Color3.fromRGB(255, 220, 60) },
			{ "Wedge", Vector3.new(0.6, 1.4, 1.2), Vector3.new(-1.1, 3.8, 0), Color3.fromRGB(120, 80, 40) },
			{ "Wedge", Vector3.new(0.6, 1.4, 1.2), Vector3.new(1.1, 3.8, 0), Color3.fromRGB(120, 80, 40) },
		},
	},
	{
		key = "lirili", name = "Lirili Larila", tier = "Common",
		price = 150, income = 3,
		body = Color3.fromRGB(255, 150, 90), accent = Color3.fromRGB(255, 240, 200),
		parts = {
			{ "Block", Vector3.new(2.6, 1.6, 3.4), Vector3.new(0, 1.5, 0), Color3.fromRGB(255, 150, 90) },
			{ "Ball", Vector3.new(1.6, 1.6, 1.6), Vector3.new(0, 2.8, 1.2), Color3.fromRGB(255, 240, 200) },
			{ "Wedge", Vector3.new(0.5, 1.6, 1.8), Vector3.new(0, 1.6, -2.2), Color3.fromRGB(255, 100, 60) },
			{ "Block", Vector3.new(0.4, 1, 1.4), Vector3.new(-1.5, 2.6, 0.4), Color3.fromRGB(255, 240, 200) },
			{ "Block", Vector3.new(0.4, 1, 1.4), Vector3.new(1.5, 2.6, 0.4), Color3.fromRGB(255, 240, 200) },
		},
	},
	{
		key = "trippi", name = "Trippi Troppi", tier = "Rare",
		price = 400, income = 7,
		body = Color3.fromRGB(90, 180, 255), accent = Color3.fromRGB(255, 130, 170),
		parts = {
			{ "Block", Vector3.new(2.6, 1.8, 3.2), Vector3.new(0, 1.5, 0), Color3.fromRGB(90, 180, 255) },
			{ "Ball", Vector3.new(1.8, 1.8, 1.8), Vector3.new(0, 2.9, 1), Color3.fromRGB(255, 220, 230) },
			{ "Wedge", Vector3.new(0.5, 1.4, 1.6), Vector3.new(0, 1.6, -2), Color3.fromRGB(255, 130, 170) },
			{ "Cylinder", Vector3.new(0.5, 1.6, 0.5), Vector3.new(-1.2, 0.4, 1), Color3.fromRGB(255, 130, 170) },
			{ "Cylinder", Vector3.new(0.5, 1.6, 0.5), Vector3.new(1.2, 0.4, 1), Color3.fromRGB(255, 130, 170) },
		},
	},
	{
		key = "frigo", name = "Frigo Camelo", tier = "Rare",
		price = 900, income = 15,
		body = Color3.fromRGB(200, 220, 235), accent = Color3.fromRGB(180, 120, 70),
		parts = {
			{ "Block", Vector3.new(2.4, 3.4, 1.8), Vector3.new(0, 2.2, 0), Color3.fromRGB(200, 220, 235) },
			{ "Ball", Vector3.new(1.8, 1.4, 1.6), Vector3.new(0, 4.2, 0.3), Color3.fromRGB(180, 120, 70) },
			{ "Block", Vector3.new(2, 0.4, 1.4), Vector3.new(0, 3.6, 0), Color3.fromRGB(90, 140, 180) },
			{ "Block", Vector3.new(0.5, 1.6, 0.5), Vector3.new(-1, 0.4, 0.8), Color3.fromRGB(180, 120, 70) },
			{ "Block", Vector3.new(0.5, 1.6, 0.5), Vector3.new(1, 0.4, 0.8), Color3.fromRGB(180, 120, 70) },
		},
	},
	{
		key = "ballerina", name = "Ballerina Cappuccina", tier = "Epic",
		price = 2000, income = 30,
		body = Color3.fromRGB(255, 210, 230), accent = Color3.fromRGB(120, 70, 40),
		parts = {
			{ "Cylinder", Vector3.new(2.6, 0.4, 2.6), Vector3.new(0, 1.6, 0), Color3.fromRGB(255, 150, 200) },
			{ "Block", Vector3.new(1.6, 1.8, 1.2), Vector3.new(0, 2.6, 0), Color3.fromRGB(255, 210, 230) },
			{ "Ball", Vector3.new(1.5, 1.5, 1.5), Vector3.new(0, 4, 0), Color3.fromRGB(255, 220, 190) },
			{ "Cylinder", Vector3.new(1.9, 0.5, 1.9), Vector3.new(0, 4.7, 0), Color3.fromRGB(120, 70, 40) },
			{ "Block", Vector3.new(0.4, 1.8, 0.4), Vector3.new(-1.1, 2.6, 0), Color3.fromRGB(255, 220, 190) },
			{ "Block", Vector3.new(0.4, 1.8, 0.4), Vector3.new(1.1, 2.6, 0), Color3.fromRGB(255, 220, 190) },
		},
	},
	{
		key = "boneca", name = "Boneca Ambalabu", tier = "Epic",
		price = 4500, income = 60,
		body = Color3.fromRGB(255, 120, 160), accent = Color3.fromRGB(255, 240, 120),
		parts = {
			{ "Ball", Vector3.new(1.8, 1.8, 1.8), Vector3.new(0, 3.6, 0), Color3.fromRGB(255, 220, 190) },
			{ "Block", Vector3.new(2.2, 2.2, 1.4), Vector3.new(0, 1.8, 0), Color3.fromRGB(255, 120, 160) },
			{ "Wedge", Vector3.new(2.4, 1.6, 2), Vector3.new(0, 0.8, 0), Color3.fromRGB(255, 240, 120) },
			{ "Ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(-0.7, 4.6, 0), Color3.fromRGB(255, 120, 160) },
			{ "Ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0.7, 4.6, 0), Color3.fromRGB(255, 120, 160) },
		},
	},
	{
		key = "tralalero", name = "Tralalero Tralala", tier = "Legendary",
		price = 10000, income = 130,
		body = Color3.fromRGB(60, 140, 255), accent = Color3.fromRGB(240, 240, 240),
		parts = {
			{ "Block", Vector3.new(2.4, 2, 4.4), Vector3.new(0, 1.8, 0), Color3.fromRGB(60, 140, 255) },
			{ "Block", Vector3.new(2, 1, 3.6), Vector3.new(0, 1, 0), Color3.fromRGB(240, 240, 240) },
			{ "Wedge", Vector3.new(1.6, 1.8, 0.6), Vector3.new(0, 3.2, -0.4), Color3.fromRGB(60, 140, 255) },
			{ "Wedge", Vector3.new(1.8, 1.4, 0.6), Vector3.new(0, 1.8, -2.6), Color3.fromRGB(60, 140, 255) },
			{ "Ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(-0.7, 2.6, 1.8), Color3.fromRGB(20, 20, 20) },
			{ "Ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0.7, 2.6, 1.8), Color3.fromRGB(20, 20, 20) },
		},
	},
	{
		key = "bombardiro", name = "Bombardiro Crocodilo", tier = "Legendary",
		price = 22000, income = 260,
		body = Color3.fromRGB(60, 160, 80), accent = Color3.fromRGB(120, 120, 120),
		parts = {
			{ "Block", Vector3.new(2.6, 1.8, 4.6), Vector3.new(0, 1.6, 0), Color3.fromRGB(60, 160, 80) },
			{ "Block", Vector3.new(1.8, 1, 1.8), Vector3.new(0, 1.8, 2.4), Color3.fromRGB(40, 120, 60) },
			{ "Block", Vector3.new(0.4, 0.3, 3.4), Vector3.new(-1.6, 2.6, -0.4), Color3.fromRGB(120, 120, 120) },
			{ "Block", Vector3.new(0.4, 0.3, 3.4), Vector3.new(1.6, 2.6, -0.4), Color3.fromRGB(120, 120, 120) },
			{ "Wedge", Vector3.new(1.6, 1.2, 0.6), Vector3.new(0, 1.6, -2.6), Color3.fromRGB(40, 120, 60) },
			{ "Cylinder", Vector3.new(0.4, 1.2, 0.4), Vector3.new(-1, 0.4, 1.4), Color3.fromRGB(40, 120, 60) },
			{ "Cylinder", Vector3.new(0.4, 1.2, 0.4), Vector3.new(1, 0.4, 1.4), Color3.fromRGB(40, 120, 60) },
		},
	},
	{
		key = "giraffa", name = "Giraffa Celeste", tier = "Mythic",
		price = 50000, income = 550,
		body = Color3.fromRGB(255, 220, 130), accent = Color3.fromRGB(140, 200, 255),
		parts = {
			{ "Block", Vector3.new(2.4, 2, 3), Vector3.new(0, 1.6, 0), Color3.fromRGB(255, 220, 130) },
			{ "Block", Vector3.new(1, 2.6, 1), Vector3.new(0, 3.8, 1.2), Color3.fromRGB(255, 220, 130) },
			{ "Block", Vector3.new(1.6, 1.2, 1.6), Vector3.new(0, 5.6, 1.2), Color3.fromRGB(255, 220, 130) },
			{ "Wedge", Vector3.new(0.5, 1.2, 1), Vector3.new(-0.7, 6.4, 1.2), Color3.fromRGB(255, 190, 90) },
			{ "Wedge", Vector3.new(0.5, 1.2, 1), Vector3.new(0.7, 6.4, 1.2), Color3.fromRGB(255, 190, 90) },
			{ "Block", Vector3.new(2.8, 0.4, 1), Vector3.new(0, 6.4, 1.2), Color3.fromRGB(140, 200, 255) },
		},
	},
	{
		key = "vaca", name = "La Vaca Saturno Saturnita", tier = "Mythic",
		price = 110000, income = 1100,
		body = Color3.fromRGB(240, 240, 240), accent = Color3.fromRGB(255, 200, 60),
		parts = {
			{ "Block", Vector3.new(2.8, 2.2, 3.4), Vector3.new(0, 1.7, 0), Color3.fromRGB(240, 240, 240) },
			{ "Ball", Vector3.new(1.8, 1.8, 1.8), Vector3.new(0, 3.4, 1.2), Color3.fromRGB(240, 240, 240) },
			{ "Cylinder", Vector3.new(3.6, 0.3, 3.6), Vector3.new(0, 3.4, 0), Color3.fromRGB(255, 200, 60) },
			{ "Ball", Vector3.new(0.9, 0.9, 0.9), Vector3.new(0, 3.4, 3.2), Color3.fromRGB(255, 150, 200) },
			{ "Wedge", Vector3.new(0.5, 1.2, 0.8), Vector3.new(-0.9, 4.4, 1.2), Color3.fromRGB(255, 200, 60) },
			{ "Wedge", Vector3.new(0.5, 1.2, 0.8), Vector3.new(0.9, 4.4, 1.2), Color3.fromRGB(255, 200, 60) },
		},
	},
	{
		key = "pot", name = "Pot Hotspot", tier = "Brainrot God",
		price = 250000, income = 2400,
		body = Color3.fromRGB(220, 90, 60), accent = Color3.fromRGB(255, 220, 80),
		parts = {
			{ "Cylinder", Vector3.new(2.6, 2.4, 2.6), Vector3.new(0, 1.7, 0), Color3.fromRGB(220, 90, 60) },
			{ "Cylinder", Vector3.new(2.9, 0.4, 2.9), Vector3.new(0, 3, 0), Color3.fromRGB(90, 90, 90) },
			{ "Ball", Vector3.new(1.6, 1.2, 1.6), Vector3.new(0, 3.6, 0), Color3.fromRGB(255, 220, 80) },
			{ "Block", Vector3.new(0.5, 1.4, 0.5), Vector3.new(-1, 3.4, 0), Color3.fromRGB(255, 220, 80) },
			{ "Block", Vector3.new(0.5, 1.4, 0.5), Vector3.new(1, 3.4, 0), Color3.fromRGB(255, 220, 80) },
			{ "Ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(-0.6, 2.2, 1.3), Color3.fromRGB(20, 20, 20) },
			{ "Ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0.6, 2.2, 1.3), Color3.fromRGB(20, 20, 20) },
		},
	},
	{
		key = "sahur", name = "Tung Tung Tung Sahur", tier = "Secret",
		price = 600000, income = 6000,
		body = Color3.fromRGB(150, 100, 60), accent = Color3.fromRGB(255, 240, 200),
		parts = {
			{ "Cylinder", Vector3.new(2.8, 2.6, 2.8), Vector3.new(0, 1.8, 0), Color3.fromRGB(150, 100, 60) },
			{ "Cylinder", Vector3.new(3, 0.4, 3), Vector3.new(0, 3.2, 0), Color3.fromRGB(255, 240, 200) },
			{ "Cylinder", Vector3.new(3, 0.4, 3), Vector3.new(0, 0.5, 0), Color3.fromRGB(255, 240, 200) },
			{ "Ball", Vector3.new(1.7, 1.7, 1.7), Vector3.new(0, 4.2, 0), Color3.fromRGB(255, 240, 200) },
			{ "Block", Vector3.new(0.4, 2, 0.4), Vector3.new(-1.4, 4.4, 0), Color3.fromRGB(120, 70, 40) },
			{ "Block", Vector3.new(0.4, 2, 0.4), Vector3.new(1.4, 4.4, 0), Color3.fromRGB(120, 70, 40) },
			{ "Ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-0.6, 4.4, 0.8), Color3.fromRGB(20, 20, 20) },
			{ "Ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0.6, 4.4, 0.8), Color3.fromRGB(20, 20, 20) },
		},
	},
}

function BrainrotData.tierColor(tierName)
	for _, tier in ipairs(BrainrotData.Tiers) do
		if tier.name == tierName then
			return tier.color
		end
	end
	return Color3.fromRGB(255, 255, 255)
end

function BrainrotData.byKey(key)
	for _, char in ipairs(BrainrotData.Characters) do
		if char.key == key then
			return char
		end
	end
	return nil
end

-- Weighted random pick. rushBoost shifts weight toward rarer tiers
-- (used by the Tung Tung Rush event).
function BrainrotData.pickCharacter(rushBoost)
	local total = 0
	local weights = {}
	for _, char in ipairs(BrainrotData.Characters) do
		local w = 1
		for _, tier in ipairs(BrainrotData.Tiers) do
			if tier.name == char.tier then
				w = tier.weight
				break
			end
		end
		if rushBoost and (char.tier == "Legendary" or char.tier == "Mythic"
			or char.tier == "Brainrot God" or char.tier == "Secret") then
			w *= 6
		end
		table.insert(weights, w)
		total += w
	end
	local roll = math.random() * total
	for i, w in ipairs(weights) do
		roll -= w
		if roll <= 0 then
			return BrainrotData.Characters[i]
		end
	end
	return BrainrotData.Characters[1]
end

return BrainrotData
