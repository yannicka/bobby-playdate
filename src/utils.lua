CELL_SIZE = 20

function math.clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

function table.indexOf(array, value)
    for i,v in ipairs(array) do
        if v == value then
            return i
        end
    end

    return nil
end

function table.contains(array, value)
    for i,v in ipairs(array) do
        if value == v then
            return true
        end
    end

    return false
end

function table.count(array)
    local size = 0

    for _ in ipairs(array) do
        size += 1
    end

    return size
end

function string.trim(s)
    return (string.gsub(s, '^%s*(.-)%s*$', '%1'))
end
