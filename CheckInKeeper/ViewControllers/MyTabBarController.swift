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
    var taggedPlaceResponse: TaggedPlacesResponse? {
        didSet {
            refreshListController()
            refreshMapController()
            refreshLogoutController()
        }
    }
    var userName: String?
    var userID: String?
    var profilePicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        getUserDetails()
    }
    
    func getUserDetails() {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                if let name = response.dictionaryValue?["name"] as? String {
                    self.userName = name
                }
                if let userID = response.dictionaryValue?["id"] as? String {
                    self.userID = userID
                    self.getCheckinList(for: userID)
                    self.getProfilePicture(for: userID)
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
                }
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    func getProfilePicture(for userID: Any) {
        let url = URL(string: "https://graph.facebook.com/\(userID)/picture?type=large")
        DispatchQueue.global().async {
            if let url = url, let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.profilePicture = UIImage(data: data)
                }
            }
        }
    }
    
    func refreshListController() {
        guard let listTableViewController = (selectedViewController as? UINavigationController)?.viewControllers.first as? ListTableViewController else { return }
        if let data = taggedPlaceResponse?.data {
            let sortedData = data.sorted { (first, next) -> Bool in
                return first.created_time! > next.created_time!
            }
            listTableViewController.taggedPlaces = sortedData
            listTableViewController.immutableInitialListOfTaggedPlaces = sortedData
        }
    }
    
    func refreshMapController () {
        guard let mapViewController = (selectedViewController as? UINavigationController)?.viewControllers.first as? MapViewController else { return }
        mapViewController.mapLocations = []
        if let taggedPlaces = taggedPlaceResponse?.data {
            _ = taggedPlaces.compactMap { (taggedPlace) -> TaggedPlace? in
                var existingIndex = -1
                for (index, mapLocation) in mapViewController.mapLocations.enumerated() {
                    if mapLocation.placeID == taggedPlace.place.id {
                        existingIndex = index
                    }
                }
                if existingIndex >= 0 {
                    mapViewController.mapLocations[existingIndex].taggedPlaces.append(taggedPlace)
                } else {
                    let newMapLocation = MapLocation(placeID: taggedPlace.place.id, taggedPlaces: [taggedPlace])
                    mapViewController.mapLocations.append(newMapLocation)
                }
                return taggedPlace
            }
            mapViewController.mapView.clear()
            mapViewController.addMarkers(mapLocations: mapViewController.mapLocations)
        }
    }
    
    func refreshLogoutController() {
        guard let logoutViewController = selectedViewController as? LogoutViewController else { return }
        guard let id = userID, let name = userName, let image = profilePicture else { return }
        logoutViewController.userNameLabel.text = name
        logoutViewController.idTextView.text = id
        logoutViewController.imageView.image = image
    }
}

extension MyTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        refreshMapController()
        refreshListController()
        refreshLogoutController()
    }
}

