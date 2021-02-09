//
//  LigandManager.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 04.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

protocol ILigandManager {
    func getLigandWith(name: String, completion: @escaping (Ligand?, Error?) -> (Void))
}

class LigandManager: ILigandManager {
    
    private let parser: ILigandParser
    private let downloader: ILigandDownloader
    
    init(downloader: ILigandDownloader, parser: ILigandParser) {
        self.downloader = downloader
        self.parser = parser
    }
    
    convenience init() {
        self.init(downloader: LigandDownloader(), parser: LigandParser())
    }
    
    func getLigandWith(name: String, completion: @escaping (Ligand?, Error?) -> (Void)) {
        downloader.downloadLigandData(with: name) { [weak self] data, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            self?.parser.parse(data: data) { ligand, error in
                guard let ligand = ligand else {
                    completion(nil, error)
                    return
                }
                completion(ligand, nil)
            }
        }
    }
}
