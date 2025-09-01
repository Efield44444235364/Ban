-- AntiCheat bypass
for i, v in pairs(getgc(true)) do
    if typeof(v) == "function" and islclosure(v) then
        local upvs = debug.getupvalues(v)
        for _, uv in pairs(upvs) do
            if uv == "AndroidAnticheatKick" then
                hookfunction(v, function(...)
                    return nil
                end)
            end
        end
    end
end
print("[✅] Anti-Cheat Bypass!!")

-- Services
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===== ลบ Part ใน dojo =====
local dojo = Workspace.Map["Oni Realm"].dojo
local targetIndex = 41

local function deletePart()
    local part = dojo:GetChildren()[targetIndex]
    if part then
        part:Destroy()
        print("[✅] Part in Oni Temple fix")
    end
end

-- ลบ Part ครั้งแรก
deletePart()

-- ตรวจสอบ Remote และเรียกใช้งาน
local OniRemote = ReplicatedStorage:FindFirstChild("Modules") 
                  and ReplicatedStorage.Modules:FindFirstChild("Net") 
                  and ReplicatedStorage.Modules.Net:FindFirstChild("RF/OniTempleTransportation")

if OniRemote then
    local args = {"InitiateTeleportToTemple"}
    pcall(function()
        OniRemote:InvokeServer(unpack(args))
    end)
    -- ลบ Part ซ้ำ หลังเรียก Remote เผื่อเกิด Part ใหม่
    deletePart()
end

-- ===== ย้าย Temple of Time =====
local MapStash = ReplicatedStorage:FindFirstChild("MapStash")
if MapStash then
    local temple = MapStash:FindFirstChild("Temple of Time")
    if temple then
        temple.Parent = Workspace
        print("[✅] Temple of time Bypass")
    else
        warn("[❌] Temple of time has been Byapss!!")
    end
else
    warn("[❌] Temple of time has been Byapss!!")
end
