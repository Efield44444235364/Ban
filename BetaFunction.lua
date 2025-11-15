-- 📦 Services
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🌍 World Check
local World1, World2, World3, Celebrity = false, false, false, false

if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    World2 = true
elseif game.PlaceId == 7449423635 or 100117331123089 then
    World3 = true
elseif game.PlaceId == 95165932064349 then 
    Celebrity = false
else
    warn("[❌] This script only works in Blox Fruits PlaceIds!")
    return
end

-- 🎭 Enable Emotes
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
    StarterGui:SetCore("EmotesMenuOpen", true)
end)

-- ⚙️ ค่า Default Attribute
local desired_DashLength = 150 -- เริ่มต้นกลาง ๆ (คุณปรับได้ 0–100)
local desired_WaterWalking = true

-- 🛠 ฟังก์ชันสำหรับตั้งค่า Attribute
local function ApplyAttributes(char)
    if not char then return end
    
    -- Clamp DashLength ให้อยู่ในช่วง 0–100
    local dashValue = math.clamp(desired_DashLength, 0, 300)

    -- ตั้งค่า Attribute
    char:SetAttribute("DashLength", dashValue)
    char:SetAttribute("WaterWalking", desired_WaterWalking)

    -- อัพเดทตัวแปรในสคริปต์
    Dashlength = char:GetAttribute("DashLength")
    WaterWalking = char:GetAttribute("WaterWalking")

    -- อัพเดท UI ถ้ามี
    if dashSlider then dashSlider:Set(Dashlength) end
    if waterToggle then waterToggle:Set(WaterWalking) end

    -- ตรวจสอบ HRP
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then
        warn("Failed to get HRP")
        return
    end
end

-- 🚀 เรียกใช้ทันทีตอนเริ่ม
if LocalPlayer.Character then
    ApplyAttributes(LocalPlayer.Character)
end

-- 🔄 เรียกใช้ใหม่ทุกครั้งที่ตัวละคร respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    ApplyAttributes(newChar)
end)

-- 📌 ฟังก์ชันเรียกใช้เองภายนอก
function SetDashLength(value)
    desired_DashLength = math.clamp(value, 0, 300)
    if LocalPlayer.Character then
        LocalPlayer.Character:SetAttribute("DashLength", desired_DashLength)
        Dashlength = desired_DashLength
        if dashSlider then dashSlider:Set(desired_DashLength) end
    end
end

function SetWaterWalking(value)
    desired_WaterWalking = value
    if LocalPlayer.Character then
        LocalPlayer.Character:SetAttribute("WaterWalking", value)
        WaterWalking = value
        if waterToggle then waterToggle:Set(value) end
    end
end
