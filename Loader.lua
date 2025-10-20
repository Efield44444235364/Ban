
if not _G.efield_loader then
    task.wait(5)
    game.Players.LocalPlayer:Kick("This is a fucking old script pls get new from Dev!!!!. End of story🥰😘 \n in 4sec game gonnabe shutdown!")
    wait(4)
    game:Shutdown()
    return
end

game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)


-- Place Info
local placeId = game.PlaceId
local placeName = MarketplaceService:GetProductInfo(placeId).Name

print("🌍 PlaceID : " .. placeId .. " | Map : " .. placeName)
--[[
	SCRIPT ENHANCEMENT: Fixed Issue - Prevents SUCCESS message from being replaced.
	Key change: Disconnect the RichText setting loop and ensure the correct TextLabel is referenced.
--]]

local Modules = {
    -- สีที่คัดสรรมาใหม่ เน้นความสวยงามและมืออาชีพ
    Colors =  {
        ["Success"]   = "46, 204, 113",   -- Emerald Green (สำหรับ Success/Loaded)
        ["NEON_GREEN"]= "57, 255, 20",    -- NEON Green (สำหรับ Final Success Message)
        ["Accent"]    = "52, 152, 219",   -- Bright Blue (สำหรับ Loading Bar)
        ["Primary"]   = "236, 240, 241",  -- Light Gray (สำหรับข้อความพื้นฐาน)
        ["Error"]     = "231, 76, 60",    -- Alizarin Red (สำหรับ Failure)
    },
    Services = {
        RunService = game:GetService("RunService"),
        CoreGui = game:GetService("CoreGui")
    },
    
    -- เก็บ Reference ของ Connection เพื่อ Disconnect ในภายหลัง
    HeartbeatConnection = nil 
}

