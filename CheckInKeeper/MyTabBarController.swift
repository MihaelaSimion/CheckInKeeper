//
//  MyTabBarController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/22/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import FacebookCore

protocol LogoutProtocol {
    func logout()
}

class MyTabBarController: UITabBarController {
    var logoutDelegate: LogoutProtocol?
    var taggedPlaceResponse: TaggedPlacesResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
    }
    
    func getUserDetails() {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                if let userID = response.dictionaryValue?["id"] {
                    self.getCheckinList(for: userID)
                }
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    func getCheckinList(for userID: Any) {
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest(graphPath: "/\(userID)/tagged_places")) { (response, result) in
            switch result {
            case .success(let response):
                if let taggedPlaceResponse = response.taggedPlaceResponse {
                    self.taggedPlaceResponse = taggedPlaceResponse
                    NotificationCenter.default.post(name: .taggedPlaceResponseChanged, object: nil)
                }
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
}
