//
//  MyTabBarController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/22/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

protocol LogoutProtocol {
    func logout()
}

class MyTabBarController: UITabBarController {
    var logoutDelegate: LogoutProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
