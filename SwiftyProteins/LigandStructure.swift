//
//  LigandStructure.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 02.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

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
//    case H = "H"
//    case O = "O"
//    case C = "C"
//    case N = "N"
}



struct Atom {
    let number: Int
    let coordinates: (x: Double, y: Double, z: Double)
    let type: AtomType
}

struct Ligand {
    let atoms: [Atom]
    let connections: [[Int]]
    
//    func getConnectionsCoordinates(_ first: Int, _ second: Int) -> [(x: Double, y: Double, z: Double)] {
//        
//    }
}
