--// Executor Script : Version Check + Clean Floating Announcement UI
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- Current version
local version = "2.2"
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

-- Show UI only if version changed
if lastSeen ~= version then

    local function createUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AnnouncementUI"
        ScreenGui.Parent = player:WaitForChild("PlayerGui")
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ResetOnSpawn = false

        -- Main Card
        local Card = Instance.new("Frame")
        Card.Size = UDim2.fromOffset(380, 240)
        Card.Position = UDim2.new(0.5, 0, -0.5, 0)
        Card.AnchorPoint = Vector2.new(0.5, 0.5)
        Card.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Card.BorderSizePixel = 0
        Card.Parent = ScreenGui
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Thickness = 1.5
        Stroke.Color = Color3.fromRGB(255,255,255)
        Stroke.Transparency = 0.4

        -- Shadow
        local Shadow = Instance.new("ImageLabel", Card)
        Shadow.Size = UDim2.new(1, 40, 1, 40)
        Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        Shadow.BackgroundTransparency = 1
        Shadow.Image = "rbxassetid://1316045217"
        Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.ImageTransparency = 0.65
        Shadow.ZIndex = 0

        -- Title
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -50, 0, 40)
        Title.BackgroundTransparency = 1
        Title.Text = "📢 PATCH ANNOUNCEMENT"
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 22
        Title.TextColor3 = Color3.fromRGB(255,255,255)
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Card
        Instance.new("UIPadding", Title).PaddingLeft = UDim.new(0, 16)

        -- Close Button
        local CloseButton = Instance.new("TextButton")
        CloseButton.Size = UDim2.new(0, 28, 0, 28)
        CloseButton.Position = UDim2.new(1, -36, 0, 6)
        CloseButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
        CloseButton.Text = "❌"
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.TextSize = 16
        CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
        CloseButton.Parent = Card
        Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

        -- Divider
        local Divider = Instance.new("Frame")
        Divider.Size = UDim2.new(1, -30, 0, 1)
        Divider.Position = UDim2.new(0, 15, 0, 46)
        Divider.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Divider.BackgroundTransparency = 0.6
        Divider.BorderSizePixel = 0
        Divider.Parent = Card

        -- Version Label
        local VersionLabel = Instance.new("TextLabel")
        VersionLabel.Size = UDim2.new(1, -30, 0, 28)
        VersionLabel.Position = UDim2.new(0, 16, 0, 58)
        VersionLabel.BackgroundTransparency = 1
        VersionLabel.Font = Enum.Font.GothamBold
        VersionLabel.TextSize = 18
        VersionLabel.TextColor3 = Color3.fromRGB(255,255,255)
        VersionLabel.Text = "Version: "..version
        VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
        VersionLabel.Parent = Card

        -- Sub Divider
        local SubDivider = Instance.new("Frame")
        SubDivider.Size = UDim2.new(1, -30, 0, 1)
        SubDivider.Position = UDim2.new(0, 15, 0, 90)
        SubDivider.BackgroundColor3 = Color3.fromRGB(255,255,255)
        SubDivider.BackgroundTransparency = 0.8
        SubDivider.BorderSizePixel = 0
        SubDivider.Parent = Card

        -- Content Label
        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Size = UDim2.new(1, -30, 1, -110)
        ContentLabel.Position = UDim2.new(0, 16, 0, 100)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.TextWrapped = true
        ContentLabel.Font = Enum.Font.Gotham
        ContentLabel.TextSize = 15
        ContentLabel.TextColor3 = Color3.fromRGB(220,220,220)
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        ContentLabel.Text = [[
👍🏽 Stable & Enhanced – Ensures smoother and more reliable gaming experience
➕ Optimized Performance – Removed outdated methods and applied new optimizations (KRNL, Delta not supported)
🛡️ Safe & Undetected – No new Roblox detection issues found
✨ Fastest loading map (Blox Fruit only)
        ]]
        ContentLabel.Parent = Card

        -- TweenService: Slide In
        TweenService:Create(Card, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()

        -- Close → Slide Up + Save version
        CloseButton.MouseButton1Click:Connect(function()
            local tween = TweenService:Create(Card, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, -0.5, 0)
            })
            tween:Play()
            tween.Completed:Connect(function()
                ScreenGui:Destroy()
                -- Save Patch.json
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

    createUI()
end
