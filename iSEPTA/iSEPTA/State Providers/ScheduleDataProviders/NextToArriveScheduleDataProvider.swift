//
//  NextToArriveScheduleProvider.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/4/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import ReSwift
import SeptaSchedule

class NextToArriveScheduleDataProvider: BaseScheduleDataProvider {
    static let sharedInstance = NextToArriveScheduleDataProvider()

    init() {
        super.init(targetForScheduleAction: .nextToArrive)
    }

    override func subscribe() {
        store.subscribe(self) {
            $0.select { $0.nextToArriveState.scheduleState.scheduleRequest }.skipRepeats { $0 == $1 }
        }
    }

    override func prerequisitesExistForTripStarts(scheduleRequest: ScheduleRequest) -> Bool {
        if scheduleRequest.transitMode == .rail && scheduleRequest.selectedRoute == nil {
            let action = LoadAllRailRoutes()
            store.dispatch(action)
        } else if scheduleRequest.selectedRoute == nil {
            retrieveAvailableRoutes(scheduleRequest: scheduleRequest)
        }
        return scheduleRequest.selectedRoute != nil
    }

    override func processSelectedRoute(scheduleRequest: ScheduleRequest) {
        if store.state.nextToArriveState.scheduleState.scheduleRequest.transitMode != .rail {
            let routes = store.state.nextToArriveState.scheduleState.scheduleData.availableRoutes
            if routes.routes.count == 0 {
                retrieveAvailableRoutes(scheduleRequest: scheduleRequest)
            }
        }
    }

    deinit {
        print("Next to arrive schedule data provider will vanish")
    }
}
