-- Tutorial 2: Left or Right?

-- buy a train at round start and place it in the top left corner of the map:
function ai.init( map, money )
   buyTrain(1,1)
   counter = 0
end

function ai.chooseDirection()
   direction = dir(counter)
   print("Heading ".. direction)
   counter = counter + 1
   return direction
end

function dir(i)
   mod = i % 3
   if mod == 0 then
      return "E"
   elseif mod == 1 then
      return "N"
   else
      return "S"
   end
end
