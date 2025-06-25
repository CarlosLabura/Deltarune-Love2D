local Sprite = {} 
Sprite.__index = Sprite

function Sprite.new(image, x, y)
    local spr = setmetatable({}, Sprite)

    spr.x = 0
    spr.y = 0
    spr.angle = 0
    spr.scale = 1
    spr.scroll = {0,0}
    spr.hitbox = {1,1}
    spr.origin = {0,0}
    spr.camera = {1,1}

    spr.visible = true
    spr.debug = false
    spr.image = nil
    spr.xml = nil

    spr.animations = {}
    spr.animationProperties = {
        anim_type = 0, --   0: no animation   1: sparrow animation   2: frame animation
        frames = {},
        quad = {},
        name = '',
        offsets = {0,0},

        startFrame = 1,
        maxFrames = 1,
        curFrame = 1,

        curAnimation = nil,
        animationTimer = 0,
        fps = 1,

        paused = false,
        loop = false,
        finished = false
    }

    spr:image(image)
    spr:setPosition(x,y)
    
    return spr
end

function Sprite:image(image)
    if not love.filesystem.getInfo(Paths.image(image)) then
        self.image = love.graphics.newImage('noimage.png')
        return
    end
    self.image = love.graphics.newImage(Paths.image(image))
    self:setHitbox(self.image:getWidth(), self.image:getHeight())
    self:setOrigin(self.hitbox[1]/2, self.hitbox[2]/2)
end

function Sprite:sparrow(xml_file)
    if not love.filesystem.getInfo(Paths.xml(xml_file)) then
        return
    end

    self.xml = Xml.parse(love.filesystem.read(Paths.xml(xml_file)), false) 
    self:setHitbox(self.xml.children[1].children[1].attrs.frameWidth or self.xml.children[1].children[1].attrs.width, 
                    self.xml.children[1].children[1].attrs.frameHeight or self.xml.children[1].children[1].attrs.height
    )
    self:setOrigin(self.hitbox[1]/2, self.hitbox[2]/2)
end

function Sprite:setPosition(x,y)
    self.x, self.y = x, y
end
function Sprite:setHitbox(width,height)
    self.hitbox[1], self.hitbox[2] = width, height
end
function Sprite:setOrigin(x,y)
    self.origin[1], self.origin[2] = x, y
end
function Sprite:setScroll(x,y)
    self.scroll[1], self.scroll[2] = x, y
end

function Sprite:addAnimationByPrefix(anim_name, anim_prefix, anim_offsets, anim_fps, anim_loop)
    local anim_offsets = anim_offsets or {0,0}
    self.animations[anim_name] = {
        anim_type = 1,
        name = anim_name,
        prefix = anim_prefix, 
        offsets = {x = anim_offsets[1], y = anim_offsets[2]},
        fps = anim_fps or 24,
        loop = (anim_loop == nil and true or anim_loop)
    }
    self:playAnimation(anim_name)
end

--this whole frame animation code could be way better prolly but im tired ill just keep it this way
function Sprite:addAnimationByFrames(anim_name, anim_frames, anim_offsets, anim_fps, anim_loop)
    local anim_offsets = anim_offsets or {0,0}

    local animFrames = {}
    for i = 1, #anim_frames do
        table.insert(animFrames, love.graphics.newImage(anim_frames[i]))
    end

    self.animations[anim_name] = {
        anim_type = 2,
        name = anim_name,
        frames = animFrames, 
        offsets = {x = anim_offsets[1], y = anim_offsets[2]},
        fps = anim_fps or 24,
        loop = (anim_loop == nil and true or anim_loop)
    }
    self:playAnimation(anim_name)
end

function Sprite:addAnimationByQuad(anim_name, anim_quad, anim_offsets, anim_fps, anim_loop)
    local anim_offsets = anim_offsets or {0,0}
    local animQuads = anim_quad or {0,0,0,0}

    self.animations[anim_name] = {
        anim_type = 3,
        name = anim_name,
        quad = animQuads, 
        offsets = {x = anim_offsets[1], y = anim_offsets[2]},
        --totally useless rn
        fps = anim_fps or 24,
        loop = (anim_loop == nil and true or anim_loop)
    }
    self:playAnimation(anim_name)
end

