//
//  ProteinListModel.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 02.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

protocol IProteinModel {
    func getProteinList() -> [String]
}

class ProteinModel: IProteinModel {
    func getProteinList() -> [String] {
        guard let path = Bundle.main.path(forResource: "ligands", ofType: "txt") else { fatalError("Can't find or open ligands.txt") }
        do {
            let fileContent = try String(contentsOfFile: path, encoding: .utf8).dropLast()
            let proteinList = fileContent.components(separatedBy: "\n")
            return proteinList
        } catch {
            fatalError("Can't find or open ligands.txt")
        }
    }
}
