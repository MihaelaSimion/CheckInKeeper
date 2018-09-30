//
//  DetailTableViewCell.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/30/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailNameLabel: UILabel!
    
    func configureDetailCell(taggedPlace: TaggedPlace, cellDetailType: CellDetailType) {
        view.layer.cornerRadius = 4
        detailLabel.text = cellDetailType.textForDetailLabel(taggedPlace: taggedPlace)
        detailNameLabel.text = cellDetailType.textForDetailNameLabel()
    }
}

enum CellDetailType {
    case name
    case date
    case city
    case country
    case street
    case latitude
    case longitude
    
    func textForDetailLabel(taggedPlace: TaggedPlace) -> String {
        switch self {
        case .name:
            return taggedPlace.place.name
        case .date:
            return taggedPlace.created_time?.toCustomPrint() ?? ""
        case .city:
            return taggedPlace.place.location.city
        case .country:
            return taggedPlace.place.location.country
        case .street:
            return taggedPlace.place.location.street
        case .latitude:
            return String(format: "%.8f", taggedPlace.place.location.latitude)
        case .longitude:
            return String(format: "%.8f", taggedPlace.place.location.longitude)
        }
    }
    
    func textForDetailNameLabel() -> String {
        switch self {
        case .name:
            return "Place's name:"
        case .date:
            return "Date:"
        case .city:
            return "City:"
        case .country:
            return "Country:"
        case .street:
            return "Street:"
        case .latitude:
            return "Latitude:"
        case .longitude:
            return "Longitude:"
        }
    }
}
