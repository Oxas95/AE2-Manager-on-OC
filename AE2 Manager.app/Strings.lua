strings = {}

function strings:split(s, pattern)
  result = {}
  index = nil  
  last = -1
  if s == nil then
    return nil
  end
  repeat
    i, j = string.find(s, pattern)
    if i ~= nil then
      if i == 1 then
        s = string.gsub(s, pattern, "", 1)
      else
        last = last + 1
        result[last] = string.sub(s, 1, i-1)
        s = string.gsub(s, result[last], "", 1)
        s = string.gsub(s, pattern, "", 1)
      end
    end
  until i == nil
  if string.len(s) ~= 0 then
    result[last + 1] = s
  end
  return result
end