// Septa. 2017

import Foundation
import ReSwift
import SeptaSchedule

protocol NextToArriveMiddlewareAction: SeptaAction {}

struct NavigateToNextToArriveFromSchedules: NextToArriveMiddlewareAction {
    let description = "Navigate to Next To Arrive From Schedules"
}

struct NavigateToSchedulesFromNextToArrive: NextToArriveMiddlewareAction {
    let nextToArriveTrip: NextToArriveTrip
    let description = "Navigate to SchedulesFromNextToArrive"
}

struct NavigateToSchedulesFromNextToArriveScheduleRequest: NextToArriveMiddlewareAction {
    let scheduleRequest: ScheduleRequest
    let description = "Navigate to SchedulesFromNextToArrive schedule request"
}

struct NavigateToAlertDetailsFromSchedules: NextToArriveMiddlewareAction {
    let scheduleState: ScheduleState
    let description = "Navigate to Alert Details From Schedules"
}

struct NavigateToAlertDetailsFromNotification: NextToArriveMiddlewareAction {
    let notification: SeptaAlertDetourNotification
    let description = "Navigate to Alert Details From a Push Notification"
}

struct NavigateToNextToArriveFromDelayNotification: NextToArriveMiddlewareAction {
    let notification: SeptaDelayNotification
    let description = "Navigate to Alert Details From a Push Notification"
}

struct NavigateToAlertDetailsFromNextToArrive: NextToArriveMiddlewareAction {
    let scheduleRequest: ScheduleRequest
    let nextToArriveStop: NextToArriveStop
    let description = "Navigate to Alert Details From Next To Arrive"
}
