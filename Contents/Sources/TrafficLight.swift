import SpriteKit

/**
 Traffic light sprite, controls the value for the traffic light
 */
public class TrafficLight: BaseSprite {
    public enum TrafficLightState { // enumeration containing the possible outcomes for a traffic light color
        case red
        case orange
        case green
    }
    
    public var currentState: TrafficLightState = .red
    public var state: TrafficLightState {
        set {
            self.currentState = newValue
            
            switch newValue {
            case .red:
                self.texture = SKTexture(image:#imageLiteral(resourceName: "traffic-sign-red.png"))
                break
            case .orange:
                self.texture = SKTexture(image: #imageLiteral(resourceName: "traffic-sign-orange.png"))
                break
            case .green:
                self.texture = SKTexture(image: #imageLiteral(resourceName: "traffic-sign-green.png"))
                break
            }
        }
        get { return self.currentState }
    }
}
