-- ✅ ตรวจสอบแมพ
local allowedPlaces = {
    [2753915549] = true,
    [7449423635] = true,
    [4442272183] = true,
    [168556275] = true
}

if not allowedPlaces[game.PlaceId] then
    warn("Script Down")
    return
end

-- ✅ ชื่อไฟล์สำหรับจดจำว่ามีการแสดง Blur ไปแล้วหรือยัง
local blurFile = "ScriptDown.json"

local hasBlurred = false
if isfile and isfile(blurFile) then
    hasBlurred = true
end

-- 🌫️ ถ้าเคยเบลอแล้ว → แสดงแค่ Notification ของ Roblox แล้วหยุดตรงนี้
if hasBlurred then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ℹ️ Notification",
        Text = "⚠️ Script Down For a While",
        Duration = 4
    })
    return
end

-- 🧠 บันทึกว่าเคยเบลอแล้ว
if writefile then
    writefile(blurFile, "shown")
end


-- 🌫️ โหลดบริการ
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- 🌫️ Blur พื้นหลัง
local blur = Instance.new("BlurEffect")
blur.Parent = Lighting
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(1), {Size = 32}):Play()

-- 🖼️ สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "iOSNotificationUI"
ScreenGui.Parent = game.CoreGui

-- 🖼️ Frame หลัก
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.fromScale(0.5, 0.3)
Frame.Position = UDim2.fromScale(0.25, 0.35)
Frame.ClipsDescendants = true

-- 🏷️ Title
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "Notification"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Size = UDim2.fromScale(1, 0.3)
Title.Position = UDim2.fromScale(0, 0)
Title.BackgroundTransparency = 1
Title.TextTransparency = 1

-- ━━━ เส้นขีด
local Line = Instance.new("Frame")
Line.Parent = Frame
Line.BackgroundColor3 = Color3.new(1, 1, 1)
Line.Size = UDim2.new(0, 0, 0, 2)
Line.Position = UDim2.new(0.5, 0, 0.35, 0)
Line.AnchorPoint = Vector2.new(0.5, 0)
Line.BorderSizePixel = 0
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = Line

-- 📝 Body
local Body = Instance.new("TextLabel")
Body.Parent = Frame
Body.Text = "⚠️ Script Down for a while\nWe’re rewriting and fixing all functions."
Body.TextColor3 = Color3.new(1, 1, 1)
Body.Font = Enum.Font.Gotham
Body.TextScaled = true
Body.Size = UDim2.fromScale(1, 0.4)
Body.Position = UDim2.fromScale(0, 0.5)
Body.BackgroundTransparency = 1
Body.TextTransparency = 1

-- ▶️ แอนิเมชันเปิด UI
TweenService:Create(Frame, TweenInfo.new(0.2), {}):Play()
task.wait(0.2)

TweenService:Create(Title, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
task.wait(0.4)

TweenService:Create(Line, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(0.8, 0, 0, 2)
}):Play()
task.wait(0.8)

TweenService:Create(Body, TweenInfo.new(1), {TextTransparency = 0}):Play()

-- ⏳ fade ออก
task.delay(7, function()
	TweenService:Create(Body, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
	TweenService:Create(Title, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
	TweenService:Create(Line, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(1), {Size = 0}):Play()
	task.wait(1)
	ScreenGui:Destroy()
	blur:Destroy()
end)
