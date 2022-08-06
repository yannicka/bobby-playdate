class('Scene').extends(Object)

function Scene:init()
    Scene.super.init(self)
end

function Cell:update()
    -- À surcharger
end

function Cell:destroy()
    -- À surcharger
end
