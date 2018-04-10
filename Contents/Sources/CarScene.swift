import Foundation
import AVFoundation
import PlaygroundSupport
import SpriteKit

/**
 Scene class, executing commands from the playground page
 */
public class CarScene: SKScene, PlaygroundLiveViewMessageHandler, SKPhysicsContactDelegate {
    public static let tileSize: CGFloat = 200

    // sprite variables
    private var player: Car!
    private var opponent: Car!
    private var plane: Plane!
    private var trafficLight: TrafficLight!
    private var collision: SKEmitterNode!
    private var night: SKSpriteNode!
    private var carLightLeft: SKLightNode!
    private var carLightRight: SKLightNode!
    private var navigation: Navigation!
    private var person: Person!
    
    private var speedMultiplicationFactor = 2 // speed is multiplicated to prevent too high values
    
    // store several node data
    private var updatableNodes = [UpdatableNode]()
    private var restorableNodes = [RestorableNode]()
    
    private var enforceNightMode: Bool = false // meaning that it won't be reset
    private var backgroundSound: AVAudioPlayer!

    /**
     Method to initialize all sprite variables, and play music
     */
    override public func didMove(to view: SKView) {
        // initialize car and opponent

        self.player = self.childNode(withName: "//car") as! Car
        self.opponent = self.childNode(withName: "//opponent") as! Car
        self.plane = self.childNode(withName: "//plane") as! Plane
        self.trafficLight = self.childNode(withName: "//trafficLight") as! TrafficLight
        self.collision = self.childNode(withName: "//collision") as! SKEmitterNode
        self.night = self.childNode(withName: "//night") as! SKSpriteNode
        self.carLightLeft = self.childNode(withName: "//carLightLeft") as! SKLightNode
        self.carLightRight = self.childNode(withName: "//carLightRight") as! SKLightNode
        self.navigation = self.childNode(withName: "//navigation") as! Navigation
        self.person = self.childNode(withName: "//person") as! Person

        self.navigation.initialize(car: self.player)
        self.player.startSound()
        self.opponent.startSound()

        self.updatableNodes.append(self.player)
        self.updatableNodes.append(self.opponent)
        self.updatableNodes.append(self.navigation)
        self.updatableNodes.append(self.person)

        // setup bitmask for collisions
        self.player.physicsBody?.categoryBitMask = CollisionCategory.car
        self.opponent.physicsBody?.categoryBitMask = CollisionCategory.car

        self.restorableNodes.append(self.player)
        self.restorableNodes.append(self.opponent)
        self.restorableNodes.append(self.person)
        self.restorableNodes.append(self.plane)

        // backup position for the restorable nodes
        self.restorableNodes.forEach { $0.backupPosition() }

        // setup collisions
        self.physicsWorld.contactDelegate = self
        
        // play background music
        self.playBackgroundMusic()
    }
 
    /**
     Method gets called from the EnvironmentController, and handles all commands coming from pages
     */
    public func handleLiveViewAction(_ message: PlaygroundValue) {
        guard case let .dictionary(dictionary) = message else {
            // This is an invalid command
            return
        }
        guard case let .string(command)? = dictionary["Command"] else {
            // This is an invalid command
            return
        }
            
        switch command {
        case "MovePlayerVertical":
            if case let .integer(value)? = dictionary["Value"] {
                self.player.setSpeed(x: 0, y: value * self.speedMultiplicationFactor)
            }
        case "MoveOpponentHorizontal":
            if case let .integer(value)? = dictionary["Value"] {
                self.opponent.setSpeed(x: value * self.speedMultiplicationFactor, y: 0)
            }
        case "TrafficLight":
            if case let .string(value)? = dictionary["Value"] {
                self.setTrafficLightState(state: value)
            }
        case "NavigationDirection":
            if case let .string(value)? = dictionary["Value"] {
                self.setNavigationDirection(direction: value)
            }
        case "Reset":
           resetPlayer()
        case "EnableLights":
            enableCarLights()
        case "BrakeTrafficLight":
            brakePlayerTillTrafficLight()
        case "BrakePedestrianCrossing":
            brakePlayerTillPedestrianCrossing()
        case "ForceCrash":
            forceCrash()
        case "TurnLeft":
            turnLeft()
        case "TurnRight":
            turnRight()
        case "CrossPerson":
            crossPerson()
        case "NightMode":
            enableNightMode()
        default:
            // command could not be found unfortunately
            return
        }
    }
    
