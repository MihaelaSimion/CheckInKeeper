//
//  AppDelegate.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/22/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(Constants.ApiKeys.google)
        
        if AccessToken.current != nil {
            showTabBarVC()
        } else {
            showLoginVC()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func showTabBarVC() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBar")
        if let tabBar = tabBarViewController as? MyTabBarController {
            tabBar.logoutDelegate = self
        }
        window?.rootViewController = tabBarViewController
    }
    
    func showLoginVC() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "Login")
        if let loginVC = loginViewController as? LoginViewController {
            loginVC.delegate = self
        }
        window?.rootViewController = loginViewController
    }
}

extension AppDelegate: LoginProtocol {
    func loginSuccessful() {
        showTabBarVC()
    }
}

extension AppDelegate: LogoutProtocol {
    func logout() {
        showLoginVC()
    }
}
