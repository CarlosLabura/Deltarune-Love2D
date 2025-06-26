local TextBox = {} 
TextBox.__index = TextBox

function TextBox.new(text, gap, character, expression)
    local box = setmetatable({}, TextBox)

    box.text = text
    box.character = character or ''


    camHUD:addFunction('box', function()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('fill', 20, screenHeight-85, screenWidth-40, 80)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('fill', 23, screenHeight-85+3, screenWidth-40-6, 74)

        love.graphics.setColor(1, 1, 1, 1)
    end)
    
    box.face = Sprite.new('', 30, 165)
    camHUD:add(box.face)

    box.textSprite = Text.new('hola', 35, 165, nil, camHUD)
    box.textSprite:reset()

    box:set(text, gap, character, expression)

    return box
end

function TextBox:set(text, gap, character, expression)
    local character = character or ''

    if character ~= '' then
        local charJson = Json.decode(love.filesystem.read(Paths.character(character)))

        self.face:setImage(charJson.facesPath.."/"..charJson.faces[expression])
        self.textSprite.position[1] = 100
    else
        self.face.visible = false
        self.textSprite.position[1] = 35
    end

    --self.textSprite:setFont((character ~= '' and charJson.font or nil))
    self.textSprite:reset(text)
    self.textSprite:type(gap)
end

function TextBox:close()
    camHUD:removeFunction('box')
    camHUD:remove(self.face)
    self.textSprite:reset()
end


function TextBox:update(dt)
    self.textSprite:update(dt)
end

return TextBox