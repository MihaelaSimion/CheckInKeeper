//
//  MapLocationModel.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 10/6/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation
import GoogleMaps

struct MapLocation {
    var placeID: String
    var taggedPlaces: [TaggedPlace] = []
}
