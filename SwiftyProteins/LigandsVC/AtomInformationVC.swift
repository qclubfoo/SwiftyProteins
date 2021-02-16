//
//  AtomInformationVC.swift
//  SwiftyProteins
//
//  Created by Михаил Фокин on 11.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit

class AtomInformationVC: UIViewController {

    @IBOutlet var symbol: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var mass: UILabel!
    @IBOutlet var density: UILabel!
    @IBOutlet var boil: UILabel!
    @IBOutlet var melt: UILabel!
    @IBOutlet var configuration: UILabel!
    
    var element: Element?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let element = self.element else { return }
        symbol.text = element.symbol
        name.text = element.name
        mass.text = String(format: "%.3f", element.atomicMass ?? 0.0)
        density.text = String(element.density ?? 0.0)
        boil.text = String(element.boil ?? 0.0)
        melt.text = String(element.melt ?? 0.0)
        configuration.text = element.electronConfiguration
    }
}

extension AtomInformationVC {
    static func storyboardInstance() -> AtomInformationVC {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? AtomInformationVC else { fatalError("ProteinListVC doesn't exist") }
        return vc
    }
}
