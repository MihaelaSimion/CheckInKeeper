//
//  NothingFoundTableViewCell.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/30/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class NothingFoundTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var label: UILabel!
    
    func configureNothingFoundCell() {
        mainView.layer.cornerRadius = 4
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5
    }
}
