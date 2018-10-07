//
//  TaggedPlaceModel.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/28/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation

struct TaggedPlace: Codable {
    var place: Place
    var created_time: Date?
    init?(anyData: Any?) {
        guard let anyData = anyData as? Dictionary<String, Any> else { return nil }
        guard let place = Place(anyData: anyData["place"]) else { return nil }
        self.place = place
        guard let dateString = anyData["created_time"] as? String else { return nil }
        guard let date = dateString.facebookStringValueToDate() else { return nil }
        self.created_time = date
    }
}
