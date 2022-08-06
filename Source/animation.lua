class('AnimationManager').extends(Object)

function AnimationManager:init(sprite, image)
    AnimationManager.super.init(self)

    self.sprite = sprite
    self.image = image
    self.animations = {}
    self.currentAnimation = nil
end

function AnimationManager:update()
    if self.currentAnimation then
        self.currentAnimation:update()
    end
end

function AnimationManager:addAnimation(name, frames, frameDuration, loop)
    local animation = Animation(self.sprite, self.image, frames, frameDuration, loop)

    self.animations[name] = animation
end

function AnimationManager:play(name, force)
    local nextAnimation = self.animations[name]

    if nextAnimation ~= self.currentAnimation or force then
        self.currentAnimation = nextAnimation
        self.currentAnimation:restart()
    end
end

class('Animation').extends(Object)

function Animation:init(sprite, image, frames, frameDuration, loop)
    Animation.super.init(self)

    self.sprite = sprite
    self.image = image
    self.frames = frames
    self.frameDuration = frameDuration
    self.loop = loop

    if self.loop == nil then
        self.loop = true
    end

    self.nbFrames = 0
    for _ in ipairs(self.frames) do
        self.nbFrames += 1
    end

    self.timer = 0
    self.currentIndex = 1
    self.finished = false
end

function Animation:update()
    if self.finished then
        return
    end

    self.timer += 1

    while self.timer > self.frameDuration do
        self.currentIndex += 1

        if self.currentIndex > self.nbFrames then
            if self.loop then
                self.currentIndex = 1
            else
                self.finished = true

                self.currentIndex -= 1
            end
        end

        self.timer -= self.frameDuration

        self.sprite:setImage(self.image[self:getCurrentFrame()])
    end
end

function Animation:restart()
    self.timer = 0
    self.currentIndex = 1
    self.finished = false
end

function Animation:getCurrentFrame()
    return self.frames[self.currentIndex]
end
