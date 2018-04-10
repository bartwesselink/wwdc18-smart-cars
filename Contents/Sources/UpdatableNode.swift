import Foundation
import SpriteKit

/**
 This protocol specifies which classes' update must be called, when scene's update is called
 */
public protocol UpdatableNode: class {
    func update(_ currentTime: TimeInterval)
}
