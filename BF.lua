-- ===== PlaceId Check =====
local PlaceId = game.PlaceId
if PlaceId ~= 2753915549 and PlaceId ~= 4442272183 and PlaceId ~= 7449423635 then
    return warn("[❌] Not supported PlaceId!")
end

-- ===== AntiCheat bypass =====
task.spawn(function()
    pcall(function()
        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" and islclosure(v) then
                for _, uv in ipairs(debug.getupvalues(v)) do
                    if uv == "AndroidAnticheatKick" then
                        hookfunction(v, function(...) return nil end)
                    end
                end
            end
        end
    end)
end)
print("[✅] Anti-Cheat bypass attempted")

-- ===== Services =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- ===== Temple of Time =====
local temple = ReplicatedStorage:FindFirstChild("MapStash") and ReplicatedStorage.MapStash:FindFirstChild("Temple of Time")
if not temple then
    return warn("[❌] Temple of Time not found!")
end

temple.Parent = Workspace

-- ===== Helpers =====
local removed = 0
local function safeRemove(obj)
    if obj and obj.Parent then
        obj:Destroy()
        removed += 1
    end
end

local function try(func)
    local ok, result = pcall(func)
    if ok and result then safeRemove(result) end
end

-- ===== Optimize Temple =====
task.spawn(function()
    -- loop remove junk + lights + neon
    for _, obj in ipairs(temple:GetDescendants()) do
        if obj.Name == "PerformanceBarrel" or obj.Name == "PerformanceCrate" or obj.Name == "Orb" then
            safeRemove(obj)
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            safeRemove(obj)
        elseif obj:IsA("BasePart") and obj.Material == Enum.Material.Neon then
            obj.Material = Enum.Material.SmoothPlastic
        end
    end

    -- specific parts (safe try)
    try(function() return temple.GiantRoom:FindFirstChild("FallingLeaves") end)
    try(function() return temple:FindFirstChild("Orbs") end)

    print("[✅] Temple of time has been optimized")
end)
