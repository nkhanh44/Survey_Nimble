//
//  AppDelegate.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 17/06/2022.
//

import UIKit
import IQKeyboardManager
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let splashVC = SplashViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: splashVC)
        window?.makeKeyAndVisible()
        
        configure()
        
        return true
    }
    
    private func configure() {
        let IQKeyboard = IQKeyboardManager.shared()
        IQKeyboard.isEnabled = true
        IQKeyboard.shouldResignOnTouchOutside = true
    }
}
