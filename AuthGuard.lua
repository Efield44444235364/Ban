print("loading")

-- Photo Load
loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/KawnewLogo/refs/heads/main/Loader.lua"))()
--FPS BOOST
loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/FpsBoost1.lua"))()
--FPS BOOST2
loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ban/refs/heads/main/FPSBoost2.lua"))()


game:GetService("RunService"):Set3dRenderingEnabled(true)


-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Redesigned Colors (Darker, High Contrast)
-- ใช้สีที่ดูโมเดิร์นขึ้น แต่ยังคงธีมส้ม/ดำ
local OUTER_COLOR = Color3.fromRGB(15, 15, 15)      -- ดำสนิทเกือบ 100% สำหรับพื้นหลัง/เงา
local INNER_COLOR = Color3.fromRGB(180, 75, 5)      -- ส้มไหม้/อิฐเข้ม (ดูหรูขึ้น)
local TEXT_MAIN = Color3.fromRGB(255, 240, 220)     -- Off-White/ครีม
local TEXTACCENTTOP = Color3.fromRGB(255, 170, 0)   -- ส้มทอง
local TEXTACCENTBOTTOM = Color3.fromRGB(255, 90, 0) -- ส้มไฟ

-- Get universal map name
local mapName = "Unknown map"
do
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        mapName = info.Name
    end
end

-- Root UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Name = "KawnewModernHalloweenUI"
ScreenGui.Parent = game.CoreGui

-- Outer frame (Main Container - now acting more like a clean border/shadow)
local outerFrame = Instance.new("Frame")
outerFrame.Name = "Outer"
outerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
outerFrame.Position = UDim2.new(0.5, 0, -0.2, 0)
outerFrame.Size = UDim2.new(0, 420, 0, 240) 
outerFrame.BackgroundColor3 = OUTER_COLOR
outerFrame.BorderSizePixel = 0
outerFrame.Parent = ScreenGui

-- Modern Corners (Radius เพิ่มขึ้นเล็กน้อย)
local outerCorner = Instance.new("UICorner", outerFrame)
outerCorner.CornerRadius = UDim.new(0, 20)

-- Inner frame (Content Area)
local bgFrame = Instance.new("Frame")
bgFrame.Name = "Inner"
bgFrame.AnchorPoint = Vector2.new(0.5, 0.5)
bgFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
bgFrame.Size = UDim2.new(0, 410, 0, 230) 
bgFrame.BackgroundColor3 = INNER_COLOR
bgFrame.BorderSizePixel = 0
bgFrame.Parent = outerFrame

local bgCorner = Instance.new("UICorner", bgFrame)
bgCorner.CornerRadius = UDim.new(0, 18) 

-- Left image (The Halloween Art)
local image = Instance.new("ImageLabel")
image.Name = "Art"
image.AnchorPoint = Vector2.new(0, 0.5)
image.Position = UDim2.new(0, 20, 0.5, 0)
image.Size = UDim2.new(0, 180, 0, 180) -- ขยายรูปให้ใหญ่ขึ้น
image.BackgroundTransparency = 1

-- **แก้ไข: กลับไปใช้การเรียกใช้รูปภาพตามต้นฉบับ**
local imagePath = "Kawnew/Kawnew_Halloween.jpg"
if getcustomasset then
    image.Image = getcustomasset(imagePath)
else
    image.Image = "rbxassetid://PUTYOURIMAGE_ID"
end
-- **สิ้นสุดการแก้ไข**

image.Parent = bgFrame

local imgCorner = Instance.new("UICorner", image)
imgCorner.CornerRadius = UDim.new(0, 12) 

local imgStroke = Instance.new("UIStroke", image)
imgStroke.Thickness = 5
imgStroke.Color = Color3.fromRGB(0, 0, 0)
imgStroke.Transparency = 0.3 

