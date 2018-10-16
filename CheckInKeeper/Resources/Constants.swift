//
//  Constants.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 10/2/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import UIKit

struct Constants {

    struct Colors {
        static let backgroundColor = UIColor(red: 51.0/255.0, green: 89.0/255.0, blue: 113.0/255.0, alpha: 1.0)
        static let buttonColor = UIColor(red: 67.0/255.0, green: 160.0/255.0, blue: 173.0/255.0, alpha: 1.0)
    }

    struct CornerRadiusValues {
        static let buttonCornerRadius: CGFloat = 10
    }

    struct MapCameraSettings {
        static let defaultCameraLatitude = 45.9432
        static let defaultCameraLongitude = 24.9668
        static let defaultCameraZoom: Float = 7.0
        static let currentLocationFoundZoom: Float = 12.0
    }
}
