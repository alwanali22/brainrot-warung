-- Controls: movement on ContextActionService (the default camera scripts eat
-- arrow keys on InputBegan, so binding here is the only path that works).
-- The sink matters: without it the default controller would fight our keys.
-- F slaps a thief, L locks the base, R fires rebirth. E stays free for the
-- buy ProximityPrompt, so it is never bound or sunk here.
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local keys = {}

local function moveDir()
	local d = Vector3.zero
	if keys[Enum.KeyCode.W] or keys[Enum.KeyCode.Up] then
		d += Vector3.new(0, 0, -1)
	end
	if keys[Enum.KeyCode.S] or keys[Enum.KeyCode.Down] then
		d += Vector3.new(0, 0, 1)
	end
	if keys[Enum.KeyCode.A] or keys[Enum.KeyCode.Left] then
		d += Vector3.new(-1, 0, 0)
	end
	if keys[Enum.KeyCode.D] or keys[Enum.KeyCode.Right] then
		d += Vector3.new(1, 0, 0)
	end
	return d
end

local function onMove(_, state, key)
	if state == Enum.UserInputState.Begin then
		keys[key] = true
	elseif state == Enum.UserInputState.End then
		keys[key] = nil
	end
	return Enum.ContextActionResult.Sink
end

local function onSlap(_, state)
	if state == Enum.UserInputState.Begin then
		remotes:WaitForChild("Slap"):FireServer()
	end
end

local function onLock(_, state)
	if state == Enum.UserInputState.Begin then
		remotes:WaitForChild("Lock"):FireServer()
	end
end

local function onRebirth(_, state)
	if state == Enum.UserInputState.Begin then
		remotes:WaitForChild("Rebirth"):FireServer()
	end
end

ContextActionService:BindActionAtPriority("BrainrotMove", onMove, true, Enum.ContextActionPriority.High.Value,
	Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
	Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right)
ContextActionService:BindAction("BrainrotSlap", onSlap, false, Enum.KeyCode.F)
ContextActionService:BindAction("BrainrotLock", onLock, false, Enum.KeyCode.L)
ContextActionService:BindAction("BrainrotRebirth", onRebirth, false, Enum.KeyCode.R)

-- humanoid:Move runs every heartbeat, including Vector3.zero at idle — without
-- the idle call the character keeps walking after the last key is released,
-- because our binding sinks the keys from the default controller.
RunService.Heartbeat:Connect(function()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:Move(moveDir(), true)
	end
end)
