-- BrainrotFactory: turns a BrainrotData row into a 3D Model with a readable
-- name / rarity / $-per-second label (name on top, rarity or mutation badge
-- in the middle, income below), plus the buy prompt on the belt.
local Shared = game:GetService("ReplicatedStorage").Shared
local BrainrotData = require(Shared.BrainrotData)
local Mutations = require(Shared.Mutations)

local Factory = {}

local function makeLabel(parent, text, color, y)
	local l = Instance.new("TextLabel")
	l.Text = text
	l.Size = UDim2.new(1, 0, 0, 20)
	l.Position = UDim2.new(0, 0, 0, y)
	l.BackgroundTransparency = 1
	l.TextColor3 = color
	l.TextScaled = true
	l.Font = Enum.Font.GothamBold
	l.TextStrokeTransparency = 0.4
	l.Parent = parent
	return l
end

function Factory.buildCharacter(char, position, mutation)
	local model = Instance.new("Model")
	model.Name = char.name
	local primary = nil
	for _, spec in ipairs(char.parts) do
		local p = Instance.new("Part")
		p.Shape = Enum.PartType[spec[1]]
		p.Size = spec[2]
		p.CFrame = CFrame.new(position + spec[3])
		p.Color = spec[4]
		p.Anchored = true
		p.CanCollide = false
		p.Parent = model
		primary = primary or p
	end
	model.PrimaryPart = primary

	local rarityText = char.tier
	local rarityColor = BrainrotData.tierColor(char.tier)
	local income = char.income
	local m = mutation and Mutations.byName(mutation)
	if m then
		rarityText = char.tier .. " " .. Mutations.tagText(mutation)
		rarityColor = m.color
		income = Mutations.mutatedIncome(char, mutation)
	end

	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.new(0, 200, 0, 60)
	gui.StudsOffset = Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.Parent = model
	makeLabel(gui, char.name, Color3.fromRGB(255, 255, 255), 0)
	makeLabel(gui, rarityText, rarityColor, 20)
	makeLabel(gui, "$" .. tostring(income) .. "/dtk", Color3.fromRGB(120, 255, 120), 40)

	model:SetAttribute("CharKey", char.key)
	return model
end

function Factory.attachBuyPrompt(model, id, price)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Beli"
	prompt.ObjectText = "$" .. tostring(price)
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 8
	prompt.Parent = model.PrimaryPart
	return prompt
end

return Factory
