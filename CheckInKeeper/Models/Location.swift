//
//  LocationModel.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/28/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation

struct Location: Codable {
    var city: String
    var country: String
    var latitude: Double
    var longitude: Double
    var street: String
    
    init?(anyData: Any?) {
        guard let dictionary = anyData as? Dictionary<String, Any> else { return nil }
        guard let lat = dictionary["latitude"] as? Double else { return nil }
        self.latitude = lat
        guard let long = dictionary["longitude"] as? Double else { return nil }
        self.longitude = long
        guard let city = dictionary["city"] as? String else { return nil }
        self.city = city
        guard let country = dictionary["country"] as? String else { return nil }
        self.country = country
        guard let street = dictionary["street"] as? String else { return nil }
        self.street = street
    }
}
