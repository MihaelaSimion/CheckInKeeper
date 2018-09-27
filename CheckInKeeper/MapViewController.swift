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
    var places: [Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getTaggedPlaceValues), name: .taggedPlaceResponseChanged, object: nil)
        locationManager.delegate = self
        mapView.delegate = self
        let defaultCamera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 45.9432, longitude: 24.9668), zoom: 7.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.camera = defaultCamera
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addMarkers(places: [Place]) {
        for place in places {
            let position = CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude)
            let marker = GMSMarker(position: position)
            marker.title = place.name
            marker.icon = GMSMarker.markerImage(with: .green)
            marker.map = mapView
        }
    }
    
    @objc func getTaggedPlaceValues() {
        if let tabController = tabBarController as? MyTabBarController {
            if let placesData = tabController.taggedPlaceResponse?.data.map({ (element) -> Place in
                return element.place
            }) {
                places = placesData
                guard let placesForMarkers = places else { return }
                addMarkers(places: placesForMarkers)
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
