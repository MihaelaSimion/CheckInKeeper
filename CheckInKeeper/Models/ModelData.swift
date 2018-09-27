//
//  File.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/25/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation

struct TaggedPlacesResponse: Codable {
    var data: [TaggedPlace]
    init?(dictionary: Dictionary<String, Any>?) {
        guard let anyDataArray = dictionary?["data"] as? Array<Any> else { return nil }
        var taggedPlaces: [TaggedPlace] = []
        
        for anyData in anyDataArray {
            if let taggedPlace = TaggedPlace(anyData: anyData) {
                taggedPlaces.append(taggedPlace)
            }
        }
        data = taggedPlaces
    }
}

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
