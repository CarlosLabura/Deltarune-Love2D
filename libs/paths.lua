local path = {}

path.image = function(key)
    return "assets/images/"..key..'.png'
end

path.xml = function(key)
    return "assets/images/"..key..'.xml'
end

path.character = function(key)
    return "assets/data/characters/"..key..'.json'
end

path.json = function(key)
    return "assets/data/"..key..'.json'
end

path.txt = function(key)
    return "assets/data/"..key..'.txt'
end

return path
