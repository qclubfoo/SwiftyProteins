//
//  ParsingManager.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 04.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

protocol ILigandParser {
    func parse(data: Data, completionHandler completion: @escaping (Ligand?, Error?) -> (Void))
}

class LigandParser: ILigandParser {
    
    func parse(data: Data, completionHandler completion: @escaping (Ligand?, Error?) -> (Void)) {
        guard let ligandStr = String(data: data, encoding: .utf8) else {
            completion(nil, CustomError.invalidConverting)
            return
        }
        let ligandsComponents = parse(ligandStr)
        let emptyOrIncompeteCondition = ligandsComponents.atoms.isEmpty || ligandsComponents.connections.isEmpty || ligandsComponents.atoms.count != ligandsComponents.connections.count
        let moreThanOneAtom = ligandsComponents.atoms.count > 1
        if  moreThanOneAtom && emptyOrIncompeteCondition {
            completion(nil, CustomError.invalidFile)
            return
        }
        if
            let atoms: [Atom] = parse(ligandsComponents.atoms),
            let connections: [[Int]] = parse(ligandsComponents.connections) {
            completion(Ligand(atoms, connections), nil)
        } else {
            completion(nil, CustomError.invalidFile)
        }
    }
    
    private func parse(_ ligand: String) -> (atoms: [String], connections: [String]) {
        var atoms = [String]()
        var connections = [String]()
        ligand.components(separatedBy: "\n").forEach({
            if $0.contains("ATOM") {
                atoms.append($0)
            } else if $0.contains("CONECT") {
                connections.append($0)
            }
        })
        return (atoms, connections)
    }
    
    private func parse(_ atoms: [String]) -> [Atom]? {
        var atomsArray = [Atom]()
        for (atomNumber, atom) in atoms.enumerated() {
            let filtredAtom = atom.split(separator: " ")
            if filtredAtom.count >= 12 {
                if let number = Int(filtredAtom[1]), atomNumber != number - 1 {
                    return nil
                }
                guard
                    let type = AtomType(rawValue: String(filtredAtom[11])),
                    let x = Float(filtredAtom[6]),
                    let y = Float(filtredAtom[7]),
                    let z = Float(filtredAtom[8]) else { return nil }
                atomsArray.append(Atom(number: atomNumber, coordinates: (x, y, z), type: type))
            }
        }
        return atomsArray
    }
    
    private func parse(_ connections: [String]) -> [[Int]]? {
        var arrayConnections = [[Int]]()
        for (minNumber, connection) in connections.enumerated() {
            let splitedConnection = connection.components(separatedBy: " ").filter({ !$0.isEmpty })
            var tmpArray = [Int]()
            for number in splitedConnection {
                if let num = Int(number), num > minNumber + 1 {
                    tmpArray.append(num - 1)
                }
            }
            arrayConnections.append(tmpArray)
        }
//        if !arrayConnections.isEmpty {
//            return arrayConnections
//        }
        //return nil
        return arrayConnections
    }
}
