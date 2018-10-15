//
//  FacebookService.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 10/14/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation
import FacebookCore

protocol FacebookServiceProtocol: AnyObject {
    func refreshData()
}

class FacebookService {
    var userName: String?
    var userID: String?
    var profilePicture: UIImage?
    weak var facebookServiceDelegate: FacebookServiceProtocol?
    var taggedPlaceResponse: TaggedPlacesResponse? {
        didSet {
            facebookServiceDelegate?.refreshData()
        }
    }

    func getUserDetails(completion: @escaping (Bool) -> Void ) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me")) { _, result in
            switch result {
            case .success(let response):
                if let name = response.dictionaryValue?["name"] as? String,
                    let userID = response.dictionaryValue?["id"] as? String {
                    self.userName = name
                    self.userID = userID
                    completion(true)
                } else {
                    completion(false)
                }
            case .failed(let error):
                print("Graph Request Failed: \(error)")
                completion(false)
            }
        }
        connection.start()
    }

    func getCheckinList() {
        guard let userID = userID else { return }
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest(graphPath: "/\(userID)/tagged_places?limit=100")) { response, result in
            switch result {
            case .success(let response):
                if let taggedPlaceResponse = response.taggedPlaceResponse {
                    self.taggedPlaceResponse = taggedPlaceResponse
                }
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }

    func getProfilePicture() {
        guard let userID = userID else { return }
        let url = URL(string: "https://graph.facebook.com/\(userID)/picture?type=large")
        DispatchQueue.global().async {
            if let url = url, let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.profilePicture = UIImage(data: data)
                }
            }
        }
    }
}
