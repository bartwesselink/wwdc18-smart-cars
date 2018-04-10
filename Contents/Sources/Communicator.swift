import Foundation
import PlaygroundSupport

/**
 Communicate with the live view, from playground pages
 */
public class Communicator {
    private var proxy: PlaygroundRemoteLiveViewProxy
    
    /**
     Initialize proxy to pass over data
     */
    public init() {
        self.proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
    }
    
    /**
     Send command "Reset"
     */
    public func sendReset() {
        self.sendCommand(name: "Reset") // force a crash with other car
    }
 
    /**
     Send command "MovePlayerVertical"
     */
    public func sendPlayerSpeed(_ speed: Int) {
        self.sendCommand(name: "MovePlayerVertical", value: speed) // function moves player car up
    }
    
    /**
     Send command "BrakeTrafficLight"
     */
    public func sendPlayerBrakeTillTrafficLight() {
        self.sendCommand(name: "BrakeTrafficLight")
    }
   
    /**
     Send command "BrakePedestrianCrossing"
     */
    public func sendPlayerBrakeTillPedestrianCrossing() {
        self.sendCommand(name: "BrakePedestrianCrossing")
    }
    
    /**
     Send command "MoveOpponentHorizontal"
     */
    public func sendOpponentSpeed(_ speed: Int) {
        self.sendCommand(name: "MoveOpponentHorizontal", value: speed) // function moves opponent car up
    }
    
    /**
     Send command "ForceCrash"
     */
    public func sendForceCrash() {
        self.sendCommand(name: "ForceCrash") // force a crash with other car
    }
    
    /**
     Send command "TrafficLight"
     */
    public func sendTrafficLightColor(_ color: String) {
        self.sendCommand(name: "TrafficLight", value: color)
    }
    
    /**
     Send command "CrossPerson"
     */
    public func sendCrossPerson() {
        self.sendCommand(name: "CrossPerson") // let a pedestrian cross the crossing
    }
    
    /**
     Send command "NavigationDirection"
     */
    public func sendNavigationDirection(_ direction: String) {
        self.sendCommand(name: "NavigationDirection", value: direction)
    }
    
    /**
     Send command "TurnLeft"
     */
    public func sendPlayerTurnLeft() {
        self.sendCommand(name: "TurnLeft") // turn the car left
    }
    
    /**
     Send command "TurnRight"
     */
    public func sendPlayerTurnRight() {
        self.sendCommand(name: "TurnRight") // turn the car right
    }
    
    /**
     Send command "EnableLights"
     */
    public func sendPlayerEnableLights() {
        self.sendCommand(name: "EnableLights")
    }
    
    /**
     Send command "NightMode"
     */
    public func sendEnableNightMode() {
        self.sendCommand(name: "NightMode")
    }
    
    /**
     Send command without value
     */
    private func sendCommand(name: String) {
        let command: PlaygroundValue
        command = .dictionary([
            "Command": .string(name),
        ])
        proxy.send(command)
    }
    
    /**
     Send command with integer value
     */
    private func sendCommand(name: String, value: Int) {
        let command: PlaygroundValue
        command = .dictionary([
            "Command": .string(name),
            "Value": .integer(value),
        ])
        proxy.send(command)
    }
    
    /**
     Send command with string value
     */
    private func sendCommand(name: String, value: String) {
        let command: PlaygroundValue
        command = .dictionary([
            "Command": .string(name),
            "Value": .string(value),
        ])
        proxy.send(command)
    }
}
