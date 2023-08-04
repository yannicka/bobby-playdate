function math.clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

function table.contains(array, value)
    for _, v in ipairs(array) do
        if value == v then
            return true
        end
    end

    return false
end
