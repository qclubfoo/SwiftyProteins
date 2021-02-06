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
    
    var ligand: Ligand!
    
    var left = Bool()

    var atomsNods: [SCNNode]!
    
    var centralNode: SCNNode!
    
    var light: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setView()
        setScene()
        //createObject()
        //createPlane()
        //createBall()
        //createCylinder()
        createCentreNode()
        createAtoms()
        createLinks()
        //setLight()
        setCamera()
    }
    
    func setScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        
        scnView.showsStatistics = true              // Отображение статичтики
        scnView.backgroundColor = .lightGray
        //scnView.allowsCameraControl = true          // Разрешение на ручное взаимодействие с объектом
        scnView.autoenablesDefaultLighting = true   // Атоматическое добавление источника света.
    }
    
    func createCentreNode() {
        centralNode = SCNNode()
        centralNode.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(centralNode)
    }
    
    func setCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 15
        cameraNode.position = SCNVector3Make(20, 20, 20)
        let constrain = SCNLookAtConstraint(target: centralNode)
        cameraNode.constraints = [constrain]
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func createObject() {
        firstObject = SCNNode()
        let geometry = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
        firstObject.geometry = geometry
        let material = SCNMaterial()
        //material.diffuse.contents = UIColor(red: 1.0, green: 0.7, blue: 0, alpha: 1)
        firstObject.geometry?.materials = [material]
        firstObject.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(firstObject)
    }
    
    func createBall() {
        let geometry = SCNSphere(radius: 0.3)
        ball = SCNNode(geometry: geometry)
        let material = SCNMaterial()
        //material.diffuse.contents = UIColor.red
        ball.geometry?.materials = [material]
        ball.position = SCNVector3Make(1, 0, 1)
        scnScene.rootNode.addChildNode(ball)
        
    }
    
    func createAtoms() {
        //let atoms = Atom.allAtoms()
        let atoms = ligand.atoms
        atomsNods = [SCNNode]()
        for atom in atoms {
            atomsNods.append(createOneAtom(atom: atom))
        }
    }
    
    func createOneAtom(atom: Atom) -> SCNNode {
        let geometry = SCNSphere(radius: 0.3)
        let ball = SCNNode(geometry: geometry)
        let material = SCNMaterial()
        material.diffuse.contents = getCollorAtom(type: atom.type)
        //material.lightingModel = .
        material.lightingModel = .physicallyBased
        ball.geometry?.materials = [material]
        let coordinats = SCNVector3Make(atom.coordinates.x, atom.coordinates.y, atom.coordinates.z)
        ball.position = coordinats
        scnScene.rootNode.addChildNode(ball)
        return ball
    }
    
    func getCollorAtom(type: AtomType) -> UIColor{
        var collor = UIColor()
        switch type.rawValue {
        case "H":
            collor = UIColor.white
        case "C":
            collor = UIColor.darkGray
        case "N", "U", "W":
            collor = UIColor.blue
        case "O":
            collor = UIColor.red
        case "F", "CL":
            collor = UIColor.green
        case "S", "AU":
            collor = UIColor.yellow
        case "BR":
            collor = UIColor(red: 0.73, green: 0.03, blue: 0, alpha: 1)
        case "B", "CU":
            collor = UIColor(red: 1.0, green: 0.73, blue: 0.47, alpha: 1)
        case "P", "FE", "SE":
            collor = UIColor.orange
        case "I", "AS", "CS", "K", "LI", "MN", "NA":
            collor = UIColor.purple
        case "MO", "RU":
            collor = UIColor(red: 0.15, green: 0.82, blue: 0.82, alpha: 1)
        case "V":
            collor = UIColor(red: 0.74, green: 0.74, blue: 0.76, alpha: 1)
        case "CO", "NI":
            collor = UIColor(red: 1.13, green: 0.6, blue: 0.69, alpha: 1)
        case "BA", "MG", "CA":
            collor = UIColor(red: 0, green: 0.55, blue: 0, alpha: 1)
        case "CD":
            collor = UIColor(red: 1.0, green: 0.97, blue: 0, alpha: 1)
        case "EU":
            collor = UIColor(red: 0, green: 1.0, blue: 0.88, alpha: 1)
        case "GA":
            collor = UIColor(red: 0.89, green: 0.62, blue: 0.62, alpha: 1)
        case "HG", "PT":
            collor = UIColor(red: 0.82, green: 0.82, blue: 0.93, alpha: 1)
        case "LA":
            collor = UIColor(red: 0.36, green: 0.98, blue: 1.0, alpha: 1)
        case "PB":
            collor = UIColor(red: 0.38, green: 0.387, blue: 0.43, alpha: 1)
        case "PD":
            collor = UIColor(red: 0, green: 0.46, blue: 0.6, alpha: 1)
        default:
            break
        }
        return collor
    }
    
    func createOneLight(vectorLight: SCNVector3) {
        light = SCNNode()
        light.light = SCNLight()
        light.light?.type = .directional
        light.eulerAngles = vectorLight
        light.position = SCNVector3Make(10, 10, 10)
        light.constraints = [ SCNLookAtConstraint(target: centralNode)]
        scnScene.rootNode.addChildNode(light)
    }
    
    func setLight() {
        createOneLight(vectorLight: SCNVector3Make(Float(Double.pi / 2.0), 0, 0))
        //createOneLight(vectorLight: SCNVector3Make(-45, -45, 0))
        //createOneLight(vectorLight: SCNVector3Make(0, 0, 90))
    }
    
    func createPlane() {
        let geometry = SCNPlane(width: 20.0, height: 20.0)
        geometry.cornerRadius = 10
        geometry.widthSegmentCount = 10
        geometry.heightSegmentCount = 10
        let plane = SCNNode(geometry: geometry)
        plane.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(plane)
    }
    
    func createCylinder() {
        let geometry = SCNCylinder(radius: 0.1, height: 3)
//
//        let materianl = SCNMaterial()
//        materianl.diffuse.contents = UIColor.green
//        geometry.materials = [materianl]
//        let cylinder = SCNNode(geometry: geometry)
//        cylinder.position = SCNVector3Make(0, 0, 0)
//        cylinder.eulerAngles.x = Float(Double.pi / 2)
//        //cylinder.eulerAngles = ball.eulerAngles
//        let constrain = SCNLookAtConstraint(target: ball)
//        constrain.isGimbalLockEnabled = true
//        //constrain.targetPosition = ball.position
//        //constrain.inv
//        //constrain.isGimbalLockEnabled = true
//        //constrain.localFront = ball.position
//        //constrain.targetOffset = ball.position
//        //constrain.worldUp = ball.position
//        cylinder.constraints = [constrain]
//
//        scnScene.rootNode.addChildNode(cylinder)
        
        let heigth = 5.0
        let zAlignNode = SCNNode()
        zAlignNode.eulerAngles.x = Float(Double.pi / 2)
        
        let cylinder = SCNNode(geometry: geometry)
        cylinder.position.y = Float(-heigth / 2.0)
        zAlignNode.addChildNode(cylinder)
        let pNode = SCNNode()
        pNode.position = SCNVector3Make(0, 3, 0)
        pNode.geometry = SCNSphere(radius: 0.1)
        scnScene.rootNode.addChildNode(pNode)
        pNode.addChildNode(zAlignNode)
        pNode.constraints = [ SCNLookAtConstraint(target: ball)]
    }
    
    func creationOneLink(from: SCNNode, to: SCNNode) {
        let positionOne = from.position
        let positionTwo = to.position
        // Вычисляем высоту цилиндра
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(positionOne), SCNVector3ToGLKVector3(positionTwo)))
        let zNode = SCNNode()
        zNode.eulerAngles.x = Float(Double.pi / 2.0)
        
        
        let geometry =  SCNCylinder(radius: 0.1, height: height)
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.darkGray
        geometry.materials = [material]
        
        //Создаем цилиндр
        let cylinder = SCNNode(geometry: geometry)
        cylinder.position.y = Float(-height / 2.0)
        zNode.addChildNode(cylinder)
        let newNode = SCNNode()
        newNode.position = to.position
        //to.addChildNode(zNode)
        //to.constraints = [ SCNLookAtConstraint(target: from) ]
        newNode.addChildNode(zNode)
        newNode.constraints = [ SCNLookAtConstraint(target: from) ]
        scnScene.rootNode.addChildNode(newNode)
    }
    
    func createLinks() {
        //!!! Нужно уточнить соответствие номеров атомов и номеров atomsNods
        //let allLinks = Conection.allLink()
        //print(atomsNods.count)
        //print(ligand.atoms.count)
        let connections = ligand.connections
        for (i, numbersAtoms) in connections.enumerated(){
            for n in numbersAtoms {
                //let index = n - 1
                //print("\(i + 1) - \(n + 1) (\(i) - \(n))")
                //if (i > index) {
                //    print("continue")
                //    continue
                //}
                if n >= atomsNods.count {
                    continue
                }
                creationOneLink(from: self.atomsNods[i], to: self.atomsNods[n])
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let atoms = ligand.atoms
        for (i, atomNode) in atomsNods.enumerated() {
            let position = SCNVector3(atoms[i].coordinates.x, atoms[i].coordinates.y, atoms[i].coordinates.z)
            atomNode.removeAllActions()
            atomNode.runAction(.move(to: position, duration: 5))
        }

//        if left == false {
//            ball.removeAllActions()
//            // бесконечно двигаем шарик по координате X со скоростью 5, длительностью 20 мс
//            ball.runAction(.repeatForever(.move(by: SCNVector3Make(-5, 0, 0), duration: 20)))
//            left = true
//        } else {
//            ball.removeAllActions()
//            // бесконечно двигаем шарик по координате Y со скоростью 5, длительностью 20 мс
//            ball.runAction(.repeatForever(.move(by: SCNVector3Make(0, -5, 0), duration: 20)))
//            left = false
//        }
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
