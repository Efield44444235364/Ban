


-- Roblox Lua KRNL Loader Script (รวมโค้ด 2 ชุด)

-- === การตรวจสอบสถานะเริ่มต้นและป้องกันการทำงานซ้ำ ===

if not _G.efield_loader then
    task.wait(5)
    game.Players.LocalPlayer:Kick("This is a fucking old script pls get new from Dev!!!!. End of story🥰😘 \n in 4sec game gonnabe shutdown!")
    wait(4)
    game:Shutdown()
    return
end


-- ฟังก์ชันต่อไปที่อยากรัน
    task.wait(2)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Warning.lua"))()

local MarketplaceService = game:GetService("MarketplaceService")
local placeId = game.PlaceId

-- === 1. การกำหนด Place ID ที่อนุญาตให้โหลดโค้ดชุดพิเศษ (ชุดบน) ===
local ALLOWED_PLACE_IDS = {
    131716211654599, -- ID 1
    168556275      -- ID 2
}

local isCorrectPlace = false
for _, id in ipairs(ALLOWED_PLACE_IDS) do
    if placeId == id then
        isCorrectPlace = true
        break
    end
end

local placeName = MarketplaceService:GetProductInfo(placeId).Name
print("🌍 PlaceID : " .. placeId .. " | Map : " .. placeName)


-- ====================================================================
-- === ฟังก์ชันและ Modules พื้นฐาน (ใช้ร่วมกัน) ===
-- ====================================================================

local Modules = {
    -- สีที่คัดสรรมาใหม่ เน้นความสวยงามและมืออาชีพ
    Colors =  {
        ["Success"]   = "46, 204, 113",   -- Emerald Green (สำหรับ Success/Loaded)
        ["NEON_GREEN"]= "57, 255, 20",    -- NEON Green (สำหรับ Final Success Message)
        ["Accent"]    = "52, 152, 219",   -- Bright Blue (สำหรับ Loading Bar)
        ["Primary"]   = "236, 240, 241",  -- Light Gray (สำหรับข้อความพื้นฐาน)
        ["Error"]     = "231, 76, 60",    -- Alizarin Red (สำหรับ Failure)
        ["Warning"]   = "241, 196, 15",   -- Sun Flower Yellow (สำหรับเวลาโหลด >= 10s)
    },
    Services = {
        RunService = game:GetService("RunService"),
        CoreGui = game:GetService("CoreGui")
    },
    HeartbeatConnection = nil 
}

-- ฟังก์ชันสำหรับบังคับให้ DevConsole รองรับ RichText
Modules.ChangeColor = function() 
    Modules.HeartbeatConnection = Modules.Services.RunService.Heartbeat:Connect(function()
        local success, err = pcall(function()
            local devConsole = Modules.Services.CoreGui:FindFirstChild("DevConsoleMaster")
            if devConsole then
                for _, label in pairs(devConsole:GetDescendants()) do 
                    if label:IsA("TextLabel") then 
                        label.RichText = true 
                    end 
                end 
            end
        end)

        if not success then 
            warn(`[Console Init] Error: {err}. Disconnecting RichText loop.`)
            if Modules.HeartbeatConnection then
                Modules.HeartbeatConnection:Disconnect()
                Modules.HeartbeatConnection = nil
            end
        end 
    end)
end

-- ฟังก์ชันปิดการทำงาน RichText และแสดงข้อความสำเร็จสุดท้าย
Modules.FinalizeLoading = function(watermark, loadingLabel)
    local finalID = tostring(math.random(10, 999)) 
    
    if loadingLabel and loadingLabel:IsA("TextLabel") then
        loadingLabel.Text = string.format(
            "<font color='rgb(%s)' size='18'>[%s] ID:%s | [SUCCESS]</font>", 
            Modules.Colors["NEON_GREEN"], 
            watermark, 
            finalID
        )
    end

    if Modules.HeartbeatConnection then
        Modules.HeartbeatConnection:Disconnect()
        Modules.HeartbeatConnection = nil
    end
end

-- ====================================================================
-- === การกำหนด FILES_TO_LOAD ตามเงื่อนไข PlaceId ===
-- ====================================================================

local FILES_TO_LOAD = {}
local loadingBarFunction = nil -- ตัวแปรสำหรับเลือกใช้ Loading Bar Function

