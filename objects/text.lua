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