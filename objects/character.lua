local Character = setmetatable({}, {__index = Sprite})
Character.__index = Character

function Character.new(name, x, y)

    charJson = Json.decode(love.filesystem.read(Paths.character(name))) 
    chara = Sprite.new(charJson.idleFrame, x, y)

    setmetatable(chara, Character)

    for i = 1, #charJson.animations do
        if charJson.animations[i].reorder then
            chara:addAnimationByFrames(
                charJson.animations[i].name, 
                Utils.reorderArray(Utils.getFramesFromFolder('assets/images/' .. name .. '/'..charJson.animations[i].folder)), 
                {charJson.animations[i].offsets[1], charJson.animations[i].offsets[2]}, 
                charJson.animations[i].fps, 
                charJson.animations[i].loop
            )
        else
            chara:addAnimationByFrames(
                charJson.animations[i].name, 
                Utils.getFramesFromFolder('assets/images/' .. name .. '/'..charJson.animations[i].folder), 
                {charJson.animations[i].offsets[1], charJson.animations[i].offsets[2]}, 
                charJson.animations[i].fps, 
                charJson.animations[i].loop
            )
        end
    end

    chara.moveTime = 0
    chara.stepToTake = 0
    chara.direction = 'down'
    --[[
    --Get Animations from folders
    --Animated are names like the folders too
    local files = love.filesystem.getDirectoryItems('assets/images/' .. path)
    for i = 1, #files do
        chara:addAnimationByFrames(files[i], Utils.reorderArray(Utils.getFramesFromFolder('assets/images/' .. path .. '/'..files[i])), {0,0}, 6, true)
    end
    ]]

    return chara
end

function Character:face(direction)
    self:playAnimation(direction, true)
    self.animationProperties.paused = true
    self.animationProperties.curFrame = 4
end
function Character:move(direction, steps, time)
    self.direction = direction or 'down'
    self.stepToTake = steps or 0
    self.moveTime = time or 1
end
function Character:update(dt)


end



return Character