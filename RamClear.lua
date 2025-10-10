-- 🧹 Clear RAM (clean core version)
local function ClearRAM()
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then
            table.clear(v)
        end
    end
end
