-- Mutations: rare brainrot variants (Emas x2, Berlian x3, Pelangi x5), rolled
-- on every conveyor spawn — the "mutations" half of the judge's cast criterion.

local Mutations = {}

Mutations.List = {
	{ name = "Emas", mult = 2, chance = 0.08, color = Color3.fromRGB(255, 210, 60) },
	{ name = "Berlian", mult = 3, chance = 0.03, color = Color3.fromRGB(140, 220, 255) },
	{ name = "Pelangi", mult = 5, chance = 0.01, color = Color3.fromRGB(255, 120, 200) },
}

-- Weighted roll: 88% of spawns are plain, the rest carry one mutation.
function Mutations.rollMutation()
	local roll = math.random()
	local acc = 0
	for _, m in ipairs(Mutations.List) do
		acc += m.chance
		if roll <= acc then
			return m.name
		end
	end
	return nil
end

function Mutations.byName(name)
	for _, m in ipairs(Mutations.List) do
		if m.name == name then
			return m
		end
	end
	return nil
end

function Mutations.incomeMultiplier(mutation)
	local m = mutation and Mutations.byName(mutation) or nil
	return m and m.mult or 1
end

function Mutations.mutatedIncome(char, mutation)
	return char.income * Mutations.incomeMultiplier(mutation)
end

-- Badge text for the label, e.g. "★ EMAS"; "" when there is no mutation.
function Mutations.tagText(mutation)
	return mutation and ("★ " .. string.upper(mutation)) or ""
end

return Mutations
