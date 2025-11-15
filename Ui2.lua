local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local version = "Rewrite"
local fileName = "Patch.json"

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

local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "AmbientUpdateLog"
    gui.Parent = player:WaitForChild("PlayerGui")
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local blur = Instance.new("BlurEffect")
    blur.Size = 12
    blur.Parent = game:GetService("Lighting")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(420, 300)
    frame.Position = UDim2.new(0.5, 0, -0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 0.4
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

    local gradient = Instance.new("UIGradient", frame)
    gradient.Rotation = 0
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 0))
    }

    -- Animate gradient rotation
    task.spawn(function()
        while gui.Parent do
            gradient.Rotation = (gradient.Rotation + 1) % 360
            task.wait(0.03)
        end
    end)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 36)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "Update Log"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -36, 0, 16)
    close.BackgroundTransparency = 0.3
    close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    close.Text = "✖"
    close.Font = Enum.Font.Gotham
    close.TextSize = 16
    close.TextColor3 = Color3.fromRGB(0, 0, 0)
    close.Parent = frame
    Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -40, 1, -80)
    scroll.Position = UDim2.new(0, 20, 0, 60)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    scroll.ScrollBarThickness = 6
    scroll.Parent = frame

    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, 0, 2, 0)
    content.BackgroundTransparency = 1
    content.TextWrapped = true
    content.Font = Enum.Font.Gotham
    content.TextSize = 14
    content.TextColor3 = Color3.fromRGB(255, 255, 255)
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.Text = [[
🔧 7/10/2025 Patch Notes

Performance:
• FPS Optimizer overhaul for Blox Fruits
• Smoother gameplay on all maps

UI:
• Ambient redesign with animated gradients
• Minimal layout, better readability

 Beta:
• Long dash feature improve 
• fix character freeze while dash

 Anti-Cheat:
• Full bypass for Blox Fruits & Fish
• ⚠️ Risk of ban still exists!

 Misc:
• Minor bug fixes
• Better support for low-end devices

 End of update!
    ]]
    content.Parent = scroll

    TweenService:Create(frame, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()

    close.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0.5, 0, -0.5, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            gui:Destroy()
            blur:Destroy()
            local data = {
                Version = version,
                SeenAt = os.date("%Y-%m-%d %H:%M:%S")
            }
            writefile(fileName, HttpService:JSONEncode(data))
        end)
    end)

    -- Dragging
    local dragging, dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    title.InputEnded:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

if lastSeen ~= version then
    createUI()
end
