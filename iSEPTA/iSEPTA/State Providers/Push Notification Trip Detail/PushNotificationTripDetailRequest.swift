
import Foundation
import SeptaRest
/*
 {
 "vehicleId" : "237",
 "delayType" : "ACTUAL",
 "notificationType" : "DELAY",
 "message" : "Norristown: Train #237 going to Marcus Hook is operating 15 minutes late. Last at Main St.",
 "routeType" : "RAIL",
 "routeId" : "NOR",
 "google.c.a.e" : "1",
 "gcm.message_id" : "0:1541444889521948%65771b2f65771b2f",
 "aps" : {
 "alert" : {
 "title" : "Train Delay on NOR",
 "body" : "Norristown: Train #237 going to Marcus Hook is operating 15 minutes late. Last at Main St."
 }
 },
 "destinationStopId" : "90205"
 }
 */

typealias PushNotificationTripDetailRequestCompletion = (Data?, Int) -> Void

class PushNotificationTripDetailRequest {
    func sendRequestRealTimeTripsDetails(tripId: String, completion: @escaping PushNotificationTripDetailRequestCompletion) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "septaBaseUrl") as? String,
            var url = URL(string: "\(baseUrl)/realtimearrivals/details"),
            let apiKey = Bundle.main.object(forInfoDictionaryKey: "septaApiKey") as? String else { return }

        let URLParams = ["id": tripId]
        url = url.appendingQueryParameters(URLParams)

        let request = buildRequest(url: url, key: apiKey)

        /* Start a new Task */
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Swift.Error?) -> Void in
               let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
               DispatchQueue.main.async {
                 completion(data, statusCode)
               }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        }
    }

    fileprivate func buildRequest(url: URL, key: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(key, forHTTPHeaderField: "x-api-key")
        return request
    }
}
