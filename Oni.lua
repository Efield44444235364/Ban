local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local OniRealm = WS:WaitForChild("Map"):WaitForChild("Oni Realm")
local OniInterior = WS:WaitForChild("Map"):WaitForChild("Oni Realm (Interior)")

-- จุด dojo target
local dojoModel = OniRealm:FindFirstChild("dojo") and OniRealm.dojo:FindFirstChild("Model")
local dojoPart = OniRealm:FindFirstChild("dojo")

-- เก็บสถานะว่า optimization เริ่มหรือยัง
local optimizationStarted = false

-- จุด safePart
local safePart
local targetParent = OniRealm:GetChildren()[77]
if targetParent and targetParent:FindFirstChild("Cube.002") then
    safePart = targetParent["Cube.002"]
    safePart.Parent = safePart.Parent
end

-- Whitelist Part/Model สำคัญ
local importantParts = {
    OniRealm:FindFirstChild("Model") and OniRealm.Model:FindFirstChild("Model"),
    OniRealm:GetChildren()[5],
    OniRealm:FindFirstChild("Tree"),
    OniRealm:FindFirstChild("dojo") and OniRealm.dojo:FindFirstChild("Model"),
    OniRealm:FindFirstChild("dojo"),
    OniRealm:FindFirstChild("giantwing") and OniRealm.giantwing:FindFirstChild("wings_final")
}

local importantSet = {}
for _, v in ipairs(importantParts) do
    if v then importantSet[v] = true end
end

-- ฟังก์ชันคำนวณระยะห่างจาก dojo
local function getDistanceFromDojo()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return math.huge end

    local hrp = char.HumanoidRootPart.Position
    local candidates = {}

    if dojoModel and dojoModel:IsA("Model") and dojoModel.PrimaryPart then
        table.insert(candidates, dojoModel.PrimaryPart.Position)
    end
    if dojoPart and dojoPart:IsA("BasePart") then
        table.insert(candidates, dojoPart.Position)
    end

    local minDist = math.huge
    for _, targetPos in ipairs(candidates) do
        local dist = (hrp - targetPos).Magnitude
        if dist < minDist then
            minDist = dist
        end
    end
    return minDist
end

-- ฟังก์ชัน optimize LOD สำหรับ Oni ธรรมดา
local function optimizeLOD(map)
    for _, part in ipairs(map:GetDescendants()) do
        local skip = false
        if part == safePart then skip = true end
        for important,_ in pairs(importantSet) do
            if part:IsDescendantOf(important) then skip = true break end
        end

        if not skip then
            if part:IsA("BasePart") then
                part.CastShadow = false
                part.Material = Enum.Material.SmoothPlastic
                part.Color = Color3.fromRGB(255,255,255)
                part.Reflectance = 0
                part.Transparency = 0
                part.CanCollide = false
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part:Destroy()
            end
        end
    end
end

-- preload แบบ multi-thread batch
local function fastLoad(map, extremelyFast)
    task.spawn(function()
        local descendants = map:GetDescendants()
        local batchSize = extremelyFast and #descendants or 100
        local i = 1
        while i <= #descendants do
            for j = i, math.min(i+batchSize-1, #descendants) do
                local part = descendants[j]
                if part:IsA("BasePart") then
                    pcall(function()
                        part.Parent = part.Parent
                    end)
                end
            end
            i = i + batchSize
            task.wait(0)
        end
    end)
end

-- ฟังก์ชัน LOD ของ Oni Initiate
local function setOniInitiateLOD(isActive)
    for _, part in ipairs(OniInterior:GetDescendants()) do
        if part:IsA("BasePart") then
            if isActive then
                part.CastShadow = true
                part.Reflectance = 0.2 -- เปิดแสง/สะท้อน
            else
                part.CastShadow = false
                part.Reflectance = 0    -- ปิดแสง/สะท้อน
            end
        end
    end
end

-- เริ่มต้นปิดแสง/เงา Oni Initiate
setOniInitiateLOD(false)

-- Remote hook
local NetModule = RS:WaitForChild("Modules"):WaitForChild("Net")
local teleportRemote = NetModule:WaitForChild("RF/OniTempleTransportation")

local function handleRemote(args)
    if not optimizationStarted then return end -- ✅ ถ้ายังไม่เริ่ม optimization → ข้ามไป

    if args[1] == "InitiateTeleportToInterior" then
        setOniInitiateLOD(true)       -- เปิดแสง/สะท้อน
        fastLoad(OniInterior, true)   -- preload full-speed Oni Initiate
    else
        fastLoad(OniRealm)            -- preload Oni ธรรมดา
    end
end

if teleportRemote:IsA("RemoteFunction") then
    local originalInvoke = teleportRemote.InvokeServer
    teleportRemote.InvokeServer = function(self, ...)
        local args = {...}
        handleRemote(args)
        return originalInvoke(self, ...)
    end
elseif teleportRemote:IsA("RemoteEvent") then
    local originalFire = teleportRemote.FireServer
    teleportRemote.FireServer = function(self, ...)
        local args = {...}
        handleRemote(args)
        return originalFire(self, ...)
    end
end

-- 🔄 ตัวเช็คเงื่อนไข (ทำงานทุก ๆ 1 วิ)
task.spawn(function()
    while true do
        task.wait(1)
        if not optimizationStarted then
            local dist = getDistanceFromDojo()
            if dist > 200 then
                optimizationStarted = true
                print("[OPTIMIZATION] Player ห่างจาก dojo เกิน 200m → เริ่มทำงาน")
                optimizeLOD(OniRealm)
            end
        end
    end
end)
