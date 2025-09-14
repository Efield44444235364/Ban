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

-- ===== Optimize Temple (deferred queue) =====
task.spawn(function()
    local descendants = temple:GetDescendants()
    local index = 1
    local batchSize = 50

    local function processBatch()
        local limit = math.min(index + batchSize - 1, #descendants)
        for i = index, limit do
            local obj = descendants[i]
            if obj.Name == "PerformanceBarrel" or obj.Name == "PerformanceCrate" or obj.Name == "Orb" then
                safeRemove(obj)
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                safeRemove(obj)
            elseif obj:IsA("BasePart") and obj.Material == Enum.Material.Neon then
                obj.Material = Enum.Material.SmoothPlastic
            end
        end
        index = limit + 1
        if index <= #descendants then
            task.defer(processBatch)
        else
            -- specific parts (safe try)
            try(function() return temple.GiantRoom:FindFirstChild("FallingLeaves") end)
            try(function() return temple:FindFirstChild("Orbs") end)
        end
    end

    processBatch()
end)