-- Right side layout (for title + body text)
local rightHolder = Instance.new("Frame")
rightHolder.Name = "Right"
rightHolder.AnchorPoint = Vector2.new(0, 0.5)
rightHolder.Position = UDim2.new(0, 220, 0.5, 0) 
rightHolder.Size = UDim2.new(0, 175, 0, 180)    
rightHolder.BackgroundTransparency = 1
rightHolder.Parent = bgFrame

local padding = Instance.new("UIPadding", rightHolder)
padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 5)
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)

local vlist = Instance.new("UIListLayout", rightHolder)
vlist.FillDirection = Enum.FillDirection.Vertical
vlist.HorizontalAlignment = Enum.HorizontalAlignment.Left
vlist.VerticalAlignment = Enum.VerticalAlignment.Top
vlist.SortOrder = Enum.SortOrder.LayoutOrder
vlist.Padding = UDim.new(0, 10) 

-- Title: Happy Halloween (bigger + gradient)
local title = Instance.new("TextLabel")
title.Name = "Title"
title.LayoutOrder = 1
title.Size = UDim2.new(1, 0, 0, 40) 
title.BackgroundTransparency = 1
title.Text = "Happy Halloween 🎃" 
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = TEXT_MAIN
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = rightHolder

local titleGradient = Instance.new("UIGradient", title)
titleGradient.Rotation = 90
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, TEXTACCENTTOP),
    ColorSequenceKeypoint.new(1.0, TEXTACCENTBOTTOM),
})
-- **แก้ไข: ลบ UIStroke ที่สร้างขอบดำออก**
-- local titleStroke = Instance.new("UIStroke", title) -- ถูกลบ

-- Scroll area for long text
local scrollText = Instance.new("ScrollingFrame")
scrollText.Name = "BodyScroll"
scrollText.LayoutOrder = 2
scrollText.Size = UDim2.new(1, 0, 1, -50) 
scrollText.BackgroundTransparency = 1
scrollText.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollText.ScrollBarThickness = 5
scrollText.ScrollBarImageColor3 = Color3.fromRGB(80, 40, 20) 
scrollText.Parent = rightHolder

local bodyPadding = Instance.new("UIPadding", scrollText)
bodyPadding.PaddingTop = UDim.new(0, 2)

local body = Instance.new("TextLabel")
body.Name = "Body"
body.Size = UDim2.new(1, -2, 0, 0)
body.BackgroundTransparency = 1
body.TextWrapped = true
body.TextYAlignment = Enum.TextYAlignment.Top
body.TextXAlignment = Enum.TextXAlignment.Left
body.Font = Enum.Font.GothamMedium 
body.TextColor3 = TEXT_MAIN
body.TextSize = 15
body.AutomaticSize = Enum.AutomaticSize.Y
body.Parent = scrollText

-- Compose readable body text with spacing and cleaned punctuation
local bodyTextLines = {
    "Happy Halloween Everyone 🎃🤩👻",
    "FPS Boost Active. Enjoy a smooth experience!",
    "Happy farming! 👻",
}

body.Text = table.concat(bodyTextLines, "\n\n")

-- Update canvas size when text changes
local function updateCanvas()
    scrollText.CanvasSize = UDim2.new(0, 0, 0, body.TextBounds.Y)
end
updateCanvas()
body:GetPropertyChangedSignal("TextBounds"):Connect(updateCanvas)

-- 3. Dynamic Entrance Animation (Scale & Slide)
image.ImageTransparency = 1
TweenService:Create(image, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()

-- Slide-down & slight Scale-in animation for the whole UI
outerFrame.Size = UDim2.new(0, 400, 0, 220) -- Start slightly smaller (ก่อนจะขยายเข้า)

TweenService:Create(
    outerFrame,
    TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), -- ใช้ Elastic เพื่อให้ดูมีชีวิตชีวา
    { 
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 420, 0, 240) -- ขยายกลับไปที่ขนาดจริง
    }
):Play()

-- Dragging logic (touch + mouse)
do
    local dragging = false
    local dragStart, startPos

    outerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = outerFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            outerFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end
