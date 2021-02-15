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
    func loudElements(withNewStruct periodicElementsStructure: PeriodicElemestsStructures)
}

class ProteinListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var model: IProteinModel?
    var ligandManager: ILigandManager?
    var proteinList = [String]()
    var elements = [Element]()
    
    var filteredLigands = [String]()
    var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Protein list"
        model?.delegate = self
        if proteinList.isEmpty {
            model?.getProteins()
        }
        if elements.isEmpty {
            model?.getPeriodicTableAtoms()
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search ligands"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredLigands = proteinList.filter { (ligand: String) -> Bool in
        return ligand.uppercased().contains(searchText.uppercased())
      }
      
      tableView.reloadData()
    }
    
}

extension ProteinListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let inputedText = searchController.searchBar.text {
            filterContentForSearchText(inputedText)
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
    
    func loudElements(withNewStruct periodicElementsStructure: PeriodicElemestsStructures) {
        self.elements = periodicElementsStructure.elements
    }
}

extension ProteinListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
          return filteredLigands.count
        }
          
        return proteinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        let ligand: String
        if isFiltering {
            ligand = filteredLigands[indexPath.row]
        } else {
            ligand = proteinList[indexPath.row]
        }
        cell.textLabel?.text = ligand
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
                    nextVC.elements = self?.elements
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


/*

 
 extension ProteinListVC: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.allowsSelection = false
         activityIndicator.startAnimating()
         for str in proteinList {
         //ligandManager?.getLigandWith(name: proteinList[indexPath.row]) { ligand, error in
             ligandManager?.getLigandWith(name: str) { ligand, error in
             DispatchQueue.main.async { [weak self] in
                 if let error = error {
                     print("Error str = \(str)")
                     //let ac = UIAlertController(title: "Error", message: error.localizedDescription, //preferredStyle: .alert)
                     //ac.addAction(UIAlertAction(title: "Ok", style: .default))
                     //self?.present(ac, animated: true)
                 } else {
                     //let nextVC = TestViewController.storyboardInstance()
                     //nextVC.ligand = ligand
                     //nextVC.title = self?.proteinList[indexPath.row]
                     //self?.navigationController?.pushViewController(nextVC, animated: true)
                 }
                 self?.activityIndicator.stopAnimating()
                 tableView.allowsSelection = true
             }
         }
         }
         tableView.deselectRow(at: indexPath, animated: true)
     }
 }
 */
