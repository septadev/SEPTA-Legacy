// Septa. 2017

import Foundation
import UIKit

class UIAlert {
    static func presentOKAlertFrom(viewController: UIViewController, withTitle title: String, message: String, completion: (() -> Void)? = nil) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
            completion?()
        })

        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }

    static func presentYesNoAlertFrom(viewController: UIViewController, withTitle title: String, message: String, completion: (() -> Void)? = nil) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { _ in
            completion?()
        })
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default))

        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }

    static func presentDestructiveYesNoAlertFrom(viewController: UIViewController, withTitle title: String, message: String, completion: (() -> Void)? = nil) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { _ in
            completion?()
        })
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel))

        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }

    static func presentOKJumpToSchedulesAlert(viewController: UIViewController, withTitle title: String, message: String, completion: (() -> Void)? = nil) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Go to Schedules", style: UIAlertActionStyle.default) { _ in
            let action = NavigateToSchedulesFromNextToArriveScheduleRequest(scheduleRequest: store.state.currentTargetForScheduleActionsScheduleRequest())
            store.dispatch(action)
        })

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
            completion?()
        })

        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }

    static func presentComingSoonAlertFrom(_ viewController: UIViewController) {
        presentOKAlertFrom(viewController: viewController, withTitle: "SEPTA iOS", message: "This cool feature is coming soon!")
    }

    static func presentHolidayAlertFrom(viewController: UIViewController, holidaySchedule: HolidaySchedule) {
        guard let message = holidaySchedule.holidayMessage(),
            let onlineSchedules = holidaySchedule.onlineHolidaySchedules(),
            let onlineScheduleController = Bundle.main.loadNibNamed("HolidaySchedule", owner: nil, options: nil)?.first as? HolidayScheduleViewController else { return }

        let alert = UIAlertController(title: "Holiday Schedule", message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Switch to Next To Arrive", style: UIAlertActionStyle.default) { _ in
            let action = SwitchTabs(activeNavigationController: .nextToArrive, description: "Holiday Schedules")
            store.dispatch(action)
        }
        )
        for onlineSchedule in onlineSchedules {
            alert.addAction(UIAlertAction(title: onlineSchedule.label, style: UIAlertActionStyle.default) { _ in
                let request = URLRequest(url: onlineSchedule.url)
                onlineScheduleController.uiWebView.loadRequest(request)
                viewController.present(onlineScheduleController, animated: true, completion: nil)
            })
        }

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in }
        )

        viewController.present(alert, animated: true, completion: nil)
    }

    static func resetModalAlertsDisplayedFlag(flagMode: Bool) {
        let action = ResetModalAlertsDisplayed(modalAlertsDisplayed: flagMode)
        store.dispatch(action)
    }

    static func resetGenericAlertWasShownFlag(flagMode: Bool) {
        let action = ResetGenericAlertWasShown(genericAlertWasShown: flagMode)
        store.dispatch(action)
    }

    static func resetAppAlertWasShownFlag(flagMode: Bool) {
        let action = ResetAppAlertWasShown(appAlertWasShown: flagMode)
        store.dispatch(action)
    }

    static func presentAppOrGenericAlertFrom(viewController: UIViewController, withTitle title: String, attributedString: NSAttributedString, isGeneric: Bool, isApp: Bool, completion: (() -> Void)? = nil) {
        // create the alert
        let alert = UIAlertController(title: title, message: attributedString.string, preferredStyle: UIAlertControllerStyle.alert)

        // add an action buttons
        alert.addAction(UIAlertAction(title: "More Details", style: UIAlertActionStyle.default) { _ in
            let action = SwitchTabs(activeNavigationController: .alerts, description: "Jumping to Alerts Screen Generic Alert")
            store.dispatch(action)
            UIAlert.resetGenericAlertWasShownFlag(flagMode: true)
            UIAlert.resetAppAlertWasShownFlag(flagMode: true)
            UIAlert.resetModalAlertsDisplayedFlag(flagMode: false)
        })
        alert.addAction(UIAlertAction(title: "Don’t Show Me This Alert Again", style: UIAlertActionStyle.default) { _ in
            completion?()
            if isGeneric {
                let lastGenericUpdated = (store.state.alertState.genericAlertDetails.first)?.last_updated ?? ""
                let action = DoNotShowGenericAlertAgain(lastSavedDoNotShowGenericAlertAgainState: lastGenericUpdated, doNotShowGenericAlertAgain: true)
                store.dispatch(action)
            }
            if isApp {
                let lastAppUpdated = (store.state.alertState.appAlertDetails.first)?.last_updated ?? ""
                let action = DoNotShowAppAlertAgain(lastSavedDoNotShowAppAlertAgainState: lastAppUpdated, doNotShowAppAlertAgain: true)
                store.dispatch(action)
            }
            UIAlert.resetModalAlertsDisplayedFlag(flagMode: false)
        })
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
            completion?()
            UIAlert.resetGenericAlertWasShownFlag(flagMode: true)
            UIAlert.resetAppAlertWasShownFlag(flagMode: true)
            UIAlert.resetModalAlertsDisplayedFlag(flagMode: false)
        })

        // show the alert
        //viewController.present(alert, animated: true, completion: nil)
        alert.show()
    }

    static func presentNavigationToSettingsNeededAlertFrom(viewController: UIViewController?, completion: (() -> Void)? = nil) {
        // create the alert
        guard let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController else { return }
        let alert = UIAlertController(title: "Action Required", message: "In order to receive notifications, you must enable that feature for SEPTA in the Settings App", preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "Go To Settings", style: UIAlertActionStyle.default) { _ in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
            completion?()
        })
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
            completion?()
        })

        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }

    static func presentEnableAllRoutes(viewController: UIViewController?, pushNotificationRoute _: PushNotificationRoute) {
        // create the alert
        guard let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController else { return }
        let alert = UIAlertController(title: "SEPTA", message: "Push Notifications are not enabled for the app.  Do you want to re-enabled all your routes?", preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "Enable All Routes", style: UIAlertActionStyle.default) { _ in
            store.dispatch(UserWantsToSubscribeToPushNotifications(viewController: viewController, boolValue: true))
        })
        alert.addAction(UIAlertAction(title: "Just This Route", style: UIAlertActionStyle.default) { _ in
            store.dispatch(UserWantsToSubscribeToPushNotifications(viewController: viewController, boolValue: true, alsoEnableRoutes: false))
        })
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
