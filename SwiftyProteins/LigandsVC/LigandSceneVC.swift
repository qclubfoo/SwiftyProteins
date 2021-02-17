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

class LigandSceneVC: UIViewController {
    
    @IBOutlet var scnView: SCNView!
    
    var scnScene = SCNScene()
    var cameraNode = SCNNode()
    var centralNode = SCNNode()
    var atomsNods = [SCNNode]()
    
    var ligand: Ligand?
    var elements: [Element]?
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let locationView: CGPoint = sender.location(in: scnView)
        let hits = scnView.hitTest(locationView, options: nil)
    
        guard let ligand = self.ligand else { return }
        guard let elements = self.elements else { return }
        
        if let tappedNode = hits.first?.node {
            for atom in ligand.atoms {
                let location = SCNVector3Make(atom.coordinates.x, atom.coordinates.y, atom.coordinates.z)
                if location == tappedNode.position {
                    for elementAtom in elements {
                        if atom.type.rawValue.uppercased() == elementAtom.symbol.uppercased() {
                            showAtomInfo(element: elementAtom, location: locationView)
                            return
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        setTap()
        setScene()
        createCentreNode()
        createAtoms()
        createLinks()
        setCamera()
    }
    
    // MARK: share - is the method where we should put image of the ligand. It should be provide by SceneKit
    @objc func share() {
        let image = self.scnView.snapshot()
        if let ligandName = title {
            let ac = UIActivityViewController(activityItems: [image, "This is \(ligandName) ligand"], applicationActivities: nil)
            present(ac, animated: true)
        }
    }

    // MARK: Show custom popup.
    func showAtomInfo(element: Element, location: CGPoint) {
        let atomInfoVC = AtomInformationVC.storyboardInstance()
        atomInfoVC.modalPresentationStyle = .popover
        let popOverVC = atomInfoVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.scnView
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
        scnView.scene = scnScene
        scnView.backgroundColor = .lightGray
        scnView.autoenablesDefaultLighting = true   // Атоматическое добавление источника света.
    }
    
    func createCentreNode() {
        centralNode.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(centralNode)
    }
    
    func setCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 15
        cameraNode.position = SCNVector3Make(20, 20, 20)
        let constrain = SCNLookAtConstraint(target: centralNode)
        cameraNode.constraints = [constrain]
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    
    // MARK: Create atoms and add to scene.
    func createAtoms() {
        guard let ligand = self.ligand else { return }
        let atoms = ligand.atoms
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
    
    // MARK: Create links atoms
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
        newNode.addChildNode(zNode)
        newNode.constraints = [ SCNLookAtConstraint(target: from) ]
        scnScene.rootNode.addChildNode(newNode)
    }
    
    func createLinks() {
        guard let ligand = self.ligand else { return }
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
}

// MARK: Extension
extension LigandSceneVC {
    static func storyboardInstance() -> LigandSceneVC {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? LigandSceneVC else { fatalError("LoginVC doesn't exist") }
        return vc
    }
}

extension SCNVector3 {
    static func == (left: SCNVector3, right: SCNVector3) -> Bool {
        return left.x == right.x && left.y == right.y && left.z == right.z
    }
}

extension LigandSceneVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
