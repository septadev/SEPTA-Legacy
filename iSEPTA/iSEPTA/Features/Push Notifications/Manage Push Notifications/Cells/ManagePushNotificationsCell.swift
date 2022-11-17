//
//  ManagePushNotificationsCell.swift
//  iSEPTA
//
//  Created by Mark Broski on 7/27/18.
//  Copyright © 2018 Mark Broski. All rights reserved.
//

import Foundation
import UIKit

protocol ManagePushNotificationsCell where Self: UITableViewCell {
    var rowIdentifier: ManagePushNotificationsViewModel.RowIdentifier { get }
}
