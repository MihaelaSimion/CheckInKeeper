//
//  MainTableViewCell.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/29/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(_ taggedPlace: TaggedPlace) {
        cellView.layer.cornerRadius = 4
        placeNameLabel.text = taggedPlace.place.name
        dateLabel.text = taggedPlace.created_time?.toCustomPrint()
    }

}