if isCorrectPlace then
    
    -- โค้ดชุดที่ 1: สำหรับ Place ID ที่ตรง
    FILES_TO_LOAD = {
        -- Bypass (สุ่มเวลาโหลด 5-16 วิ)
        {
            Name = "Bypass", 
            URL = "", -- ใช้ไฟล์เดิม
            CustomWait = math.random(50, 160) / 10 -- 5.0s ถึง 16.0s
        },
        -- Memory cleaning (เวลาโหลดปกติ)
        {
            Name = "Memory cleaning", 
            URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/RamClear%20Auto.lua",
            CustomWait = 0.4 -- ใช้เวลาโหลดจำลองปกติ
        },
    }

    -- ฟังก์ชัน LoadingBar สำหรับชุดที่ 1 (มีการจับเวลาและแสดงสีตามเวลา)
    loadingBarFunction = function(watermark, loadingSymbol)
        loadingSymbol = loadingSymbol or "█"
        
        local totalFiles = #FILES_TO_LOAD
        
        local uniqueID = tostring(math.random(10, 999))
        local uniqueText = string.format("[%s] ID:%s | i think script load successfully \nif you see this with white text!!", watermark, uniqueID)
        print(uniqueText) 
    
        local loadingLabel = nil
        repeat task.wait()
            local devConsole = Modules.Services.CoreGui:FindFirstChild("DevConsoleMaster")
            if devConsole then
                for _, label in pairs(devConsole:GetDescendants()) do 
                     if label:IsA("TextLabel") and string.find(label.Text, uniqueID) then 
                        loadingLabel = label 
                        break
                    end 
                end 
            end
        until loadingLabel
    
        if not loadingLabel then 
            warn("Failed to find initial DevConsole TextLabel. Stopping loading bar.")
            return 
        end
        
        local accentColor = Modules.Colors["Accent"]
        local whiteColor = Modules.Colors["Primary"]
        local errorColor = Modules.Colors["Error"]
        local warningColor = Modules.Colors["Warning"]

        local loadingBarTemplate = [[<font color='rgb(%s)' size='15'>[%s] <font color='rgb(%s)'>[</font>%s<font color='rgb(%s)'>%s</font><font color='rgb(%s)'>]</font> %d%% | %s</font>]]
        local finalTemplate = [[<font color='rgb(%s)' size='15'>[%s] <font color='rgb(%s)'>[</font>%s<font color='rgb(%s)'>%s</font><font color='rgb(%s)'>]</font> %d%% | Status: %s | Time: %s</font>]]
        
        
        -- โหลดไฟล์ทีละตัว
        for i, fileData in ipairs(FILES_TO_LOAD) do
            local currentFileName = fileData.Name
            local loadTime = fileData.CustomWait or 0.1
    
            -- Animation แสดงชื่อไฟล์ (Pre-Load)
            for j = 1, 5 do
                local currentProgress = (i - 1) / totalFiles + (j / 5) * (1 / totalFiles)
                local percent = math.floor(currentProgress * 100)
                local barLength = math.floor(currentProgress * 30)
                
                local bar = string.rep(loadingSymbol, barLength)
                local empty = string.rep(" ", 30 - barLength)
    
                loadingLabel.Text = string.format(
                    loadingBarTemplate, 
                    whiteColor, watermark, accentColor, bar, whiteColor, empty, accentColor, percent,
                    "Loading: " .. currentFileName
                )
                task.wait(0.05)
            end
            
            -- ดำเนินการโหลดจริง (Blocking Call)
            local startTime = tick()
            local success = pcall(function()
                task.wait(loadTime) -- หน่วงเวลาตามที่กำหนด
                if fileData.URL and fileData.URL ~= "" then
                    loadstring(game:HttpGet(fileData.URL))()
                end
            end)
            local endTime = tick()
            local timeElapsed = math.floor((endTime - startTime) * 100) / 100 
            
            -- การกำหนดสีตามเวลาโหลด
            local timeColor = whiteColor
            if timeElapsed >= 10 and timeElapsed < 20 then 
                timeColor = warningColor 
            elseif timeElapsed >= 20 then
                timeColor = errorColor 
            end
            
            -- อัพเดท Loading Bar ให้เต็ม Step และแสดงสถานะ
            local statusText = success and "<font color='rgb("..Modules.Colors["Success"]..")'>Complete</font>" or "<font color='rgb("..errorColor..")'>Failed</font>"
            local percent = math.floor((i / totalFiles) * 100)
            local barLength = math.floor((i / totalFiles) * 30)
            
            local bar = string.rep(loadingSymbol, barLength)
            local empty = string.rep(" ", 30 - barLength)
            local timeDisplay = string.format("<font color='rgb(%s)'>%.2fs</font>", timeColor, timeElapsed)
    
            loadingLabel.Text = string.format(
                finalTemplate, 
                whiteColor, watermark, accentColor, bar, whiteColor, empty, accentColor, percent,
                statusText, timeDisplay
            )
            task.wait(0.1)
        end
    
        Modules.FinalizeLoading(watermark, loadingLabel)

    end -- ปิด LoadingBar ชุด 1

