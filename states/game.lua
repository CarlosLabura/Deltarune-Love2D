
Kris = require 'objects.kris'
Character = require 'objects.character'
Text = require 'objects.text'

local tesxt
function create() 
    print('loaded game state')

    love.camera.scale = 3
    camHUD = CameraManager.newCamera('camHUD', 0, 0 ,1280, 720)
    camHUD.scale = 3

    ralsei = Character.new('ralsei', 650, 330)
    ralsei:face('down')
    love.camera:add(ralsei)

    kris = Kris.new(510,300)
    love.camera:add(kris)

    tesxt = Text.new("* Kris, I'm gay fr", 450, 330, nil, camHUD)
end

function update(dt)
    kris:update(dt)

    tesxt:update(dt)
    if Keyboard:justPressed('g') then
        ralsei:face('left')
        tesxt:type(0.05)
    end
end


return {
    load = create,
    update = update,
    draw = draw
}