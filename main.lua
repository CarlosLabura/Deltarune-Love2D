StateManager = require "libs.state_manager"
Keyboard = require 'libs.keyboard'
Sprite = require 'libs.sprite'
Tween = require 'libs.tween'
Utils = require 'libs.utils'
Paths = require 'libs.paths'
Camera = require 'libs.camera'
CameraManager = require 'libs.camera_manager'
Json = require 'libs.parsers.json'
Xml = require 'libs.parsers.xml'

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0.3, 0.3, 0.3, 1)

    local keys = {
        'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z', --Characters (Letters)
        '0','1','2','3','4','5','6','7','8','9', --Characters (Numbers)
        '!','"','#','$','&',"'",'(',')','*','+',',','-','.','/',':',';','<','=','>','?','@','[',']','^','_','`', ----Characters (Symbols) --Just in case
        'kp0','kp1','kp2','kp3','kp4','kp5','kp6','kp7','kp8','kp9','kp.','kp,','kp/','kp*','kp-','kp+','kpenter','kp=', --Numpad
        'space','up','down','right','left','&','home','end','pageup','pagedown', --Navigation
        'insert','backspace','tab','clear','return','delete', --Editing
        'f1','f2','f3','f4','f5','f6','f7','f8','f9','f10','f11','f12','f13','f14','f15','f16','f17','f18', --Function
        'numlock','capslock','scrolllock','rshift','lshift','rctrl','lctrl','ralt','lalt','rgui','lgui','mode', --Modifer
        'pause','escape','help','printscreen','sysreq','menu','application','power','undo', --Miscellaneous --TF????? 
    }
    Keyboard = Keyboard.createInstance(keys)

    screenWidth, screenHeight, screenFlags = love.window.getMode()
    screenMultiplier = 3

    love.camera = Camera.new(0-screenWidth/screenMultiplier, 0-screenHeight/screenMultiplier, screenWidth, screenHeight)
    love.camera.scale = screenMultiplier

    StateManager.switch( require("states.game") )

    camHUD = CameraManager.newCamera('camHUD', 0-screenWidth/screenMultiplier, 0-screenHeight/screenMultiplier, screenWidth, screenHeight)
    camHUD.scale = screenMultiplier
end

--Tweens--
local _tweenTable = {}
function love.tween(var, object, params, duration, ease)
    local tag = var
    var = Tween.new(duration or 1, object, params, ease or 'linear', tag)
    for i = 1, #_tweenTable do
        if _tweenTable[i].tag == tag then
            table.remove(_tweenTable,i)
            table.insert(_tweenTable, i, var)
            return var
        end
    end
    table.insert(_tweenTable, var)
    return var
end
function Tween.manager(dt)
    for i = 1, #_tweenTable do
        if _tweenTable[i] then
            _tweenTable[i]:update(dt)
            if _tweenTable[i]:finished() then
                table.remove(_tweenTable,i)
            end
        end
    end
end

function love.update(dt)
    Keyboard:updateInput()
    Tween.manager(dt)
    StateManager.update(dt)
end

function love.draw()
    --StateManager.draw()
    love.camera:draw(function()
        love.camera:drawObjects()
    end)
    CameraManager.drawCameras()
end