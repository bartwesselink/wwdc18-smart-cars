import SpriteKit

/**
 Class contains logic for all sprites (e.g. restoring position, setting speed)
 */
public class BaseSprite: SKSpriteNode, RestorableNode {
    private var oldPosition: CGPoint? // contains the old position when the node was added to the scene
    private var oldRotation: CGFloat? // contains the old rotation when the node was added to the scene
    
    /**
     Method to store position at initialization
     */
    public func backupPosition() {
        self.oldPosition = CGPoint(x: self.position.x, y: self.position.y)
        self.oldRotation = CGFloat(self.zRotation)
    }
    
    /**
     Method to restore position (if it has been backed up)
     */
    public func restorePosition() {
        if let position = self.oldPosition, let rotation = self.oldRotation {
            self.position = position
            self.zRotation = rotation
        }
    }

    /**
     Method to move the sprite
     */
    public func setSpeed(x: CGFloat, y: CGFloat) {
        self.physicsBody?.velocity = CGVector(dx: x, dy: y)
    }
    
    /**
     Overload method to set speed by using integers
     */
    public func setSpeed(x: Int, y: Int) {
        self.setSpeed(x: CGFloat(x), y: CGFloat(y))
    }
    
    /**
     Return current horizontal speed
     */
    public func getVerticalSpeed() -> CGFloat? {
        return self.physicsBody?.velocity.dy
    }
    
    /**
     Return current vertical speed
     */
    public func getHorizontalSpeed() -> CGFloat? {
        return self.physicsBody?.velocity.dx
    }
    
    /**
     Return current horizontal position
     */
    public func getX() -> CGFloat {
        return self.position.x
    }
    
    /**
     Return current vertical position
     */
    public func getY() -> CGFloat {
        return self.position.y
    }
    
    /**
     Return sprite height
     */
    public func getHeight() -> CGFloat {
        return self.size.height
    }
    
    /**
     Return sprite widht
     */
    public func getWidth() -> CGFloat {
        return self.size.width
    }
}
