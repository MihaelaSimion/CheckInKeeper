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

protocol LoginProtocol {
    func loginSuccessful()
}

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    var delegate: LoginProtocol?
 
    @IBAction func loginButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .userTaggedPlaces], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! \(accessToken)")
                self.delegate?.loginSuccessful()
            }
        }
    }
}


