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
    
    var scnScene: SCNScene!
    
    var cameraNode: SCNNode!
    
    var firstObject: SCNNode!
    var ball: SCNNode!
    
    var ligand: Ligand!
    
    var left = Bool()

    var atomsNods: [SCNNode]!
    var elements: [Element]?
    
    var centralNode: SCNNode!
    
    var light: SCNNode!
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let locationView: CGPoint = sender.location(in: scnView)
        //print(location)
        let hits = scnView.hitTest(locationView, options: nil)
        if let tappedNode = hits.first?.node {
            for atom in ligand.atoms {
                let location = SCNVector3Make(atom.coordinates.x, atom.coordinates.y, atom.coordinates.z)
                if location == tappedNode.position {
                    guard let elements = self.elements else { return }
                    for elementAtom in elements {
                        if atom.type.rawValue.uppercased() == elementAtom.symbol.uppercased() {
                            showAtomInfo(element: elementAtom, location: locationView)
                            //print(elementAtom.name)
                            return
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTap()
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
    
    func showAtomInfo(element: Element, location: CGPoint) {
        let atomInfoVC = AtomInformationVC.storyboardInstance()
        
        atomInfoVC.modalPresentationStyle = .popover
        
        let popOverVC = atomInfoVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.scnView
        //popOverVC?.sourceRect = location
        popOverVC?.sourceRect = CGRect(x: location.x, y: location.y, width: 0, height: 0)
        atomInfoVC.preferredContentSize = CGSize(width: 200, height: 200)
        atomInfoVC.element = element
        self.present(atomInfoVC, animated: true, completion: nil)
    }
    
    func setTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tap.numberOfTapsRequired = 2
        scnView.addGestureRecognizer(tap)
    }
    
    @objc func doubleTap() {
        print("double tap")
    }
    
    func setScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        
        //scnView.showsStatistics = true              // Отображение статичтики
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
        let radius: CGFloat
        if atom.type == .H {
            radius = 0.3
        } else {
            radius = 0.4
        }
        let geometry = SCNSphere(radius: radius)
        let ball = SCNNode(geometry: geometry)
        let material = SCNMaterial()
        material.diffuse.contents = getCollorAtom(type: atom.type)
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
        let connections = ligand.connections
        for (i, numbersAtoms) in connections.enumerated(){
            for n in numbersAtoms {
                if n >= atomsNods.count {
                    continue
                }
                creationOneLink(from: self.atomsNods[i], to: self.atomsNods[n])
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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

extension SCNVector3 {
    static func == (left: SCNVector3, right: SCNVector3) -> Bool {
        return left.x == right.x && left.y == right.y && left.z == right.z
    }
}

extension TestViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
