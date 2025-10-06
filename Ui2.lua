--// Executor Script : Version Check + Minimal Green Scrollable UI
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- Current version
local version = "Taylor Swift" -- เวอร์ชันใหม่
local fileName = "Patch.json"

-- Read old version
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

-- Function to create the UI
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AnnouncementUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false

    -- Main Card
    local Card = Instance.new("Frame")
    Card.Size = UDim2.fromOffset(360, 260)
    Card.Position = UDim2.new(0.5, 0, -0.5, 0)
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.BackgroundColor3 = Color3.fromRGB(220, 245, 220) -- เขียวอ่อนมินิมอล
    Card.BorderSizePixel = 0
    Card.Parent = ScreenGui
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 32)
    Title.Position = UDim2.new(0, 20, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = "Patch Announcement"
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(35, 90, 40) -- เขียวเข้ม
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Card

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -36, 0, 12)
    CloseButton.BackgroundColor3 = Color3.fromRGB(180, 230, 180)
    CloseButton.Text = "❌"
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.TextSize = 16
    CloseButton.TextColor3 = Color3.fromRGB(35, 90, 40)
    CloseButton.Parent = Card
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1,0)

    -- Divider
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 0, 60)
    Divider.BackgroundColor3 = Color3.fromRGB(180, 220, 180)
    Divider.BorderSizePixel = 0
    Divider.Parent = Card

    -- Version Label
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(1, -40, 0, 28)
    VersionLabel.Position = UDim2.new(0, 20, 0, 66)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Font = Enum.Font.GothamSemibold
    VersionLabel.TextSize = 16
    VersionLabel.TextColor3 = Color3.fromRGB(35, 90, 40)
    VersionLabel.Text = "Version: "..version
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = Card

    -- Scrollable Content
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -40, 1, -110)
    ScrollFrame.Position = UDim2.new(0, 20, 0, 100)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- กำหนดสูงเริ่มต้น (สามารถปรับได้ตาม Content)
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.Parent = Card

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, 0, 2, 0) -- ยาวกว่า ScrollFrame ให้ Scroll
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.TextWrapped = true
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 14
    ContentLabel.TextColor3 = Color3.fromRGB(50, 110, 50)
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.Text = [[
6/10/2025 Update

Performance Improvements:

Blox Fruits and all maps optimized for smoother FPS Optimizer improvements applied this version runs fast as fuck

User Interface:

Refreshed UI design with minimal clean green theme for easier navigation.

Beta Features

Long dash feature added (currently in beta may contain minor bugs)

Anti-Cheat Bypass:

Full bypass for Blox Fruits and Fish but its maybe got some ban or permanent ban!!! OK?

Miscellaneous:

Various minor bug fixes and stability improvements.
General performance enhancements for low-end devices.

End of update!
    ]]
    ContentLabel.Parent = ScrollFrame

    -- TweenService: Slide In
    TweenService:Create(Card, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5,0,0.5,0)
    }):Play()

    -- Close → Slide Up + Save version
    CloseButton.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, -0.5, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            ScreenGui:Destroy()
            local data = {
                Version = version,
                SeenAt = os.date("%Y-%m-%d %H:%M:%S")
            }
            writefile(fileName, HttpService:JSONEncode(data))
        end)
    end)

    -- Draggable UI
    local dragging, dragStart, startPos
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Card.Position
        end
    end)
    Title.InputEnded:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Show UI only if version changed
if lastSeen ~= version then
    createUI()
end
