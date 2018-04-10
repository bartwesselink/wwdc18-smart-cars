//#-code-completion(everything, hide)
//#-code-completion(identifier, show, moveForward(), moveLeft(), moveRight(), enableLights())
/*:
 It has been so long since we've started, that night has fallen. Don't forget to enable your lights (call `enableLights()`)! We will now move on with an essential part for self-driving cars, namely: [navigation](glossary://navigation). How does a car know where to go, if we don't tell it? The next part of implementing the brain, is creating the navigation controller. This controller (🗺️) has a property `🗺️.direction`, which can be `.left`, `.forward`, `.right`. It is up to you to implement the directions. We added two methods, so now you have `moveForward()`, `moveLeft()` and `moveRight()`.
 */
//#-hidden-code

import PlaygroundSupport
import Foundation

let communicator = Communicator()
let 🌃 = true
let defaultSpeed = Car.defaultSpeed
let solution = """
```
if (🌃) {
    enableLights()
}

switch (🗺️.direction) {
case .left:
    moveLeft()
    break
case .right:
    moveRight()
    break
case .forward:
    moveForward()
    break
}
```
"""

var mustEnableLights = false
var mustGoLeft = false
var mustGoForward = false
var mustGoRight = false

/**
 Reset test conditions
 */
func resetTest() {
    mustEnableLights = false
    mustGoLeft = false
    mustGoForward = false
    mustGoRight = false
}

/**
 Function to check if correct method was called
 */
func enableLights() {
    mustEnableLights = true
}

/**
 Function to check if correct method was called
 */
func moveLeft() {
    mustGoLeft = true
}

/**
 Function to check if correct method was called
 */
func moveRight() {
    mustGoRight = true
}

/**
 Function to check if correct method was called
 */
func moveForward() {
    mustGoForward = true
}

/**
 Delay the execution, so that the car has gone out of view
 */
func waitExecution() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
        PlaygroundPage.current.finishExecution()
    }
}

/**
 Simulate a left turn
 */
func simulateLeft(navigationDirection: String = "left") {
    PlaygroundPage.current.needsIndefiniteExecution = true
    
    communicator.sendTrafficLightColor("green")
    communicator.sendPlayerEnableLights()
    communicator.sendPlayerSpeed(defaultSpeed)
    communicator.sendNavigationDirection(navigationDirection)
    communicator.sendPlayerTurnLeft()
    waitExecution()
}

/**
 Simulate a right turn
 */
func simulateRight(navigationDirection: String = "right") {
    PlaygroundPage.current.needsIndefiniteExecution = true
    
    communicator.sendTrafficLightColor("green")
    communicator.sendPlayerEnableLights()
    communicator.sendPlayerSpeed(defaultSpeed)
    communicator.sendNavigationDirection(navigationDirection)
    communicator.sendPlayerTurnRight()
    waitExecution()
}

/**
 Simulate forward move
 */
func simulateForward(navigationDirection: String = "forward") {
    PlaygroundPage.current.needsIndefiniteExecution = true
    
    communicator.sendTrafficLightColor("green")
    communicator.sendPlayerEnableLights()
    communicator.sendPlayerSpeed(defaultSpeed)
    communicator.sendNavigationDirection(navigationDirection)

    waitExecution()
}

// create a closure (which is not visible for the user)
let brain: (Navigation) -> () = {
    let 🗺️: Navigation = $0

//#-end-hidden-code
if (🌃) {
    /*#-editable-code*/<#Night time! No sleep yet, but what is necessary?#>/*#-end-editable-code*/
}
    
switch (🗺️.direction) {
case /*#-editable-code*/<#Which direction?#>/*#-end-editable-code*/:
    /*#-editable-code*/<#What do we have to do then?#>/*#-end-editable-code*/
    break
case /*#-editable-code*/<#Which direction?#>/*#-end-editable-code*/:
    /*#-editable-code*/<#What do we have to do then?#>/*#-end-editable-code*/
    break
case /*#-editable-code*/<#Which direction?#>/*#-end-editable-code*/:
    /*#-editable-code*/<#What do we have to do then?#>/*#-end-editable-code*/
    break
}
//#-hidden-code
}

communicator.sendReset()

// testing the correct cases
let navigation = Navigation()
navigation.direction = .forward

brain(navigation)

if (!mustEnableLights) {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["First things first! It's night, so what is the most important thing we need to do?"], solution: solution)
} else {
    if (!mustGoForward) {
        if (mustGoLeft && !mustGoRight) {
            simulateLeft(navigationDirection: "forward")
        } else if (mustGoRight && !mustGoLeft) {
            simulateRight(navigationDirection: "forward")
        }
        
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Mmm... your car won't go forward when it needs to."], solution: solution)
    } else {
        resetTest()
        navigation.direction = .left
        
        brain(navigation)
        
        if (!mustGoLeft) {
            if (mustGoForward && !mustGoRight) {
                simulateForward(navigationDirection: "left")
            } else if (mustGoRight && !mustGoForward) {
                simulateRight(navigationDirection: "right")
            }
            
            PlaygroundPage.current.assessmentStatus = .fail(hints: ["Mmm... your car won't go left when it needs to."], solution: solution)
        } else {
            navigation.direction = .right
            
            brain(navigation)
            
            if (!mustGoRight) {
                if (mustGoLeft && !mustGoForward) {
                    simulateLeft(navigationDirection: "right")
                } else if (mustGoForward && !mustGoLeft) {
                    simulateForward(navigationDirection: "right")
                }
                
                PlaygroundPage.current.assessmentStatus = .fail(hints: ["Mmm... your car won't go right when it needs to."], solution: solution)
            } else {
                // determine which (random) direction we will show
                switch(arc4random_uniform(2)) {
                case 0:
                    simulateLeft()
                    break
                case 1:
                    simulateRight()
                    break
                default:
                    simulateLeft()
                    break
                }
                PlaygroundPage.current.assessmentStatus = .pass(message: "Well done! You've now completed all functionalities of our self-driving car. [Ready to see the result?](@next)")
            }
        }
    }
}

//#-end-hidden-code
/*:
 We've now added everything our smart car needs. [Click here to see the result!](@next)
 */

