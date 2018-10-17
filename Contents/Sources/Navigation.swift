import Foundation
import SpriteKit

/**
 Navigation sprite, updates navigation dot and direction, and state
 */
public class Navigation: BaseSprite, UpdatableNode {
    private var car: Car?
    private var dot: SKSpriteNode!
    private static let padding: CGFloat = 30
    
    /**
     Initialzie the navigation, so it has information about where the car is
     */
    public func initialize(car: Car) {
        self.car = car
        self.dot = self.childNode(withName: "//dot") as! SKSpriteNode
        
        let animation = SKAction.scale(by: 1.15, duration: 0.6)
        
        self.dot.run(SKAction.repeatForever(SKAction.sequence([animation,
                                        animation.reversed()])))
    }
    
    private var currentDirection: Direction = .forward
    public var direction: Direction {
        set {
            self.currentDirection = newValue
            
            switch newValue {
            case .left:
                self.texture = SKTexture(image: #imageLiteral(resourceName: "map-left.png"))
                break
            case .forward:
                self.texture = SKTexture(image: #imageLiteral(resourceName: "map-forward.png"))
                break
            case .right:
                self.texture = SKTexture(image: #imageLiteral(resourceName: "map-right.png"))
                break
            }
        }
        get { return self.currentDirection }
    }
    
    /**
     Every update cycle, the position of the car on the map needs to be updated
     */
    public func update(_ currentTime: TimeInterval) {
        // update navigation point
        if let car = self.car, let scene = self.scene {
            self.updatePosition()
            
            let carX = car.getX()
            let carY = car.getY()
            
            // get size of navigation
            let navigationWidth = self.getWidth()
            let navigationHeight = self.getHeight()
            
            // get scene width
            let sceneWidth = scene.frame.width
            let sceneHeight = scene.frame.height

            // calculate position for the navigation dot
            let carNavigationX = (carX / sceneWidth) * navigationWidth
            let carNavigationY = (carY / sceneHeight) * navigationHeight
            
            // update dot position with a representation of the car
            self.dot.position = CGPoint(x: CGFloat(carNavigationX), y: CGFloat(carNavigationY))
            self.dot.zRotation = self.car!.zRotation
            
            // check if we still have to show the dot (or if it has disappeared out of view)
            let xVisibleTreshold = (self.size.width/2 - self.dot.size.height)
            let yVisibleTreshold = (self.size.height/2 - self.dot.size.width)

            if (carNavigationX > xVisibleTreshold || carNavigationY > yVisibleTreshold || carNavigationX < -xVisibleTreshold) {
                self.dot.alpha = 0.0
            } else {
                self.dot.alpha = 1.0
            }
        }
    }
    
    /**
      Update position to the right corner, based on viewport size
      */
    private func updatePosition() {
        if let scene = self.scene as? CarScene, let view = scene.view {
            let viewSize = view.bounds.size
            
            // get viewport sizes
            let viewHeight = viewSize.height
            let viewWidth = viewSize.width
            
            // get original screen sizes
            let sceneSize = scene.frame.size
            let sceneWidth = sceneSize.width
            let sceneHeight = sceneSize.height
            
            // get navigation size
            let navigationWidth = self.getWidth()
            let navigationHeight = self.getHeight()
            
            var maxWidth: CGFloat
            var maxHeight: CGFloat
            
            // check which sizes is used, depending on the screen size and fill
            if (viewHeight > viewWidth) {
                let aspectRatio = sceneHeight / viewHeight
 
                maxWidth = aspectRatio * viewWidth
                maxHeight = sceneHeight
            } else {
                let aspectRatio = sceneWidth / viewWidth
                
                maxWidth = sceneWidth
                maxHeight = aspectRatio * viewHeight
            }
            
            let halfWidth = maxWidth / 2
            let halfHeight = maxHeight / 2
                        
            let x = -halfWidth + navigationWidth / 2 + Navigation.padding
            let y = halfHeight - navigationHeight / 2 - Navigation.padding
            
            self.position = CGPoint(x: x, y: y)
        }
    }
}
