//
//  ProteinListVC.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 28.01.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit

class ProteinListVC: UIViewController {
    
    let model: IProteinModel = ProteinModel()
    lazy var ligandDownloader: ILigandDownloader = LigandDownloader()
    var proteinList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if proteinList.isEmpty {
            proteinList = model.getProteinList()
        }
    }
}

extension ProteinListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        proteinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = proteinList[indexPath.row]
        return cell
    }
    
}

extension ProteinListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You choose \(proteinList[indexPath.row]) protein")
        let ligand = ligandDownloader.downloadLigand(with: proteinList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProteinListVC {
    static func storyboardInstance() -> ProteinListVC {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? ProteinListVC else { fatalError("ProteinListVC doesn't exist") }
        return vc
    }
}
