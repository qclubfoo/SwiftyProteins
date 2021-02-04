//
//  ProteinListVC.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 28.01.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit

protocol ProteinListVCDelegate: class {
    func updateTableView(withNewData data: [String])
}

class ProteinListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: IProteinModel?
    var ligandManager: ILigandManager?
    var proteinList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Protein list"
        model?.delegate = self
        if proteinList.isEmpty {
            model?.getProteins()
        }
    }
}

extension ProteinListVC: ProteinListVCDelegate {
    func updateTableView(withNewData data: [String]) {
        self.proteinList = data
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
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
// MARK: TableViewDelegate methods
extension ProteinListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false
        activityIndicator.startAnimating()
        ligandManager?.getLigandWith(name: proteinList[indexPath.row]) { ligand, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac, animated: true)
                } else {
                    let nextVC = TestViewController.storyboardInstance()
                    nextVC.ligand = ligand
                    nextVC.title = self?.proteinList[indexPath.row]
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
                self?.activityIndicator.stopAnimating()
                tableView.allowsSelection = true
            }
        }
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
