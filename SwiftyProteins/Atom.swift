//
//  Atom.swift
//  SwiftyProteins
//
//  Created by Михаил Фокин on 03.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation
import SceneKit
struct Atom {
    var coordinates: SCNVector3
}

extension Atom {
    static func allAtoms() -> [Atom] { return [
        Atom(coordinates: SCNVector3( 0.018,  1.763,  1.424)),
        Atom(coordinates: SCNVector3(-0.305,  0.331,  1.460)),
        Atom(coordinates: SCNVector3(-0.081, -0.199,  2.853)),
        Atom(coordinates: SCNVector3( 0.762,  0.297,  3.560)),
        Atom(coordinates: SCNVector3( 0.595, -0.419,  0.477)),
        Atom(coordinates: SCNVector3( 0.368,  0.118, -0.936)),
        Atom(coordinates: SCNVector3( 1.269, -0.632, -1.918)),
        Atom(coordinates: SCNVector3( 1.042, -0.093, -3.332)),
        Atom(coordinates: SCNVector3(-0.422, -0.295, -3.726)),
        Atom(coordinates: SCNVector3(-1.322,  0.455, -2.743)),
        Atom(coordinates: SCNVector3(-1.095, -0.083, -1.329)),
        Atom(coordinates: SCNVector3(-0.819, -1.224,  3.307)),
        Atom(coordinates: SCNVector3( 0.988,  1.848,  1.689)),
        Atom(coordinates: SCNVector3(-0.044,  2.050,  0.459)),
        Atom(coordinates: SCNVector3(-1.348,  0.186,  1.180)),
        Atom(coordinates: SCNVector3( 1.639, -0.275,  0.758)),
        Atom(coordinates: SCNVector3( 0.356, -1.482,  0.504)),
        Atom(coordinates: SCNVector3( 0.608,  1.181, -0.962)),
        Atom(coordinates: SCNVector3( 2.312, -0.487, -1.638)),
        Atom(coordinates: SCNVector3( 1.029, -1.695, -1.892)),
        Atom(coordinates: SCNVector3( 1.282,  0.969, -3.359)),
        Atom(coordinates: SCNVector3( 1.684, -0.628, -4.032)),
        Atom(coordinates: SCNVector3(-0.583,  0.088, -4.733)),
        Atom(coordinates: SCNVector3(-0.661, -1.358, -3.699)),
        Atom(coordinates: SCNVector3(-1.083,  1.518, -2.770)),
        Atom(coordinates: SCNVector3(-2.366,  0.311, -3.024)),
        Atom(coordinates: SCNVector3(-1.335, -1.146, -1.303)),
        Atom(coordinates: SCNVector3(-1.737,  0.451, -0.629)),
        Atom(coordinates: SCNVector3(-0.676, -1.564,  4.201))
    ]}
}

struct Conection {
    var link: [[Int]]
}

extension Conection {
    static func allLink() -> [[Int]] { return [
        [2,  13,  14],
        [1,   3,   5,  15],
        [2,   4,  12],
        [3],
        [2,   6,  16,  17],
        [5,   7,  11,  18],
        [6,   8,  19,  20],
        [7,   9,  21,  22],
        [8,  10,  23,  24],
        [9,  11,  25,  26],
        [6,  10,  27,  28],
        [3,  29]
    ]
    }
}
