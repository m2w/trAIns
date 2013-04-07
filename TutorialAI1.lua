-- Tutorial 1: Baby Steps
function ai.init()
   buyTrain(1,3)
   buyTrain(5,4)
end

function ai.foundPassengers(train, passengers)
   print("Welcome aboard " .. passengers[1].name)
   return passengers[1]
end

function ai.foundDestination(train)
   print("Thank you for traveling with trAIns!")
   dropPassenger(train)
end
