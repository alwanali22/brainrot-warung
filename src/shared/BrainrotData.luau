-- BrainrotData: the cast. 16 Italian-brainrot characters on 7 rarity tiers,
-- each built 3D from primitive Parts. One row = one model: key, name, tier,
-- price, income per second, body/accent colours, and 6–8 Parts.
-- A part is { shape, size, offset, colour }: shape Block/Ball/Wedge/Cylinder.
local V = Vector3.new
local C = Color3.fromRGB

local BrainrotData = {}

BrainrotData.Tiers = {
	{ name = "Common", color = C(180, 180, 180), weight = 0.40 },
	{ name = "Rare", color = C(80, 180, 255), weight = 0.25 },
	{ name = "Epic", color = C(180, 90, 255), weight = 0.15 },
	{ name = "Legendary", color = C(255, 190, 40), weight = 0.10 },
	{ name = "Mythic", color = C(255, 80, 140), weight = 0.06 },
	{ name = "Brainrot God", color = C(255, 70, 50), weight = 0.03 },
	{ name = "Secret", color = C(90, 230, 180), weight = 0.01 },
}

BrainrotData.Characters = {
	{ key = "chimpanzini", name = "Chimpanzini Bananini", tier = "Common", price = 50, income = 1,
		body = C(120, 85, 50), accent = C(255, 220, 90), parts = {
			{ "Block", V(2.2, 1.8, 1.6), V(0, 1.4, 0), C(120, 85, 50) },
			{ "Ball", V(1.6, 1.6, 1.6), V(0, 2.9, 0), C(120, 85, 50) },
			{ "Wedge", V(0.5, 1.8, 0.5), V(0.9, 3.4, 0), C(255, 220, 90) },
			{ "Block", V(0.5, 1.2, 0.5), V(-1.3, 1.4, 0), C(120, 85, 50) },
			{ "Block", V(0.5, 1.2, 0.5), V(1.3, 1.4, 0), C(120, 85, 50) },
			{ "Ball", V(0.4, 0.4, 0.4), V(-0.5, 3.1, 0.8), C(20, 20, 20) },
			{ "Ball", V(0.4, 0.4, 0.4), V(0.5, 3.1, 0.8), C(20, 20, 20) },
		} },
	{ key = "lirili", name = "Lirili Larila", tier = "Common", price = 150, income = 3,
		body = C(220, 190, 140), accent = C(90, 160, 220), parts = {
			{ "Cylinder", V(2, 2.2, 2), V(0, 1.6, 0), C(220, 190, 140) },
			{ "Ball", V(1.4, 1.4, 1.4), V(0, 3.1, 0), C(220, 190, 140) },
			{ "Wedge", V(0.8, 1.2, 1.2), V(0, 3.1, -1), C(90, 160, 220) },
			{ "Block", V(0.4, 1, 0.4), V(-1.2, 1.4, 0), C(220, 190, 140) },
			{ "Block", V(0.4, 1, 0.4), V(1.2, 1.4, 0), C(220, 190, 140) },
			{ "Ball", V(0.5, 0.5, 0.5), V(0, 3.6, 0.7), C(90, 160, 220) },
		} },
	{ key = "trippi", name = "Trippi Troppi", tier = "Rare", price = 400, income = 7,
		body = C(90, 140, 200), accent = C(255, 240, 200), parts = {
			{ "Block", V(2.4, 1.6, 2.8), V(0, 1.3, 0), C(90, 140, 200) },
			{ "Ball", V(1.5, 1.5, 1.5), V(0, 2.8, 0.6), C(90, 140, 200) },
			{ "Cylinder", V(0.5, 1.6, 0.5), V(0, 2.8, 1.8), C(255, 240, 200) },
			{ "Wedge", V(1, 1.4, 0.8), V(-0.9, 3.4, 0), C(255, 240, 200) },
			{ "Wedge", V(1, 1.4, 0.8), V(0.9, 3.4, 0), C(255, 240, 200) },
			{ "Block", V(0.5, 1, 0.5), V(-1.2, 0.5, 0.9), C(90, 140, 200) },
		} },
	{ key = "frigo", name = "Frigo Camelo", tier = "Rare", price = 900, income = 15,
		body = C(140, 200, 240), accent = C(255, 255, 255), parts = {
			{ "Block", V(2.2, 2.4, 2.2), V(0, 1.7, 0), C(140, 200, 240) },
			{ "Ball", V(1.3, 1.3, 1.3), V(0, 3.4, 0), C(140, 200, 240) },
			{ "Block", V(1.2, 0.8, 1.6), V(0, 3.4, 1.2), C(255, 255, 255) },
			{ "Wedge", V(0.6, 1, 0.6), V(-0.8, 4.2, 0), C(255, 255, 255) },
			{ "Wedge", V(0.6, 1, 0.6), V(0.8, 4.2, 0), C(255, 255, 255) },
			{ "Block", V(0.5, 1.4, 0.5), V(0, 1.2, -1.2), C(140, 200, 240) },
		} },
	{ key = "ballerina", name = "Ballerina Cappuccina", tier = "Epic", price = 2000, income = 30,
		body = C(255, 180, 210), accent = C(255, 255, 255), parts = {
			{ "Cylinder", V(1.6, 2, 1.6), V(0, 1.5, 0), C(255, 180, 210) },
			{ "Cylinder", V(2.6, 0.3, 2.6), V(0, 1.2, 0), C(255, 255, 255) },
			{ "Ball", V(1.3, 1.3, 1.3), V(0, 3, 0), C(255, 180, 210) },
			{ "Block", V(0.4, 1.2, 0.4), V(-1, 1.8, 0), C(255, 180, 210) },
			{ "Block", V(0.4, 1.2, 0.4), V(1, 1.8, 0), C(255, 180, 210) },
			{ "Ball", V(0.6, 0.6, 0.6), V(0, 3.9, 0), C(255, 255, 255) },
		} },
	{ key = "cappuccino", name = "Cappuccino Assassino", tier = "Epic", price = 3000, income = 45,
		body = C(90, 60, 40), accent = C(240, 230, 210), parts = {
			{ "Cylinder", V(2.6, 2.4, 2.6), V(0, 1.7, 0), C(90, 60, 40) },
			{ "Cylinder", V(2.9, 0.4, 2.9), V(0, 3, 0), C(60, 40, 25) },
			{ "Ball", V(1.6, 1.6, 1.6), V(0, 3.8, 0), C(240, 230, 210) },
			{ "Block", V(0.5, 1.4, 0.5), V(-1.3, 2, 0), C(240, 230, 210) },
			{ "Block", V(0.5, 1.4, 0.5), V(1.3, 2, 0), C(240, 230, 210) },
			{ "Wedge", V(0.4, 1.2, 1), V(0, 3.8, -1.2), C(90, 60, 40) },
		} },
	{ key = "boneca", name = "Boneca Ambalabu", tier = "Epic", price = 4500, income = 60,
		body = C(200, 120, 160), accent = C(255, 220, 150), parts = {
			{ "Block", V(2, 2.2, 1.8), V(0, 1.6, 0), C(200, 120, 160) },
			{ "Ball", V(1.5, 1.5, 1.5), V(0, 3.2, 0), C(200, 120, 160) },
			{ "Cylinder", V(0.4, 1.8, 0.4), V(-1.2, 2.4, 0), C(255, 220, 150) },
			{ "Cylinder", V(0.4, 1.8, 0.4), V(1.2, 2.4, 0), C(255, 220, 150) },
			{ "Wedge", V(1.2, 1, 1), V(0, 3.2, -1.1), C(255, 220, 150) },
			{ "Ball", V(0.7, 0.7, 0.7), V(0, 4.2, 0), C(255, 220, 150) },
		} },
	{ key = "tralalero", name = "Tralalero Tralala", tier = "Legendary", price = 10000, income = 130,
		body = C(90, 130, 180), accent = C(240, 240, 240), parts = {
			{ "Block", V(2, 1.6, 4.4), V(0, 1.4, 0), C(90, 130, 180) },
			{ "Wedge", V(1.4, 1.2, 1.2), V(0, 1.4, 2.6), C(90, 130, 180) },
			{ "Wedge", V(1, 1.6, 0.6), V(0, 2.6, 0), C(240, 240, 240) },
			{ "Ball", V(1.2, 1.2, 1.2), V(0, 2.4, 1.6), C(90, 130, 180) },
			{ "Block", V(0.8, 0.5, 1), V(0, 2, 2.4), C(240, 240, 240) },
			{ "Block", V(0.4, 1, 0.4), V(-1.1, 0.5, 0), C(90, 130, 180) },
		} },
	{ key = "patapim", name = "Brr Brr Patapim", tier = "Legendary", price = 16000, income = 190,
		body = C(150, 180, 120), accent = C(220, 180, 120), parts = {
			{ "Block", V(2.4, 2, 3), V(0, 1.6, 0), C(150, 180, 120) },
			{ "Ball", V(1.8, 1.8, 1.8), V(0, 3.2, 1), C(220, 180, 120) },
			{ "Cylinder", V(0.7, 1.8, 0.7), V(0, 3.2, 2.2), C(220, 180, 120) },
			{ "Wedge", V(1, 1.4, 1.4), V(0, 1.6, -1.8), C(150, 180, 120) },
			{ "Block", V(0.5, 1.6, 0.5), V(-1.3, 0.6, 0.8), C(150, 180, 120) },
			{ "Block", V(0.5, 1.6, 0.5), V(1.3, 0.6, 0.8), C(150, 180, 120) },
		} },
	{ key = "bombardiro", name = "Bombardiro Crocodilo", tier = "Legendary", price = 22000, income = 260,
		body = C(110, 140, 110), accent = C(255, 150, 60), parts = {
			{ "Block", V(2.4, 1.6, 4.2), V(0, 1.3, 0), C(110, 140, 110) },
			{ "Block", V(1.6, 0.9, 1.6), V(0, 1.3, 2.4), C(110, 140, 110) },
			{ "Wedge", V(1.2, 1, 1), V(0, 1.3, -2.4), C(110, 140, 110) },
			{ "Block", V(2.6, 0.4, 1.2), V(-1.4, 2.4, 0), C(255, 150, 60) },
			{ "Block", V(2.6, 0.4, 1.2), V(1.4, 2.4, 0), C(255, 150, 60) },
			{ "Ball", V(0.6, 0.6, 0.6), V(-0.5, 2.2, 2.8), C(20, 20, 20) },
		} },
	{ key = "giraffa", name = "Giraffa Celeste", tier = "Mythic", price = 50000, income = 550,
		body = C(240, 200, 90), accent = C(140, 90, 50), parts = {
			{ "Cylinder", V(1.8, 2, 1.8), V(0, 1.5, 0), C(240, 200, 90) },
			{ "Cylinder", V(0.7, 2.6, 0.7), V(0, 3.4, 0), C(240, 200, 90) },
			{ "Ball", V(1.2, 1.2, 1.2), V(0, 5, 0.4), C(240, 200, 90) },
			{ "Block", V(0.5, 1, 0.5), V(-0.9, 0.5, 0.5), C(140, 90, 50) },
			{ "Block", V(0.5, 1, 0.5), V(0.9, 0.5, 0.5), C(140, 90, 50) },
			{ "Wedge", V(0.8, 1, 0.8), V(0, 5, 1.2), C(140, 90, 50) },
		} },
	{ key = "frulli", name = "Frulli Frulla", tier = "Mythic", price = 75000, income = 800,
		body = C(180, 200, 220), accent = C(255, 100, 150), parts = {
			{ "Cylinder", V(2.6, 2.6, 2.6), V(0, 1.8, 0), C(180, 200, 220) },
			{ "Cylinder", V(2.9, 0.5, 2.9), V(0, 3.3, 0), C(255, 100, 150) },
			{ "Ball", V(1.5, 1.5, 1.5), V(0, 4.2, 0), C(180, 200, 220) },
			{ "Block", V(2.8, 0.6, 1), V(0, 0.5, 0), C(255, 100, 150) },
			{ "Wedge", V(1, 1.6, 0.6), V(-1.2, 3.6, 0), C(180, 200, 220) },
			{ "Wedge", V(1, 1.6, 0.6), V(1.2, 3.6, 0), C(180, 200, 220) },
		} },
	{ key = "lavaca", name = "La Vaca Saturno Saturnita", tier = "Mythic", price = 110000, income = 1100,
		body = C(240, 240, 240), accent = C(200, 160, 90), parts = {
			{ "Block", V(2.4, 1.8, 3), V(0, 1.4, 0), C(240, 240, 240) },
			{ "Ball", V(1.4, 1.4, 1.4), V(0, 2.8, 1), C(240, 240, 240) },
			{ "Cylinder", V(3.4, 0.3, 3.4), V(0, 1.4, 0), C(200, 160, 90) },
			{ "Wedge", V(0.7, 1.1, 0.7), V(-0.8, 3.6, 1), C(240, 240, 240) },
			{ "Wedge", V(0.7, 1.1, 0.7), V(0.8, 3.6, 1), C(240, 240, 240) },
			{ "Block", V(0.5, 1, 0.5), V(-1, 0.5, 1), C(200, 160, 90) },
		} },
	{ key = "pothotspot", name = "Pot Hotspot", tier = "Brainrot God", price = 250000, income = 2400,
		body = C(200, 60, 50), accent = C(255, 150, 50), parts = {
			{ "Cylinder", V(2.2, 2.4, 2.2), V(0, 1.7, 0), C(200, 60, 50) },
			{ "Cylinder", V(2.5, 0.5, 2.5), V(0, 3, 0), C(255, 150, 50) },
			{ "Ball", V(1.4, 1.4, 1.4), V(0, 3.8, 0), C(255, 150, 50) },
			{ "Ball", V(0.9, 0.9, 0.9), V(0, 4.4, 0), C(255, 220, 90) },
			{ "Block", V(0.5, 1.2, 0.5), V(-1.2, 0.6, 0), C(200, 60, 50) },
			{ "Block", V(0.5, 1.2, 0.5), V(1.2, 0.6, 0), C(200, 60, 50) },
		} },
	{ key = "tungtung", name = "Tung Tung Tung Sahur", tier = "Secret", price = 600000, income = 6000,
		body = C(140, 95, 55), accent = C(230, 200, 150), parts = {
			{ "Block", V(1.6, 3, 1.6), V(0, 2, 0), C(140, 95, 55) },
			{ "Ball", V(1.2, 1.2, 1.2), V(0, 3.9, 0), C(140, 95, 55) },
			{ "Block", V(0.5, 1.6, 0.5), V(-1.1, 2.4, 0.3), C(230, 200, 150) },
			{ "Block", V(2, 0.4, 0.4), V(1.4, 2.8, 0), C(230, 200, 150) },
			{ "Ball", V(0.4, 0.4, 0.4), V(-0.4, 4.1, 0.6), C(20, 20, 20) },
			{ "Ball", V(0.4, 0.4, 0.4), V(0.4, 4.1, 0.6), C(20, 20, 20) },
		} },
	{ key = "glorbo", name = "Glorbo Fruttodrillo", tier = "Secret", price = 900000, income = 9000,
		body = C(80, 200, 90), accent = C(255, 220, 80), parts = {
			{ "Block", V(2.6, 1.8, 4.6), V(0, 1.6, 0), C(80, 200, 90) },
			{ "Block", V(1.8, 1, 1.8), V(0, 1.8, 2.4), C(40, 140, 60) },
			{ "Ball", V(1.4, 1.4, 1.4), V(0, 3, 1.6), C(255, 220, 80) },
			{ "Wedge", V(1.6, 1.2, 0.6), V(0, 1.6, -2.6), C(40, 140, 60) },
			{ "Cylinder", V(0.4, 1.2, 0.4), V(-1, 0.4, 1.4), C(40, 140, 60) },
			{ "Cylinder", V(0.4, 1.2, 0.4), V(1, 0.4, 1.4), C(40, 140, 60) },
			{ "Ball", V(0.7, 0.7, 0.7), V(-0.6, 2.6, 2.6), C(20, 20, 20) },
			{ "Ball", V(0.7, 0.7, 0.7), V(0.6, 2.6, 2.6), C(20, 20, 20) },
		} },
}

-- Tier colour for labels, by tier name.
function BrainrotData.tierColor(tier)
	for _, t in ipairs(BrainrotData.Tiers) do
		if t.name == tier then
			return t.color
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

-- Weighted pick. rareOnly (Tung Tung Rush) draws from Legendary and up only.
-- Weights come from the tier table, so a tier rebalance needs one edit.
function BrainrotData.pickCharacter(rareOnly)
	local pool = {}
	for _, char in ipairs(BrainrotData.Characters) do
		local tierIndex = 0
		for i, t in ipairs(BrainrotData.Tiers) do
			if t.name == char.tier then
				tierIndex = i
			end
		end
		if not rareOnly or tierIndex >= 4 then
			table.insert(pool, char)
		end
	end
	local total = 0
	for _, char in ipairs(pool) do
		for _, t in ipairs(BrainrotData.Tiers) do
			if t.name == char.tier then
				total += t.weight
			end
		end
	end
	local roll = math.random() * total
	for _, char in ipairs(pool) do
		for _, t in ipairs(BrainrotData.Tiers) do
			if t.name == char.tier then
				roll -= t.weight
				if roll <= 0 then
					return char
				end
			end
		end
	end
	return pool[#pool]
end

return BrainrotData
