// Septa. 2017

import Foundation
import UIKit

enum ViewController: String, Equatable {
    /// Initial screen in schedules.  Holds the toolbar. Root view controller
    case selectSchedules
    case routesViewController
    case selectStartController
    case selectStopController
    case selectStopNavigationController
    case tripScheduleController

    // -- next to arrive

    case nextToArriveController
    case nextToArriveDetailController

    // Favorites

    case favoritesViewController
    case noFavoritesViewController
    case editFavoriteViewController

    // Alerts
    case alertsViewController
    case alertDetailViewController

    // more
    case moreNavigationController
    case moreViewController
    case webViewController
    case faresViewController
    case perksViewController
    case contactViewController
    case aboutViewController

    // push
    case managePushNotficationsController
    case customPushNotificationsController
    case timeOfDayPickerController

    // trip detials
    case tripDetailViewController
    case jsonDetailViewController

    // push notification trip detials
    case pushNotificationTripDetailViewController
    case pushNotificationTripDetailNavigationController

    // TransitView
    case transitViewSelectionViewController
    case transitViewSelectRouteViewController
    case transitViewMap

    func storyboardIdentifier() -> String {
        switch self {
        case .selectSchedules:
            return "schedules"
        case .routesViewController:
            return "schedules"
        case .selectStartController:
            return "schedules"
        case .selectStopController:
            return "schedules"
        case .selectStopNavigationController:
            return "schedules"
        case .tripScheduleController:
            return "schedules"
        case .nextToArriveController:
            return "nextToArrive"
        case .nextToArriveDetailController:
            return "nextToArriveDetail"
        case .favoritesViewController:
            return "favorites"
        case .noFavoritesViewController:
            return "favorites"
        case .editFavoriteViewController:
            return "favorites"
        case .alertsViewController:
            return "alerts"
        case .alertDetailViewController:
            return "alerts"
        case .faresViewController:
            return "fares"
        case .moreNavigationController:
            return "more"
        case .moreViewController:
            return "more"
        case .webViewController:
            return "webView"
        case .contactViewController:
            return "contact"
        case .aboutViewController:
            return "about"
        case .tripDetailViewController:
            return "tripDetail"
        case .transitViewSelectionViewController:
            return "TransitView"
        case .transitViewSelectRouteViewController:
            return "TransitView"
        case .transitViewMap:
            return "TransitView"
        case .managePushNotficationsController:
            return "PushNotifications"
        case .customPushNotificationsController:
            return "PushNotifications"
        case .timeOfDayPickerController:
            return "PushNotifications"
        case .perksViewController:
            return "perks"
        case .pushNotificationTripDetailViewController:
            return "pushNotificationTripDetail"
        case .pushNotificationTripDetailNavigationController, .jsonDetailViewController:
            return "pushNotificationTripDetail"
        }
    }

    func storyboard() -> UIStoryboard? {
        return UIStoryboard(name: storyboardIdentifier(), bundle: nil)
    }

    func instantiateViewController<T>() -> T? where T: UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier(), bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: rawValue) as? T {
            let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            viewController.navigationItem.backBarButtonItem = item
            return viewController
        } else {
            return nil
        }
    }

    func instantiateViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier(), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: rawValue)
    }

    func presentationController(presentedViewController: UIViewController, presenting: UIViewController?) -> UIPresentationController? {
        switch self {
        case .editFavoriteViewController:
            return HalfSizePresentationController(presentedViewController: presentedViewController, presenting: presenting)
        case .moreNavigationController, .routesViewController, .selectStartController, .selectStopController, .selectStopNavigationController:
            return SevenEightsPresentationController(presentedViewController: presentedViewController, presenting: presenting)
        case .timeOfDayPickerController:
            return DatePickerPresentationController(presentedViewController: presentedViewController, presenting: presenting)
        default: return nil
        }
    }

    func transitioningDelegate() -> UIViewControllerTransitioningDelegate? {
        switch self {
        case .editFavoriteViewController:
            return HalfSheetTransitioningDelegate(viewController: self)
        case .moreNavigationController, .routesViewController, .selectStartController, .selectStopController, .selectStopNavigationController,
             .transitViewSelectRouteViewController:
            return SevenEightsTransitioningDelegate(viewController: self)
        case .timeOfDayPickerController:
            return DatePickerTransitioningDelegate(viewController: self)
        default: return nil
        }
    }

    func animationInController() -> UIViewControllerAnimatedTransitioning? {
        switch self {
        case .editFavoriteViewController:
            return HalfSheetAnimationIn()
        case .timeOfDayPickerController:
            return DatePickerAnimationIn()
        default: return nil
        }
    }

    func animationOutController() -> UIViewControllerAnimatedTransitioning? {
        switch self {
        case .editFavoriteViewController:
            return HalfSheetAnimationOut()
        case .timeOfDayPickerController:
            return DatePickerAnimationOut()
        default: return nil
        }
    }
}
