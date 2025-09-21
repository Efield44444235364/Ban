-- ===== PlaceId Check =====  
local PlaceId = game.PlaceId  
if PlaceId ~= 2753915549 and PlaceId ~= 4442272183 and PlaceId ~= 7449423635 then  
    return warn("[❌] Not supported PlaceId!")  
end  

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- 🔔 Notification System
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

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    holder.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end)

local function createNotification(message,duration)
    duration = duration or 3
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,300,0,60)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = holder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = frame

    local shadow = Instance.new("UIStroke")
    shadow.Thickness = 1
    shadow.Color = Color3.fromRGB(70,70,70)
    shadow.Transparency = 0.4
    shadow.Parent = frame

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

    frame.BackgroundTransparency = 1
    text.TextTransparency = 1
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency=0.1})
    local tweenTextIn = TweenService:Create(text, TweenInfo.new(0.3), {TextTransparency=0})
    tweenIn:Play()
    tweenTextIn:Play()

    task.delay(duration,function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency=1})
        local tweenTextOut = TweenService:Create(text, TweenInfo.new(0.3), {TextTransparency=1})
        tweenOut:Play()
        tweenTextOut:Play()
        tweenOut.Completed:Wait()
        frame:Destroy()
    end)
end

-- ✅ Whitelist Touch JumpButton
local whitelist = {
    LocalPlayer.PlayerGui:WaitForChild("TouchGui"):WaitForChild("TouchControlFrame"):WaitForChild("JumpButton")
}

local function IsWhitelisted(obj)
    for _, w in pairs(whitelist) do
        if obj == w or obj:IsDescendantOf(w) then
            return true
        end
    end
    return false
end

-- ✅ SmartScale สำหรับ UI
local function SmartScale(asset)
    if not asset then return "" end
    local id = tostring(asset):match("%d+")
    if id then
        return "rbxassetid://" .. id
    else
        return asset
    end
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

-- ✅ StreamingEnabled
pcall(function()
    Workspace.StreamingEnabled = true
    Workspace.StreamingMinRadius = 100
    Workspace.StreamingTargetRadius = 200
end)

-- ✅ ปิดเงา / แสงสะท้อน ทุก Part / MeshPart ของ Workspace
local function OptimizeAllParts(parent)
    for _, obj in pairs(parent:GetDescendants()) do
        if (obj:IsA("Part") or obj:IsA("MeshPart")) and not IsWhitelisted(obj) then
            obj.CastShadow = false
            obj.Reflectance = 0
        end
    end
    createNotification("Optimized load",3)
end

OptimizeAllParts(Workspace)

-- ✅ ลบ ChestEffects
local chestEffects = ReplicatedStorage:FindFirstChild("Effect") 
                   and ReplicatedStorage.Effect:FindFirstChild("Container") 
                   and ReplicatedStorage.Effect.Container:FindFirstChild("Chests") 
                   and ReplicatedStorage.Effect.Container.Chests:FindFirstChild("Open") 
                   and ReplicatedStorage.Effect.Container.Chests.Open:FindFirstChild("ChestEffects")

if chestEffects then
    chestEffects:Destroy()
    createNotification("ChestEffects Removed",3)
end

-- ✅ ลบ Part "MISC." ใน HumanoidRootPart ของ NPC ทุกตัว
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

    createNotification("NPC Misc Removed",3)
end

RemoveMiscFromNPCs()

-- ✅ เฝ้าระวัง NPC ใหม่ spawn
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

-- ✅ Hook Death & Respawn
pcall(function()
    hookfunction(require(ReplicatedStorage.Effect.Container.Death), function() end)
    hookfunction(require(ReplicatedStorage.Effect.Container.Respawn), function() end)
    createNotification("Death & Respawn Hooked",3)
end)

-- ✅ Monitor Enemies + Reduce Size + Limit Display
local enemiesFolder = Workspace:FindFirstChild("Enemies")
if enemiesFolder then
    local optimizedEnemies = {}

    local function optimizeEnemy(enemy)
        if optimizedEnemies[enemy] then return end
        optimizedEnemies[enemy] = true

        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
        if rootPart then
            enemy:SetPrimaryPartCFrame(rootPart.CFrame)
            for _, part in ipairs(enemy:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * 0.8
                end
            end
        end
    end

    local function monitorEnemy(enemy)
        if enemy.ClassName ~= "Model" then return end
        optimizeEnemy(enemy)

        local humanoid = enemy:FindFirstChild("Humanoid")
        if not humanoid then return end

        humanoid.HealthChanged:Connect(function(health)
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
        end)
    end

    local function updateVisibility()
        local allEnemies = {}
        for _, e in ipairs(enemiesFolder:GetChildren()) do
            if e:IsA("Model") then
                table.insert(allEnemies,e)
            end
        end
        local limit = 3
        for i, e in ipairs(allEnemies) do
            for _, part in ipairs(e:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = (i <= limit) and 0.8 or 1 -- แสดงเฉพาะ 2-3 ตัว
                    part.CanCollide = (i <= limit)
                end
            end
        end
    end

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        monitorEnemy(enemy)
    end

    enemiesFolder.ChildAdded:Connect(function(enemy)
        monitorEnemy(enemy)
    end)

    spawn(function()
        while true do
            task.wait(0.2)
            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                optimizeEnemy(enemy)
            end
            updateVisibility()
        end
    end)

    createNotification("Enemies Monitored + Size Reduced + Limited Display",3)
end
