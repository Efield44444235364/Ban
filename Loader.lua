
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
loadingString("Admins", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Admins.lua")
loadingString("Ui", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Ui2.lua")
loadingString("Auto Reconnect", "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Auto%20reconnect.lua")

-- loadingString("Optimize", "")





