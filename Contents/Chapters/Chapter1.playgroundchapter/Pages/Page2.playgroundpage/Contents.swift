//#-code-completion(everything, hide)
//#-code-completion(identifier, show, move(), stop())
/*:
 That did not work out so well, did it? Now we're going to implement the brain of the car. To do this properly, the car relies on [sensors](glossary://sensor). Our car has several sensors available.
 
 You are going to write code for the brain of your car. Keep in mind that this code gets executed repeatedly, so every [cycle](glossary://cycle) your car will call this procedure. The crash on the previous page could have been prevented, if we had just seen that traffic light... Luckily we have the traffic light sensor. There is a variable `🚦`. This variable contains `nil` when there is no traffic light nearby. If there is, a traffic light is detected, and we need to stop! In the case that there is a traffic light, `🚦?.state` contains either `.red`, `.orange` or `.black`. We also want to detect persons, so we can prevent any accident involving crossing humans. Therefore, the system has a variable `👱🏾` available, which is `true` when a person is seen, and `false` when there is no person around. For your convenience the methods `stop()` (stop the car) and `move()` (move with allowed speed) are added.
 */
//#-hidden-code

// it is hard to check whether this closure is correct. Therefore, we will conduct several tests based on those functions. State will be determined and check whether this equals the expected values.
import PlaygroundSupport
import Foundation

let communicator = Communicator()
let defaultSpeed = Car.defaultSpeed
let solution = """
```
if (🚦 == nil || 🚦?.state == .green) {
    if (👱🏾) {
        stop()
    } else {
        move()
    }
} else {
    stop()
}
```
"""

var mustContinue: Bool = false // while we are evaluating, we store wich methods are called.
var mustStop: Bool = false

/**
 Reset test conditions
 */
func resetTest() {
    mustContinue = false
    mustStop = false
}

/**
 Function to check if correct method was called
 */
func move() {
    mustContinue = true
}

/**
 Function to check if correct method was called
 */
func stop() {
    mustStop = true
}

// create a closure (which is not visible for the user)
let brain: (TrafficLight?, Bool) -> () = {
    let 🚦: TrafficLight? = $0
    let 👱🏾: Bool = $1

//#-end-hidden-code
if (🚦 == nil || 🚦?.state == .green) {
    if (👱🏾) {
        /*#-editable-code*/<#Quick! We spotted a person#>/*#-end-editable-code*/
    } else {
        /*#-editable-code*/<#No person to be seen!#>/*#-end-editable-code*/
    }
} else {
    /*#-editable-code*/<#A red traffic light! Now what?#>/*#-end-editable-code*/
}
//#-hidden-code
}

// communicate with scene to handle the traffic light

/**
 Wait, and let the opponent pass
 */
func playWaitForTrafficLight() {
    // first, move upwards
    communicator.sendPlayerSpeed(defaultSpeed)
    
    // then send the command to break
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        communicator.sendPlayerBrakeTillTrafficLight()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        communicator.sendOpponentSpeed(-100)
    }
}

/**
 Plays the correct state, where it ways for a green light and then waits for the pedestiran
 */
func playCorrectState() {
    PlaygroundPage.current.needsIndefiniteExecution = true
    
    playWaitForTrafficLight()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
        communicator.sendTrafficLightColor("green")
        communicator.sendPlayerSpeed(defaultSpeed)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        communicator.sendPlayerBrakeTillPedestrianCrossing()
        communicator.sendCrossPerson()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 16) {
        communicator.sendPlayerSpeed(defaultSpeed)

        PlaygroundPage.current.finishExecution()
    }
}

/**
 Play the state where the user drives through a red sign
 */
func playThroughRedState() {
    PlaygroundPage.current.needsIndefiniteExecution = true

    // move up, through redcurrent
    communicator.sendPlayerSpeed(defaultSpeed)

    // now force a crash
    communicator.sendForceCrash()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
        PlaygroundPage.current.finishExecution()
    }
}

// test case 1: there is no traffic light
brain(nil, false)

communicator.sendReset()

if (!(mustContinue && !mustStop)) {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Are you sure you implemented the stopping code for person detection right?"], solution: solution)
} else {
    let trafficLight = TrafficLight()
    trafficLight.state = .red

    resetTest()
    brain(trafficLight, false)
    
    if (!(mustStop && !mustContinue)) {
        playThroughRedState()

        PlaygroundPage.current.assessmentStatus = .fail(hints: ["When there is a traffic light, or the traffic light is not green, we have to stop! Try looking at the given methods."], solution: solution)
    } else {
        playCorrectState()

        PlaygroundPage.current.assessmentStatus = .pass(message: "Great! Your cars very first brain. Well done. Ready to evolve it further? [Let's go!](@next)")
    }
}

//#-end-hidden-code
/*:
 Our car is driving really wel! Ready to add more details? [Go to the next page!](@next)
 */
