if not _G.efield_loader then
    game.Players.LocalPlayer:Kick("This is a fucking old script pls get new from Dev!!!!. End of story🥰😘 \n in 4sec game gonnabe shutdown!")
    wait(4)
    game:Shutdown()
    return
end

-- ===== HWID + Player Name + Place Info =====
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- HWID (เอาจาก gethwid ถ้ามี / ถ้าไม่มีใช้ ClientId)
local hwid = (gethwid and gethwid()) or tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- Player
local player = game.Players.LocalPlayer
local playerName = player.Name

-- ถ้าเจอชื่อ shadow_4675 ให้ใส่ฉายาข้างๆ
if playerName == "shadow_4675" then
    playerName = playerName .. " | อีนาง ครางเสียว"
end

-- Place Info
local placeId = game.PlaceId
local placeName = MarketplaceService:GetProductInfo(placeId).Name

-- Print
print("🖥️ HWID : " .. hwid)
print("👤 Player : " .. playerName)
print("🌍 PlaceID : " .. placeId .. " | Map : " .. placeName)
warn("__________________________________________________________________________")
local function loadingString(name, url)
    print("[🔄] Loading " .. name .. " ...")
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if success then
        print("[✅] " .. name .. " Loaded Successfully!")
    else
        warn("[❌] Failed to load " .. name .. " | Error: " .. tostring(result))
    end
end

--// Files
loadingString("BF", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/BF.lua")
loadingString("Optimize", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/blox%20fruit%20Optimize.lua")
loadingString("Admins", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Admins.lua")
loadingString("Auto Reconnect", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Auto%20reconnect.lua")
loadingString("Ui", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Ui2.lua")




