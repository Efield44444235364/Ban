-- MADE BY RIP#6666 (Revised by AI - Fixed Coroutine Call Error)
-- send issues or suggestions to my discord: discord.gg/rips

-- ====================================================================
--                      การตั้งค่า & Global Variables
-- ====================================================================
local RunService = game:GetService("RunService")

-- ตรวจสอบสถานะ Toggle และดำเนินการตามคำขอ
if _G.RenderingToggle == true then
    -- สถานะปัจจุบันคือ FPS Booster (ปิด 3D Rendering)
    
    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    
    _G.RenderingToggle = false
    warn("FPS Booster ถูกปิด: 3D Rendering ถูกเปิด (true) และสคริปต์หยุดทำงาน.")
    return
else
    -- สถานะปัจจุบันคือ FPS Booster ถูกปิดอยู่ หรือเป็นการรันครั้งแรก
    
    pcall(function() RunService:Set3dRenderingEnabled(false) end)
    
    _G.RenderingToggle = true
    warn("FPS Booster ถูกเปิด: 3D Rendering ถูกปิด (false) และเริ่ม FPS Booster (รวม Low Quality Parts).")
end


-- ====================================================================
--                      FPS BOOSTER SCRIPT START
-- ====================================================================

if not _G.Ignore then
    _G.Ignore = {}
end
if _G.ConsoleLogs == nil then
    _G.ConsoleLogs = false
end

if not game:IsLoaded() then
    repeat
        task.wait()
    until game:IsLoaded()
end

-- การตั้งค่า
if not _G.Settings then
    _G.Settings = {
        Players = {
            ["Ignore Me"] = true,
            ["Ignore Others"] = true,
            ["Ignore Tools"] = true
        },
        Meshes = {
            NoMesh = false,
            NoTexture = false,
            Destroy = false
        },
        Images = {
            Invisible = true,
            Destroy = false
        },
        Explosions = {
            Smaller = true,
            Invisible = false,
            Destroy = false
        },
        Particles = {
            Invisible = true,
            Destroy = false
        },
        TextLabels = {
            LowerQuality = false,
            Invisible = false,
            Destroy = false
        },
        MeshParts = {
            LowerQuality = true,
            Invisible = false,
            NoTexture = false,
            NoMesh = false,
            Destroy = false
        },
        Other = {
            ["FPS Cap"] = true,
            ["No Camera Effects"] = true,
            ["No Clothes"] = true,
            ["Low Water Graphics"] = true,
            ["No Shadows"] = true,
            ["Low Rendering"] = true,
            ["Low Quality Parts"] = true, 
            ["Low Quality Models"] = true,
            ["Reset Materials"] = true,
            ["Lower Quality MeshParts"] = true,
            ClearNilInstances = false
        }
    }
end

local Players, Lighting, MaterialService = game:GetService("Players"), game:GetService("Lighting"), game:GetService("MaterialService")
local Workspace = game:GetService("Workspace")
local ME, CanBeEnabled = Players.LocalPlayer, {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}

local function PartOfCharacter(Inst)
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= ME and v.Character and Inst:IsDescendantOf(v.Character) then
            return true
        end
    end
    return false
end

local function DescendantOfIgnore(Inst)
    for i, v in pairs(_G.Ignore) do
        if Inst:IsDescendantOf(v) then
            return true
        end
    end
    return false
end