else

    -- โค้ดชุดที่ 2: สำหรับ Place ID ที่ไม่ตรง
    FILES_TO_LOAD = {
        {Name = "Blox Fruits", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/BF.lua"},
        {Name = "Optimization Engine", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/blox%20fruit%20Optimize.lua"},
        {Name = "Memory optimize", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/RamClear%20Auto.lua"},
        {Name = "Anti-Admin", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Admins.lua"},
        {Name = "Auto Reconnect", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Auto%20reconnect.lua"},
        {Name = "User Interface (UI)", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Ui2.lua"},
    }

    -- ฟังก์ชัน LoadingBar สำหรับชุดที่ 2 (ไม่มีการจับเวลา)
    loadingBarFunction = function(watermark, loadingSymbol)
        loadingSymbol = loadingSymbol or "█"
        
        local totalFiles = #FILES_TO_LOAD
        
        local uniqueID = tostring(math.random(10, 999))
        local uniqueText = string.format("[%s] ID:%s | i think script load successfully.... ", watermark, uniqueID)
        print(uniqueText) 
    
        local loadingLabel = nil
        repeat task.wait()
            local devConsole = Modules.Services.CoreGui:FindFirstChild("DevConsoleMaster")
            if devConsole then
                for _, label in pairs(devConsole:GetDescendants()) do 
                     if label:IsA("TextLabel") and string.find(label.Text, uniqueID) then 
                        loadingLabel = label 
                        break
                    end 
                end 
            end
        until loadingLabel
    
        if not loadingLabel then 
            warn("Failed to find initial DevConsole TextLabel. Stopping loading bar.")
            return 
        end
        
        local accentColor = Modules.Colors["Accent"]
        local whiteColor = Modules.Colors["Primary"]
        local errorColor = Modules.Colors["Error"]

        local loadingBarTemplate = [[<font color='rgb(%s)' size='15'>[%s] <font color='rgb(%s)'>[</font>%s<font color='rgb(%s)'>%s</font><font color='rgb(%s)'>]</font> %d%% | %s</font>]]
        local finalTemplate = [[<font color='rgb(%s)' size='15'>[%s] <font color='rgb(%s)'>[</font>%s<font color='rgb(%s)'>%s</font><font color='rgb(%s)'>]</font> %d%% | Status: %s</font>]]
        
        
        -- โหลดไฟล์ทีละตัว
        for i, fileData in ipairs(FILES_TO_LOAD) do
            local currentFileName = fileData.Name
            
            -- Animation แสดงชื่อไฟล์ (Pre-Load)
            for j = 1, 5 do
                local currentProgress = (i - 1) / totalFiles + (j / 5) * (1 / totalFiles)
                local percent = math.floor(currentProgress * 100)
                local barLength = math.floor(currentProgress * 30)
                
                local bar = string.rep(loadingSymbol, barLength)
                local empty = string.rep(" ", 30 - barLength)
    
                loadingLabel.Text = string.format(
                    loadingBarTemplate, 
                    whiteColor, watermark, accentColor, bar, whiteColor, empty, accentColor, percent,
                    "Loading: " .. currentFileName
                )
                task.wait(0.05)
            end
            
            -- ดำเนินการโหลดจริง (Blocking Call)
            local success = pcall(function()
                task.wait(0.1) -- หน่วงเวลาจำลองการโหลด
                return loadstring(game:HttpGet(fileData.URL))()
            end)
            
            -- อัพเดท Loading Bar ให้เต็ม Step และแสดงสถานะ
            local statusText = success and "<font color='rgb("..Modules.Colors["Success"]..")'>Complete</font>" or "<font color='rgb("..errorColor..")'>Failed</font>"
            local percent = math.floor((i / totalFiles) * 100)
            local barLength = math.floor((i / totalFiles) * 30)
            
            local bar = string.rep(loadingSymbol, barLength)
            local empty = string.rep(" ", 30 - barLength)
    
            loadingLabel.Text = string.format(
                finalTemplate, 
                whiteColor, watermark, accentColor, bar, whiteColor, empty, accentColor, percent,
                statusText
            )
            task.wait(0.1)
        end
    
        Modules.FinalizeLoading(watermark, loadingLabel)

    end -- ปิด LoadingBar ชุด 2
end

-- ====================================================================
-- === การใช้งานจริง ===
-- ====================================================================

Modules.ChangeColor()

if loadingBarFunction then
    loadingBarFunction("KAWNEW_LOAD", "█")
end


-- สิ้นสุดสคริปต์
