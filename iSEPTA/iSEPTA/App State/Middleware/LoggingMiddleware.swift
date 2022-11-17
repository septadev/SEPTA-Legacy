//
//  LoggingMiddleware.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/18/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Crashlytics
import Foundation
import ReSwift

let loggingMiddleware: Middleware<AppState> = { _, _ in { next in
    return { action in
        if let action = action as? SeptaAction {
            if let action = action as? NavigationAction {
                Answers.logCustomEvent(withName: action.description, customAttributes: nil)
            }
            if let action = action as? UserPreferencesAction {
                Answers.logCustomEvent(withName: action.description, customAttributes: nil)
            }
            CLSLogv(action.description, getVaList([]))
        }

        return next(action)
    }
}
}
