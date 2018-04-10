import SpriteKit
import AVFoundation

/**
 Car sprite, either player or opponent
 */
public class Car: BaseSprite, UpdatableNode {
    enum TurnDirection {
        case left
        case right
    }
    
    public static let defaultSpeed: Int = 50

    private var brakeAcceleration: CGFloat = -60
    private var brakingVertical: Bool = false
    private var turning: Bool = false
    private var turnDirection: TurnDirection?
    private var turnRotating: Bool = false
    private var turnThreshold: CGFloat = 100
    private var turningSpeed: CGFloat = 70
    private var beforeTurnSpeed: CGFloat?
    private var carSound: AVAudioPlayer?
    
    /**
     Method boots up the car engine sound
     */
    public func startSound() {
        do {
            if let url = Bundle.main.url(forResource: "engine", withExtension: "wav") {
                let carSound = try AVAudioPlayer(contentsOf: url)
                carSound.numberOfLoops = -1
                carSound.prepareToPlay()
                carSound.play()
                carSound.volume = 0 // only when the car moves, play  music
                
                self.carSound = carSound
            }
        } catch {
            print("Error playing engine music!")
        }
    }
    
    /**
     Update every cycle
     */
    public func update(_ currentTime: TimeInterval){
        if (brakingVertical) {
            // check if we're braking the car vertically
            if let verticalSpeed = self.getVerticalSpeed() {
                if Int(verticalSpeed) <= 0 { // if we reached 0, reset
                    self.setSpeed(x: 0, y: 0)
                    self.brakingVertical = false
                } else { // apply a force to stop the car
                    let mass = self.physicsBody?.mass
                    self.physicsBody?.applyForce(CGVector(dx: 0, dy: mass! * self.brakeAcceleration))
                }
            }
        } else if (turning) {
            self.updateTurn()
        }
        
        self.checkOutOfBounds()
        self.checkCarAudio()
    }
    
    /**
     Brake the car on the Y-axis for a distance of x meters, using negative acceleration
     */
    public func brakeVerticalForDistance(distance: CGFloat) {
        // calculate the acceleration needed to stop before center
        if let verticalSpeed = self.getVerticalSpeed() {
            self.brakingVertical = true
            
            // calculate average speed over distance (v0 + v1)
            let avgSpeed = 0.5 * verticalSpeed
            let timeNeeded = distance / avgSpeed // dx/dv = t
            
            let accelerationNeeded = -abs(verticalSpeed / timeNeeded) // dv/dt = a
            self.brakeAcceleration = accelerationNeeded
        }
    }
    
    /**
     Method for initializing a turn, which will be continued in update
     */
    public func turnLeft() {
        self.beforeTurnSpeed = self.getVerticalSpeed()
        self.turning = true
        self.turnDirection = .left
    }
    
    /**
     Method for initializing a turn, which will be continued in update
     */
    public func turnRight() {
        self.beforeTurnSpeed = self.getVerticalSpeed()
        self.turning = true
        self.turnDirection = .right
    }
    
    /**
     Method continues the turn of the car, depending on the direction
     */
    private func updateTurn() {
        let y = self.getY()
        
        // check if we almost reached the center
        if (y >= -self.turnThreshold) {
            let quarterCircle = 0.5*CGFloat.pi
            
            // check if we have not yet completed the turn of 90 degrees
            if (abs(self.zRotation) < quarterCircle) {
                // if we want to travel at turningSpeed, calculate vertical and horizontal components
                let dx = self.turningSpeed * sin(self.zRotation)
                let dy = self.turningSpeed * cos(self.zRotation)
                
                // calculate the distance of the quarter circle
                let distance = quarterCircle * self.turnThreshold
                let timeToTravel = distance / self.turningSpeed
                
                self.setSpeed(x: -dx, y: dy)
                
                // check if we already started the rotation
                if (!self.turnRotating) {
                    self.turnRotating = true
                    
                    var angle = quarterCircle
                    
                    // depending on the direction, the angle changes
                    if (self.turnDirection! == .right) {
                        angle = angle * -1
                    }
                    
                    // rotate the car
                    let rotateAction = SKAction.rotate(toAngle: angle, duration: Double(timeToTravel))
                    self.run(rotateAction)
                }
            } else {
                // we finished turning, so reset variables
                self.turning = false
                self.turnRotating = false
                
                var angle = quarterCircle
                var speed = self.beforeTurnSpeed!
                
                // check which direction we have to go, depending on the turn direction
                if (self.turnDirection! == .left) {
                    speed = speed * -1
                } else {
                    angle = angle * -1
                }
                
                self.zRotation = angle
                self.setSpeed(x: speed, y: 0)
            }
        }
    }
    
    /**
     Method to control the engine sound
     */
    private func checkCarAudio() {
        var speed: CGFloat = 0
        
        if (self.getHorizontalSpeed() != 0) {
            speed = self.getHorizontalSpeed()!
        } else if (self.getVerticalSpeed() != 0) {
            speed = self.getVerticalSpeed()!
        }
        
        if let audio = self.carSound {
            audio.volume = Float(min(abs(speed), 70) / 70) * 0.5
        }
    }
    
    /**
      Fade out speed when car gets out of view
      */
    private func checkOutOfBounds() {
        // check if car is out of view
        if let scene = self.scene {
            let halfSceneHeight = scene.size.height / 2 + 100
            let halfSceneWidth = scene.size.width / 2 + 100
            
            let carX = self.getX()
            let carY = self.getY()
            
            var horizontalSpeed = self.getHorizontalSpeed()!
            var verticalSpeed = self.getVerticalSpeed()!
            
            // check if car is out of view and moving in the correct direction
            if (carY > halfSceneHeight && verticalSpeed > 0) {
                verticalSpeed -= 1
                
                if (verticalSpeed < 0) {
                    verticalSpeed = 0
                }
                
                self.setSpeed(x: 0, y: verticalSpeed)
            } else if (carX < -halfSceneWidth && horizontalSpeed < 0) {
                horizontalSpeed += 1
                
                if (horizontalSpeed > 0) {
                    horizontalSpeed = 0
                }
                
                self.setSpeed(x: horizontalSpeed, y: 0)
            } else if (carX > halfSceneWidth && horizontalSpeed > 0) {
                horizontalSpeed -= 1
                
                if (horizontalSpeed < 0) {
                    horizontalSpeed = 0
                }
                
                self.setSpeed(x: horizontalSpeed, y: 0)
            }
        }
    }
}
