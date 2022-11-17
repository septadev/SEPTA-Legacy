//
//  SeptaRestTests.swift
//  SeptaRestTests
//
//  Created by Mark Broski on 8/29/17.
//  Copyright © 2017 SEPTA. All rights reserved.
//

import XCTest
@testable import SeptaRest
import PromiseKit

class SeptaRestTests: XCTestCase {
    let client = SEPTAApiClient.defaultClient(url: "https://vnjb5kvq2b.execute-api.us-east-1.amazonaws.com/prod", apiKey: "7Nx754dd9G5YkpYoRLbi4aoNW9LtWllt1Jcbw9v8")

    func testAlerts() {
        let expectation = self.expectation(description: "Should Return")
        client.getAlerts(route: "").then { alerts -> Void in
            if let alerts = alerts?.alerts {
                XCTAssertTrue(alerts.count > 0, "Should always be some alerts")
                expectation.fulfill()
            }
        }.catch { err in
            print(err)
        }

        waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription)
        }
    }

    //    func testArrivals() {
    //        let expectation = self.expectation(description: "Should Return")
    //        client.getArrivals(origin: "Gravers", destination:"Chestnut Hill East").then { arrivals -> Void in
    //            print(arrivals)
    //            expectation.fulfill()
    //        }.catch { err in
    //            print(err)
    //        }
    //
    //        waitForExpectations(timeout: 10) { error in
    //            print(error?.localizedDescription)
    //        }
    //    }

    func testRealTimeArrivals() {
        let expectation = self.expectation(description: "Should Return")

        client.getRealTimeArrivals(originId: "90719", destinationId: "90720", transitType: .RAIL, route: nil).then { arrivals -> Void in
            XCTAssertNotNil(arrivals, "Did not get back arrivals")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription)
        }
    }

    func testRealTimeRailArrivalDetail() {
        let expectation = self.expectation(description: "Should Return")

        client.getRealTimeArrivals(originId: "90719", destinationId: "90720", transitType: .RAIL, route: nil).then { arrivals -> Void in
            XCTAssertNotNil(arrivals, "Did not get back arrivals")
            guard let arrivals = arrivals, let arrivalList = arrivals.arrivals, let firstItem = arrivalList.first, let tripId = firstItem.orig_line_trip_id else {
                return
            }
            self.client.getRealTimeRailArrivalDetail(tripId: tripId).then { details -> Void in
                XCTAssertNotNil(details, "Did not get back arrivals")
                expectation.fulfill()
            }.catch { error in
                print(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10000) { error in
            print(error?.localizedDescription)
        }
    }

    func testRealTimeBusArrivalDetail() {
        let expectation = self.expectation(description: "Should Return")

        client.getRealTimeArrivals(originId: "15473", destinationId: "809", transitType: .BUS, route: "22").then { arrivals -> Void in
            XCTAssertNotNil(arrivals, "Did not get back arrivals")
            guard let arrivals = arrivals,
                let arrivalList = arrivals.arrivals,
                let firstItem = arrivalList.first,
                let tripId = firstItem.orig_line_trip_id,
                let routeId = firstItem.orig_line_route_id,
                let vehicleId = firstItem.orig_vehicle_id else {
                return
            }
            self.client.getRealTimeBusArrivalDetail(tripId: vehicleId, routeId: routeId).then { details -> Void in
                XCTAssertNotNil(details, "Did not get back arrivals")
                expectation.fulfill()
            }.catch { error in
                print(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10000) { error in
            print(error?.localizedDescription)
        }
    }

    func testRoutes() {
        let expectation = self.expectation(description: "Should Return")
        client.getTransitRoutes(route: "44").then { transitRoutes -> Void in
            print(transitRoutes)
        }.catch { err in
            print(err)
        }

        waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription)
        }
    }
}
