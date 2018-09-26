//
//  MapViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/24/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    var locations: [Location]?
    var placeNames: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getTaggedPlaceValues), name: .taggedPlaceResponseChanged, object: nil)
        locationManager.delegate = self
        mapView.delegate = self
        let defaultCamera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 45.9432, longitude: 24.9668), zoom: 7.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.camera = defaultCamera
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addMarkers(locations: [Location]) {
        var count = 0
        for location in locations {
            let locationIndex = count
            let position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let marker = GMSMarker(position: position)
            if let names = placeNames {
                marker.title = names[locationIndex]
            }
            marker.icon = GMSMarker.markerImage(with: .yellow)
            marker.map = mapView
            count += 1
        }
        
    }
    
    @objc func getTaggedPlaceValues() {
        if let tabController = tabBarController as? MyTabBarController {
            if let placeNamesArray = tabController.taggedPlaceResponse?.data.map({ (element) -> String in
                return element.place.name
            }) {
                placeNames = placeNamesArray
            }
            
            if let locationsData = tabController.taggedPlaceResponse?.data.map({ (element) -> Location in
                return element.place.location
            }) {
                locations = locationsData
                guard let locationsForMarkers = locations else { return }
                addMarkers(locations: locationsForMarkers)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .taggedPlaceResponseChanged, object: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        let camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 12.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.animate(to: camera)
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    // You can listen to events that occur on the map, such as when a user taps a marker or an info window
}
