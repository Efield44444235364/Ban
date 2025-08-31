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


local dojo = workspace.Map["Oni Realm"].dojo
local targetIndex = 41
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function deletePart()
    local part = dojo:GetChildren()[targetIndex]
    if part then
        part:Destroy()
    end
end

-- ขั้นตอนแรก ลบเลย
deletePart()

-- ตรวจสอบ Remote ว่ามีไหม
local OniRemote = ReplicatedStorage:FindFirstChild("Modules") 
                  and ReplicatedStorage.Modules:FindFirstChild("Net") 
                  and ReplicatedStorage.Modules.Net:FindFirstChild("RF/OniTempleTransportation")

if OniRemote then
    local args = {"InitiateTeleportToTemple"}
    pcall(function()
        OniRemote:InvokeServer(unpack(args))
    end)
    -- หลังเรียก Remote ลบซ้ำอีกครั้ง เผื่อเกิด Part ใหม่
    deletePart()
end

-- สคริปต์จบตรงนี้
