//
//  TestViewController.swift
//  SwiftyProteins
//
//  Created by Михаил Фокин on 29.01.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    deinit {
        print("Deinit TestViewController")
    }
}

extension TestViewController {
    static func storyboardInstance() -> TestViewController {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? TestViewController else { fatalError("LoginVC doesn't exist") }
        return vc
    }
}
