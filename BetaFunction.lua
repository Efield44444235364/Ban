local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- ===== World Check =====
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
else
    warn("[❌] This script only works in Blox Fruits PlaceIds!")
    pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
end)

pcall(function()
    StarterGui:SetCore("EmotesMenuOpen", true)
end)
    return
end

-- ===== Toggle =====
getgenv().InfAbility = true
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
end)

pcall(function()
    StarterGui:SetCore("EmotesMenuOpen", true)
end)

-- ===== Services =====
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ===== Infinite Ability Effect (เร็วขึ้น) =====
local function InfAb(Char)
    local HRP = Char:WaitForChild("HumanoidRootPart",10)
    if not HRP:FindFirstChild("Agility") then
        local inf = Instance.new("ParticleEmitter")
        inf.Name = "Agility"
        inf.Enabled = true
        inf.Rate = 2000        -- ปล่อยอนุภาคมากขึ้น
        inf.Lifetime = NumberRange.new(0,0)
        inf.Speed = NumberRange.new(50,50)   -- เพิ่มความเร็ว
        inf.RotSpeed = NumberRange.new(20000,200000)
        inf.Drag = 10          -- อนุภาคเคลื่อนที่เร็วขึ้น
        inf.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,6)})
        inf.SpreadAngle = Vector2.new(0,0)
        inf.LockedToPart = true
        inf.Parent = HRP
    end
end

-- ===== Character Handler =====
local function OnCharacterAdded(Char)
    Char:WaitForChild("HumanoidRootPart",10)
    if getgenv().InfAbility then
        InfAb(Char)
    end
end

-- ===== Init =====
if LocalPlayer.Character then
    OnCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
