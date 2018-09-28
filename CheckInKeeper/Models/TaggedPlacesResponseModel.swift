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





