-- ===== ✅ PlaceId Check =====
local PlaceId = game.PlaceId
if PlaceId ~= 2753915549 and PlaceId ~= 4442272183 and PlaceId ~= 7449423635 then
    return warn("[❌] Not supported PlaceId!")
end

-- ===== ✅ Services =====
local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ===== 🔔 Notification System =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local holder = Instance.new("Frame")
holder.Size = UDim2.new(1,0,1,0)
holder.Position = UDim2.new(0,0,0,0)
holder.BackgroundTransparency = 1
holder.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,10)
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
layout.Parent = holder

local function createNotification(message,duration)
    duration = duration or 3

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,300,0,60)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = holder

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(70,70,70)

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,-20,1,-20)
    text.Position = UDim2.new(0,10,0,10)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.fromRGB(255,255,255)
    text.TextWrapped = true
    text.Font = Enum.Font.GothamSemibold
    text.TextSize = 16
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = frame

    -- Fade In
    frame.BackgroundTransparency = 1
    text.TextTransparency = 1
    TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency=0.1}):Play()
    TweenService:Create(text, TweenInfo.new(0.3), {TextTransparency=0}):Play()

    -- Auto remove
    task.delay(duration,function()
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
        TweenService:Create(text, TweenInfo.new(0.3), {TextTransparency=1}):Play()
        task.wait(0.3)
        frame:Destroy()
    end)
end

-- ===== ✅ Whitelist Touch JumpButton =====
local whitelist = {
    LocalPlayer.PlayerGui:WaitForChild("TouchGui")
        :WaitForChild("TouchControlFrame")
        :WaitForChild("JumpButton")
}

local function IsWhitelisted(obj)
    for _, w in pairs(whitelist) do
        if obj == w or obj:IsDescendantOf(w) then
            return true
        end
    end
    return false
end

-- ===== ✅ SmartScale UI =====
local function SmartScale(asset)
    if not asset then return "" end
    local id = tostring(asset):match("%d+")
    return id and "rbxassetid://"..id or asset
end

local function ScaleUI(uiElement)
    if uiElement:IsDescendantOf(LocalPlayer.PlayerGui:FindFirstChild("TouchGui")) then return end
    if uiElement:IsA("ImageLabel") or uiElement:IsA("ImageButton") then
        uiElement.Image = SmartScale(uiElement.Image)
    end
    for _, v in pairs(uiElement:GetChildren()) do
        ScaleUI(v)
    end
end

ScaleUI(LocalPlayer.PlayerGui)

-- ===== ✅ StreamingEnabled =====
pcall(function()
    Workspace.StreamingEnabled = true
    Workspace.StreamingMinRadius = 100
    Workspace.StreamingTargetRadius = 200
end)

-- ===== ✅ Optimize Parts =====
local function OptimizeAllParts(parent)
    for _, obj in pairs(parent:GetDescendants()) do
        if (obj:IsA("Part") or obj:IsA("MeshPart")) and not IsWhitelisted(obj) then
            obj.CastShadow = false
            obj.Reflectance = 0
        end
    end
    createNotification("Optimized load!!",3)
end
OptimizeAllParts(Workspace)

-- ===== ✅ Remove ChestEffects =====
local chestEffects = ReplicatedStorage:FindFirstChild("Effect")
    and ReplicatedStorage.Effect:FindFirstChild("Container")
    and ReplicatedStorage.Effect.Container:FindFirstChild("Chests")
    and ReplicatedStorage.Effect.Container.Chests:FindFirstChild("Open")
    and ReplicatedStorage.Effect.Container.Chests.Open:FindFirstChild("ChestEffects")

if chestEffects then
    chestEffects:Destroy()
end

-- ===== ✅ Remove NPC Misc =====
local function RemoveMiscFromNPCs()
    local npcsFolder = Workspace:FindFirstChild("NPCs")
    if not npcsFolder then return end

    for _, npc in pairs(npcsFolder:GetChildren()) do  
        local hrp = npc:FindFirstChild("HumanoidRootPart")  
        if hrp then  
            local miscPart = hrp:FindFirstChild("MISC.")  
            if miscPart then  
                miscPart:Destroy()  
            end  
        end  
    end  
end
RemoveMiscFromNPCs()

-- ✅ Watch new NPC spawn
local npcsFolder = Workspace:FindFirstChild("NPCs")
if npcsFolder then
    npcsFolder.ChildAdded:Connect(function(npc)
        task.wait(1)
        local hrp = npc:FindFirstChild("HumanoidRootPart")
        if hrp then
            local miscPart = hrp:FindFirstChild("MISC.")
            if miscPart then
                miscPart:Destroy()
                warn("ลบ MISC. ออกจาก " .. npc.Name)
            end
        end
    end)
end

-- ===== ✅ Hook Death & Respawn =====
pcall(function()
    hookfunction(require(ReplicatedStorage.Effect.Container.Death), function() end)
    hookfunction(require(ReplicatedStorage.Effect.Container.Respawn), function() end)
    createNotification("All Effect Has been improved ",3)
end)

-- ===== ✅ Monitor Enemies =====
local enemiesFolder = Workspace:FindFirstChild("Enemies")
if enemiesFolder then
    spawn(function()
        while true do
            task.wait(0.1)
            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                if enemy.ClassName == "Model" then
                    local humanoid = enemy:FindFirstChild("Humanoid")
                    if humanoid then
                        local health = humanoid.Health
                        local maxHealth = humanoid.MaxHealth or 100
                        for _, part in ipairs(enemy:GetDescendants()) do
                            if part:IsA("BasePart") then
                                if health <= 0 then
                                    part.Transparency = 1
                                    part.CanCollide = false
                                elseif health >= maxHealth then
                                    part.Transparency = 0
                                    part.CanCollide = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
