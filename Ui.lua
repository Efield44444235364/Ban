--// Executor Script : Announcement + Patch.json system


-- เวอร์ชันปัจจุบัน (เปลี่ยนตรงนี้ตอนมีอัพเดทใหม่)
local version = "1.7.1 rewrite"
local fileName = "Patch.json"

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- อ่านไฟล์ Patch.json
local lastSeen = nil
if isfile(fileName) then
    local data = readfile(fileName)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(data)
    end)
    if ok and decoded.Version then
        lastSeen = decoded.Version
    end
end

-- ฟังก์ชันสร้าง UI
local function createUI()
    --// ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AnnouncementUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false

    --// Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(450, 280)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    -- Rounded corners + Shadow
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
    local Shadow = Instance.new("UIStroke", MainFrame)
    Shadow.Thickness = 2
    Shadow.Color = Color3.fromRGB(70, 130, 255)
    Shadow.Transparency = 0.25

    -- Gradient background
    local UIGradient = Instance.new("UIGradient", MainFrame)
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 100, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 50, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 20, 70))
    }
    UIGradient.Rotation = 0

    -- Title Bar
    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, -40, 0, 40)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Text = "📢 Announcement | Rewrite All Scripts"
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextSize = 22
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.TextXAlignment = Enum.TextXAlignment.Left
    TitleBar.Parent = MainFrame
    local TitlePadding = Instance.new("UIPadding", TitleBar)
    TitlePadding.PaddingLeft = UDim.new(0, 16)

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.Position = UDim2.new(1, -38, 0, 4)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.Text = "❌"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 20
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.AutoButtonColor = true
    CloseButton.Parent = MainFrame
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 16)

    CloseButton.MouseEnter:Connect(function()
        CloseButton.BackgroundTransparency = 0
    end)
    CloseButton.MouseLeave:Connect(function()
        CloseButton.BackgroundTransparency = 0.2
    end)

    -- Divider
    local Divider = Instance.new("Frame", MainFrame)
    Divider.Size = UDim2.new(1, -30, 0, 2)
    Divider.Position = UDim2.new(0, 15, 0, 44)
    Divider.BackgroundColor3 = Color3.fromRGB(120, 180, 255)
    Divider.BackgroundTransparency = 0.4
    Divider.BorderSizePixel = 0

    -- Scroll Content
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -70)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    ScrollingFrame.Parent = MainFrame
    local Padding = Instance.new("UIPadding", ScrollingFrame)
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.PaddingTop = UDim.new(0, 8)

    -- Content Label
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -10, 0, 600)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.TextWrapped = true
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 16
    ContentLabel.TextColor3 = Color3.fromRGB(230, 240, 255)
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.Parent = ScrollingFrame

    -- Fixed English text + เพิ่มเลขเวอร์ชัน
    local englishText = [[
📢 Update Log ]].."\n\nVersion: "..version..[[

🚪 Add bypass Temple of time 
🛡️ Blox Fruit Anti-Reset now active (beta)
🚀 All Script smooth now 
🔧 Fix Lag when Execute scriptu

      ✅ Zero Error Coming soon
      👀 Beta test closer!!! new features is coming!!
    ]]
    ContentLabel.Text = englishText

    -- Gradient rotation animation
    task.spawn(function()
        while true do
            for rot = 0, 360, 1 do
                UIGradient.Rotation = rot
                task.wait(0.02)
            end
        end
    end)

    -- TweenService
    local TweenService = game:GetService("TweenService")

    -- Popup Animation
    MainFrame.Visible = true
    MainFrame.Size = UDim2.fromOffset(0, 0)
    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.fromOffset(450, 280)})
    tween:Play()

    -- Close Animation
    CloseButton.MouseButton1Click:Connect(function()
        local tweenInfoExpand = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tweenExpand = TweenService:Create(MainFrame, tweenInfoExpand, {
            Size = UDim2.fromOffset(500, 320),
            BackgroundTransparency = 0
        })
        local tweenInfoShrink = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local tweenShrink = TweenService:Create(MainFrame, tweenInfoShrink, {
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        })
        tweenExpand:Play()
        tweenExpand.Completed:Connect(function()
            tweenShrink:Play()
        end)
        tweenShrink.Completed:Connect(function()
            MainFrame.Visible = false
            MainFrame.Size = UDim2.fromOffset(450, 280)
            MainFrame.BackgroundTransparency = 0
        end)
    end)

    -- Draggable UI
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    TitleBar.InputEnded:Connect(function()
        dragging = false
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- แสดง UI ก็ต่อเมื่อเวอร์ชันเปลี่ยน
if lastSeen ~= version then
    createUI()
    -- เขียน Patch.json ใหม่
    local data = {
        Version = version,
        SeenAt = os.date("%Y-%m-%d %H:%M:%S")
    }
    writefile(fileName, HttpService:JSONEncode(data))
end

print("load")
