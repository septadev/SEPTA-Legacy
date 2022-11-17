//
//  PushNotificationTripDetailData.swift
//  iSEPTA
//
//  Created by Mark Broski on 11/6/18.
//  Copyright © 2018 Mark Broski. All rights reserved.
//

import Foundation
import SeptaRest
import SeptaRest

struct PushNotificationTripDetailData: Equatable, Encodable {
    let consist: [String]?
    let destination: String?
    let destinationDelay: Int?
    let destinationStation: String?
    let direction: String?
    let latitude: Double
    let line: String?
    let longitude: Double
    let nextstopDelay: Int?
    let nextstopStation: String?
    let results: Int?
    let service: String?
    let source: String?
    let speed: String?
    let track: String?
    let trackChange: String?
    var routeId: String?
    let tripId: String?

    init(
        consist: [String]? = nil,
        destination: String? = nil,
        destinationDelay: Int? = nil,
        destinationStation: String? = nil,
        direction: String? = nil,
        latitude: Double? = nil,
        line: String? = nil,
        longitude: Double? = nil,
        nextstopDelay: Int? = nil,
        nextstopStation: String? = nil,
        results: Int? = nil,
        service: String? = nil,
        source: String? = nil,
        speed: String? = nil,
        track: String? = nil,
        trackChange: String? = nil,
        tripId: String? = nil
    ) {
        self.consist = consist
        self.destination = destination
        self.destinationDelay = destinationDelay
        self.destinationStation = destinationStation
        self.direction = direction
        self.latitude = latitude ?? 0
        self.line = line
        self.longitude = longitude ?? 0
        self.nextstopDelay = nextstopDelay
        self.nextstopStation = nextstopStation
        self.results = results
        self.service = service
        self.source = source
        self.speed = speed
        self.track = track
        self.trackChange = trackChange
        self.tripId = tripId
    }

    init(nextToArriveRailDetails details: NextToArriveRailDetails) {
        consist = details.consist
        destination = details.destination
        destinationDelay = details.destinationDelay
        destinationStation = details.destinationStation
        direction = details.direction
        latitude = details.latitude ?? 0
        line = details.line
        longitude = details.longitude ?? 0
        nextstopDelay = details.nextstopDelay
        nextstopStation = details.nextstopStation
        results = details.results
        service = details.service
        source = details.source
        speed = details.speed
        track = details.track
        trackChange = details.trackChange
        let tripIdInt = details.tripid ?? 0
        tripId = String(tripIdInt)
    }

    
}
