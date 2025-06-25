local utils = {}

utils.range = function(from, to, step)
  local str=''
  for i=from,to,(step or 1) do
      str=str..i..','
  end 
  return str:sub(1, -2)
end

utils.split = function(inputstr, sep)
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

utils.printTable = function(t)
  for k, v in pairs(t) do
    if type(v) == "table" then
      print(k .. ":")
      utils.printTable(v)
    else
      print(k .. ": " .. tostring(v))
    end
  end
end

utils.getFirstLetter = function(str)
  return str:sub(1, 1)
end
utils.getLastLetter = function(str)
  return str:sub(-1, -1)
end
utils.getLetterByPosition = function(str,pos)
  return string.sub(str, pos, pos)
end

utils.getFramesFromFolder = function(folderName)
  local folda = love.filesystem.getDirectoryItems(folderName)
  local freims = {}
  for i = 1, #folda do
      table.insert(freims, folderName..'/'..folda[i])
  end
  return freims
end
utils.reorderArray = function(array)
  table.insert(array, table.remove(array, 1))
  return array
end

utils.tableContains = function(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end



return utils