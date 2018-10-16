//
//  ViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/22/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

protocol LoginProtocol: AnyObject {
    func loginSuccessful()
}

class LoginViewController: UIViewController {
    @IBOutlet private weak var loginButton: UIButton!
    weak var delegate: LoginProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        loginButton.backgroundColor = Constants.Colors.buttonColor
        loginButton.layer.cornerRadius = Constants.CornerRadiusValues.buttonCornerRadius
        loginButton.showsTouchWhenHighlighted = true
    }

    @IBAction private func loginButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .userTaggedPlaces], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                self.delegate?.loginSuccessful()
            }
        }
    }
}
