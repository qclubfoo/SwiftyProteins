//
//  NetworkManager.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 02.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

protocol ILigandDownloader {
    func downloadLigand(with name: String) -> Ligand?
}

class LigandDownloader: ILigandDownloader {
    func downloadLigand(with name: String) -> Ligand? {
        let path = "https://files.rcsb.org/ligands/view/\(name.lowercased())_ideal.pdb"
        if let url = URL(string: path) {
            do {
                let ligand = try String(contentsOf: url)
                return parse(ligand)
            } catch {
                
            }
        }
        return nil
    }
    
    private func parse(_ ligand: String) -> Ligand? {
        let splitedLigand = ligand.components(separatedBy: "\n")
        var atoms = [String]()
        var connections = [String]()
        for str in splitedLigand {
            if str.contains("ATOM") {
                atoms.append(str)
            } else if str.contains("CONECT") {
                connections.append(str)
            }
        }
        if let lignadAtoms: [Atom] = parse(atoms),
            let ligandConnections: [[Int]]  = parse(connections) {
            return Ligand(atoms: lignadAtoms, connections: ligandConnections)
        }
        return nil
    }
    
    private func parse(_ atoms: [String]) -> [Atom]? {
        var atomsArray = [Atom]()
        print("Count str atoms\(atoms.count)")
        for atom in atoms {
            let filtredAtom = atom.split(separator: " ")
            if filtredAtom.count >= 12 {
                guard
                    // Ниже изменил Double на Float
                    let type = AtomType(rawValue: String(filtredAtom[11])),
                    let x = Float(filtredAtom[6]),
                    let y = Float(filtredAtom[7]),
                    let z = Float(filtredAtom[8]),
                    let number = Int(filtredAtom[1]) else { return nil }
                atomsArray.append(Atom(number: number - 1, coordinates: (x, y, z), type: type))
            }
        }
        return atomsArray
    }
    
    private func parse(_ connections: [String]) -> [[Int]]? {
        var arrayConnections = [[Int]]()
        var currentNumber = 1
        for connection in connections {
            let splitedConnection = connection.components(separatedBy: " ").filter({ !$0.isEmpty })
            var tmpArray = [Int]()
            for number in splitedConnection{
                if let num = Int(number), num > currentNumber {
                    tmpArray.append(num - 1)
                }
            }
            arrayConnections.append(tmpArray)
            currentNumber += 1
        }
        if !arrayConnections.isEmpty {
            return arrayConnections
        }
        return nil
    }
}
