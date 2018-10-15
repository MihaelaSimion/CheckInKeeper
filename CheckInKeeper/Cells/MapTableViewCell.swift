//
//  MapTableViewCell.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/30/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import GoogleMaps

class MapTableViewCell: UITableViewCell {
    @IBOutlet private weak var mapView: GMSMapView!
    var taggedPlace: TaggedPlace?

    func configureCell(taggedPlace: TaggedPlace) {
        mapView.layer.cornerRadius = 4
        self.taggedPlace = taggedPlace
        loadMap()
        addMarker()
    }

    func addMarker() {
        let coordinates = getCoordinates()
        let position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let marker = GMSMarker(position: position)
        marker.title = taggedPlace?.place.name ?? "Check-in"
        marker.icon = UIImage(named: "selectedBluePin")
        marker.map = mapView
    }

    func loadMap() {
        do {
            if let styleURL = Bundle.main.url(forResource: "GoogleMapsStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        let coordinates = getCoordinates()
        let defaultCamera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude), zoom: 14.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.camera = defaultCamera
        mapView.isMyLocationEnabled = true
        mapView.settings.rotateGestures = false
        mapView.settings.scrollGestures = false
        mapView.settings.tiltGestures = false
    }

    func getCoordinates() -> CLLocationCoordinate2D {
        let latitude = taggedPlace?.place.location.latitude ?? 45.9432
        let longitude = taggedPlace?.place.location.longitude ?? 24.9668

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
