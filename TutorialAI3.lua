-- Tutorial 3: Be smart!

function ai.init()
   buyTrain(3,1)
end

function ai.chooseDirection(train, directions)
   if train.passenger then
      print(train.name .. " carries " .. train.passenger.name)
      if train.passenger.destX < train.x then
	 return "W"
      else
	 return "E"
      end
   else
      print(train.name .. " carries no passenger.")
      return "S"
   end
end

function ai.foundPassengers(train, passengers)
   i = 1
   while i < #passengers do
      if train.ID % 2 == 0 and passengers[i].destX < train.x then
	 return passengers[i]
      elseif train.ID % 2 == 1 and passengers[i].destX > train.x then
	 return passengers[i]
      end
      i = i + 1
   end
end

function ai.foundDestination(train)
   dropPassenger(train)
end

function ai.enoughMoney()
   buyTrain(3,4, "S")
end
