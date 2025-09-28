local StarterGui = game:GetService("StarterGui")

-- ===== World Check =====
local World1, World2, World3, Celebrity = false, false, false, false

if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
elseif game.PlaceId == 95165932064349 then 
    Celebrity= true
else
    warn("[❌] This script only works in Blox Fruits PlaceIds!")
    return
end

-- ===== Toggle Emotes =====
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
    StarterGui:SetCore("EmotesMenuOpen", true)
end)

-- ===== ตรงนี้สามารถใส่สคริปต์อื่นต่อได้ เช่น Temple of Time, Infinite Ability =====
