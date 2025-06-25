local stateManager = {
    currentState = nil,
}

function stateManager.switch(state)
    if stateManager.currentState and stateManager.currentState.exit then
        stateManager.currentState.exit()
    end
    love.camera:clean()
    CameraManager.cleanCameras()
    stateManager.currentState = state
    if stateManager.currentState and stateManager.currentState.load then
        stateManager.currentState.load()
    end
end

function stateManager.update(dt)
    if stateManager.currentState and stateManager.currentState.update then
        stateManager.currentState.update(dt)
    end
end

function stateManager.draw()
    if stateManager.currentState and stateManager.currentState.draw then
        stateManager.currentState.draw()
    end
end

function stateManager.keypressed(key)
    if stateManager.currentState and stateManager.currentState.keypressed then
        stateManager.currentState.keypressed(key)
    end
end

function stateManager.mousepressed(x, y, button, istouch, presses)
    if stateManager.currentState and stateManager.currentState.mousepressed then
        stateManager.currentState.mousepressed(x, y, button, istouch, presses)
    end
end

function stateManager.getCurrentState()
    return stateManager.currentState
end

return stateManager
