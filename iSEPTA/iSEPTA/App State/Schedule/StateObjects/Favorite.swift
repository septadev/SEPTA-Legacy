//
//  Favorite.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/1/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import SeptaSchedule

enum FavoriteType: String, Codable {
    case nextToArrive
    case transitView
}

// TODO: create a parallel favorite data array so that we aren't writing favorites to disk so much
struct Favorite: Codable {
    var favoriteType: FavoriteType
    var favoriteId: String
    var favoriteName: String
    var transitMode: TransitMode
    var selectedRoute: Route
    var selectedStart: Stop
    var selectedEnd: Stop
    var nextToArriveTrips: [NextToArriveTrip]
    var nextToArriveUpdateStatus: NextToArriveUpdateStatus
    var transitViewRoutes: [TransitRoute]
    var refreshDataRequested: Bool
    var collapsed: Bool
    var sortOrder: Int

    static var reversedFavoriteId: String = "ReversedFavorite"

    static let defaultSortOrder = 999

    var scheduleRequest: ScheduleRequest {
        return convertedToScheduleRequest()
    }

    init(favoriteType: FavoriteType, favoriteId: String, favoriteName: String, transitMode: TransitMode, selectedRoute: Route, selectedStart: Stop, selectedEnd: Stop, nextToArriveTrips: [NextToArriveTrip] = [NextToArriveTrip](), nextToArriveUpdateStatus: NextToArriveUpdateStatus = .idle, transitViewRoutes: [TransitRoute] = [], refreshDataRequested: Bool = false, collapsed: Bool = false, sortOrder: Int = Favorite.defaultSortOrder) {
        self.favoriteType = favoriteType
        self.favoriteId = favoriteId
        self.favoriteName = favoriteName
        self.transitMode = transitMode
        self.selectedRoute = selectedRoute
        self.selectedStart = selectedStart
        self.selectedEnd = selectedEnd
        self.nextToArriveTrips = nextToArriveTrips
        self.nextToArriveUpdateStatus = nextToArriveUpdateStatus
        self.transitViewRoutes = transitViewRoutes
        self.refreshDataRequested = refreshDataRequested
        self.collapsed = collapsed
        self.sortOrder = sortOrder
    }

    enum CodingKeys: String, CodingKey {
        case favoriteType
        case favoriteId
        case favoriteName
        case transitMode
        case selectedRoute
        case selectedStart
        case selectedEnd
        case collapsed
        case sortOrder
        case transitViewRoutes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container

        transitMode = try container.decode(TransitMode.self, forKey: .transitMode)
        selectedRoute = try container.decode(Route.self, forKey: .selectedRoute)
        selectedStart = try container.decode(Stop.self, forKey: .selectedStart)
        selectedEnd = try container.decode(Stop.self, forKey: .selectedEnd)

        let defaultId = UUID().uuidString
        do {
            favoriteId = try container.decode(String?.self, forKey: .favoriteId) ?? defaultId
        } catch {
            favoriteId = defaultId
        }

        let defaultName = "\(selectedRoute.routeId): \(selectedStart.stopName) to \(selectedEnd.stopName)"
        do {
            favoriteName = try container.decode(String?.self, forKey: .favoriteName) ?? defaultName
        } catch {
            favoriteName = defaultName
        }

        let defaultCollapsed = false
        do {
            collapsed = try container.decode(Bool?.self, forKey: .collapsed) ?? defaultCollapsed
        } catch {
            collapsed = defaultCollapsed
        }

        do {
            sortOrder = try container.decode(Int?.self, forKey: .sortOrder) ?? Favorite.defaultSortOrder
        } catch {
            sortOrder = Favorite.defaultSortOrder
        }

        do {
            transitViewRoutes = try container.decode([TransitRoute]?.self, forKey: .transitViewRoutes) ?? []
        } catch {
            transitViewRoutes = []
        }

