//#-code-completion(everything, hide)
//#-code-completion(identifier, show, drive())
/*:
 Now that we've finally come here, it is time to put all the pieces together. Everything you've created in previous pages, is now combined into one method: `drive()`. It contains everything: person and traffic light detection, auto-navigation and auto-lighting. In this playbook we've covered the very basics of how self-driving cars work, so by now you should be able to understand how [sensors](glossary://sensor) and [actuators](glossary://actuator) (like [motors](glossary://motor)) work together in these cars.
 */
//#-hidden-code

import PlaygroundSupport
import Foundation

var mustDrive = false
let communicator = Communicator()
let defaultSpeed = Car.defaultSpeed
let solution = "`drive()`"

/**
 Function to check if the correct method was called
 */
func drive() {
    mustDrive = true
}

/**
 Play everying after each other
 */
func play() {
    PlaygroundPage.current.needsIndefiniteExecution = true
    
    communicator.sendNavigationDirection("forward")
    communicator.sendPlayerSpeed(defaultSpeed)

    // then send the command to break
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        communicator.sendPlayerBrakeTillTrafficLight()
    }
    
    // let opponent pass
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        communicator.sendOpponentSpeed(-100)
    }
    
    // move on and enable the night mode
    DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
        communicator.sendTrafficLightColor("green")
        communicator.sendPlayerSpeed(defaultSpeed)
        communicator.sendEnableNightMode()
        communicator.sendPlayerEnableLights()
    }
    
    // wait for a passing person
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        communicator.sendPlayerBrakeTillPedestrianCrossing()
        communicator.sendCrossPerson()
    }
    
    // passing person has passed, so move on
    DispatchQueue.main.asyncAfter(deadline: .now() + 16) {
        communicator.sendPlayerSpeed(defaultSpeed)

        PlaygroundPage.current.finishExecution()
    }
}

// create a closure (which is not visible for the user)
let brain: () -> () = {
//#-end-hidden-code
//#-editable-code What is the only method we have to call?

//#-end-editable-code
//#-hidden-code
}

communicator.sendReset()
brain()

if (mustDrive) {
    play()
    
    PlaygroundPage.current.assessmentStatus = .pass(message: "Well done. Feels good, having built your very own smart car, right?")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["There is one function that will make the car drive."], solution: solution)
}
//#-end-hidden-code
/*:
 That was it! 🎉 You did it, you've built your very own basic smart car. Of course, real life cars are way more advanced. They have more [sensors](glossary://sensor), so they have to process way more things. Maybe this playground has made you excited about this field of science, I sure hope it did 😃.
 */
