//
//  DatabaseUpdateWatcher.swift
//  iSEPTA
//
//  Created by Mike Mannix on 6/12/18.
//  Copyright © 2018 Mark Broski. All rights reserved.
//

import ReSwift
import SeptaSchedule

protocol DatabaseUpdateWatcherDelegate: AnyObject {
    func databaseUpdateAvailable()
}

class DatabaseUpdateWatcher: BaseWatcher {
    weak var delegate: DatabaseUpdateWatcherDelegate?

    init(delegate: DatabaseUpdateWatcherDelegate) {
        super.init()
        self.delegate = delegate
        subscribe()
    }

    func subscribe() {
        store.subscribe(self) {
            $0.select {
                $0.databaseUpdateState
            }.skipRepeats {
                $0 == $1
            }
        }
    }
}

extension DatabaseUpdateWatcher: StoreSubscriber {
    typealias StoreSubscriberStateType = DatabaseUpdateState

    func newState(state: DatabaseUpdateState) {
        switch state.status {
        case .updateAvailable:
            delegate?.databaseUpdateAvailable()
        case .updateDownloaded:
            store.dispatch(RefreshAvailableRoutes(description: "Refresh available TransitView routes due to database update"))
        default:
            return
        }
    }
}
