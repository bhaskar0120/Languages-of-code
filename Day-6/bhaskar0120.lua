
-- Get input 
f = io.open('inp.txt', 'r')
s = f:read('line')
f:close()

array = {}
function convertToIterable()
  local count = 0
  for i in s:gmatch('.') do
    array[count] = i
    count = count + 1
  end
  len = count
end

function Solution(r)
  local found = {}
  local count = 0 --Count of unique character in sliding window
  for i=0,len-1 do
    if found[array[i]] == nil or found[array[i]] == 0 then 
      found[array[i]] = 1 
      count = count + 1
    else
      found[array[i]] = found[array[i]] + 1
    end

    if i > (r-1) then 
      if found[array[i-r]] == 1 then
        count = count - 1
      end
      found[array[i-r]] = found[array[i-r]] - 1
    end
    if count == r then 
      return i+1
    end
  end
end


convertToIterable()

print("Easy: "..Solution(4))
print("Hard: "..Solution(14))
