//
//  TaggedPlaceModel.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/28/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation

struct TaggedPlace {
    var place: Place
    var createdTime: Date?

    init?(anyData: Any?) {
        guard let anyData = anyData as? Dictionary<String, Any> else { return nil }
        guard let place = Place(anyData: anyData["place"]) else { return nil }
        self.place = place
        guard let dateString = anyData["created_time"] as? String else { return nil }
        guard let date = dateString.facebookStringValueToDate() else { return nil }
        self.createdTime = date
    }
}

extension Array where Element == TaggedPlace {
    func addMapLocations() -> [MapLocation] {
        var mapLocations: [MapLocation] = []
        for taggedPlace in self {
            var existingIndex = -1
            for (index, mapLocation) in mapLocations.enumerated() where mapLocation.placeID == taggedPlace.place.id {
                existingIndex = index
            }
            if existingIndex >= 0 {
                mapLocations[existingIndex].taggedPlaces.append(taggedPlace)
            } else {
                let newMapLocation = MapLocation(placeID: taggedPlace.place.id, taggedPlaces: [taggedPlace])
                mapLocations.append(newMapLocation)
            }
        }
        return mapLocations
    }
}
