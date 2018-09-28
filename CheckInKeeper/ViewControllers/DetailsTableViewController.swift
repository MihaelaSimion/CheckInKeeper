//
//  DetailsTableViewController.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/27/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {
    var taggedPlace: TaggedPlace?
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let taggedPlace = taggedPlace else { return }
        placeNameLabel.text = taggedPlace.place.name
        dateLabel.text = taggedPlace.created_time?.toCustomPrint()
        cityLabel.text = taggedPlace.place.location.city
        countryLabel.text = taggedPlace.place.location.country
        streetLabel.text = taggedPlace.place.location.street
        latitudeLabel.text = String(format: "%.8f", taggedPlace.place.location.latitude)
        longitudeLabel.text = String(format: "%.8f", taggedPlace.place.location.longitude)
    }
}
