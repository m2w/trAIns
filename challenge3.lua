-- Challenge 3: Smalltown

function ai.init(map, money)
   buyTrain(8,0, "E")
   transit = false
   isolated = true
end

function ai.newTrain(train)
   -- for some reason train creation is delayed
   -- but the train counter for the challenge gets incremented immediately
   -- this means trying to buy two trains in init will ALWAYS fail...
   buyTrain(15,12, "W")
end

function ai.newPassenger(name, x, y, destX, destY, vipTime)
   if not isolated and x > 7 and y < 6 then
      isolated = true -- new passenger on the isolated track
   end
end

function ai.foundDestination(train)
   dropPassenger(train)
end

function ai.chooseDirection(train, directions)
   -- only go to the inter-city junction if there is a reason to
   if (train.nextX == 7 and train.nextY == 7) or (train.nextX == 10 and train.nextY == 9) then
      if (train.passenger == nil and transit) or (train.passenger and city(train.passenger) ~= train.ID) then
	 if train.ID == 1 then
	    return "E"
	 else
	    return "W"
	 end
      elseif train.ID == 1 then
	 return "W"
      else
	 return "N"
      end
   end

   -- ensure that trains stay in their own city
   if train.x == 7 and train.y == 9 then
      if train.ID == 1 then
	 return "N"
      else
	 return "E"
      end
   elseif train.nextX == 8 and train.nextY == 9 then
      return "W"
   end

   -- handle inner city junctions
   -- NW city
   if train.ID == 1 then
      if train.nextX == 7 and train.nextY == 4 then
	 if train.passenger == nil and isolated then
	    if train.dir == "W" then
	       isolated = false
	    else
	       return "E"
	    end
	 elseif train.passenger and train.passenger.destX > 7 and train.passenger.destY < 6 then
	    return "E"
	 elseif train.dir == "N" then
	    return "W"
	 else
	    return "S"
	 end
      elseif train.dir == "N" then
	 return "W"
      end
   end

   -- SE city
   if train.passenger and city(train.passenger) ~= train.ID then
      if train.nextX == 10 and train.nextY == 10 then
	 return "N"
      else
	 return "S"
      end
   elseif train.passenger then
      return closest(train, directions)
   end
   return randomDirection(train, directions) -- rather inefficient!!!
end

-- check if we found the passenger at a special location (inter-city junction, or zombie track)
function ai.foundPassengers(train, passengers)
   -- handle the inter-city junction
   if train.x == 7 and train.y == 9 then
      validPassengers = filter(passengers, train)
      if #validPassengers then
	 dropPassenger(train) -- this is necessary as it seems that mapEvent is thrown after foundPassengers is called
	 return validPassengers[1]
      else
	 return nil
      end
   end

   -- check if there are more passengers on the isolated track segment
   if train.ID == 1 and train.x > 7 and train.passenger then
      isolated = true
   else
      return passengers[1]
   end
end


-- called when a train enters the inter-city junction
-- drop off passengers that are headed for the other city
function ai.mapEvent(train)
   if train.passenger and city(train.passenger) ~= train.ID then
      transit = true
      dropPassenger(train)
   end
end

---------------------------------------------------
-- INTERNAL FUNCTIONS
---------------------------------------------------

-- filters a list of passengers to only contain those
-- whose destination is inside the train's city
function filter(passengers, train)
   t = {}
   x = 1
   for i=1, #passengers do
      if city(passengers[i]) == train.ID then
	 t[x] = passengers[i]
	 x = x + 1
      end
   end
   return t
end

function city(passenger)
   return c(passenger.destX, passenger.destY)
end

-- returns which city a destination is in
function c(destX, destY)
   if destX > 8 and destY > 6 then
      return 2
   else
      return 1
   end
end

-- returns a more optimal direction for train 2 at junctions
function closest(train, directions) -- train 2 only
   if train.passenger == nil and transit then
      if train.dir == "N" then
	 return "E"
      elseif train.dir == "E" then
	 return "S"
      else
	 return "N"
      end
   elseif city(train.passenger) == train.ID then
      if inner(train.passenger) then
	 return "S"
      else
	 return "E"
      end
   end
end

-- returns whether a passenger wants to go to the inner circle of city 2
function inner(passenger)
   return passenger.destX < 14 and passenger.destY < 11
end

-- returns the fastest direction to a passengers destination
function closestPossible(train, directions)
   dX = train.passenger.destX
   dY = train.passenger.destY
   if dX < train.nextX and directions["W"] then
      return "W"
   elseif dX > train.nextX and directions["E"] then
      return "E"
   elseif dY > train.nextY and directions["N"] then
      return "N"
   elseif dY < train.nextY and directions["S"] then
      return "S"
   end
end

-- returns a list of possible directions
function possible(directions)
   t = {}
   x = 1
   if directions["N"] then
      t[x] = "N"
      x = x + 1
   end
   if directions["E"] then
      t[x] = "E"
      x = x + 1
   end
   if directions["S"] then
      t[x] = "S"
      x = x + 1
   end
   if directions["W"] then
      t[x] = "W"
      x = x + 1
   end
   return t
end

-- returns a random direction from those possible
function randomDirection(train, directions)
   d = possible(directions)
   r = random(#d)
   return d[r]
end
