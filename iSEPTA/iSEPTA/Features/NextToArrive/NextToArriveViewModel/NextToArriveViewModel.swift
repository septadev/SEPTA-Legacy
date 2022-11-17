//
//  NextToArriveViewModel.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/5/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import ReSwift
import SeptaSchedule
import UIKit

typealias CellModel = NextToArriveRowDisplayModel

class NextToArriveViewModel: NSObject, StoreSubscriber, LastCellDelegate {
    typealias StoreSubscriberStateType = ScheduleRequest

    @IBOutlet var view: UIView!
    @IBOutlet var nextToArriveViewController: UpdateableFromViewModel?
    @IBOutlet var schedulesDelegate: SchedulesViewModelDelegate?
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    var scheduleRequest: ScheduleRequest?

    var transitMode: TransitMode!

    func lastCellBottomSet(bottom: CGFloat) {
        let bottomWithBorder = bottom + 15
        if bottomWithBorder != tableViewHeightConstraint.constant {
            tableViewHeightConstraint.constant = bottomWithBorder
        }
        view.setNeedsLayout()
    }

    var targetForScheduleAction: TargetForScheduleAction! { return store.state.currentTargetForScheduleActions() }

    fileprivate var selectRouteRowDisplayModel: NextToArriveRowDisplayModel?
    fileprivate var selectStartRowDisplayModel: NextToArriveRowDisplayModel?
    fileprivate var selectEndRowDisplayModel: NextToArriveRowDisplayModel?
    fileprivate var displayModel = [NextToArriveRowDisplayModel]()

    func newState(state: StoreSubscriberStateType) {
        scheduleRequest = state

        transitMode = state.transitMode
        buildDisplayModel()
        nextToArriveViewController?.viewModelUpdated()
        schedulesDelegate?.formIsComplete(scheduleRequest?.selectedEnd != nil)
    }

    func buildDisplayModel() {
        displayModel = [
            configureSelectRouteDisplayModel(),
            configureSelectStartDisplayModel(),
            configureSelectEndDisplayModel(),
        ]
    }

    func transitModeTitle() -> String? {
        return transitMode.routeTitle()
    }

    func scheduleTitle() -> String {
        return transitMode.nextToArriveTitle()
    }

    deinit {
        unsubscribe()
    }
}

// MARK: -  Loading table view cells

extension NextToArriveViewModel {
    func shouldDisplayBlankSectionHeaderForSection(_ section: Int) -> Bool {
        if section == 0 && transitMode != .rail {
            return false
        } else {
            return true
        }
    }

    func heightForSectionHeader(atRow row: Int) -> CGFloat {
        switch row {
        case 0:
            return transitMode == .rail ? 0 : 37
        case 1: return 15
        case 2: return 11
        case 3: return 21
        default: return 0
        }
    }

    func numberOfRows() -> Int {
        return 4
    }

    func cellIdForRow(_ row: Int) -> String {
        guard let transitMode = scheduleRequest?.transitMode else { return "" }
        if transitMode == .rail && row == 0 {
            return "noRouteNeeded"
        } else {
            if row == 0 && scheduleRequest?.selectedRoute != nil {
                return "routeSelectedCell"
            } else {
                return "singleStringCell"
            }
        }
    }

    func configureCell(_ cell: UITableViewCell, atRow row: Int) {
        guard row < displayModel.count else { return }
        let rowModel = displayModel[row]
        if let cell = cell as? SingleStringCell {
            cell.label!.font = changeFontWeight(font: cell.label!.font, weight: rowModel.fontWeight)
            cell.setLabelText(rowModel.text)
            cell.setEnabled(rowModel.isSelectable)
            cell.setShouldFill(rowModel.shouldFillCell)
            cell.searchIcon.isHidden = !rowModel.showSearchIcon
            let image = UIImage(named: rowModel.searchIconName)
            cell.searchIcon.image = image
            cell.searchIcon.isHidden = false

        } else if let cell = cell as? RouteSelectedTableViewCell, let selectedRoute = scheduleRequest?.selectedRoute {
            cell.routeIdLabel.text = "\(selectedRoute.routeId):"
            cell.routeShortNameLabel.text = rowModel.text
            cell.pillView.backgroundColor = rowModel.pillColor
        }

        cell.accessibilityTraits = UIAccessibilityTraitSearchField
        if !rowModel.isSelectable {
            cell.accessibilityTraits |= UIAccessibilityTraitNotEnabled
        }
    }

    func changeFontWeight(font currentFont: UIFont, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: currentFont.pointSize, weight: weight)
    }

    func canCellBeSelected(atRow row: Int) -> Bool {
        guard row < displayModel.count else { return false }
        return displayModel[row].isSelectable
    }

    func rowSelected(_ row: Int) {
        guard row < displayModel.count,
            let viewController = displayModel[row].targetController else { return }
        let action = PresentModal(
            viewController: viewController,
            description: "User Wishes to pick a route")

        store.dispatch(action)

        if let stopToEdit = StopToSelect(rawValue: row) {
            let editStopAction = CurrentStopToEdit(targetForScheduleAction: targetForScheduleAction, stopToEdit: stopToEdit)
            store.dispatch(editStopAction)
        }
    }
}

extension NextToArriveViewModel: SubscriberUnsubscriber {
    override func awakeFromNib() {
        super.awakeFromNib()
        subscribe()
    }

    func subscribe() {
        store.subscribe(self) {
            $0.select {
                $0.nextToArriveState.scheduleState.scheduleRequest
            }.skipRepeats { $0 == $1 }
        }
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
