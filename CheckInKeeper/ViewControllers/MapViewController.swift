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
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var taggedPlace: TaggedPlace?
    var infoWindow: InfoWindow?
    var tappedMarker: GMSMarker?
    var mapLocations: [MapLocation] = []
    var selectedMapLocation: MapLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoWindow = InfoWindow().loadView()
        
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
    
    func addMarkers(mapLocations: [MapLocation]) {
        for mapLocation in mapLocations {
            guard let place = mapLocation.taggedPlaces.first?.place else { return }
            let location = place.location
            let position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let marker = GMSMarker(position: position)
            marker.title = place.name
            marker.snippet = "\(location.city), \(location.country)\n\(location.street)"
            marker.icon = UIImage(named: "bluePin")
            marker.map = mapView
            marker.userData = mapLocation.placeID
        }
    }
    
    //MARK: Navigation:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "markerInfoWindowToDetails" {
            guard let controller = segue.destination as? DetailsTableViewController else { return }
            guard let selectedMapLocation = selectedMapLocation,
                let taggedPlace = selectedMapLocation.taggedPlaces.first else { return }
            controller.taggedPlace = taggedPlace
        } else if segue.identifier == "multipleCheckinsForATaggedPlace" {
            guard let controller = segue.destination as? ListTableViewController else { return }
            guard let selectedTaggedPlaces = selectedMapLocation?.taggedPlaces else { return }
            controller.taggedPlaces = selectedTaggedPlaces
            controller.navigationItem.titleView = nil
            controller.navigationItem.title = selectedTaggedPlaces[0].place.name
            controller.tableView.refreshControl = nil
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
        if let selectedPlaceId = marker.userData as? String {
            self.selectedMapLocation = mapLocations.filter { return $0.placeID == selectedPlaceId }.first
        }
        marker.tracksInfoWindowChanges = true
        if tappedMarker == nil {
            marker.icon = UIImage(named: "selectedBluePin")
            self.tappedMarker = marker
        } else if tappedMarker == marker {
            tappedMarker?.icon = UIImage(named: "bluePin")
            tappedMarker = nil
        } else {
            tappedMarker?.icon = UIImage(named: "bluePin")
            marker.icon = UIImage(named: "selectedBluePin")
            self.tappedMarker = marker
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        infoWindow?.titleLabel.text = marker.title
        infoWindow?.addressLabel.text = marker.snippet
        marker.tracksInfoWindowChanges = false
        return self.infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let selectedMapLocation = selectedMapLocation,
            selectedMapLocation.taggedPlaces.isEmpty == false else { return }
        
        if selectedMapLocation.taggedPlaces.count == 1 {
            performSegue(withIdentifier: "markerInfoWindowToDetails", sender: self)
        } else {
            performSegue(withIdentifier: "multipleCheckinsForATaggedPlace", sender: self)
        }
        navigationController?.navigationBar.isHidden = false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if tappedMarker != nil {
            tappedMarker?.icon = UIImage(named: "bluePin")
            tappedMarker = nil
        }
    }
}


