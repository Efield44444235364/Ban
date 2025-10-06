local StarterGui = game:GetService("StarterGui")

-- ===== World Check =====
local World1, World2, World3, Celebrity = false, false, false, false

if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
elseif game.PlaceId == 95165932064349 then 
    Celebrity= true
else
    warn("[❌] This script only works in Blox Fruits PlaceIds!")
    return
end

-- ===== Toggle Emotes =====
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
    StarterGui:SetCore("EmotesMenuOpen", true)
end)

--[[

-- ===== Long Dash =====
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- หา UI ปุ่ม Dodge เดิม
local dodgeGroup = player:WaitForChild("PlayerGui")
	:WaitForChild("MobileContextButtons")
	:WaitForChild("ContextButtonFrame")
	:WaitForChild("BoundActionDodge")

-- หาปุ่มจริงข้างใน
local realButton
for _, child in ipairs(dodgeGroup:GetDescendants()) do
	if child:IsA("ImageButton") or child:IsA("TextButton") then
		realButton = child
		break
	end
end

if not realButton then
	warn("❌ ไม่เจอปุ่มจริงใน BoundActionDodge")
	return
end

-- ⚙️ CONFIG
local DODGE_DISTANCE = 100
local DODGE_TIME = 0.25
local DODGE_COOLDOWN = 0
local dodging = false

local function DodgeDirection()
	if dodging then return end
	dodging = true

	char = player.Character or player.CharacterAdded:Wait()
	hrp = char:WaitForChild("HumanoidRootPart")
	hum = char:WaitForChild("Humanoid")

	-- ใช้ MoveDirection ของ Humanoid แทน LookVector
	local moveDir = hum.MoveDirection
	if moveDir.Magnitude == 0 then
		-- ถ้าไม่ได้กดเดิน พุ่งไปข้างหน้า default
		moveDir = hrp.CFrame.LookVector
	end

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e6, 0, 1e6)
	bv.Velocity = moveDir.Unit * (DODGE_DISTANCE / DODGE_TIME)
	bv.P = 1250
	bv.Parent = hrp

	task.wait(DODGE_TIME)
	bv:Destroy()

	task.wait(DODGE_COOLDOWN)
	dodging = false
end

-- 🟢 เชื่อมปุ่ม
realButton.Activated:Connect(DodgeDirection)
]]

print("Long Dash Haven't access on your account")
