//
//  DetailsTableViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/27/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailsTableViewController: UITableViewController {
    var taggedPlace: TaggedPlace?
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Check-in details:"
        
        mapView.layer.cornerRadius = 4
        let coordinates = getCoordinates()
        let defaultCamera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude), zoom: 14.0, bearing: 0.0, viewingAngle: 0.0)
        mapView.camera = defaultCamera
        mapView.isMyLocationEnabled = true
        mapView.settings.rotateGestures = false
        mapView.settings.scrollGestures = false
        mapView.settings.tiltGestures = false
    
        addMarker()
        
        guard let taggedPlace = taggedPlace else { return }
        placeNameLabel.text = taggedPlace.place.name
        dateLabel.text = taggedPlace.created_time?.toCustomPrint()
        cityLabel.text = taggedPlace.place.location.city
        countryLabel.text = taggedPlace.place.location.country
        streetLabel.text = taggedPlace.place.location.street
        latitudeLabel.text = String(format: "%.8f", taggedPlace.place.location.latitude)
        longitudeLabel.text = String(format: "%.8f", taggedPlace.place.location.longitude)
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
    
    //MARK: Table View delegate method:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
