
Kris = require 'objects.kris'
Character = require 'objects.character'
Text = require 'objects.text'

local tesxt
function create() 
    print('loaded game state')

    ralsei = Character.new('ralsei', 200, 100)
    ralsei:face('down')
    love.camera:add(ralsei)

    kris = Kris.new(100,100)
    love.camera:add(kris)

    tesxt = Text.new("* Kris, I'm gay fr", 0, 0, nil, camHUD)
end

function update(dt)
    kris:update(dt)

    tesxt:update(dt)
    if Keyboard:justPressed('g') then
        ralsei:face('left')
        tesxt:type(0.05)
    end
    if Keyboard:justPressed('h') then
        tesxt:reset('hola')
        tesxt:type(0.05)
    end
end


return {
    load = create,
    update = update,
    draw = draw
}