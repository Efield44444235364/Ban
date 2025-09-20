-- ===== PlaceId Check =====
local PlaceId = game.PlaceId
if PlaceId ~= 2753915549 and PlaceId ~= 4442272183 and PlaceId ~= 7449423635 then
    return warn("[❌] Not supported PlaceId!")
end

-- ===== AntiCheat bypass (deferred queue) =====
task.spawn(function()
    local gc = getgc(true)
    local index = 1
    local batchSize = 50

    local function processBatch()
        local limit = math.min(index + batchSize - 1, #gc)
        for i = index, limit do
            local v = gc[i]
            if typeof(v) == "function" and islclosure(v) then
                local success, uvs = pcall(debug.getupvalues, v)
                if success and uvs then
                    for _, uv in ipairs(uvs) do
                        if uv == "AndroidAnticheatKick" then
                            hookfunction(v, function(...) return nil end)
                        end
                    end
                end
            end
        end
        index = limit + 1
        if index <= #gc then
            task.defer(processBatch)
        end
    end

    processBatch()
end)

-- ===== Services =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- ===== Temple of Time =====
local temple = ReplicatedStorage:FindFirstChild("MapStash") and ReplicatedStorage.MapStash:FindFirstChild("Temple of Time")
if not temple then
    return warn("[❌] Temple of Time not found!")
end
temple.Parent = Workspace


-- ===== Enable Infinite Ability =====
getgenv().InfAbility = true
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
    StarterGui:SetCore("EmotesMenuOpen", true)
end)

-- ===== Infinite Ability Effect =====
local function InfAb(Char)
    local HRP = Char:WaitForChild("HumanoidRootPart",10)
    if HRP and not HRP:FindFirstChild("Agility") then
        local inf = Instance.new("ParticleEmitter")
        inf.Name = "Agility"
        inf.Enabled = true
        inf.Rate = 2000
        inf.Lifetime = NumberRange.new(0,0)
        inf.Speed = NumberRange.new(50,50)
        inf.RotSpeed = NumberRange.new(20000,200000)
        inf.Drag = 10
        inf.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,6)})
        inf.SpreadAngle = Vector2.new(0,0)
        inf.LockedToPart = true
        inf.Parent = HRP
    end
end

-- ===== Character Handler =====
local function OnCharacterAdded(Char)
    if getgenv().InfAbility then
        InfAb(Char)
    end
end

-- ===== Init =====
if LocalPlayer.Character then
    OnCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
