//
//  InfoWindow.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 10/3/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

class InfoWindow: UIView {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func loadView() -> InfoWindow {
        let customInfoWindow = Bundle.main.loadNibNamed("MapMarkerWindowView", owner: self, options: nil)?[0] as! InfoWindow
        customInfoWindow.layer.cornerRadius = 3
        return customInfoWindow
    }
}
