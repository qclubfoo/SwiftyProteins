//
//  ViewController.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 28.01.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func pressSignIn(_ sender: UIButton) {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Please authenticate to proceed.") { [weak self] (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
            }
        } else {
            print("Not biometry")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 2
    }
}

extension LoginVC {
    static func storyboardInstance() -> LoginVC {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? LoginVC else { fatalError("LoginVC doesn't exist") }
        return vc
    }
}