function Sprite:playAnimation(anim_name, force)
    local force = (force == nil and true or force)

    if not force and not self.animationProperties.finished then
        return
    end

    self.animationProperties.name = self.animations[anim_name].name
    self.animationProperties.paused = false
    self.animationProperties.finished = false
    self.animationProperties.maxFrames = 1
    self.animationProperties.offsets[1] = self.animations[anim_name].offsets.x
    self.animationProperties.offsets[2] = self.animations[anim_name].offsets.y
    self.animationProperties.fps = self.animations[anim_name].fps
    self.animationProperties.loop = self.animations[anim_name].loop
    self.animationProperties.anim_type = self.animations[anim_name].anim_type
    self.animationProperties.frames = {}
    self.animationProperties.quad = {}

    if self.animationProperties.anim_type == 1 then
        for i = 1, #self.xml.children[1].children do
            if string.sub(self.xml.children[1].children[i].attrs.name, 1, string.len(self.animations[anim_name].prefix)) == self.animations[anim_name].prefix then
                self.animationProperties.startFrame = i
                break
            end
        end

        for i = self.animationProperties.startFrame, #self.xml.children[1].children do
            if string.sub(self.xml.children[1].children[i].attrs.name, 1, string.len(self.animations[anim_name].prefix)) == self.animations[anim_name].prefix then
                self.animationProperties.maxFrames = self.animationProperties.maxFrames + 1
            else break end
        end
    elseif self.animationProperties.anim_type == 2 then
        self.animationProperties.startFrame = 1
        self.animationProperties.maxFrames = #self.animations[anim_name].frames
        self.animationProperties.frames = self.animations[anim_name].frames
    elseif self.animationProperties.anim_type == 3 then
        self.animationProperties.startFrame = 1
        self.animationProperties.maxFrames = 1
        self.animationProperties.quad = self.animations[anim_name].quad
    end
    self.animationProperties.curFrame = self.animationProperties.startFrame
end

function Sprite:draw()
    if not self.visible then
        return 
    end

    if self.debug then
        love.graphics.circle('fill', self.x + self.origin[1], self.y + self.origin[2], 1)
        love.graphics.rectangle('line', self.x, self.y, self.hitbox[1], self.hitbox[2])
    end

    if self.animationProperties.anim_type == 0 then --IMAGE TYPE
        love.graphics.draw(self.image, self.x - self.camera[1] * self.scroll[1] + self.origin[1], 
            self.y - self.camera[2] * self.scroll[2] + self.origin[2], 
            math.rad(self.angle), self.scale, self.scale, self.origin[1], self.origin[2]
        )
        return
    end
    self.animationProperties.animationTimer = self.animationProperties.animationTimer + love.timer.getDelta()
    if self.animationProperties.anim_type == 1 then --SPARROW TYPE
        self.curAnimation = love.graphics.newQuad(
            self.xml.children[1].children[self.animationProperties.curFrame].attrs.x, 
            self.xml.children[1].children[self.animationProperties.curFrame].attrs.y, 
            self.xml.children[1].children[self.animationProperties.curFrame].attrs.width, 
            self.xml.children[1].children[self.animationProperties.curFrame].attrs.height, 
            self.image
        )
        love.graphics.draw(self.image, self.curAnimation, 
            self.x - self.camera[1] * self.scroll[1] - self.animationProperties.offsets[1] - (self.xml.children[1].children[self.animationProperties.curFrame].attrs.frameX or 0) + self.origin[1],
            self.y - self.camera[2] * self.scroll[2] - self.animationProperties.offsets[2] - (self.xml.children[1].children[self.animationProperties.curFrame].attrs.frameY or 0) + self.origin[2],
            math.rad(self.angle), self.scale, self.scale, self.origin[1], self.origin[2]
        )
    elseif self.animationProperties.anim_type == 2 then --FRAME TYPE
        love.graphics.draw(self.animationProperties.frames[self.animationProperties.curFrame], 
            self.x - self.camera[1] * self.scroll[1] - self.animationProperties.offsets[1] + self.origin[1],
            self.y - self.camera[2] * self.scroll[2] - self.animationProperties.offsets[2] + self.origin[2],
            math.rad(self.angle), self.scale, self.scale, self.origin[1], self.origin[2]
        )
    elseif self.animationProperties.anim_type == 3 then --QUAD TYPE
        self.curAnimation = love.graphics.newQuad(
            self.animationProperties.quad[1], 
            self.animationProperties.quad[2], 
            self.animationProperties.quad[3], 
            self.animationProperties.quad[4], 
            self.image
        )
        love.graphics.draw(self.image, self.curAnimation, 
            self.x - self.camera[1] * self.scroll[1] - self.animationProperties.offsets[1] + self.origin[1],
            self.y - self.camera[2] * self.scroll[2] - self.animationProperties.offsets[2] + self.origin[2],
            math.rad(self.angle), self.scale, self.scale, self.origin[1], self.origin[2]
        )
    end

    if self.animationProperties.finished then
        return
    end
    if self.animationProperties.paused then
        return
    end
    if self.animationProperties.animationTimer < 1 / self.animationProperties.fps then
        return
    end

    self.animationProperties.animationTimer = 0
    if self.animationProperties.anim_type == 1 then
        if self.animationProperties.curFrame < self.animationProperties.startFrame + self.animationProperties.maxFrames - 2 then 
            self.animationProperties.curFrame = self.animationProperties.curFrame + 1 
        else
            if self.animationProperties.loop then
                self.animationProperties.curFrame = self.animationProperties.startFrame
            else 
                self.animationProperties.finished = true
            end
        end
    elseif self.animationProperties.anim_type == 2 then
        if self.animationProperties.curFrame < self.animationProperties.maxFrames then 
            self.animationProperties.curFrame = self.animationProperties.curFrame + 1 
        else
            if self.animationProperties.loop then
                self.animationProperties.curFrame = self.animationProperties.startFrame
            else 
                self.animationProperties.finished = true
            end
        end
    end
end
return Sprite