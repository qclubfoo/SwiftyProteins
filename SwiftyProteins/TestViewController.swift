//
//  TestViewController.swift
//  SwiftyProteins
//
//  Created by Михаил Фокин on 29.01.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class TestViewController: UIViewController {
    
    @IBOutlet var scnView: SCNView!
    //var scnView: SCNView!
    var scnScene: SCNScene!
    
    var cameraNode: SCNNode!
    
    var firstObject: SCNNode!
    var ball: SCNNode!
    
    var left = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        //setView()
        setScene()
        createObject()
        createBall()
        setLight()
        setCamera()
        
        // Do any additional setup after loading the view.
    }
    
    func setScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        
        scnView.showsStatistics = true              // Отображение статичтики
        scnView.backgroundColor = .black
        scnView.allowsCameraControl = true          // Разрешение на ручное взаимодействие с объектом
        //scnView.autoenablesDefaultLighting = true   // Атоматическое добавление источника света.
    }
    
    func setView( ){
        scnView = self.view as? SCNView
    }
    
    func setCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 3
        cameraNode.position = SCNVector3Make(20, 20, 20)
        cameraNode.eulerAngles = SCNVector3Make(-45, 45, 0)
        let constrain = SCNLookAtConstraint(target: firstObject)
        constrain.isGimbalLockEnabled = true
        cameraNode.constraints = [constrain]
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func createObject() {
        firstObject = SCNNode()
        let geometry = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
        firstObject.geometry = geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 1.0, green: 0.7, blue: 0, alpha: 1)
        firstObject.geometry?.materials = [material]
        firstObject.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(firstObject)
    }
    
    func createBall() {
        let geometry = SCNSphere(radius: 0.3)
        ball = SCNNode(geometry: geometry)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.cyan
        ball.geometry?.materials = [material]
        ball.position = SCNVector3Make(0, 1.5, 0)
        scnScene.rootNode.addChildNode(ball)
        
    }
    func setLight() {
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = .directional
        light.eulerAngles = SCNVector3Make(-45, 45, 0)
        scnScene.rootNode.addChildNode(light)
        
        let light2 = SCNNode()
        light2.light = SCNLight()
        light2.light?.type = .directional
        light2.eulerAngles = SCNVector3Make(45, 45, 0)
        scnScene.rootNode.addChildNode(light2)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if left == false {
            ball.removeAllActions()
            // бесконечно двигаем шарик по координате X со скоростью 50, длительностью 20 мс
            ball.runAction(.repeatForever(.move(by: SCNVector3Make(-5, 0, 0), duration: 20)))
            left = true
        } else {
            ball.removeAllActions()
            // бесконечно двигаем шарик по координате Y со скоростью 50, длительностью 20 мс
            ball.runAction(.repeatForever(.move(by: SCNVector3Make(0, -5, 0), duration: 20)))
            left = false
        }
    }
    
    deinit {
        print("Deinit TestViewController")
    }
}

extension TestViewController {
    static func storyboardInstance() -> TestViewController {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? TestViewController else { fatalError("LoginVC doesn't exist") }
        return vc
    }
}
