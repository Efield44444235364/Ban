for i, v in pairs(getgc(true)) do
    if typeof(v) == "function" and islclosure(v) then
        local upvs = debug.getupvalues(v)
        for _, uv in pairs(upvs) do
            if uv == "AndroidAnticheatKick" then
                hookfunction(v, function(...)
                    return nil
                end)
            end
        end
    end
end

print(" [ ✅ ] Successfully fixed AndroidAnticheatKick")
