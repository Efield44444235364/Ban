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


-- ===== Long Dash =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- 🧩 Notification function
local Notification = require(ReplicatedStorage:WaitForChild("Notification"))
local function Notify(text, color)
	Notification.new("<Color="..color..">"..text.."<Color=/>"):Display()
end

-- ⚙️ CONFIG Dodge
local DODGE_DISTANCE = 70
local DODGE_TIME = 0.25

-- 🌀 ระบบพุ่ง
local function LoadFullDash()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	local dodgeGroup = player:WaitForChild("PlayerGui")
		:WaitForChild("MobileContextButtons")
		:WaitForChild("ContextButtonFrame")
		:WaitForChild("BoundActionDodge")

	local realButton
	for _, child in ipairs(dodgeGroup:GetDescendants()) do
		if child:IsA("ImageButton") or child:IsA("TextButton") then
			realButton = child
			break
		end
	end

	if not realButton then
		Notify("Script Error", "Red")
		return
	end

	local dodging = false

	local function DodgeDirection()
		if dodging then return end
		dodging = true

		char = player.Character or player.CharacterAdded:Wait()
		hrp = char:WaitForChild("HumanoidRootPart")
		hum = char:WaitForChild("Humanoid")

		local moveDir = hum.MoveDirection
		if moveDir.Magnitude == 0 then
			moveDir = hrp.CFrame.LookVector
		end

		local startTime = tick()
		local endTime = startTime + DODGE_TIME
		local velocity = moveDir.Unit * (DODGE_DISTANCE / DODGE_TIME)

		local connection
		connection = RunService.RenderStepped:Connect(function()
			if tick() >= endTime then
				connection:Disconnect()
				dodging = false
				return
			end
			hrp.AssemblyLinearVelocity = velocity
		end)
	end

	realButton.Activated:Connect(DodgeDirection)
	Notify("Beta Function load", "Green") -- Notification ตัวเดียวตอนเริ่ม
end

-- 🚀 โหลดครั้งแรก
task.spawn(function()
	LoadFullDash()
	-- ตั้งขนาดน้ำตอนเริ่ม
	pcall(function()
		local water = workspace:WaitForChild("Map"):WaitForChild("WaterBase-Plane")
		water.Size = Vector3.new(1000, 112, 1000)
	end)
end)

-- 📡 ตรวจสถานะ Part
local lastExists = true
local charFolder = workspace:FindFirstChild("Characters")

local function CheckCharacterState()
	charFolder = workspace:FindFirstChild("Characters")
	if not charFolder then return end
	local myPart = charFolder:FindFirstChild(player.Name)

	if not myPart and lastExists then
		lastExists = false
		warn("Its gonee!!!")
Notify("Script loading", "White")
	elseif myPart and not lastExists then
		lastExists = true
task.wait(1.8)
		task.spawn(LoadFullDash)
		pcall(function()
			local water = workspace:WaitForChild("Map"):WaitForChild("WaterBase-Plane")
			water.Size = Vector3.new(1000, 112, 1000)
		end)
	end
end

-- 🎧 Event Based ตรวจ Children เปลี่ยน
if charFolder then
	charFolder.ChildAdded:Connect(function(child)
		if child.Name == player.Name then
			CheckCharacterState()
		end
	end)
	charFolder.ChildRemoved:Connect(function(child)
		if child.Name == player.Name then
			CheckCharacterState()
		end
	end)
end

-- ⏱ Backup ตรวจซ้ำทุก 0.25 วิ
task.spawn(function()
	while task.wait(0.2) do
		CheckCharacterState()
	end
end)
