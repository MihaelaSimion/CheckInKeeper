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
    @IBOutlet weak var viewWithNumber: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    func configureCell(_ taggedPlace: TaggedPlace, for index: IndexPath) {
        cellView.layer.cornerRadius = 4
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowOffset = CGSize.zero
        cellView.layer.shadowRadius = 5
        viewWithNumber.layer.cornerRadius = 16
        numberLabel.text = "\(index.row + 1)"
        numberLabel.textColor = .white
        placeNameLabel.text = taggedPlace.place.name
        dateLabel.text = taggedPlace.created_time?.toCustomPrint()
        detailView.layer.cornerRadius = 2
    }
}