        var defaultFavoriteType: FavoriteType = .nextToArrive
        if transitViewRoutes.count > 0 {
            defaultFavoriteType = .transitView
        }
        do {
            favoriteType = try container.decode(FavoriteType?.self, forKey: .favoriteType) ?? defaultFavoriteType
        } catch {
            favoriteType = defaultFavoriteType
        }

        nextToArriveTrips = [NextToArriveTrip]()
        nextToArriveUpdateStatus = .idle
        refreshDataRequested = true
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(favoriteType, forKey: .favoriteType)
        try container.encode(favoriteId, forKey: .favoriteId)
        try container.encode(favoriteName, forKey: .favoriteName)
        try container.encode(transitMode, forKey: .transitMode)
        try container.encode(selectedRoute, forKey: .selectedRoute)
        try container.encode(selectedStart, forKey: .selectedStart)
        try container.encode(selectedEnd, forKey: .selectedEnd)
        try container.encode(collapsed, forKey: .collapsed)
        try container.encode(sortOrder, forKey: .sortOrder)
        try container.encode(transitViewRoutes, forKey: .transitViewRoutes)
    }

    public static let emptyRoute = Route(routeId: "", routeShortName: "", routeLongName: "", routeDirectionCode: .inbound)
    public static let emptyStop = Stop(stopId: 0, sequence: 0, stopName: "", stopLatitude: 0, stopLongitude: 0, wheelchairBoarding: false, weekdayService: false, saturdayService: false, sundayService: false)
}

extension Favorite: Hashable {
    var hashValue: Int {
        return favoriteId.hashValue
    }
}

extension Favorite: Equatable {}
func == (lhs: Favorite, rhs: Favorite) -> Bool {
    var areEqual = true

    areEqual = lhs.favoriteId == rhs.favoriteId
    guard areEqual else { return false }

    areEqual = lhs.favoriteName == rhs.favoriteName
    guard areEqual else { return false }

    areEqual = lhs.transitMode == rhs.transitMode
    guard areEqual else { return false }

    areEqual = lhs.selectedRoute == rhs.selectedRoute
    guard areEqual else { return false }

    areEqual = lhs.selectedStart == rhs.selectedStart
    guard areEqual else { return false }

    areEqual = lhs.selectedEnd == rhs.selectedEnd
    guard areEqual else { return false }

    areEqual = lhs.nextToArriveTrips == rhs.nextToArriveTrips
    guard areEqual else { return false }

    areEqual = lhs.nextToArriveUpdateStatus == rhs.nextToArriveUpdateStatus
    guard areEqual else { return false }

    areEqual = lhs.refreshDataRequested == rhs.refreshDataRequested
    guard areEqual else { return false }

    areEqual = lhs.collapsed == rhs.collapsed
    guard areEqual else { return false }

    areEqual = lhs.sortOrder == rhs.sortOrder
    guard areEqual else { return false }

    areEqual = lhs.favoriteType == rhs.favoriteType
    guard areEqual else { return false }

    areEqual = lhs.transitViewRoutes == rhs.transitViewRoutes
    guard areEqual else { return false }

    return areEqual
}

func == (lhs: Favorite, rhs: ScheduleRequest) -> Bool {
    let scheduleRequestTransitMode = rhs.transitMode
    guard
        let scheduleRequestSelectedRoute = rhs.selectedRoute,
        let scheduleRequestSelectedStart = rhs.selectedStart,
        let scheduleRequestSelectedEnd = rhs.selectedEnd else { return false }
    var areEqual = true

    areEqual = lhs.transitMode == scheduleRequestTransitMode
    guard areEqual else { return false }

    areEqual = lhs.selectedRoute == scheduleRequestSelectedRoute
    guard areEqual else { return false }

    areEqual = lhs.selectedStart == scheduleRequestSelectedStart
    guard areEqual else { return false }

    areEqual = lhs.selectedEnd == scheduleRequestSelectedEnd
    guard areEqual else { return false }

    return areEqual
}

func == (lhs: ScheduleRequest, rhs: Favorite) -> Bool {
    return rhs == lhs
}
