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
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var idTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        logoutButton.backgroundColor = Constants.Colors.buttonColor
        logoutButton.layer.cornerRadius = Constants.CornerRadiusValues.buttonCornerRadius
        logoutButton.showsTouchWhenHighlighted = true

        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true

        idTextView.isEditable = false
        idTextView.isSelectable = true
    }

    @IBAction private func logoutButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        if let tabController = tabBarController as? MyTabBarController {
            tabController.logoutDelegate?.logout()
        }
    }

    func setUserNameLabelText(text: String) {
        userNameLabel.text = text
    }

    func setIdTextView(text: String) {
        idTextView.text = text
    }

    func setImageViewImage(image: UIImage) {
        imageView.image = image
    }
}
