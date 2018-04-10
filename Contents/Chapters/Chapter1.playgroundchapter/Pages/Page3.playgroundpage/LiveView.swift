import PlaygroundSupport
import SpriteKit

// Load the SKScene from 'GameScene.sks'
let sceneView = EnvironmentController(frame: CGRect(x:0 , y:0, width: 768, height: 1024))
if let scene = CarScene(fileNamed: "CarScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill

    // Present the scene
    sceneView.presentScene(scene)
    scene.forceNightMode()
    scene.enableNavigation()
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
