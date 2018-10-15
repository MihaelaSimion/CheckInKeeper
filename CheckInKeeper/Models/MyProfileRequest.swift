//
//  MyProfileRequest.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/25/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation
import FacebookCore

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var taggedPlaceResponse: TaggedPlacesResponse?

        init(rawResponse: Any?) {
            if let dic = rawResponse as? Dictionary<String, Any>,
                let taggedPlaceResponse = TaggedPlacesResponse(dictionary: dic) {
                self.taggedPlaceResponse = taggedPlaceResponse
            }
        }
    }

    var parameters: [String: Any]?
    var graphPath: String

    init(graphPath: String) {
        self.graphPath = graphPath
    }

    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}
