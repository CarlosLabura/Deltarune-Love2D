local Kris = setmetatable({}, {__index = Sprite})
Kris.__index = Kris

function Kris.new(x, y)
    krs = Sprite.new('kris/spr_krisd/spr_krisd_0', x, y)

    setmetatable(krs, Kris)

    krs.inCutscene = false

    krs.maxVelocity = 120
    krs.minVelocity = 80
    krs.velocity = 0

    local anims = {'down','right','up','left'}
    for i = 1, #anims do
        krs:addAnimationByFrames(anims[i], Utils.reorderArray(Utils.getFramesFromFolder('assets/images/kris/spr_kris'..Utils.getFirstLetter(anims[i]))), {0,0}, 6, true)
    end
    
    return krs
end

function Kris:update(dt)
    if krs.inCutscene then
        return
    end
    if Keyboard:isDown('down') then
        self.y = self.y + self.velocity * dt
    end
    if Keyboard:isDown('up') then
        self.y = self.y - self.velocity * dt
    end
    if Keyboard:isDown('right') then
        self.x = self.x + self.velocity * dt
    end
    if Keyboard:isDown('left') then
        self.x = self.x - self.velocity * dt
    end
    if Keyboard:isDown('x') then
        self.velocity = self.maxVelocity
    else
        self.velocity = self.minVelocity
    end
    
    --Animation checks
    if Keyboard:isDown('down') then
        self:playAnimation('down', (self.animationProperties.name ~= 'down'))
    elseif Keyboard:isDown('up') then
        self:playAnimation('up', (self.animationProperties.name ~= 'up'))
    elseif Keyboard:isDown('right') then
        self:playAnimation('right', (self.animationProperties.name ~= 'right'))
    elseif Keyboard:isDown('left') then
        self:playAnimation('left', (self.animationProperties.name ~= 'left'))
    else
        self.animationProperties.curFrame = 4
    end
    self.animationProperties.fps = (self.velocity == self.maxVelocity and 12 or 6)
end


return Kris