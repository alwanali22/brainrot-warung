-- BrainrotFactory: builds a brainrot's 3D model from primitive Parts only
-- (Block, Ball, Wedge, Cylinder) plus a BillboardGui label with its name,
-- rarity and money per second. No unions, meshes or SurfaceAppearance, so
-- the place can be published through Roblox Open Cloud. Every part is
-- Anchored: the server moves models by setting CFrame, never by physics.

local BrainrotData = require(game:GetService("ReplicatedStorage").Shared.BrainrotData)

local Factory = {}

local SHAPES = {
	Block = Enum.PartType.Block,
	Ball = Enum.PartType.Ball,
	Wedge = Enum.PartType.Wedge,
	Cylinder = Enum.PartType.Cylinder,
}

-- Build one character model at `position`, facing +Z (down the conveyor).
-- Returns the Model; its PrimaryPart is the first recipe part.
function Factory.buildCharacter(char, position)
	local model = Instance.new("Model")
	model.Name = char.name

	local primary = nil
	for _, spec in ipairs(char.parts) do
		local shapeName, size, offset, color = spec[1], spec[2], spec[3], spec[4]
		local part = Instance.new("Part")
		part.Shape = SHAPES[shapeName] or Enum.PartType.Block
		part.Size = size
		part.CFrame = CFrame.new(position + offset)
		part.Color = color
		part.Material = Enum.Material.SmoothPlastic
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = true
		part.Name = shapeName
		part.Parent = model
		if not primary then
			primary = part
		end
	end
	model.PrimaryPart = primary

	-- The readable label: name, rarity (in the tier colour), $/second.
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "BrainrotLabel"
	billboard.Size = UDim2.fromOffset(220, 90)
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 5.2, 0)
	billboard.AlwaysOnTop = false
	billboard.Parent = model

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = char.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextStrokeTransparency = 0.2
	nameLabel.Parent = billboard

	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Name = "Rarity"
	rarityLabel.Size = UDim2.new(1, 0, 0.3, 0)
	rarityLabel.Position = UDim2.new(0, 0, 0.4, 0)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.Text = char.tier
	rarityLabel.TextColor3 = BrainrotData.tierColor(char.tier)
	rarityLabel.TextScaled = true
	rarityLabel.Font = Enum.Font.GothamBold
	rarityLabel.TextStrokeTransparency = 0.2
	rarityLabel.Parent = billboard

	local incomeLabel = Instance.new("TextLabel")
	incomeLabel.Name = "Income"
	incomeLabel.Size = UDim2.new(1, 0, 0.3, 0)
	incomeLabel.Position = UDim2.new(0, 0, 0.7, 0)
	incomeLabel.BackgroundTransparency = 1
	incomeLabel.Text = "$" .. tostring(char.income) .. "/dtk"
	incomeLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
	incomeLabel.TextScaled = true
	incomeLabel.Font = Enum.Font.GothamBold
	incomeLabel.TextStrokeTransparency = 0.2
	incomeLabel.Parent = billboard

	return model
end

-- A buy prompt on the model's PrimaryPart. Fires Conveyor.buyFromPrompt.
function Factory.attachBuyPrompt(model, itemId, price)
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "BuyPrompt"
	prompt.ActionText = "BELI $" .. tostring(price)
	prompt.ObjectText = model.Name
	prompt.HoldDuration = 0
	prompt.RequiresLineOfSight = false
	prompt.MaxActivationDistance = 14
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt:SetAttribute("ItemId", itemId)
	prompt.Parent = model.PrimaryPart
	return prompt
end

-- Move a whole model so its PrimaryPart sits at `position`.
function Factory.moveModel(model, position)
	local primary = model.PrimaryPart
	if not primary then
		return
	end
	local delta = position - primary.Position
	model:PivotTo(model:GetPivot() + delta)
end

return Factory
