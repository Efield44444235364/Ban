--// =============================
--//  Roblox AutoExec + FPS Monitor + Notifications + Load Wait
--// =============================

--// รอเกมโหลดเต็ม
if not game:IsLoaded() then
	game.Loaded:Wait()
end

--// Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
LocalPlayer:WaitForChild("PlayerGui")

--// รอ Folder / Object สำคัญในเกม (เปลี่ยนตามเกม)
--[[ ตัวอย่าง:
ReplicatedStorage:WaitForChild("SomeFolder")
Workspace:WaitForChild("Map")
]]--

--// =============================
--// Config
--// =============================
Antikick = Antikick or true
AutoExecute = AutoExecute or true
LowRendering = LowRendering or false

local ConfigFolder = "Optimization"
local ConfigFile = ConfigFolder .. "/Config_" .. game.PlaceId .. ".json"

local function SaveConfig()
	if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
	writefile(ConfigFile, HttpService:JSONEncode({
		Antikick = Antikick,
		AutoExecute = AutoExecute,
		LowRendering = LowRendering
	}))
end

local function LoadConfig()
	if isfile(ConfigFile) then
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile(ConfigFile))
		end)
		if ok and typeof(data) == "table" then
			Antikick = data.Antikick
			AutoExecute = data.AutoExecute
			LowRendering = data.LowRendering
		end
	end
end

LoadConfig()
SaveConfig()

--// =============================
--// Notification UI
--// =============================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmoothNotificationQueue"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local notifications = {}
local MAX_NOTIFICATIONS = 3

local function createNotification(titleText, messageText)
	local function build()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 260, 0, 70)
		frame.Position = UDim2.new(1, 300, 0, 20)
		frame.AnchorPoint = Vector2.new(1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame.BackgroundTransparency = 0.05
		frame.Parent = screenGui
		frame.ClipsDescendants = true

		local stroke = Instance.new("UIStroke", frame)
		stroke.Thickness = 1.2
		stroke.Transparency = 0.3
		stroke.Color = Color3.fromRGB(210, 210, 210)

		local corner = Instance.new("UICorner", frame)
		corner.CornerRadius = UDim.new(0, 12)

		local title = Instance.new("TextLabel", frame)
		title.Size = UDim2.new(1, -20, 0, 22)
		title.Position = UDim2.new(0, 10, 0, 10)
		title.Text = titleText
		title.Font = Enum.Font.GothamMedium
		title.TextSize = 16
		title.TextColor3 = Color3.fromRGB(30, 30, 30)
		title.BackgroundTransparency = 1
		title.TextXAlignment = Enum.TextXAlignment.Left

		local message = Instance.new("TextLabel", frame)
		message.Size = UDim2.new(1, -20, 0, 20)
		message.Position = UDim2.new(0, 10, 0, 36)
		message.Text = messageText
		message.Font = Enum.Font.Gotham
		message.TextSize = 14
		message.TextColor3 = Color3.fromRGB(90, 90, 90)
		message.BackgroundTransparency = 1
		message.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(notifications, 1, frame)
		for i, notif in ipairs(notifications) do
			TweenService:Create(notif, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -20, 0, 20 + ((i - 1) * 80))
			}):Play()
		end

		TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -20, 0, 20)
		}):Play()

		local dismissed = false
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not dismissed then
				dismissed = true
				local i = table.find(notifications, frame)
				if i then table.remove(notifications, i) end
				TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1
				}):Play()
				task.delay(0.4, function() frame:Destroy() end)
			end
		end)

		task.delay(4, function()
			if not dismissed and frame and frame.Parent then
				dismissed = true
				local i = table.find(notifications, frame)
				if i then table.remove(notifications, i) end
				TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1
				}):Play()
				task.delay(0.4, function() frame:Destroy() end)
			end
		end)
	end

	if #notifications >= MAX_NOTIFICATIONS then
		local oldest = table.remove(notifications, #notifications)
		if oldest then oldest:Destroy() end
		build()
	else
		build()
	end
end

--// =============================
--// FPS Monitor
--// =============================
local fpsThresholdLow = 20
local fpsThresholdHigh = 30
local timeThresholdLow = 15
local timeThresholdHigh = 10
local belowStart, aboveStart
local checkingLow, checkingHigh = true, true

RunService.RenderStepped:Connect(function(dt)
	local fps = math.floor(1/dt)

	-- FPS ต่ำกว่า threshold
	if fps < fpsThresholdLow then
		if not belowStart then belowStart = tick() end
		if tick() - belowStart >= timeThresholdLow and checkingLow then
			checkingLow = false
			LowRendering = true
			AutoExecute = false
			SaveConfig()
			createNotification("⚡ Performance Mode", "FPS ต่ำ <20 นาน 15s → LowRendering เปิด")
			warn("[⚡] FPS ต่ำ 15s+ | LowRendering = true, AutoExecute = false")
		end
	else
		belowStart = nil
		checkingLow = true
	end

	-- FPS สูงกว่า threshold
	if fps >= fpsThresholdHigh then
		if not aboveStart then aboveStart = tick() end
		if tick() - aboveStart >= timeThresholdHigh and checkingHigh then
			checkingHigh = false
			if LowRendering then
				LowRendering = false
				SaveConfig()
				createNotification("✅ Normal Mode", "FPS ≥30 นาน 10s → LowRendering ปิด")
				warn("[✅] FPS สูง 10s+ | LowRendering = false")
			end
		end
	else
		aboveStart = nil
		checkingHigh = true
	end
end)

--// =============================
--// แจ้งเตือนตอนโหลดสคริปต์เสร็จ
--// =============================
createNotification(" [ ✅ ] Auto Execute", "Script Loaded Successfully")
warn("[ ⚙️ ] Script loaded - FPS monitor active")
