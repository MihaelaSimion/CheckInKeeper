//
//  PlaceModel.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/28/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation

struct Place: Codable {
    var location: Location
    var name: String
    init?(anyData: Any?) {
        guard let dictionary = anyData as? Dictionary<String, Any> else { return nil}
        guard let name = dictionary["name"] as? String else { return nil}
        self.name = name
        guard let location = Location(anyData: dictionary["location"]) else { return nil }
        self.location = location
    }
}
