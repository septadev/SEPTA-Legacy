// Septa. 2017

import Foundation

struct SeptaString {
    static let SelectRoute = NSLocalizedString("Select Route", comment: "To Select a Transit Route")
    static let SelectStart = NSLocalizedString("Select Start", comment: "To Select a starting transit stop")
    static let SelectEnd = NSLocalizedString("Select Destination", comment: "To Select a Transit Stop")

    static let selectScheduleButton = NSLocalizedString("View Schedules", comment: "To Indicate that user wants to view schedule")

    static let NoRoutesAvailable = NSLocalizedString("Sorry, there are no routes that match your request", comment: "Query for routes in the database returned no results")
    static let NoStopsAvailable = NSLocalizedString("Sorry, there are no stops/stations that match your request", comment: "Query for stops in the database returned no results")
    static let NoTripsAvailable = NSLocalizedString("Sorry, there are no trips that match your request", comment: "Query for trips in the database returned no results")
    static let NoRouteNeeded = NSLocalizedString("Select your stations to see Next to Arrive Trains", comment: "Don't need to search for route because we can build a trip for your from any two stops, provided you are using rail")

    static let NextToArriveTitle = NSLocalizedString("Next to Arrive", comment: "Text indicating a feature that allows user's to view coming transit opportunities")

    static let NoFavoritesInfo = NSLocalizedString("Save your SEPTA trips as a favorite to get immediate access to the Next to Arrive transit, and schedules.", comment: "How favorites work in the app")
    static let NoFavoritesInstructions = NSLocalizedString("Find a trip then use the favorite icon to add it to your Favorites.", comment: "How favorites work in the app instructions")
}
