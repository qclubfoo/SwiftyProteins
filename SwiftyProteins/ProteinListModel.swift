//
//  ProteinListModel.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 02.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

protocol IProteinModel {
    var delegate: ProteinListVCDelegate? { get set }
    
    func getProteins()
}

class ProteinModel: IProteinModel {
    
    weak var delegate: ProteinListVCDelegate?
    
    func getProteins() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let path = Bundle.main.path(forResource: "ligands_new", ofType: "txt") else { fatalError("Can't find or open ligands.txt") }
            do {
                let fileContent = try String(contentsOfFile: path, encoding: .utf8).dropLast()
                let proteinList = fileContent.components(separatedBy: "\n")
                self?.delegate?.updateTableView(withNewData: proteinList)
            } catch {
                fatalError("Can't find or open ligands.txt")
            }
        }
    }
}
