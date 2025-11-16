local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local version = "Rewrite Wave2"
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
    blur.Size = 18
    blur.Parent = game:GetService("Lighting")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(460, 320)
    frame.Position = UDim2.new(0.5, 0, -0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 0.25
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.7

    local gradient = Instance.new("UIGradient", frame)
    gradient.Rotation = 45
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 0))
    }

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "📜 Update Log"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    -- Close Button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -44, 0, 16)
    close.BackgroundTransparency = 0.2
    close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    close.Text = "✖"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Parent = frame
    Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

    close.MouseEnter:Connect(function()
        TweenService:Create(close, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 40, 40)}):Play()
    end)
    close.MouseLeave:Connect(function()
        TweenService:Create(close, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)

    -- Scroll Content
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -40, 1, -80)
    scroll.Position = UDim2.new(0, 20, 0, 70)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    scroll.ScrollBarThickness = 6
    scroll.Parent = frame

    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, 0, 2, 0)
    content.BackgroundTransparency = 1
    content.TextWrapped = true
    content.Font = Enum.Font.GothamMedium
    content.TextSize = 15
    content.TextColor3 = Color3.fromRGB(240, 240, 240)
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.Text = [[
✨ 16/11/2025 Patch Notes

Beta:
• 𝗪𝗮𝗹𝗸 𝗼𝗻 𝘄𝗮𝘁𝗲𝗿 𝗶𝗺𝗽𝗿𝗼𝘃𝗲𝗱 (Fix ice gone while walking)
• 𝗟𝗼𝗻𝗴 𝗗𝗮𝘀𝗵 𝘂𝗽𝗴𝗿𝗮𝗱𝗲
     Now you can dash longer

Anti Ban:
• 𝗹𝗺𝗽𝗿𝗼𝘃𝗲 𝗮𝗻𝘁𝗶 𝗰𝗵𝗲𝗮𝘁 𝗯𝘆𝗽𝗮𝘀𝘀 (Blox Fruit)
• 𝗔𝗱𝗱 𝗻𝗲𝘄 𝗮𝗻𝘁𝗶-𝗖𝗵𝗲𝗮𝘁 𝗯𝘆𝗽𝗮𝘀 (Fish)

Ui:
• 𝗥𝗲𝗱𝗲𝘀𝗶𝗴𝗻 𝗨𝗶 𝗮𝗻𝗱 𝗶𝗺𝗽𝗿𝗼𝘃𝗲 𝗮𝗻𝗶𝗺𝗮𝘁𝗶𝗼𝗻

Performance:
• 𝗙𝗶𝘅 𝗹𝗼𝗮𝗱𝗲𝗿 𝘀𝘂𝗰𝗸 𝗮𝗻𝗱 𝗰𝗿𝗮𝘀𝗵𝗲𝗱 
• 𝗔𝗱𝗱 𝗽𝗿𝗲𝗹𝗼𝗮𝗱 𝗶𝗻 𝗮𝗹𝗹 𝗺𝗮𝗽 (load faster)

End of update!
    ]]
    content.Parent = scroll

    -- Animate frame (fade + scale) → Text จะเคลื่อนพร้อม Frame
    frame.Size = UDim2.fromOffset(0,0)
    frame.BackgroundTransparency = 1
    TweenService:Create(frame, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
        Size = UDim2.fromOffset(460, 320),
        BackgroundTransparency = 0.25,
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()

    -- Close action
    close.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0.5, 0, -0.5, 0),
            BackgroundTransparency = 1
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
end

if lastSeen ~= version then
    createUI()
end
