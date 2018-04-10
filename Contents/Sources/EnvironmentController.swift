import Foundation
import PlaygroundSupport
import SpriteKit

public class EnvironmentController: SKView, PlaygroundLiveViewMessageHandler {
    /**
     Receive messages from the page, and pass them on to the scene
     */
    public func receive(_ message: PlaygroundValue) {
        if let scene = self.scene as? CarScene {
            scene.handleLiveViewAction(message)
        }
    }
}
