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

    for i = 1, #text do
        letter = Sprite.new('fonts/'..fontJson.image, x + 8 * (i-1), y)

        local curLetter = Utils.getLetterByPosition(text, i)
        local letterQuad = {
            fontJson.characters[curLetter][1],
            fontJson.characters[curLetter][2],
            fontJson.characters[curLetter][3],
            fontJson.characters[curLetter][4]
        }
        letter:addAnimationByQuad(curLetter, letterQuad)
        letter.visible = false
        camera:add(letter)

        table.insert(txt.letters, letter)
    end
    return txt
end 

function Text:reset(text)
    for i = 1, #self.letters do
        self.camera:remove(self.letters[i])
    end
    self.text = text
    self.typeActivated = false
    self.gap = 0
    self.timer = 0
    self.letters = {}
    self.letterIndex = 1

    if #text < 1 then
        return
    end

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
        self.camera:add(letter)

        table.insert(self.letters, letter)
    end
end

function Text:type(gapTime)
    if self.letterIndex > #self.text then
        return
    end
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
    print(dt)
    if self.timer >= self.gap then
        self.letters[self.letterIndex].visible = true
        self.timer = 0
        self.letterIndex = self.letterIndex + 1
    end
end



return Text