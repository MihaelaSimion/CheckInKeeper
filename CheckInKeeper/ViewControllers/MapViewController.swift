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
    
    var taggedPlaces: [TaggedPlace]?
    var taggedPlace: TaggedPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getTaggedPlaceValues), name: .taggedPlaceResponseChanged, object: nil)
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        loadMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func loadMap() {
        do {
            if let styleURL = Bundle.main.url(forResource: "GoogleMapsStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        let defaultCamera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 45.9432, longitude: 24.9668), zoom: 7.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.camera = defaultCamera
    }
    
    func addMarkers(taggedPlaces: [TaggedPlace]) {
        for taggedPlace in taggedPlaces {
            let position = CLLocationCoordinate2D(latitude: taggedPlace.place.location.latitude, longitude: taggedPlace.place.location.longitude)
            let marker = GMSMarker(position: position)
            marker.title = taggedPlace.place.name
            marker.snippet = "\(taggedPlace.place.location.city), \(taggedPlace.place.location.country)\n\(taggedPlace.place.location.street)"
            marker.map = mapView
            marker.userData = taggedPlace
        }
    }
    
    @objc func getTaggedPlaceValues() {
        if let tabController = tabBarController as? MyTabBarController {
            if let taggedPlaces = tabController.taggedPlaceResponse?.data {
                self.taggedPlaces = taggedPlaces
                addMarkers(taggedPlaces: taggedPlaces)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .taggedPlaceResponseChanged, object: nil)
    }
    
    //MARK: Navigation:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "markerInfoWindowToDetails" {
            guard let controller = segue.destination as? DetailsTableViewController else { return }
            guard let taggedPlace = taggedPlace else { return }
            controller.taggedPlace = taggedPlace
        }
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let taggedPlace = marker.userData as? TaggedPlace {
            self.taggedPlace = taggedPlace
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "markerInfoWindowToDetails", sender: self)
        navigationController?.navigationBar.isHidden = false
    }
}
