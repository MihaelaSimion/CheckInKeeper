//
//  LocationModel.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/28/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation

struct Location {
    var city: String?
    var country: String?
    var latitude: Double
    var longitude: Double
    var street: String?

    init?(anyData: Any?) {
        guard let dictionary = anyData as? Dictionary<String, Any> else { return nil }
        guard let lat = dictionary["latitude"] as? Double else { return nil }
        guard let long = dictionary["longitude"] as? Double else { return nil }
        self.latitude = lat
        self.longitude = long

        if let city = dictionary["city"] as? String {
            self.city = city
        }

        if let country = dictionary["country"] as? String {
            self.country = country
        }

        if let street = dictionary["street"] as? String {
            self.street = street
        }
    }
}
