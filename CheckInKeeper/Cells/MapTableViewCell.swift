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
    @IBOutlet weak var mapView: GMSMapView!
    var taggedPlace: TaggedPlace?
    
    func configureCell(taggedPlace: TaggedPlace) {
        mapView.layer.cornerRadius = 4
        self.taggedPlace = taggedPlace
        
        let coordinates = getCoordinates()
        let defaultCamera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude), zoom: 14.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.camera = defaultCamera
        mapView.isMyLocationEnabled = true
        mapView.settings.rotateGestures = false
        mapView.settings.scrollGestures = false
        mapView.settings.tiltGestures = false
        addMarker()
    }
   
    func addMarker() {
        let coordinates = getCoordinates()
        let position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let marker = GMSMarker(position: position)
        marker.title = taggedPlace?.place.name ?? "Check-in"
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        let latitude = taggedPlace?.place.location.latitude ?? 45.9432
        let longitude = taggedPlace?.place.location.longitude ?? 24.9668
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
