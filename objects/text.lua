local Text = {} 
Text.__index = Text

function Text.new(text, x, y, font, camera)
    if #text < 1 then
        return
    end

    local font = font or 'default'
    local camera = camera or love.camera
    fontJson = Json.decode(love.filesystem.read(Paths.json('fonts/'..font))) 

    local txt = setmetatable({}, Text)

    txt.text = text

    txt.camera = camera
    txt.json = fontJson
    txt.position = {x or 0,y or 0}

    txt.typeActivated = false
    txt.gap = 0
    txt.timer = 0
    txt.letters = {}
    txt.letterIndex = 1

    txt:generate(text)
    return txt
end 

function Text:setFont(font)
    local font = font or 'default'
    local fontJson = Json.decode(love.filesystem.read(Paths.json('fonts/'..font))) 

    self.json = fontJson
end

function Text:generate(text)
    for i = 1, #text do
        letter = Sprite.new('fonts/'..self.json.image, self.position[1] + 8 * (i-1), self.position[2])

        local curLetter = Utils.getLetterByPosition(text, i)
        local letterQuad = {
            self.json.characters[curLetter][1],
            self.json.characters[curLetter][2],
            self.json.characters[curLetter][3],
            self.json.characters[curLetter][4]
        }
        letter:addAnimationByQuad(curLetter, letterQuad)
        letter.visible = false
        table.insert(self.letters, letter)
        self.camera:add(letter)
    end
end

function Text:reset(text)
    for i = 1, #self.letters do
        self.letters[i].visible = false
        self.camera:remove(self.letters[i])
    end
    self.text = text
    self.typeActivated = false
    self.gap = 0
    self.timer = 0
    self.letterIndex = 1

    self.letters = {}

    if text == nil or #text < 1 then
        return
    end

    self:generate(text)
end

function Text:type(gapTime)
    if self.letterIndex > #self.text then
        return
    end

    local gapTime = gapTime or 0.05

    self.typeActivated = true
    self.gap = gapTime
    self.timer = 0

    self.letters[self.letterIndex].visible = true
    self.letterIndex = self.letterIndex + 1
end
function Text:update(dt)
    if not self.typeActivated then
        return
    end
    if self.letterIndex > #self.text then
        return
    end

    self.timer = self.timer + dt
    if self.timer >= self.gap then
        self.letters[self.letterIndex].visible = true
        self.timer = 0
        self.letterIndex = self.letterIndex + 1
    end
end



return Text