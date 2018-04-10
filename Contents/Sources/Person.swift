import SpriteKit
import Foundation

/**
 Person sprite, to control the person (e.g. cross pedestrian crossing)
 */
public class Person: BaseSprite, UpdatableNode {
    private var textures = [SKTexture]()
    private var crossing: Bool = false
    private let walkSpeed: CGFloat = 50
    
    /**
     Initialize walking sprite
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for i in 1...12 {
            let Name = "person-state-\(i).png"
            self.textures.append(SKTexture(imageNamed: Name))
        }
        
        self.run(SKAction.repeatForever(SKAction.animate(with: self.textures, timePerFrame: 0.05)))
    }
    
    /**
     Start crossing the pedestrian crossing
     */
    public func cross() {
        self.physicsBody?.velocity = CGVector(dx: -self.walkSpeed, dy: 0)
        self.crossing = true
    }
    
    /**
     If the person is crossing, check if we should change it's direction to move out of view
     */
    public func update(_ currentTime: TimeInterval) {
        if (crossing) {
            let tileSize: CGFloat = CarScene.tileSize
            
            if (self.position.x <= -(tileSize/2 + self.size.width)/2) {
                let rotateAction = SKAction.rotate(toAngle: -CGFloat.pi, duration: 1)
                self.run(rotateAction)
                
                self.physicsBody?.velocity = CGVector(dx: 0, dy: self.walkSpeed)
                crossing = false
            }
        }
    }
}
