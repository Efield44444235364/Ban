


warn("scroll down to read warning")
-- [1] ประกาศตารางหลัก
local Modules = {}

-- [2] กำหนดชุดสี
Modules.Colors = {
    ["Success"]   = "46, 204, 113",   -- Emerald Green
    ["Warning"]   = "241, 196, 15",   -- Sun Yellow
    ["Info"]      = "52, 152, 219",   -- Bright Blue
    ["Error"]     = "231, 76, 60",    -- Alizarin Red
    ["Accent"]    = "155, 89, 182",   -- Amethyst Purple
    ["Primary"]   = "149, 165, 166",  -- Silver
    ["NeonGreen"] = "57, 255, 20",     -- Neon Green
    ["White"] = "255, 255, 255"
}

-- [3] เปลี่ยนสีใน DevConsole (ให้ TextLabel รองรับ RichText)
Modules.ChangeColor = function() 
    game:GetService("RunService").Heartbeat:Connect(function()
        local devConsole = game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster")
        if devConsole then 
            for _, v in pairs(devConsole:GetDescendants()) do 
                if v:IsA("TextLabel") then 
                    v.RichText = true 
                end 
            end 
        end
    end)
end

-- [4] ฟังก์ชัน print แบบปรับสีและขนาดได้
Modules.print = function(color, text, size)
	if not Modules.Colors[color] then 
		warn("Color key '" .. tostring(color) .. "' was not found! Using 'Primary' color.")
		color = "Primary"
	end 
	
    local Text = '<font color="rgb(' .. Modules.Colors[color] .. ')"'
    if size then
        Text = Text .. ' size="' .. tostring(size) .. '"'
    end
    Text = Text .. '>' .. tostring(text) .. '</font>'
    
    print(Text)
end

-- === การใช้งานจริง ===
Modules.ChangeColor()

-- [5] ข้อความเตือนเรื่องความเสี่ยง (Warning)
local riskWarning = "<font size=\"24\">⚠️ ACCOUNT SECURITY & RISK WARNING ⚠️</font>\n\n"
riskWarning = riskWarning .. "You are attempting to engage with a <font color=\"rgb(" .. Modules.Colors["Error"] .. ")\">third-party modification</font> that is considered exploitative.\n\n"
riskWarning = riskWarning .. "<font size=\"18\">READ CAREFULLY:</font>\n"
riskWarning = riskWarning .. " • <font color=\"rgb(" .. Modules.Colors["Error"] .. ")\">NO FULL PROTECTION:</font> We <b>cannot guarantee</b> your account's safety at any time.\n"
riskWarning = riskWarning .. " • <font color=\"rgb(" .. Modules.Colors["Warning"] .. ")\">ANTI-CHEAT DETECTION:</font> Roblox’s detection systems <b>actively monitor</b> such behavior and may trigger <b>immediate suspension or termination</b>.\n"
riskWarning = riskWarning .. " • <font color=\"rgb(" .. Modules.Colors["Accent"] .. ")\">YOUR RESPONSIBILITY:</font> By continuing, you accept <b>all potential risks</b> including loss of data, assets, or account.\n\n"
riskWarning = riskWarning .. "<font color=\"rgb(" .. Modules.Colors["NeonGreen"] .. ")\">Proceed only if you understand the irreversible consequences.</font>"

-- [6] แทรกข้อความเวอร์ชันและสถานะเข้าไปใน riskWarning (หลังจากเว้น 3 บรรทัด)
riskWarning = riskWarning .. "\n\n\n\n"
riskWarning = riskWarning .. "<font color=\"rgb(" .. Modules.Colors["White"] .. ")\">© 2025 Kawnew Software Development All Rights Reserved</font>\n"
riskWarning = riskWarning .. "<font color=\"rgb(" .. Modules.Colors["White"] .. ")\">Version Beta</font>\n"
riskWarning = riskWarning .. "\nKawnew luau: <font color=\"rgb(" .. Modules.Colors["Success"] .. ")\">Stable</font> ✅"

-- [7] แสดงทั้งหมดใน print เดียว
Modules.print("Warning", riskWarning)

return Modules
