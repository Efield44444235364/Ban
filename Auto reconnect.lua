--// Auto Reconnect (Hybrid: Smart + Instant on Kick)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local reconnecting = false

-- ฟังก์ชัน Reconnect ทันที
local function tryReconnect()
    if reconnecting then return end
    reconnecting = true

    spawn(function()
        local placeId, jobId = game.PlaceId, game.JobId
        pcall(function()
            if jobId and jobId ~= "" then
                TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
            else
                TeleportService:Teleport(placeId, player)
            end
        end)
    end)
end

-- ตรวจ Player หาย (เบา ๆ)
task.spawn(function()
    while task.wait(1) do
        if not Players.LocalPlayer or not Players.LocalPlayer.Parent then
            warn("[AutoReconnect] Lost player instance. Reconnecting...")
            tryReconnect()
            break
        end
    end
end)

-- ฟัง ErrorPrompt
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(obj)
    if obj.Name == "ErrorPrompt" then
        task.wait(0.05) -- แทบไม่ต้องหน่วง
        local msg = obj:FindFirstChildWhichIsA("TextLabel", true)

        if msg and msg.Text then
            local text = msg.Text:lower()
            if text:find("shutdown") then
                warn("[AutoReconnect] Game shutdown detected. Skip reconnect.")
                reconnecting = true
                return
            elseif text:find("kick") then
                warn("[AutoReconnect] Kick detected. Rejoining immediately!")
                tryReconnect() -- โดนเตะปุ๊บ รีจอยเลย
            else
                warn("[AutoReconnect] Disconnect detected. Rejoining immediately!")
                tryReconnect()
            end
        else
            warn("[AutoReconnect] Unknown error. Rejoining immediately!")
            tryReconnect()
        end
    end
end)

print("[✅] Auto Reconnect load.!!")
