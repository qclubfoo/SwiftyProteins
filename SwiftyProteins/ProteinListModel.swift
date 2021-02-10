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
    
    func getPeriodicTableAtoms()
}

class ProteinModel: IProteinModel {
    weak var delegate: ProteinListVCDelegate?
    
    func getPeriodicTableAtoms() {
        let urlString = "https://raw.githubusercontent.com/Bowserinator/Periodic-Table-JSON/master/periodic-table-lookup.json"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let periodicElemestsStructures = try decoder.decode(PeriodicElemestsStructures.self, from: data)
                self.delegate?.loudElements(withNewStruct: periodicElemestsStructures)
            } catch {
                print("\(error)")
            }
        }.resume()
    }
    
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
/*
 let bundle = Bundle(for: type(of: self))
 guard
     let url = bundle.url(forResource: "PeriodicTableJSON", withExtension: "json"),
     let data = try? Data(contentsOf: url) else { fatalError("Can't find or open PeriodicTableJSON.json") }
 do {
     let decoger = JSONDecoder()
     decoger.keyDecodingStrategy = .convertFromSnakeCase
     let periodicElemestsStructures = try decoger.decode(PeriodicElemestsStructures.self, from: data)
     self?.delegate?.loudElements(withNewStruct: periodicElemestsStructures)
 } catch {
     fatalError("Can't find or open PeriodicTableJSON.json")
 }
 */
