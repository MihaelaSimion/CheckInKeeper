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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        let defaultCamera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 45.9432, longitude: 24.9668), zoom: 7.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.camera = defaultCamera
        locationManager.requestWhenInUseAuthorization()
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
}
