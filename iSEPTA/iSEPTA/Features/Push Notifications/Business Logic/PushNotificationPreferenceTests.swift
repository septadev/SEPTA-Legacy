//
//  PushNotificationPreferenceTests.swift
//  iSEPTATests
//
//  Created by Mark Broski on 7/23/18.
//  Copyright © 2018 Mark Broski. All rights reserved.
//

@testable import Septa
import XCTest

class PushNotificationPreferenceTests: XCTestCase {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    let calendar = Calendar.current

    func testDayOfWeek() {
        let dateString = "2018-07-23" // a Monday
        let date = dateFormatter.date(from: dateString)!
        XCTAssertEqual(DaysOfWeekOptionSet.monday.matchesDate(date), true)
        XCTAssertEqual(DaysOfWeekOptionSet.tuesday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.wednesday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.thursday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.friday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.saturday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.sunday.matchesDate(date), false)
    }

    func testDayOfWeek2() {
        let dateString = "2018-07-25" // A Wednesday
        let date = dateFormatter.date(from: dateString)!
        XCTAssertEqual(DaysOfWeekOptionSet.monday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.tuesday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.wednesday.matchesDate(date), true)
        XCTAssertEqual(DaysOfWeekOptionSet.thursday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.friday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.saturday.matchesDate(date), false)
        XCTAssertEqual(DaysOfWeekOptionSet.sunday.matchesDate(date), false)
    }

    func testDayOfWeek3() {
        let dateString = "2018-07-25" // a Wednesday
        let date = dateFormatter.date(from: dateString)!
        let daysOfWeek: DaysOfWeekOptionSet = [.monday, .wednesday]
        XCTAssertEqual(daysOfWeek.matchesDate(date), true)
    }

    func testDayOfWeek4() {
        let dateString = "2018-07-24" // a Tuesday
        let date = dateFormatter.date(from: dateString)!
        let daysOfWeek: DaysOfWeekOptionSet = [.monday, .wednesday]
        XCTAssertEqual(daysOfWeek.matchesDate(date), false)
    }

    func testPushNotificationPreferenceState() {
        let testDateComponents = DateComponents(hour: 1, minute: 30)
        let testDate = calendar.date(from: testDateComponents)!
        let minutesSinceMidnight = MinutesSinceMidnight(date: testDate)!
        XCTAssertEqual(90, minutesSinceMidnight.minutes)
        let timeOnlyDateString = DateFormatters.networkFormatter.string(from: minutesSinceMidnight.timeOnlyDate!)
        XCTAssertTrue(timeOnlyDateString.contains("0001-01-01T01:30:00.000"))
    }

    func testPushNotificationPreferenceState2() {
        let testDateComponents = DateComponents(year: 2018, month: 7, day: 12, hour: 15, minute: 45)
        let testDate = calendar.date(from: testDateComponents)!
        let minutesSinceMidnight = MinutesSinceMidnight(date: testDate)!
        XCTAssertEqual(15 * 60 + 45, minutesSinceMidnight.minutes)
        let timeOnlyDateString = DateFormatters.networkFormatter.string(from: minutesSinceMidnight.timeOnlyDate!)
        XCTAssertTrue(timeOnlyDateString.contains("0001-01-01T15:45:00.000"))
    }

    func testNotificationTimeWindow() {
        let startTime = dateFromHourMinute(hour: 7, minute: 30)
        let endTime = dateFromHourMinute(hour: 9, minute: 30)
        let testTime = dateFromHourMinute(hour: 8, minute: 15)
        let timeWindow = NotificationTimeWindow(startTime: startTime, endTime: endTime)!
        let actualResult = timeWindow.dateFitsInRange(date: testTime)!
        let expectedResult = true
        XCTAssertEqual(actualResult, expectedResult)
    }

    func testNotificationTimeWindow2() {
        let startTime = dateFromHourMinute(hour: 7, minute: 30)
        let endTime = dateFromHourMinute(hour: 9, minute: 30)
        let testTime = dateFromHourMinute(hour: 9, minute: 30)
        let timeWindow = NotificationTimeWindow(startTime: startTime, endTime: endTime)!
        let actualResult = timeWindow.dateFitsInRange(date: testTime)!
        let expectedResult = true
        XCTAssertEqual(actualResult, expectedResult)
    }

    func testNotificationTimeWindow3() {
        let startTime = dateFromHourMinute(hour: 7, minute: 30)
        let endTime = dateFromHourMinute(hour: 9, minute: 30)
        let testTime = dateFromHourMinute(hour: 10, minute: 30)
        let timeWindow = NotificationTimeWindow(startTime: startTime, endTime: endTime)!
        let actualResult = timeWindow.dateFitsInRange(date: testTime)!
        let expectedResult = false
        XCTAssertEqual(actualResult, expectedResult)
    }

    func testPushNotificationStatePersistence() {
        let startTime = dateFromHourMinute(hour: 7, minute: 30)
        let endTime = dateFromHourMinute(hour: 9, minute: 30)

        let timeWindow = NotificationTimeWindow(startTime: startTime, endTime: endTime)!

        let daysOfWeek: DaysOfWeekOptionSet = [.wednesday] // will no longer match fridays

        let route1 = PushNotificationRoute(routeId: "44", routeName: "", transitMode: .bus)
        let route2 = PushNotificationRoute(routeId: "44", routeName: "", transitMode: .bus)
        let routeIds = [route1, route2]

        var preferenceState = PushNotificationPreferenceState()
        preferenceState.notificationTimeWindows = [timeWindow]
        preferenceState.daysOfWeek = daysOfWeek
        preferenceState.routeIds = routeIds

        let action = UpdatePushNotificationPreferenceState(pushNotificationPreferenceState: preferenceState)
        store.dispatch(action)

        let newPreferenceState = store.state.preferenceState.pushNotificationPreferenceState
        XCTAssertEqual(preferenceState, newPreferenceState)
    }

    func testPushNotificationStatePersistence2() {
        let startTime = dateFromHourMinute(hour: 7, minute: 30)
        let endTime = dateFromHourMinute(hour: 9, minute: 30)

        let timeWindow = NotificationTimeWindow(startTime: startTime, endTime: endTime)!

        let daysOfWeek: DaysOfWeekOptionSet = [.wednesday, .tuesday] // will no longer match fridays

        let route1 = PushNotificationRoute(routeId: "44", routeName: "Bus 44", transitMode: .bus)
        let route2 = PushNotificationRoute(routeId: "465564", routeName: "Bus 465564", transitMode: .bus)
        let routeIds = [route1, route2]

        var preferenceState = PushNotificationPreferenceState()
        preferenceState.notificationTimeWindows = [timeWindow]
        preferenceState.daysOfWeek = daysOfWeek
        preferenceState.routeIds = routeIds

        let action = UpdatePushNotificationPreferenceState(pushNotificationPreferenceState: preferenceState)
        store.dispatch(action)

        let expectation = XCTestExpectation(description: "Wait for defaults to get written")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            let data: Data = UserDefaults.standard.data(forKey: UserPreferencesKeys.pushNotificationPreferenceState.rawValue)!
            let newPreferenceState = try! JSONDecoder().decode(PushNotificationPreferenceState.self, from: data)
            XCTAssertEqual(preferenceState, newPreferenceState)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 2)
    }

    func dateFromHourMinute(hour: Int, minute: Int) -> Date {
        let testDateComponents = DateComponents(hour: hour, minute: minute)
        return calendar.date(from: testDateComponents)!
    }

    func dateFromComponents(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        let testDateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return calendar.date(from: testDateComponents)!
    }
}
