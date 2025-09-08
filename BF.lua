-- ===== PlaceId Check =====    
local World1, World2, World3 = false, false, false    
if game.PlaceId == 2753915549 then    
    World1 = true    
elseif game.PlaceId == 4442272183 then    
    World2 = true    
elseif game.PlaceId == 7449423635 then    
    World3 = true    
else    
    print("[❌] This script only works in Blox Fruits PlaceIds!")    
    return    
end    
print("[✅] PlaceId OK!")    

-- ===== AntiCheat bypass =====    
pcall(function()    
    for i, v in pairs(getgc(true)) do    
        if typeof(v) == "function" and islclosure(v) then    
            local upvs = debug.getupvalues(v)    
            for _, uv in pairs(upvs) do    
                if uv == "AndroidAnticheatKick" then    
                    hookfunction(v, function(...) return nil end)    
                end    
            end    
        end    
    end    
end)    
print("[✅] Anti-Cheat Bypass attempted (may vary by executor)")    

-- ===== Services =====    
local Workspace = game:GetService("Workspace")    
local ReplicatedStorage = game:GetService("ReplicatedStorage")    

-- ===== ย้าย Temple of Time =====    
local temple    
pcall(function()    
    local MapStash = ReplicatedStorage:WaitForChild("MapStash", 10)    
    temple = MapStash:WaitForChild("Temple of Time", 10)    
    if temple then
        temple.Parent = Workspace
        print("[✅] Temple of Time Bypassed")
    end
end)

-- ===== Optimize Temple of Time =====
local TotalRemoved = 0
local function safeRemove(instance)
    if instance and instance:IsA("Instance") and instance.Parent then
        instance:Destroy()
        TotalRemoved += 1
    end
end

local function purgePerformanceStuff()
    if not temple then return end
    for _, descendant in ipairs(temple:GetDescendants()) do
        if descendant.Name == "PerformanceBarrel" or descendant.Name == "PerformanceCrate" then
            safeRemove(descendant)
        end
    end
end

local function removeSpecificParts()
    if not temple then return end
    local function try(pathFunc)
        local success, result = pcall(pathFunc)
        if success and result then safeRemove(result) end
    end

    try(function() return temple["GiantRoom"]:GetChildren()[18]:FindFirstChild("FHead") end)
    try(function() return temple:FindFirstChild("Orbs") end)
    try(function() return temple:GetChildren()[78] end)
    try(function() return temple["GiantRoom"]:GetChildren()[43] end)
    try(function() return temple["GiantRoom"]:GetChildren()[57] end)
    try(function() return temple["GiantRoom"]:GetChildren()[58] end)
    try(function() return temple["GiantRoom"]:GetChildren()[52]:GetChildren()[6] end)
    try(function() return temple["GiantRoom"]:GetChildren()[52]:GetChildren()[5] end)
    try(function() return temple["GiantRoom"]:GetChildren()[186] end)
    try(function() return temple["GiantRoom"]:GetChildren()[42] end)
    try(function() return temple:GetChildren()[7]:GetChildren()[5] end)
    try(function() return temple:GetChildren()[25]:GetChildren()[6] end)
    try(function() return temple.GiantRoom:FindFirstChild("FallingLeaves") end)
    try(function() return temple.GiantRoom:GetChildren()[193] end)
    try(function() return temple.SpawnRoom:GetChildren()[13]:FindFirstChild("PerformanceBarrel") and temple.SpawnRoom:GetChildren()[13].PerformanceBarrel:FindFirstChild("Barrel") end)
    try(function() return temple.SpawnRoom:GetChildren()[13]:GetChildren()[4] end)
    try(function() return temple.SpawnRoom:GetChildren()[13]:FindFirstChild("PerformanceBarrel") end)
    try(function() return temple.SpawnRoom:GetChildren()[13]:FindFirstChild("PerformanceCrate") end)
    try(function() return temple.SpawnRoom:GetChildren()[13]:GetChildren()[2] end)
end

local function purgeExactOrb()
    if not temple then return end
    for _, descendant in ipairs(temple:GetDescendants()) do
        if descendant.Name == "Orb" then
            safeRemove(descendant)
        end
    end
end

local function optimizeLightingInTemple()
    if not temple then return end
    for _, obj in ipairs(temple:GetDescendants()) do
        if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            safeRemove(obj)
        end
        if obj:IsA("BasePart") and obj.Material == Enum.Material.Neon then
            obj.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- ===== Execute Optimization =====
task.spawn(function()
    purgePerformanceStuff()
    purgeExactOrb()
    removeSpecificParts()
    optimizeLightingInTemple()
    print("[✅] Temple optimized")
end)