local function CheckIfBad(Inst)
    if not Inst:IsDescendantOf(Players) and (_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Inst) 
    or not _G.Settings.Players["Ignore Others"]) and (_G.Settings.Players["Ignore Me"] and ME.Character and not Inst:IsDescendantOf(ME.Character) 
    or not _G.Settings.Players["Ignore Me"]) and (_G.Settings.Players["Ignore Tools"] and not Inst:IsA("BackpackItem") and not Inst:FindFirstAncestorWhichIsA("BackpackItem") 
    or not _G.Settings.Players["Ignore Tools"]) and (_G.Ignore and not table.find(_G.Ignore, Inst) and not DescendantOfIgnore(Inst) 
    or (not _G.Ignore or type(_G.Ignore) ~= "table" or #_G.Ignore <= 0)) then
        if Inst:IsA("DataModelMesh") then
            if Inst:IsA("SpecialMesh") then
                if _G.Settings.Meshes.NoMesh then Inst.MeshId = "" end
                if _G.Settings.Meshes.NoTexture then Inst.TextureId = "" end
            end
            if _G.Settings.Meshes.Destroy or _G.Settings["No Meshes"] then Inst:Destroy() end
        elseif Inst:IsA("FaceInstance") then
            if _G.Settings.Images.Invisible then Inst.Transparency = 1; Inst.Shiny = 1 end
            if _G.Settings.Images.LowDetail then Inst.Shiny = 1 end
            if _G.Settings.Images.Destroy then Inst:Destroy() end
        elseif Inst:IsA("ShirtGraphic") then
            if _G.Settings.Images.Invisible then Inst.Graphic = "" end
            if _G.Settings.Images.Destroy then Inst:Destroy() end
        elseif table.find(CanBeEnabled, Inst.ClassName) then
            if (_G.Settings.Other and _G.Settings.Other["Invisible Particles"]) or (_G.Settings.Particles and _G.Settings.Particles.Invisible) then Inst.Enabled = false end
            if (_G.Settings.Other and _G.Settings.Other["No Particles"]) or (_G.Settings.Particles and _G.Settings.Particles.Destroy) then Inst:Destroy() end
        elseif Inst:IsA("PostEffect") and (_G.Settings.Other and _G.Settings.Other["No Camera Effects"]) then
            Inst.Enabled = false
        elseif Inst:IsA("Explosion") then
            if (_G.Settings.Explosions and _G.Settings.Explosions.Smaller) then Inst.BlastPressure = 1; Inst.BlastRadius = 1 end
            if (_G.Settings.Explosions and _G.Settings.Explosions.Invisible) then Inst.BlastPressure = 1; Inst.BlastRadius = 1; Inst.Visible = false end
            if (_G.Settings.Explosions and _G.Settings.Explosions.Destroy) then Inst:Destroy() end
        elseif Inst:IsA("Clothing") or Inst:IsA("SurfaceAppearance") or Inst:IsA("BaseWrap") then
            if (_G.Settings.Other and _G.Settings.Other["No Clothes"]) then Inst:Destroy() end
        elseif Inst:IsA("BasePart") and not Inst:IsA("MeshPart") then
            if _G.Settings.Other["Low Quality Parts"] then Inst.Material = Enum.Material.Plastic; Inst.Reflectance = 0 end
        elseif Inst:IsA("TextLabel") and Inst:IsDescendantOf(Workspace) then
            if (_G.Settings.TextLabels and _G.Settings.TextLabels.LowerQuality) then Inst.Font = Enum.Font.SourceSans; Inst.TextScaled = false; Inst.RichText = false; Inst.TextSize = 14 end
            if (_G.Settings.TextLabels and _G.Settings.TextLabels.Invisible) then Inst.Visible = false end
            if (_G.Settings.TextLabels and _G.Settings.TextLabels.Destroy) then Inst:Destroy() end
        elseif Inst:IsA("Model") then
            if _G.Settings.Other["Low Quality Models"] then Inst.LevelOfDetail = 1 end
        elseif Inst:IsA("MeshPart") then
            if (_G.Settings.MeshParts and _G.Settings.MeshParts.LowerQuality) then Inst.RenderFidelity = 2; Inst.Reflectance = 0; Inst.Material = Enum.Material.Plastic end
            if (_G.Settings.MeshParts and _G.Settings.MeshParts.Invisible) then Inst.Transparency = 1; Inst.RenderFidelity = 2; Inst.Reflectance = 0; Inst.Material = Enum.Material.Plastic end
            if _G.Settings.MeshParts and _G.Settings.MeshParts.NoTexture then Inst.TextureID = "" end
            if _G.Settings.MeshParts and _G.Settings.MeshParts.NoMesh then Inst.MeshId = "" end
            if (_G.Settings.MeshParts and _G.Settings.MeshParts.Destroy) then Inst:Destroy() end
        end
    end
end

-- ====================================================================
--                         การเรียกใช้งานหลัก
-- ====================================================================

local function safeRun(func, name)
    local success, err = pcall(func)
    if not success and _G.ConsoleLogs then
        warn("FPS Booster Error in '" .. (name or "Unnamed Function") .. "': " .. tostring(err))
    end
end

-- #1: ฟังก์ชัน Low Water Graphics
safeRun(function()
    if _G.Settings.Other["Low Water Graphics"] then
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if not terrain then
            repeat task.wait() until Workspace:FindFirstChildOfClass("Terrain")
            terrain = Workspace:FindFirstChildOfClass("Terrain")
        end
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
        if sethiddenproperty then
            sethiddenproperty(terrain, "Decoration", false)
        else
            warn("Your exploit does not support sethiddenproperty. (Low Water Graphics)")
        end
        if _G.ConsoleLogs then warn("Low Water Graphics Enabled") end
    end
end, "Low Water Graphics")

-- #2: ฟังก์ชัน No Shadows
safeRun(function()
    if _G.Settings.Other["No Shadows"] then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.ShadowSoftness = 0
        if sethiddenproperty then
            sethiddenproperty(Lighting, "Technology", 2)
        else
            warn("Your exploit does not support sethiddenproperty. (No Shadows)")
        end
        if _G.ConsoleLogs then warn("No Shadows Enabled") end
    end
end, "No Shadows")

-- #3: ฟังก์ชัน Low Rendering
safeRun(function()
    if _G.Settings.Other["Low Rendering"] then
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        if _G.ConsoleLogs then warn("Low Rendering Enabled") end
    end
end, "Low Rendering")

-- #4: ฟังก์ชัน Reset Materials
safeRun(function()
    if _G.Settings.Other["Reset Materials"] then
        for i, v in pairs(MaterialService:GetChildren()) do
            v:Destroy()
        end
        MaterialService.Use2022Materials = false
        if _G.ConsoleLogs then warn("Reset Materials Enabled") end
    end
end, "Reset Materials")

-- #5: ฟังก์ชัน FPS Cap
safeRun(function()
    if _G.Settings.Other["FPS Cap"] then
        if setfpscap then
            local capValue = _G.Settings.Other["FPS Cap"]
            if type(capValue) == "string" or type(capValue) == "number" then
                setfpscap(tonumber(capValue))
                if _G.ConsoleLogs then warn("FPS Capped to " .. tostring(capValue)) end
            elseif capValue == true then
                setfpscap(1e6)
                if _G.ConsoleLogs then warn("FPS Uncapped") end
            end
        else
            warn("FPS Cap Failed (setfpscap not supported)")
        end
    end
end, "FPS Cap")

-- #6: ฟังก์ชัน Clear Nil Instances
safeRun(function()
    if _G.Settings.Other["ClearNilInstances"] then
        if getnilinstances then
            for _, v in pairs(getnilinstances()) do
                pcall(v.Destroy, v)
            end
        else
            warn("Your exploit does not support getnilinstances.")
        end
    end
end, "Clear Nil Instances")


-- ตรวจสอบ Instances ที่มีอยู่แล้ว
local Descendants = game:GetDescendants()
if _G.ConsoleLogs then
    warn("Checking " .. #Descendants .. " Instances...")
end
for i, v in pairs(Descendants) do
    CheckIfBad(v)
end
warn("FPS Booster Loaded and All Initial Checks Completed!")

-- เชื่อมต่อ DescendantAdded เพื่อจัดการ Instances ใหม่
game.DescendantAdded:Connect(function(value)
    task.wait(_G.LoadedWait or 1)
    CheckIfBad(value)
end)
