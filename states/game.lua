


local tesxt
function create() 
    print('loaded game state')

    
    camHUD = CameraManager.newCamera('camHUD', 0-screenWidth, 0-screenHeight, screenWidth*screenMultiplier, screenHeight*screenMultiplier)
    camHUD.scale = screenMultiplier

    ralsei = Character.new('ralsei', 200, 100)
    ralsei:face('down')
    love.camera:add(ralsei)

    kris = Kris.new(100,100)
    love.camera:add(kris)
    
    
end

local state = 0
function update(dt)
    if Keyboard:justPressed('z') then
        if state == 0 then
            state = 1
            textbox = TextBox.new("* Kris", nil, 'ralsei', 'normal')
            kris.inCutscene = true
            ralsei:face('left')
        elseif state == 1 then
            state = 2
            textbox:set("* I'm gay fr", nil, 'ralsei', 'blud')
        elseif state == 2 then
            state = 3
            textbox:set("* (You felt gay for a moment)")
        elseif state == 3 then
            kris.inCutscene = false
            textbox:close()
            ralsei:playAnimation('right', true)
            love.tween('ralseigo', ralsei, {x = 800}, 10)
        end
    end

    kris:update(dt)
    if textbox ~= nil then
        textbox:update(dt)
    end
end


return {
    load = create,
    update = update,
    draw = draw
}