-- ข้อมูลไฟล์ที่ต้องการโหลด
local FILES_TO_LOAD = {
    {Name = "Blox Fruits", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/BF.lua"},
    {Name = "Optimization Engine", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/blox%20fruit%20Optimize.lua"},
    {Name = "Memory optimize", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/RamClear%20Auto.lua"},
    {Name = "Anti-Admin", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Admins.lua"},
    {Name = "Auto Reconnect", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Auto%20reconnect.lua"},
    {Name = "User Interface (UI)", URL = "https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Ui2.lua"},
}

-- ฟังก์ชันสำหรับบังคับให้ DevConsole รองรับ RichText (ปรับให้เก็บ Connection)
Modules.ChangeColor = function() 
    -- เชื่อมต่อ Heartbeat และเก็บ Connection
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


-- ฟังก์ชัน LoadingBar ที่ปรับปรุงให้แสดงชื่อไฟล์ และไม่มีการพิมพ์ข้อความสถานะระหว่างโหลด
Modules.LoadingBar = function(watermark, loadingSymbol)
    loadingSymbol = loadingSymbol or "█"
    
    local totalFiles = #FILES_TO_LOAD
    local filesLoaded = 0
    
    -- 1. สร้าง ID เฉพาะและพิมพ์ข้อความเริ่มต้น
    local uniqueID = tostring(math.random(10, 999))
    local uniqueText = string.format("[%s] ID:%s | Preparing file system...", watermark, uniqueID)
    print(uniqueText) 

    local loadingLabel = nil
    
    -- 2. ค้นหา TextLabel ที่เพิ่งพิมพ์ไป
    repeat task.wait()
        local devConsole = Modules.Services.CoreGui:FindFirstChild("DevConsoleMaster")
        if devConsole then
            -- ค้นหาโดยใช้ uniqueID เพื่อความแม่นยำ
            for _, label in pairs(devConsole:GetDescendants()) do 
                 if label:IsA("TextLabel") and string.find(label.Text, uniqueID) then 
                    loadingLabel = label 
                    break
                end 
            end 
        end
    until loadingLabel

    -- หากไม่พบ TextLabel ให้หยุดทำงาน (กรณี Console ถูกปิดหรือเปลี่ยนแปลง)
    if not loadingLabel then 
        warn("Failed to find initial DevConsole TextLabel. Stopping loading bar.")
        return 
    end
    
    local accentColor = Modules.Colors["Accent"]
    local whiteColor = Modules.Colors["Primary"]
    local errorColor = Modules.Colors["Error"]

    local startTime = os.time()
    
    -- 3. โหลดไฟล์ทีละตัว
    for i, fileData in ipairs(FILES_TO_LOAD) do
        local currentFileName = fileData.Name
        
        -- Animation แสดงชื่อไฟล์ (Pre-Load)
        for j = 1, 5 do
            local currentProgress = (i - 1) / totalFiles + (j / 5) * (1 / totalFiles)
            local percent = math.floor(currentProgress * 100)
            local barLength = math.floor(currentProgress * 30)
            
            local bar = string.rep(loadingSymbol, barLength)
            local empty = string.rep(" ", 30 - barLength)

            local textTemplate = [[<font color='rgb(%s)' size='15'>[%s] <font color='rgb(%s)'>[</font>%s<font color='rgb(%s)'>%s</font><font color='rgb(%s)'>]</font> %d%% | Loading: %s</font>]]
            
            loadingLabel.Text = string.format(
                textTemplate, 
                whiteColor, 
                watermark,
                accentColor, 
                bar, 
                whiteColor, 
                empty,
                accentColor, 
                percent,
                currentFileName
            )
            task.wait(0.05)
        end
        
        -- ดำเนินการโหลดจริง (Blocking Call)
        local success, result = pcall(function()
            task.wait(0.1) -- หน่วงเวลาจำลองการโหลด
            return loadstring(game:HttpGet(fileData.URL))()
        end)
        
        if success then
            filesLoaded = filesLoaded + 1
        end
        
        -- อัพเดท Loading Bar ให้เต็ม Step และแสดงสถานะ (Complete/Failed)
        local statusText = success and "<font color='rgb("..Modules.Colors["Success"]..")'>Complete</font>" or "<font color='rgb("..errorColor..")'>Failed</font>"
        
        local percent = math.floor((i / totalFiles) * 100)
        local barLength = math.floor((i / totalFiles) * 30)
        
        local bar = string.rep(loadingSymbol, barLength)
        local empty = string.rep(" ", 30 - barLength)

        local textTemplateFinal = [[<font color='rgb(%s)' size='15'>[%s] <font color='rgb(%s)'>[</font>%s<font color='rgb(%s)'>%s</font><font color='rgb(%s)'>]</font> %d%% | Status: %s</font>]]
        
        loadingLabel.Text = string.format(
            textTemplateFinal, 
            whiteColor, 
            watermark,
            accentColor, 
            bar, 
            whiteColor, 
            empty,
            accentColor, 
            percent,
            statusText
        )
        task.wait(0.1)
    end

    -- 4. แสดงข้อความสำเร็จแบบ NEON GREEN สุดปัง
    local finalID = tostring(math.random(10, 999)) 
    
    -- อัปเดต TextLabel ตัวสุดท้าย
    loadingLabel.Text = string.format(
        "<font color='rgb(%s)' size='18'>[%s] ID:%s | [SUCCESS]</font>", 
        Modules.Colors["NEON_GREEN"], 
        watermark, 
        finalID
    )

    -- **การแก้ไขปัญหาสำคัญ:** ตัดการเชื่อมต่อ Heartbeat Loop ทันทีที่โหลดเสร็จ
    if Modules.HeartbeatConnection then
        Modules.HeartbeatConnection:Disconnect()
        Modules.HeartbeatConnection = nil
    end
    -- (ทางเลือก: พิมพ์ข้อความจบการทำงานอีกครั้งเพื่อให้อยู่ใน Console History)


-- === การใช้งาน ===

Modules.ChangeColor()

-- เรียกใช้งาน Loading Bar
Modules.LoadingBar("Kawnew_LOAD", "█")




