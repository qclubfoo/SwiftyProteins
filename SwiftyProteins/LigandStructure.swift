//
//  LigandStructure.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 02.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation
import SceneKit

enum AtomType: String {
    
    case H = "H"
    case C = "C"
    case N = "N"
    case O = "O"
    case F = "F"
    case I = "I"
    case Br = "Br"
    case S = "S"
    case Cl = "Cl"
    
}



struct Atom {
    
    let number: Int
    let coordinates: (x: Float, y: Float, z: Float)
    let type: AtomType
    
}

struct Ligand {
    
    let atoms: [Atom]
    let connections: [[Int]]
    
    init(_ atoms: [Atom], _ connections: [[Int]]) {
        self.atoms = atoms
        self.connections = connections
    }
    
}
