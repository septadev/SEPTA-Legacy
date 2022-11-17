//
//  NextToArriveProvider.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/7/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import CoreLocation
import Foundation
import ReSwift
import SeptaRest
import SeptaSchedule

class NextToArriveProvider: StoreSubscriber, NextToArriveReverseTripWatcherDelegate {
    typealias StoreSubscriberStateType = Bool

    let mapper = NextToArriveMapper()
    let reverseTripWatcher = NextToArriveState_ReverseTripStatusWatcher()

    static let sharedInstance = NextToArriveProvider()

    let client = SEPTAApiClient.defaultClient(url: SeptaNetwork.sharedInstance.url, apiKey: SeptaNetwork.sharedInstance.apiKey)

    let scheduleRequestWatcher = NextToArriveScheduleRequestWatcher()

    let nextToArriveDetailProvider = NextToArriveDetailProvider()

    var nextToArriveReverseTripStatus: NextToArriveReverseTripStatus = .noReverse

    private init() {
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    func nextToArriveReverseTripStatusChanged(status: NextToArriveReverseTripStatus) {
        nextToArriveReverseTripStatus = status
    }

    var scheduleRequest: ScheduleRequest { return store.state.nextToArriveState.scheduleState.scheduleRequest }
    var nextToArriveUpdateStatus: NextToArriveUpdateStatus { return store.state.nextToArriveState.nextToArriveUpdateStatus }

    func newState(state: Bool) {
        let refreshDataRequested = state

        if refreshDataRequested && nextToArriveUpdateStatus != .dataLoading {
            reportStatus(.dataLoading)
            retrieveNextToArrive(scheduleRequest: scheduleRequest, completion: mapArrivals)
        }
    }

    func reportStatus(_ status: NextToArriveUpdateStatus, nextToArriveTrips: [NextToArriveTrip] = [NextToArriveTrip]()) {
        let updateAction = UpdateNextToArriveStatusAndData(nextToArriveUpdateStatus: status, nextToArriveTrips: nextToArriveTrips, refreshDataRequested: false)
        store.dispatch(updateAction)
    }

    func retrieveNextToArrive(scheduleRequest: ScheduleRequest, completion: (([RealTimeArrival], TransitMode) -> Void)?) {
        guard
            let startId = scheduleRequest.selectedStart?.stopId,
            let stopId = scheduleRequest.selectedEnd?.stopId else { return }
        let transitType = TransitType.fromTransitMode(scheduleRequest.transitMode)
        let originId = String(startId)
        let destinationId = String(stopId)

        let routeId = scheduleRequest.transitMode == .rail ? nil : scheduleRequest.selectedRoute?.routeId

        client.getRealTimeArrivals(originId: originId, destinationId: destinationId, transitType: transitType, route: routeId).then { realTimeArrivals -> Void in

            guard let arrivals = realTimeArrivals?.arrivals else { return }
            if arrivals.count == 0 {
                throw NextToArriveError.noResultsReturned
            }
            completion?(arrivals, scheduleRequest.transitMode)

        }.catch { error in
            print(error.localizedDescription)
            if let _ = error as? NextToArriveError {
                self.reportStatus(.noResultsReturned)
            } else {
                self.reportStatus(.dataLoadingError)
            }
        }
    }

    func mapArrivals(realTimeArrivals: [RealTimeArrival], transitMode: TransitMode) {
        var nextToArriveTrips = [NextToArriveTrip]()
        for realTimeArrival in realTimeArrivals {
            let startStop = mapper.mapStart(realTimeArrival: realTimeArrival, transitMode: transitMode)
            let endStop = mapper.mapEnd(realTimeArrival: realTimeArrival, transitMode: transitMode)

            let connectionLocation = mapper.mapConnectionStation(realTimeArrival: realTimeArrival)

            if let startStop = startStop, let endStop = endStop {
                let vehicleLocation = mapper.mapVehicleLocation(realTimeArrival: realTimeArrival, startStop: startStop, endStop: endStop)
                let nextToArriveTrip = NextToArriveTrip(
                    startStop: startStop,
                    endStop: endStop,
                    vehicleLocation: vehicleLocation,
                    connectionLocation: connectionLocation)

                nextToArriveTrips.append(nextToArriveTrip)
                nextToArriveDetailProvider.retrieveNextToArriveDetail(nextToArriveTrip: nextToArriveTrip, transitMode: transitMode)
            }
        }
        reportStatus(.dataLoadedSuccessfully, nextToArriveTrips: nextToArriveTrips)
    }
}

extension NextToArriveProvider: SubscriberUnsubscriber {
    func subscribe() {
        store.subscribe(self) {
            $0.select {
                $0.nextToArriveState.refreshDataRequested
            }.skipRepeats { $0 == $1 }
        }
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
