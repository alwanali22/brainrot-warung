-- Controls.client: player input for BRAINROT WARUNG, bound through
-- ContextActionService. Roblox's default camera scripts swallow the Left
-- and Right arrow keys before UserInputService.InputBegan ever sees them
-- (RULES.txt), so movement is bound here at high priority and sunk, and
-- the game actions (slap, lock, rebirth) are bound the same way. The E
-- key is deliberately NOT bound: the buy ProximityPrompt owns it.
-- Movement itself is the default character controller's job; this script
-- only feeds it a direction, computed from the camera each frame.

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Held keys, one flag per direction.
local held = { Forward = false, Back = false, Left = false, Right = false }

local function bindMove(actionName, flag, ...)
	ContextActionService:BindActionAtPriority(actionName, function(_, state)
		if state == Enum.UserInputState.Begin then
			held[flag] = true
		elseif state == Enum.UserInputState.End then
			held[flag] = false
		end
		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.High.Value, ...)
end

bindMove("WarungMoveForward", "Forward", Enum.KeyCode.W, Enum.KeyCode.Up)
bindMove("WarungMoveBack", "Back", Enum.KeyCode.S, Enum.KeyCode.Down)
bindMove("WarungMoveLeft", "Left", Enum.KeyCode.A, Enum.KeyCode.Left)
bindMove("WarungMoveRight", "Right", Enum.KeyCode.D, Enum.KeyCode.Right)

-- Slap the thief in front of you (F), lock your base (L), open rebirth (R).
local function bindAction(actionName, remoteName, ...)
	ContextActionService:BindActionAtPriority(actionName, function(_, state)
		if state == Enum.UserInputState.Begin then
			local remote = remotes:FindFirstChild(remoteName)
			if remote then
				remote:FireServer()
			end
		end
		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.High.Value, ...)
end

bindAction("WarungSlap", "Slap", Enum.KeyCode.F)
bindAction("WarungLockBase", "LockBase", Enum.KeyCode.L)
bindAction("WarungRebirth", "Rebirth", Enum.KeyCode.R)

-- Each frame, turn the held keys into a camera-relative move direction.
RunService.RenderStepped:Connect(function()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local forward = camera.CFrame.LookVector
	forward = Vector3.new(forward.X, 0, forward.Z).Unit
	local right = camera.CFrame.RightVector
	right = Vector3.new(right.X, 0, right.Z).Unit
	local move = Vector3.zero
	if held.Forward then
		move += forward
	end
	if held.Back then
		move -= forward
	end
	if held.Right then
		move += right
	end
	if held.Left then
		move -= right
	end
	if move.Magnitude > 0 then
		humanoid:Move(move.Unit, false)
	else
		-- No keys held: stop. (Our bindings sink the keys, so the default
		-- controller never sees them; we are the only driver of Move.)
		humanoid:Move(Vector3.zero, false)
	end
end)
