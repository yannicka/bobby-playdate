CELL_SIZE = 20

function math.clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

function indexOf(array, value)
    for i,v in ipairs(array) do
        if v == value then
            return i
        end
    end

    return nil
end
