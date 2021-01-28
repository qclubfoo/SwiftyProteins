//
//  ProteinListVC.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 28.01.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit

class ProteinListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
