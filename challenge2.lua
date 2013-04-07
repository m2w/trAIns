-- Challenge 2: Smalltown

function ai.init(map, money)
   buyTrain(5,1, "E")
   remotes = 3
   height = map.height
end

function ai.foundPassengers(train, passengers)
   i = 1
   min = {dist=100, i=nil}
   while i<=#passengers do
      dist = distance(train.x, train.y, passengers[i].destX, passengers[i].destY)
      if dist < min.dist then
	 min.dist = dist
	 min.i = i
      end
      i = i +1
   end
   pass = passengers[min.i]
   if train.passenger == nil and train.x > 5 and train.y == 1 then
      remotes = remotes - 1
   end
   return pass
end

function ai.foundDestination(train)
   dropPassenger(train)
end

function ai.chooseDirection(train, directions)
   if train.y < height/2 then
      return "S"
   elseif train.dir == "S" then
      return "E"
   elseif train.dir == "N" then
      return "W"
   elseif train.dir == "W" and remotes > 0 then
      return "N"
   elseif train.dir == "W" then
      return "W"
   end
end

function distance(x1, y1, x2, y2)
   return sqrt((x1-x2)^2 + (y1-y2)^2)
end

function ai.enoughMoney()
   buyTrain(1,1, 'S')
end
