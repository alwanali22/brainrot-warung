-- BrainrotData: the cast of BRAINROT WARUNG. Sixteen named Italian-brainrot
-- characters on a seven-tier rarity ladder; each entry carries price, $/second,
-- colours, and a recipe of primitive parts BrainrotFactory assembles into a
-- 3D model (no unions, no meshes). Part recipe: { shape, size, offset, color }.
-- V = Vector3.new, C = Color3.fromRGB (short aliases keep the dossier small).

local V = Vector3.new
local C = Color3.fromRGB

local BrainrotData = {}

BrainrotData.Tiers = {
	{ name = "Common", color = C(180, 180, 180), weight = 40 },
	{ name = "Rare", color = C(80, 160, 255), weight = 25 },
	{ name = "Epic", color = C(170, 90, 220), weight = 16 },
	{ name = "Legendary", color = C(255, 190, 40), weight = 10 },
	{ name = "Mythic", color = C(255, 80, 120), weight = 5 },
	{ name = "Brainrot God", color = C(255, 60, 60), weight = 3 },
	{ name = "Secret", color = C(40, 230, 180), weight = 1 },
}

-- Character list. Price and income grow roughly x2.2 per step up the ladder,
-- so every tier is a real purchase goal, never a free upgrade.
BrainrotData.Characters = {
	{
		key = "chimpanzini", name = "Chimpanzini Bananini", tier = "Common",
		price = 50, income = 1,
		body = C(120, 80, 40), accent = C(255, 220, 60),
		parts = {
			{ "Block", V(2.4, 2, 2), V(0, 1.6, 0), C(120, 80, 40) },
			{ "Ball", V(1.8, 1.8, 1.8), V(0, 3.2, 0), C(120, 80, 40) },
			{ "Ball", V(2.2, 1.2, 0.6), V(0, 1.2, 1), C(255, 220, 60) },
			{ "Wedge", V(0.6, 1.4, 1.2), V(-1.1, 3.8, 0), C(120, 80, 40) },
			{ "Wedge", V(0.6, 1.4, 1.2), V(1.1, 3.8, 0), C(120, 80, 40) },
		},
	},
	{
		key = "lirili", name = "Lirili Larila", tier = "Common",
		price = 150, income = 3,
		body = C(255, 150, 90), accent = C(255, 240, 200),
		parts = {
			{ "Block", V(2.6, 1.6, 3.4), V(0, 1.5, 0), C(255, 150, 90) },
			{ "Ball", V(1.6, 1.6, 1.6), V(0, 2.8, 1.2), C(255, 240, 200) },
			{ "Wedge", V(0.5, 1.6, 1.8), V(0, 1.6, -2.2), C(255, 100, 60) },
			{ "Block", V(0.4, 1, 1.4), V(-1.5, 2.6, 0.4), C(255, 240, 200) },
			{ "Block", V(0.4, 1, 1.4), V(1.5, 2.6, 0.4), C(255, 240, 200) },
		},
	},
	{
		key = "trippi", name = "Trippi Troppi", tier = "Rare",
		price = 400, income = 7,
		body = C(90, 180, 255), accent = C(255, 130, 170),
		parts = {
			{ "Block", V(2.6, 1.8, 3.2), V(0, 1.5, 0), C(90, 180, 255) },
			{ "Ball", V(1.8, 1.8, 1.8), V(0, 2.9, 1), C(255, 220, 230) },
			{ "Wedge", V(0.5, 1.4, 1.6), V(0, 1.6, -2), C(255, 130, 170) },
			{ "Cylinder", V(0.5, 1.6, 0.5), V(-1.2, 0.4, 1), C(255, 130, 170) },
			{ "Cylinder", V(0.5, 1.6, 0.5), V(1.2, 0.4, 1), C(255, 130, 170) },
		},
	},
	{
		key = "frigo", name = "Frigo Camelo", tier = "Rare",
		price = 900, income = 15,
		body = C(200, 220, 235), accent = C(180, 120, 70),
		parts = {
			{ "Block", V(2.4, 3.4, 1.8), V(0, 2.2, 0), C(200, 220, 235) },
			{ "Ball", V(1.8, 1.4, 1.6), V(0, 4.2, 0.3), C(180, 120, 70) },
			{ "Block", V(2, 0.4, 1.4), V(0, 3.6, 0), C(90, 140, 180) },
			{ "Block", V(0.5, 1.6, 0.5), V(-1, 0.4, 0.8), C(180, 120, 70) },
			{ "Block", V(0.5, 1.6, 0.5), V(1, 0.4, 0.8), C(180, 120, 70) },
		},
	},
	{
		key = "ballerina", name = "Ballerina Cappuccina", tier = "Epic",
		price = 2000, income = 30,
		body = C(255, 210, 230), accent = C(120, 70, 40),
		parts = {
			{ "Cylinder", V(2.6, 0.4, 2.6), V(0, 1.6, 0), C(255, 150, 200) },
			{ "Block", V(1.6, 1.8, 1.2), V(0, 2.6, 0), C(255, 210, 230) },
			{ "Ball", V(1.5, 1.5, 1.5), V(0, 4, 0), C(255, 220, 190) },
			{ "Cylinder", V(1.9, 0.5, 1.9), V(0, 4.7, 0), C(120, 70, 40) },
			{ "Block", V(0.4, 1.8, 0.4), V(-1.1, 2.6, 0), C(255, 220, 190) },
			{ "Block", V(0.4, 1.8, 0.4), V(1.1, 2.6, 0), C(255, 220, 190) },
		},
	},
	{
		key = "cappuccino", name = "Cappuccino Assassino", tier = "Epic",
		price = 3000, income = 45,
		body = C(90, 60, 40), accent = C(240, 230, 210),
		parts = {
			{ "Cylinder", V(2.6, 2.4, 2.6), V(0, 1.7, 0), C(90, 60, 40) },
			{ "Cylinder", V(2.9, 0.4, 2.9), V(0, 3, 0), C(60, 40, 25) },
			{ "Ball", V(1.6, 1.6, 1.6), V(0, 3.8, 0), C(240, 230, 210) },
			{ "Block", V(0.5, 1.4, 0.5), V(-1.3, 2, 0), C(240, 230, 210) },
			{ "Block", V(0.5, 1.4, 0.5), V(1.3, 2, 0), C(240, 230, 210) },
			{ "Wedge", V(0.4, 1.2, 1), V(0, 3.8, -1.2), C(90, 60, 40) },
		},
	},
	{
		key = "boneca", name = "Boneca Ambalabu", tier = "Epic",
		price = 4500, income = 60,
		body = C(255, 120, 160), accent = C(255, 240, 120),
		parts = {
			{ "Ball", V(1.8, 1.8, 1.8), V(0, 3.6, 0), C(255, 220, 190) },
			{ "Block", V(2.2, 2.2, 1.4), V(0, 1.8, 0), C(255, 120, 160) },
			{ "Wedge", V(2.4, 1.6, 2), V(0, 0.8, 0), C(255, 240, 120) },
			{ "Ball", V(0.7, 0.7, 0.7), V(-0.7, 4.6, 0), C(255, 120, 160) },
			{ "Ball", V(0.7, 0.7, 0.7), V(0.7, 4.6, 0), C(255, 120, 160) },
		},
	},
	{
		key = "tralalero", name = "Tralalero Tralala", tier = "Legendary",
		price = 10000, income = 130,
		body = C(60, 140, 255), accent = C(240, 240, 240),
		parts = {
			{ "Block", V(2.4, 2, 4.4), V(0, 1.8, 0), C(60, 140, 255) },
			{ "Block", V(2, 1, 3.6), V(0, 1, 0), C(240, 240, 240) },
			{ "Wedge", V(1.6, 1.8, 0.6), V(0, 3.2, -0.4), C(60, 140, 255) },
			{ "Wedge", V(1.8, 1.4, 0.6), V(0, 1.8, -2.6), C(60, 140, 255) },
			{ "Ball", V(1.2, 1.2, 1.2), V(-0.7, 2.6, 1.8), C(20, 20, 20) },
			{ "Ball", V(1.2, 1.2, 1.2), V(0.7, 2.6, 1.8), C(20, 20, 20) },
		},
	},
	{
		key = "patapim", name = "Brr Brr Patapim", tier = "Legendary",
		price = 16000, income = 190,
		body = C(150, 180, 120), accent = C(220, 180, 120),
		parts = {
			{ "Block", V(2.4, 2, 3), V(0, 1.6, 0), C(150, 180, 120) },
			{ "Ball", V(1.8, 1.8, 1.8), V(0, 3.2, 1), C(220, 180, 120) },
			{ "Cylinder", V(0.7, 1.8, 0.7), V(0, 3.2, 2.2), C(220, 180, 120) },
			{ "Wedge", V(1, 1.4, 1.4), V(0, 1.6, -1.8), C(150, 180, 120) },
			{ "Block", V(0.5, 1.6, 0.5), V(-1.3, 0.6, 0.8), C(150, 180, 120) },
			{ "Block", V(0.5, 1.6, 0.5), V(1.3, 0.6, 0.8), C(150, 180, 120) },
		},
	},
	{
		key = "bombardiro", name = "Bombardiro Crocodilo", tier = "Legendary",
		price = 22000, income = 260,
		body = C(60, 160, 80), accent = C(120, 120, 120),
		parts = {
			{ "Block", V(2.6, 1.8, 4.6), V(0, 1.6, 0), C(60, 160, 80) },
			{ "Block", V(1.8, 1, 1.8), V(0, 1.8, 2.4), C(40, 120, 60) },
			{ "Block", V(0.4, 0.3, 3.4), V(-1.6, 2.6, -0.4), C(120, 120, 120) },
			{ "Block", V(0.4, 0.3, 3.4), V(1.6, 2.6, -0.4), C(120, 120, 120) },
			{ "Wedge", V(1.6, 1.2, 0.6), V(0, 1.6, -2.6), C(40, 120, 60) },
			{ "Cylinder", V(0.4, 1.2, 0.4), V(-1, 0.4, 1.4), C(40, 120, 60) },
			{ "Cylinder", V(0.4, 1.2, 0.4), V(1, 0.4, 1.4), C(40, 120, 60) },
		},
	},
	{
		key = "giraffa", name = "Giraffa Celeste", tier = "Mythic",
		price = 50000, income = 550,
		body = C(255, 220, 130), accent = C(140, 200, 255),
		parts = {
			{ "Block", V(2.4, 2, 3), V(0, 1.6, 0), C(255, 220, 130) },
			{ "Block", V(1, 2.6, 1), V(0, 3.8, 1.2), C(255, 220, 130) },
			{ "Block", V(1.6, 1.2, 1.6), V(0, 5.6, 1.2), C(255, 220, 130) },
			{ "Wedge", V(0.5, 1.2, 1), V(-0.7, 6.4, 1.2), C(255, 190, 90) },
			{ "Wedge", V(0.5, 1.2, 1), V(0.7, 6.4, 1.2), C(255, 190, 90) },
			{ "Block", V(2.8, 0.4, 1), V(0, 6.4, 1.2), C(140, 200, 255) },
		},
	},
	{
		key = "frulli", name = "Frulli Frulla", tier = "Mythic",
		price = 75000, income = 800,
		body = C(180, 200, 220), accent = C(255, 100, 150),
		parts = {
			{ "Cylinder", V(2.6, 2.6, 2.6), V(0, 1.8, 0), C(180, 200, 220) },
			{ "Cylinder", V(2.9, 0.5, 2.9), V(0, 3.3, 0), C(255, 100, 150) },
			{ "Ball", V(1.5, 1.5, 1.5), V(0, 4.2, 0), C(180, 200, 220) },
			{ "Block", V(2.8, 0.6, 1), V(0, 0.5, 0), C(255, 100, 150) },
			{ "Wedge", V(1, 1.6, 0.6), V(-1.2, 3.6, 0), C(180, 200, 220) },
			{ "Wedge", V(1, 1.6, 0.6), V(1.2, 3.6, 0), C(180, 200, 220) },
		},
	},
	{
		key = "vaca", name = "La Vaca Saturno Saturnita", tier = "Mythic",
		price = 110000, income = 1100,
		body = C(240, 240, 240), accent = C(255, 200, 60),
		parts = {
			{ "Block", V(2.8, 2.2, 3.4), V(0, 1.7, 0), C(240, 240, 240) },
			{ "Ball", V(1.8, 1.8, 1.8), V(0, 3.4, 1.2), C(240, 240, 240) },
			{ "Cylinder", V(3.6, 0.3, 3.6), V(0, 3.4, 0), C(255, 200, 60) },
			{ "Ball", V(0.9, 0.9, 0.9), V(0, 3.4, 3.2), C(255, 150, 200) },
			{ "Wedge", V(0.5, 1.2, 0.8), V(-0.9, 4.4, 1.2), C(255, 200, 60) },
			{ "Wedge", V(0.5, 1.2, 0.8), V(0.9, 4.4, 1.2), C(255, 200, 60) },
		},
	},
	{
		key = "pot", name = "Pot Hotspot", tier = "Brainrot God",
		price = 250000, income = 2400,
		body = C(220, 90, 60), accent = C(255, 220, 80),
		parts = {
			{ "Cylinder", V(2.6, 2.4, 2.6), V(0, 1.7, 0), C(220, 90, 60) },
			{ "Cylinder", V(2.9, 0.4, 2.9), V(0, 3, 0), C(90, 90, 90) },
			{ "Ball", V(1.6, 1.2, 1.6), V(0, 3.6, 0), C(255, 220, 80) },
			{ "Block", V(0.5, 1.4, 0.5), V(-1, 3.4, 0), C(255, 220, 80) },
			{ "Block", V(0.5, 1.4, 0.5), V(1, 3.4, 0), C(255, 220, 80) },
			{ "Ball", V(0.8, 0.8, 0.8), V(-0.6, 2.2, 1.3), C(20, 20, 20) },
			{ "Ball", V(0.8, 0.8, 0.8), V(0.6, 2.2, 1.3), C(20, 20, 20) },
		},
	},
	{
		key = "sahur", name = "Tung Tung Tung Sahur", tier = "Secret",
		price = 600000, income = 6000,
		body = C(150, 100, 60), accent = C(255, 240, 200),
		parts = {
			{ "Cylinder", V(2.8, 2.6, 2.8), V(0, 1.8, 0), C(150, 100, 60) },
			{ "Cylinder", V(3, 0.4, 3), V(0, 3.2, 0), C(255, 240, 200) },
			{ "Cylinder", V(3, 0.4, 3), V(0, 0.5, 0), C(255, 240, 200) },
			{ "Ball", V(1.7, 1.7, 1.7), V(0, 4.2, 0), C(255, 240, 200) },
			{ "Block", V(0.4, 2, 0.4), V(-1.4, 4.4, 0), C(120, 70, 40) },
			{ "Block", V(0.4, 2, 0.4), V(1.4, 4.4, 0), C(120, 70, 40) },
			{ "Ball", V(0.6, 0.6, 0.6), V(-0.6, 4.4, 0.8), C(20, 20, 20) },
			{ "Ball", V(0.6, 0.6, 0.6), V(0.6, 4.4, 0.8), C(20, 20, 20) },
		},
	},
	{
		key = "glorbo", name = "Glorbo Fruttodrillo", tier = "Secret",
		price = 900000, income = 9000,
		body = C(80, 200, 90), accent = C(255, 220, 80),
		parts = {
			{ "Block", V(2.6, 1.8, 4.6), V(0, 1.6, 0), C(80, 200, 90) },
			{ "Block", V(1.8, 1, 1.8), V(0, 1.8, 2.4), C(40, 140, 60) },
			{ "Ball", V(1.4, 1.4, 1.4), V(0, 3, 1.6), C(255, 220, 80) },
			{ "Wedge", V(1.6, 1.2, 0.6), V(0, 1.6, -2.6), C(40, 140, 60) },
			{ "Cylinder", V(0.4, 1.2, 0.4), V(-1, 0.4, 1.4), C(40, 140, 60) },
			{ "Cylinder", V(0.4, 1.2, 0.4), V(1, 0.4, 1.4), C(40, 140, 60) },
			{ "Ball", V(0.7, 0.7, 0.7), V(-0.6, 2.6, 2.6), C(20, 20, 20) },
			{ "Ball", V(0.7, 0.7, 0.7), V(0.6, 2.6, 2.6), C(20, 20, 20) },
		},
	},
}

function BrainrotData.tierColor(tierName)
	for _, tier in ipairs(BrainrotData.Tiers) do
		if tier.name == tierName then
			return tier.color
		end
	end
	return C(255, 255, 255)
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
