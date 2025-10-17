-- ตั้งค่า key
getgenv().AUTH_KEY = getgenv().AUTH_KEY or ""
local key = getgenv().AUTH_KEY

-- helper: คัดลอกลิงก์แล้วเตะ
local function copy_and_kick(kick_msg)
    pcall(function() setclipboard("https://authguard.org/a/1561?id=") end)
    task.wait(0.05)
    local plr = game:GetService("Players").LocalPlayer
    if plr then plr:Kick(kick_msg) end
end

-- ถ้าไม่มี key ให้คัดลอกแล้วเตะ
if key == "" or key == "YOUR_KEY_HERE" then
    copy_and_kick("Key Not Found!! pls go to getkey bitch!!")
    return
end

-- ถ้า key มีค่า ให้ตรวจกับ AuthGuard (ถ้ามี)
if AuthGuard and type(AuthGuard.ValidateKey) == "function" then
    local ok, res = pcall(function()
        return AuthGuard.ValidateKey({ Service = __SERVICE_ID__, Key = key })
    end)
    if not ok or res == "invalid" then
        -- ถ้า validate ไม่ผ่าน หรือเกิด error -> คัดลอกแล้วเตะด้วยข้อความที่ขอ
        copy_and_kick("wrong key go get real key bitch")
        return
    end
end

local StarterGui = game:GetService("StarterGui")

-- ฟังก์ชันย่อ notify(title, text, duration)
local function notify(t, msg, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = t or "Notification",
            Text = msg or "",
            Duration = dur or 5,
           -- Button1 = "OK"
        })
    end)
end

-- โหลดสคริปต์ตามสถานะ (premium / free)
local isFreeUser = false -- ณ จุดนี้ key ผ่านการ validate
if AG_IsPremium then
    print("premium user😎")
    notify("Premium user😎", "Script is loading pls wait 4-10sec", 6)
    _G.efield_loader = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/Loader.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/BetaFunction.lua"))()
else
    print("free user😘")
    notify("Normal user 😘", "Script is loading pls wait 4-10 sec", 6)
    _G.efield_loader = true
loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/FreeLoader.lua"))()
end
