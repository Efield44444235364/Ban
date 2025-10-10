-- 🧹 Clear RAM (Smart Dual-Idle Version)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local lastTouchTime = tick()   -- เวลาแตะหน้าจอ/กดปุ่มล่าสุด
local lastMoveTime = tick()    -- เวลาเคลื่อนไหวล่าสุด

-- 💾 ฟังก์ชันล้างหน่วยความจำ
local function ClearRAM()
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                table.clear(v)
            end
        end
        collectgarbage("collect")
        warn("[🧹] RAM Cleared at " .. os.date("%X"))
    end)
end

-- 🎮 ตรวจจับการแตะหน้าจอ / กดปุ่ม / คลิกเมาส์
UserInputService.InputBegan:Connect(function()
    lastTouchTime = tick()
end)

-- 🕺 ตรวจจับการขยับตัว (เดิน/หมุนกล้อง)
task.spawn(function()
    while task.wait(1) do
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                lastMoveTime = tick()
            end
        end
    end
end)

-- ⏰ ล้าง RAM ทุกๆ 4 นาทีอัตโนมัติ
task.spawn(function()
    while task.wait(240) do
        ClearRAM()
    end
end)

-- 💤 ถ้า “ไม่ได้แตะจอ” และ “ไม่ได้ขยับ” เกิน 4.5 นาที ให้ Clear RAM
task.spawn(function()
    while task.wait(10) do
        local idleTimeTouch = tick() - lastTouchTime
        local idleTimeMove = tick() - lastMoveTime

        if idleTimeTouch >= 270 and idleTimeMove >= 270 then
            ClearRAM()
            -- รีเซ็ตเวลาใหม่หลังล้าง
            lastTouchTime = tick()
            lastMoveTime = tick()
        end
    end
end)
