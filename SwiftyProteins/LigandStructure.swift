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
    case BR = "BR"
    case B = "B"
    case S = "S"
    case CL = "CL"
    case P = "P"
    case MO = "MO"
    case AU = "AU"
    case V = "V"
    case CO = "CO"
    case BA = "BA"
    case MG = "MG"
    case CA = "CA"
    case AS = "AS"
    case CD = "CD"
    case CS = "CS"
    case CU = "CU"
    case RU = "RU"
    case EU = "EU"
    case FE = "FE"
    case GA = "GA"
    case HG = "HG"
    case U = "U"
    case K = "K"
    case LA = "LA"
    case LI = "LI"
    case MN = "MN"
    case SE = "SE"
    case NA = "NA"
    case NI = "NI"
    case PB = "PB"
    case PD = "PD"
    case PT = "PT"
    case W = "W"
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
