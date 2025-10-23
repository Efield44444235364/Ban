-- 💧 Ultra Smooth Dynamic LOD (Silent Union Fix)
-- ✅ Optimized for KRNL / Mobile
-- 🧠 By GPT-5

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera

local LOD_DISTANCE = 300
local LOD_BUFFER = 20           -- ระยะ buffer เพื่อให้ transition นุ่มนวล
local LOD_PARTS = {}
local LOD_INDEX = 0
local LOD_BATCH = 75            -- ตรวจต่อ frame (ลดภาระ)
local LOD_CHECK_RATE = 0.05     -- เวลาต่อ tick
local unionSupported = nil
local fadeState = {}            -- เก็บสถานะ LOD ของแต่ละ part

-- ☀️ Lighting Optimization
local function optimizeLighting()
    Lighting.GlobalShadows = true
    Lighting.Technology = Enum.Technology.ShadowMap
    Lighting.FogEnd = 120000
    Lighting.FogStart = 0
    Lighting.Outlines = false
    local sunRays = Lighting:FindFirstChild("SunRaysEffect")
    if sunRays then sunRays.Enabled = false end
end

-- 🧠 Detect if Union RenderFidelity is editable
local function testUnionSupport()
    if unionSupported ~= nil then return end
    local u = Instance.new("UnionOperation")
    u.Parent = Workspace
    local ok, err = pcall(function()
        u.RenderFidelity = Enum.RenderFidelity.Performance
    end)
    u:Destroy()
    if ok then
        unionSupported = true
        print("[LOD] ✅ Union RenderFidelity supported")
    else
        unionSupported = false
        print("[LOD] ⚠️ Union RenderFidelity disabled (auto-skip active)")
    end
end

-- 🧩 Register parts safely
local function optimizePart(part)
    if not part or not part:IsA("BasePart") or not part.Parent then return end
    local name = part.Name:lower()

    if part:IsA("MeshPart") then
        LOD_PARTS[#LOD_PARTS + 1] = part
        part.CollisionFidelity = Enum.CollisionFidelity.Box
        part.RenderFidelity = Enum.RenderFidelity.Performance
        fadeState[part] = 0
    elseif part:IsA("UnionOperation") then
        if unionSupported == nil then testUnionSupport() end
        part.CollisionFidelity = Enum.CollisionFidelity.Box
        if unionSupported then
            local ok = pcall(function()
                part.RenderFidelity = Enum.RenderFidelity.Performance
            end)
            if not ok then unionSupported = false end
        end
    end

    if name:find("detail") or name:find("plant") or name:find("decor") then
        part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
        part.CastShadow = false
    elseif name:find("ground") or name:find("terrain") then
        part.CastShadow = false
    end
end

-- 💧 Smooth transition effect (simulate fade)
local function smoothLODTransition(part, target)
    if not fadeState[part] then fadeState[part] = 0 end
    local current = fadeState[part]
    local speed = 0.2
    if target == 1 then
        fadeState[part] = math.min(1, current + speed)
    else
        fadeState[part] = math.max(0, current - speed)
    end

    -- ลื่นขึ้นโดยการทำให้ RenderFidelity เปลี่ยนเมื่อถึงขีด
    if fadeState[part] >= 0.8 and part.RenderFidelity ~= Enum.RenderFidelity.Precise then
        part.RenderFidelity = Enum.RenderFidelity.Precise
    elseif fadeState[part] <= 0.2 and part.RenderFidelity ~= Enum.RenderFidelity.Performance then
        part.RenderFidelity = Enum.RenderFidelity.Performance
    end
end

-- ⚙️ Smooth LOD Scheduler
local function startLODSystem()
    task.spawn(function()
        while true do
            local camPos = Camera.CFrame.Position
            for i = 1, LOD_BATCH do
                LOD_INDEX += 1
                if LOD_INDEX > #LOD_PARTS then
                    LOD_INDEX = 1
                    break
                end

                local part = LOD_PARTS[LOD_INDEX]
                if not part or not part.Parent then
                    table.remove(LOD_PARTS, LOD_INDEX)
                    break
                end

                local dist = (part.Position - camPos).Magnitude
                if dist < (LOD_DISTANCE - LOD_BUFFER) then
                    smoothLODTransition(part, 1)
                elseif dist > (LOD_DISTANCE + LOD_BUFFER) then
                    smoothLODTransition(part, 0)
                end
            end
            task.wait(LOD_CHECK_RATE)
        end
    end)
end

-- 🏁 Initialization
local function initialize()
    optimizeLighting()
    testUnionSupport()

    for _, d in ipairs(Workspace:GetDescendants()) do
        optimizePart(d)
    end

    Workspace.DescendantAdded:Connect(optimizePart)
    startLODSystem()

    print("[✅ LOD] Ultra Smooth Dynamic LOD Loaded")
    print(">> LOD Distance:", LOD_DISTANCE)
    print(">> Union Support:", tostring(unionSupported))
end

initialize()
