/*:
 ![🚗 Smart Cars](logo-small.png)
 
 [Artificial Intelligence](glossary://artificial%20intelligence) is a trendy term for tech companies. Several companies have started working on self-driving cars, but how does a car know what to do? This is what we will find out in this playground! We're building our very own smart, self-driving, car!
 
 Let's get started. A car has [actuators](glossary://actuator), like a [motor](glossary://motor). Try getting a feeling of the car by driving it in a straight line.
 * note:
 Considering there is no traffic, maybe a speed of 50 is sufficient?
 */
//#-hidden-code
import PlaygroundSupport
import SpriteKit

let communicator = Communicator()
let solution = "`moveForward(speed: 50)`"

/**
 Communicate with the live view that the car needs to start moving
 */
func moveForward(speed: Int) {
    if (speed <= 0) {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Mm.. this is not correct, our car cannot drive backwards at the moment..."], solution: solution)
    } else if (speed < 50) {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["You're almost there! But don't you think this is a little slow, considering the fact that there is no traffic?"], solution: solution)
    } else if (speed > 200) {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Unfortunately, our car is not able to drive this fast. Try decreasing the value."], solution: solution)
    } else {
        communicator.sendReset()
        communicator.sendPlayerSpeed(speed)
        
        // to show the player how important traffic lights are, we force a crashabout
        communicator.sendForceCrash()
        
        PlaygroundPage.current.needsIndefiniteExecution = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            PlaygroundPage.current.finishExecution()
        }
        
        PlaygroundPage.current.assessmentStatus = .pass(message: "Wait! Did it just ignore a red traffic light? Ouch... We need to do something about that, and fast! [Click here!](@next)")
    }
}
//#-end-hidden-code
//#-code-completion(everything, hide)
moveForward(speed: /*#-editable-code*/<#T##speed##Int#>/*#-end-editable-code*/)
/*:
 This was easy! But, um, did it just ignore a red traffic light? We need to improve its skills! [Move on!](@next)
 */
