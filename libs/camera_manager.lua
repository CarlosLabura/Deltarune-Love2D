local cameraManager = {
    cameraTable = {}
}

function cameraManager.newCamera(var, x, y, width, height)
    local tag = var
    var = Camera.new(x,y,width,height)
    for i = 1, #cameraManager.cameraTable do
        if cameraManager.cameraTable[i][2] == tag then
            table.remove(cameraManager.cameraTable,i)
            table.insert(cameraManager.cameraTable, i, {var, tag})
            return var
        end
    end
    table.insert(cameraManager.cameraTable, {var, tag})
    return var
end
function cameraManager.destroyCamera(tag)
    if #cameraManager.cameraTable < 1 then
        return
    end
    for i = 1, #cameraManager.cameraTable do
        if cameraManager.cameraTable[i][2] == tag then
            cameraManager.cameraTable[i] = nil
            collectgarbage()
        end
    end
end
function cameraManager.cleanCameras()
    if #cameraManager.cameraTable < 1 then
        return
    end
    for i = 1, #cameraManager.cameraTable do
        cameraManager.cameraTable[i] = nil
        collectgarbage()
    end
end
function cameraManager.drawCameras()
    for i = 1, #cameraManager.cameraTable do
        cameraManager.cameraTable[i][1]:draw(function()
            cameraManager.cameraTable[i][1]:drawObjects()
        end)
    end
end

return cameraManager