    /**
     Method gets called when a collision occured, and then starts particles and sound
     */
    public func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == CollisionCategory.car) &&
            (contact.bodyB.categoryBitMask == CollisionCategory.car) {
            let contactPoint = contact.contactPoint
            let halfWidth = self.size.width / 2
            
            // check if collision is in viewport
            if (abs(contactPoint.x) <= halfWidth) {
                // start the smoke
                self.collision.position = CGPoint(x: contactPoint.x, y: contactPoint.y)
                self.collision.particleBirthRate = 15
                
                self.player.setSpeed(x: 0, y: 0)
                self.opponent.setSpeed(x: 0, y: 0)
                
                // play sound
                self.run(SKAction.playSoundFileNamed("collision.wav", waitForCompletion: false))
                
                // let it rotate for a small sec, then stop moving
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.player.physicsBody?.isDynamic = false
                    self.opponent.physicsBody?.isDynamic = false
                }
            }
        }
    }
    
    /**
     Propegate update action to all sprites that require it
     */
    override public func update(_ currentTime: TimeInterval) {
        self.updatableNodes.forEach { $0.update(currentTime) }
    }
    
    /**
     Method to force a crash between the opponent and the current player car
     */
    public func forceCrash() { //
        let opponentX = abs(self.opponent.getX()) // calculate distance that the opponent needs to travel till center
        let carY = abs(self.player.getY()) // calculate distance that player travels till center
        let carSpeed = self.player.getVerticalSpeed()! // find how fast player is going

        let timeTillCenter = carY / carSpeed // calculate how long it takes for the player to reach the center
        let opponentSpeed = opponentX / timeTillCenter // calculate how fast the opponent needs to go to force crash

        self.opponent.setSpeed(x: -opponentSpeed, y: 0)
    }
    
    /**
     Method to enable the night mode (will also light car lights, if they are enabled)
     */
    public func enableNightMode() {
        self.night.alpha = 0.0
        self.night.run(SKAction.fadeIn(withDuration: 2.0))
        self.backgroundSound.volume = 0
   }
    
    /**
      Method fades out the night mode
      */
    public func disableNightMode() {
        self.night.run(SKAction.fadeOut(withDuration: 2.0))
        self.backgroundSound.volume = 1
    }
    
    /**
     Force night mdoe, so it still is on when scene is reset
     */
    public func forceNightMode() {
        self.enforceNightMode = true
        self.enableNightMode()
    }
    
    /**
     Method enables navigation screen in the corner of the screen
     */
    public func enableNavigation() {
        self.navigation.alpha = 1
    }
 
    /**
     Start playing the bird sound
     */
    private func playBackgroundMusic() {
        do {
            if let url = Bundle.main.url(forResource: "background", withExtension: "wav") {
                self.backgroundSound = try AVAudioPlayer(contentsOf: url)
                self.backgroundSound.numberOfLoops = -1
                self.backgroundSound.prepareToPlay()
                self.backgroundSound.play()
            }
        } catch {
            print("Error playing background music!")
        }
    }
    
    /**
     Reset player and other sprite to its original position
     */
    private func resetPlayer() {
        self.player.setSpeed(x: 0, y: 0)
        self.player.physicsBody?.isDynamic = true
        
        self.opponent.setSpeed(x: 0, y: 0)
        self.opponent.physicsBody?.isDynamic = true
        
        self.person.setSpeed(x: 0, y: 0)
        
        self.collision.particleBirthRate = 0
        self.trafficLight.state = .red
        
        self.disableCarLights()
        
        // restore all nodes to their original position
        self.restorableNodes.forEach { $0.restorePosition() }
        
        if (!self.enforceNightMode) { // check if night mode was on at the start of the scene
            self.disableNightMode()
        }
    }
    
    /**
     Enable car lights (when night mode is enabled)
     */
    private func enableCarLights() {
        self.carLightLeft.isEnabled = true
        self.carLightRight.isEnabled = true
    }
    
    /**
     Disable car lights
     */
    private func disableCarLights() {
        self.carLightLeft.isEnabled = false
        self.carLightRight.isEnabled = false
    }
    
    /**
     Method brakes the car till right before the traffic light
     */
    private func brakePlayerTillTrafficLight() {
        let halfTileSize = 0.5 * CarScene.tileSize // half the tile size away from the center
        let halfPlayerSize = 0.5 * self.player.getHeight() // half the player height away from the center
        
        self.player.brakeVerticalForDistance(distance: (
            abs(self.player.getY()) - halfTileSize - halfPlayerSize
        ))
    }
    
    /**
     Method brakes the car till right before the pedestrian crossing
     */
    private func brakePlayerTillPedestrianCrossing() {
        let halfTileSize = 0.5 * CarScene.tileSize // half the tile size away from the center
        let halfPlayerSize = 0.5 * self.player.getHeight() // half the player height away from the center
        
        self.player.brakeVerticalForDistance(distance: (
            abs(self.player.getY()) - halfTileSize - halfPlayerSize
        ))
    }
    
    /**
     Let a person cross the pedestrian crossing
     */
    private func crossPerson() {
        self.person.cross()
    }
 
    /**
     Make the car turn left
     */
    private func turnLeft() {
        self.player.turnLeft()
    }
    
    /**
     Make the car turn right
     */
    private func turnRight() {
        self.player.turnRight()
    }

    /**
     Set traffic light state by string value (from command)
     */
    private func setTrafficLightState(state: String) {
        switch state {
        case "red":
            self.trafficLight.state = .red
            break
        case "orange":
            self.trafficLight.state = .orange
            break
        case "green":
            self.trafficLight.state = .green
            break
        default:
            return
        }
    }

    /**
     Set navigation direction by string value (from command)
     */
    private func setNavigationDirection(direction: String) {
        switch direction {
        case "left":
            self.navigation.direction = .left
            break
        case "right":
            self.navigation.direction = .right
            break
        case "forward":
            self.navigation.direction = .forward
            break
        default:
            return
        }
    }
}
