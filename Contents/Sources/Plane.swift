import SpriteKit
import Foundation

/**
 Plane sprite, plane flies every 30 seconds in and out of the view
 */
public class Plane: BaseSprite {
    private var timer: Timer?
    private let planeSpeed: CGFloat = 160
    private let spawnSpeed: TimeInterval = 30.0
    
    /**
     Initialize the respawn timer
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        timer = Timer.scheduledTimer(timeInterval: self.spawnSpeed, target: self, selector: #selector(self.respawn), userInfo: nil, repeats: true)
    }
    
    /**
     Method that gets called when timer finishes, respawn to the original position
     */
    @objc func respawn() {
        self.restorePosition()
        self.calculateSpeed()
    }
    
    /**
     Given a desired speed, calculate vertical and horizontal components
     */
    private func calculateSpeed() {
        // because our plane is rotated, we want to calculate what the components of its speed should be
        let vY = cos(abs(self.zRotation)) * self.planeSpeed
        let vX = sin(abs(self.zRotation)) * self.planeSpeed
        
        self.physicsBody?.velocity = CGVector(dx: vX, dy: vY)
        
    }
}
