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
    
    func getProteins(from file: String?)
    
    func getPeriodicTableAtoms()
}

class ProteinModel: IProteinModel {
    weak var delegate: ProteinListVCDelegate?
    
    func getPeriodicTableAtoms() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let path = Bundle.main.path(forResource: "PeriodicTableJSON", ofType: "json") else { fatalError("Can't find or open PeriodicTableJSON.json") }
            do {
                let fileContent = try String(contentsOfFile: path, encoding: .utf8)
                let data = Data(fileContent.utf8)
                let decoder = JSONDecoder()
                let periodicElemestsStructures = try decoder.decode(PeriodicElemestsStructures.self, from: data)
                self?.delegate?.loudElements(withNewStruct: periodicElemestsStructures)
            } catch {
                fatalError("Can't find or open PeriodicTableJSON.json")
            }
        }
    }
    
    func getProteins(from file: String?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard   let file = file,
                    let path = Bundle.main.path(forResource: file, ofType: "txt") else { fatalError("Can't find or open source file") }
            do {
                let fileContent = try String(contentsOfFile: path, encoding: .utf8).dropLast()
                let proteinList = fileContent.components(separatedBy: "\n")
                self?.delegate?.updateTableView(withNewData: proteinList)
            } catch {
                fatalError("Can't find or open source file")
            }
        }
    }
}
