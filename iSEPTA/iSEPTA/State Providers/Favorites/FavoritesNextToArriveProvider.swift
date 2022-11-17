//
//  FavoritesNextToArriveProvider.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/13/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import CoreLocation
import Foundation
import ReSwift
import SeptaRest
import SeptaSchedule

class FavoritesNextToArriveProvider: StoreSubscriber {
    typealias StoreSubscriberStateType = Set<Favorite>

    let mapper = NextToArriveMapper()

    static let sharedInstance = FavoritesNextToArriveProvider()

    let client = SEPTAApiClient.defaultClient(url: SeptaNetwork.sharedInstance.url, apiKey: SeptaNetwork.sharedInstance.apiKey)

    let scheduleRequestWatcher = NextToArriveScheduleRequestWatcher()

    let nextToArriveDetailProvider = NextToArriveDetailProvider()

    private init() {
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    func newState(state: StoreSubscriberStateType) {
        let favoritesToUpdate = state
        retrieveNextToArrive(favorites: Array(favoritesToUpdate))
    }

    func retrieveNextToArrive(favorites: [Favorite]) {
        for favorite in favorites {
            retrieveNextToArrive(favorite: favorite, completion: mapArrivals)
        }
    }

    func reportSuccessfullyUpdatedFavorite(favorite: Favorite, nextToArriveTrips: [NextToArriveTrip]) {
        let updateAction = UpdateFavoriteNextToArriveTrips(favoriteId: favorite.favoriteId, nextToArriveTrips: nextToArriveTrips)
        store.dispatch(updateAction)
    }

    func reportUpdatedFavoriteStatus(favorite: Favorite, status: NextToArriveUpdateStatus) {
        let action = UpdateFavoriteNextToArriveUpdateStatus(favoriteId: favorite.favoriteId, nextToArriveUpdateStatus: status)
        store.dispatch(action)
    }

    func retrieveNextToArrive(favorite: Favorite, completion: (([RealTimeArrival], Favorite, TransitMode) -> Void)?) {
        let transitType = TransitType.fromTransitMode(favorite.transitMode)
        let startId = favorite.selectedStart.stopId
        let stopId = favorite.selectedEnd.stopId

        let originId = String(startId)
        let destinationId = String(stopId)

        let routeId = favorite.transitMode == .rail ? nil : favorite.selectedRoute.routeId

        reportUpdatedFavoriteStatus(favorite: favorite, status: .dataLoading)

        client.getRealTimeArrivals(originId: originId, destinationId: destinationId, transitType: transitType, route: routeId).then { realTimeArrivals -> Void in
            guard let arrivals = realTimeArrivals?.arrivals else { return }
            if arrivals.count == 0 {
                throw NextToArriveError.noResultsReturned
            }
            completion?(arrivals, favorite, favorite.transitMode)

        }.catch { error in
            print(error.localizedDescription)
            if let _ = error as? NextToArriveError {
                self.reportUpdatedFavoriteStatus(favorite: favorite, status: .noResultsReturned)
            } else {
                self.reportUpdatedFavoriteStatus(favorite: favorite, status: .dataLoadingError)
            }
        }
    }

    func mapArrivals(realTimeArrivals: [RealTimeArrival], favorite: Favorite, transitMode: TransitMode) {
        var nextToArriveTrips = [NextToArriveTrip]()
        for realTimeArrival in realTimeArrivals {
            let startStop = mapper.mapStart(realTimeArrival: realTimeArrival, transitMode: transitMode)
            let endStop = mapper.mapEnd(realTimeArrival: realTimeArrival, transitMode: transitMode)

            let connectionLocation = mapper.mapConnectionStation(realTimeArrival: realTimeArrival)

            if let startStop = startStop, let endStop = endStop {
                let vehicleLocation = mapper.mapVehicleLocation(realTimeArrival: realTimeArrival, startStop: startStop, endStop: endStop)
                let nextToArriveTrip = NextToArriveTrip(startStop: startStop, endStop: endStop, vehicleLocation: vehicleLocation, connectionLocation: connectionLocation)
                nextToArriveTrips.append(nextToArriveTrip)
                nextToArriveDetailProvider.retrieveNextToArriveDetail(favorite: favorite, nextToArriveTrip: nextToArriveTrip, transitMode: transitMode)
            }
        }
        reportSuccessfullyUpdatedFavorite(favorite: favorite, nextToArriveTrips: nextToArriveTrips)
    }
}

extension FavoritesNextToArriveProvider: SubscriberUnsubscriber {
    func subscribe() {
        store.subscribe(self) {
            $0.select {
                $0.favoritesState.favoritesToUpdate
            }
        }
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
