local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

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

    -- แจ้งเตือนเมื่อ Optimize เสร็จ
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "BloxFruits Optimizer",
            Text = "Workspace Parts Optimized (Safe JumpButton)",
            Duration = 3
        })
    end)
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
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "BloxFruits Optimizer",
            Text = "ChestEffects Removed",
            Duration = 3
        })
    end)
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

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "BloxFruits Optimizer",
            Text = "NPC Misc Removed",
            Duration = 3
        })
    end)
end

RemoveMiscFromNPCs()

-- ✅ เฝ้าระวัง NPC ใหม่ spawn มา
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

-- ✅ Hook Death & Respawn Effect
pcall(function()
    hookfunction(require(ReplicatedStorage.Effect.Container.Death), function() end)
    hookfunction(require(ReplicatedStorage.Effect.Container.Respawn), function() end)

    StarterGui:SetCore("SendNotification", {
        Title = "BloxFruits Optimizer",
        Text = "Death & Respawn Hooked",
        Duration = 3
    })
end)

-- ✅ Monitor Enemies: Invisible/UnInvisible
local enemiesFolder = Workspace:FindFirstChild("Enemies")

local function monitorEnemy(enemy)
    if enemy.ClassName ~= "Model" then return end
    local humanoid = enemy:FindFirstChild("Humanoid")
    if not humanoid then return end

    humanoid.HealthChanged:Connect(function(health)
        local maxHealth = humanoid.MaxHealth or 100

        if health <= 0 then
            for _, part in ipairs(enemy:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    part.CanCollide = false
                end
            end
        elseif health >= maxHealth then
            for _, part in ipairs(enemy:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end
    end)
end

if enemiesFolder then
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        monitorEnemy(enemy)
    end

    enemiesFolder.ChildAdded:Connect(monitorEnemy)

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "BloxFruits Optimizer",
            Text = "Enemies Visibility Monitored",
            Duration = 3
        })
    end)
end
