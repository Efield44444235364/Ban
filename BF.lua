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

-- ===== ลบ Part ใน dojo =====
local dojo
pcall(function()
    local Map = Workspace:WaitForChild("Map", 10)
    local OniRealm = Map:WaitForChild("Oni Realm", 10)
    dojo = OniRealm:WaitForChild("dojo", 10)
end)

local targetIndex = 41
local function deletePart()
    if dojo then
        local part = dojo:GetChildren()[targetIndex]
        if part then
            part:Destroy()
            print("[✅] Part in Oni Temple fixed")
        else
            print("[⚠️] Part index " .. targetIndex .. " not found")
        end
    else
        print("[⚠️] Dojo not found, skipping part deletion")
    end
end
deletePart()

-- ===== Remote Teleport =====
local OniRemote
pcall(function()
    OniRemote = ReplicatedStorage:WaitForChild("Modules", 10)
                   :WaitForChild("Net", 10)
                   :WaitForChild("RF/OniTempleTransportation", 10)
end)

if OniRemote then
    pcall(function()
        OniRemote:InvokeServer("InitiateTeleportToTemple")
        print("[✅] Teleport Remote Invoked")
    end)
    deletePart() -- ลบ Part ซ้ำหลัง teleport
else
    print("[⚠️] OniRemote not found, skipping teleport")
end

-- ===== ย้าย Temple of Time =====
local MapStash, temple
pcall(function()
    MapStash = ReplicatedStorage:WaitForChild("MapStash", 10)
    temple = MapStash:WaitForChild("Temple of Time", 10)
end)

if temple then
    pcall(function()
        temple.Parent = Workspace
        print("[✅] Temple of Time Bypassed")
    end)
else
    print("[⚠️] Temple of Time not found, skipping")
end
