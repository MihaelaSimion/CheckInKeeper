//
//  MyTabBarController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/22/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

protocol LogoutProtocol: AnyObject {
    func logout()
}

class MyTabBarController: UITabBarController {
    weak var logoutDelegate: LogoutProtocol?
    var facebookService: FacebookService?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        facebookService = FacebookService()
        facebookService?.facebookServiceDelegate = self
        facebookService?.getUserDetails(completion: { success in
            if success {
                self.facebookService?.getCheckinList()
                self.facebookService?.getProfilePicture()
            } else {
                let alert = UIAlertController(title: "Data error:", message: "There was a problem with getting your data. Please try again.", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

    func refreshDataInListController() {
        guard let listTableViewController = (selectedViewController as? UINavigationController)?.viewControllers.first as? ListTableViewController else { return }
        if let data = facebookService?.taggedPlaceResponse?.data {
            let sortedData = data.sorted { first, next -> Bool in
                return first.createdTime! > next.createdTime!
            }
            listTableViewController.taggedPlaces = sortedData
            listTableViewController.immutableInitialListOfTaggedPlaces = sortedData
        }
    }

    func refreshDataInMapController () {
        guard let mapViewController = (selectedViewController as? UINavigationController)?.viewControllers.first as? MapViewController else { return }
        mapViewController.mapLocations = []
        if let taggedPlaces = facebookService?.taggedPlaceResponse?.data {
            mapViewController.mapLocations = taggedPlaces.addMapLocations()
            mapViewController.clearMap()
            mapViewController.addMarkers(mapLocations: mapViewController.mapLocations)
        }
    }

    func refreshDataInLogoutController() {
        guard let logoutViewController = selectedViewController as? LogoutViewController else { return }
        guard let id = facebookService?.userID, let name = facebookService?.userName, let image = facebookService?.profilePicture else { return }
        logoutViewController.setUserNameLabelText(text: name)
        logoutViewController.setIdTextView(text: id)
        logoutViewController.setImageViewImage(image: image)
    }

    func refreshDataInAllControllers() {
        refreshDataInListController()
        refreshDataInMapController()
        refreshDataInLogoutController()
    }

    func refreshActionFromListView() {
        facebookService?.getCheckinList()
    }
}

extension MyTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        refreshDataInAllControllers()
    }
}

extension MyTabBarController: FacebookServiceProtocol {
    func refreshData() {
        refreshDataInAllControllers()
    }
}
