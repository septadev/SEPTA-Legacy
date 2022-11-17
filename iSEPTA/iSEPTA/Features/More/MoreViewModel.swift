//
//  MoreViewModel.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/28/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit

class MoreViewModel {
    func numberOfRows() -> Int {
        return 8
    }

    func configureCell(cell: MoreTableViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0: configureFaresCell(cell: cell)
        case 1: configureSubwayMapCell(cell: cell)
        case 2: configureTransitViewCell(cell: cell)
        case 3: configureTrainViewCell(cell: cell)
        case 4: configurePushNotificationsCell(cell: cell)
        case 5: configurePerksCell(cell: cell)
        case 6: configureElertsCell(cell: cell)
        case 7: configureConnectCell(cell: cell)
        case 8: configureAboutCell(cell: cell)
        default: break
        }
    }

    func configureFaresCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "Fares"
        cell.moreImageView.image = UIImage(named: "faresCell")
    }

    func configureSubwayMapCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "System Map"
        cell.moreImageView.image = UIImage(named: "subwayMapCell")
    }

    func configureTransitViewCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "TransitView"
        cell.moreImageView.image = UIImage(named: "transitviewIcon")
    }

    func configureTrainViewCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "TrainView"
        cell.moreImageView.image = UIImage(named: "trainView")
    }

    func configurePushNotificationsCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "Push Notifications"
        cell.moreImageView.image = UIImage(named: "pushNotificationIcon")
    }

    func configurePerksCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "Perks"
        cell.moreImageView.image = UIImage(named: "perksIcon")
    }

    func configureElertsCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "Report Crime or Nuisance"
        cell.moreImageView.image = UIImage(named: "elerts")
    }

    func configureConnectCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "Connect with SEPTA"
        cell.moreImageView.image = UIImage(named: "connectCell")
    }

    func configureAboutCell(cell: MoreTableViewCell) {
        cell.moreLabel.text = "About the SEPTA App"
        cell.moreImageView.image = UIImage(named: "AboutTheApp")
    }
}
