//
//  LogoutViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/22/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LogoutViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        if let tabController = tabBarController as? MyTabBarController {
            tabController.logoutDelegate?.logout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let controller = tabBarController as? MyTabBarController {
            guard let id = controller.userID, let name = controller.userName, let image = controller.profilePicture else { return }
            userNameLabel.text = name
            userIDLabel.text = "Digital ID: \(id)"
            imageView.image = image
        }
    }
}
