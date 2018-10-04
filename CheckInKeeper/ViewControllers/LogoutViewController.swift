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
    @IBOutlet weak var logoutButtonView: UIView!
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
        
        logoutButtonView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        logoutButton.showsTouchWhenHighlighted = true
        idTextView.isEditable = false
        idTextView.isSelectable = true
        
        getNameAndId()
        NotificationCenter.default.addObserver(self, selector: #selector(getNameAndId), name: .nameAndIdChanged, object: nil)
    }
    
    @objc func getNameAndId() {
        if let controller = tabBarController as? MyTabBarController {
            guard let id = controller.userID, let name = controller.userName, let image = controller.profilePicture else { return }
            userNameLabel.text = name
            idTextView.text = id
            imageView.image = image
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .nameAndIdChanged, object: nil)
    }
}
