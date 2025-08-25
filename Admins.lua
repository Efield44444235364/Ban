-- ✅ ตรวจสอบแมพ
local allowedPlaces = {
    [2753915549] = true,
    [7449423635] = true,
    [4442272183] = true
}

if not allowedPlaces[game.PlaceId] then
    warn("[❌] Not in allowed map!")
    return
end

-- ✅ Services
local Players = game:GetService("Players")
local Notification = function(msg) print("[NOTIFY]", msg) end -- เปลี่ยนเป็นระบบแจ้งเตือนจริงถ้ามี

-- ✅ Blacklist Admins
local blacklist = {
    ["mygame43"] = true,
    ["Uzoth"] = true,
    ["xonae"] = true,
    ["Onett"] = true,
    ["Uzi_London"] = true,
    ["ShafiDev"] = true,
    ["rip_indra"] = true
}

local function checkPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if blacklist[p.Name] then
            Notification("⚠ Admin " .. p.Name .. " joined! Shutting down...")
            task.wait(1.5)
            game:Shutdown()
            break
        end
    end
end

task.spawn(function()
    while true do
        checkPlayers()
        task.wait(1.5)
    end
end)

-- ✅ Anti-AFK
local VirtualUser = game:service("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
warn("[AFK] Anti AFK Active")

