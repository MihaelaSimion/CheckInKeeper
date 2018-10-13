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
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var idTextView: UITextView!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        if let tabController = tabBarController as? MyTabBarController {
            tabController.logoutDelegate?.logout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 10
        logoutButton.showsTouchWhenHighlighted = true
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        idTextView.isEditable = false
        idTextView.isSelectable = true
    }
}
