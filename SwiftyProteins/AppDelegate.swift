//
//  AppDelegate.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 28.01.2021.
//  Copyright © 2021 home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let proteinListVC = ProteinListVC.storyboardInstance()
        proteinListVC.model = ProteinModel()
        proteinListVC.ligandManager = LigandManager()
        let navController = UINavigationController(rootViewController: proteinListVC)
        navController.navigationBar.tintColor = .black
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        showLoginVC()
        return true
    }
}

extension AppDelegate {
    
    private func showLoginVC() {
        let loginVC = LoginVC.storyboardInstance()
        loginVC.modalPresentationStyle = .overFullScreen
        window?.rootViewController?.present(loginVC, animated: false)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        showLoginVC()
    }
}
