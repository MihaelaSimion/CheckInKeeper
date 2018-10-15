//
//  InfoWindow.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/28/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class InfoWindow: UIView {
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    func loadView() -> InfoWindow? {
        guard let customInfoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?[0] as? InfoWindow else { return nil }
        customInfoWindow.translatesAutoresizingMaskIntoConstraints = false
        customInfoWindow.layoutIfNeeded()
        customInfoWindow.layer.cornerRadius = 3
        return customInfoWindow
    }

    func setAddressLabelText(text: String) {
        addressLabel.text = text
    }

    func setTitleLabelText(text: String) {
        titleLabel.text = text
    }
}
