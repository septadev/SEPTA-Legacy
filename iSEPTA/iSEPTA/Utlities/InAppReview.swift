//
//  InAppReview.swift
//  iSEPTA
//
//  Created by Mike Mannix on 6/25/18.
//  Copyright © 2018 Mark Broski. All rights reserved.
//

import StoreKit

struct InAppReview {

    // MARK: - Constants

    let launchCountKey = "launchCountKey"
    let reviewRequestedKey = "reviewRequestedKey"
    let forceAppReviewResetAppliedKey = "forceAppReviewResetAppliedKey"
    let infoPlistResetAppReviewKey = "resetAppReview"
    static let crashReportedKey = "crashReportedKey"
    let minimumLaunchCount = 20
    let maximumPostCrashCount = 15
    let defaults = UserDefaults.standard

    // MARK: - Public functions

    func appLaunched() {
        if crashWasReported() {
            adjustForCrash()
        } else if shouldForceResetAppReviewState() {
            resetReviewCount()
        } else {
            incrementLaunchCount()
        }
    }

    func promptIfAppropriate() {
        if appLaunchCount() >= minimumLaunchCount && !reviewPreviouslyRequested() {
            SKStoreReviewController.requestReview()
            defaults.set(true, forKey: reviewRequestedKey)
        }
    }

    // MARK: - Private functions

    private func incrementLaunchCount() {
        let currentCount = appLaunchCount()
        defaults.set(currentCount + 1, forKey: launchCountKey)
    }

    private func appLaunchCount() -> Int {
        return defaults.integer(forKey: launchCountKey)
    }

    private func reviewPreviouslyRequested() -> Bool {
        return defaults.bool(forKey: reviewRequestedKey)
    }

    private func resetReviewCount() {
        defaults.set(false, forKey: reviewRequestedKey)
        defaults.set(0, forKey: launchCountKey)
        defaults.set(true, forKey: forceAppReviewResetAppliedKey)
    }

    private func shouldForceResetAppReviewState() -> Bool {
        if let reset = Bundle.main.object(forInfoDictionaryKey: infoPlistResetAppReviewKey) as? Bool {
            let resetAlreadyApplied = defaults.bool(forKey: forceAppReviewResetAppliedKey)
            return reset && !resetAlreadyApplied
        }
        return false
    }

    private func crashWasReported() -> Bool {
        return defaults.bool(forKey: InAppReview.crashReportedKey)
    }

    private func adjustForCrash() {
        defaults.set(false, forKey: InAppReview.crashReportedKey)
        if appLaunchCount() > maximumPostCrashCount {
            defaults.set(maximumPostCrashCount, forKey: launchCountKey)
        }
    }
}
