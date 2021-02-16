//
//  NetworkManager.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 02.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

protocol ILigandDownloader {
    func downloadLigandData(with name: String, completion: @escaping (Data?, Error?) -> ())
}

class LigandDownloader: ILigandDownloader {
    
    func downloadLigandData(with name: String, completion: @escaping (Data?, Error?) -> ()) {
        let checkName = name.lowercased().replacingOccurrences(of: " ", with: "")
        let path = "https://files.rcsb.org/ligands/view/\(checkName)_ideal.pdb"
        guard let url = URL(string: path) else {
            print("Invalid URL")
            completion(nil, CustomError.invalidURL)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, CustomError.fileNotExist)
            }
        }.resume()
    }
}
