//
//  TripDetailItemView.swift
//  iSEPTA
//
//  Created by Mark Broski on 10/12/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit

class TripDetailItemView: UIView {
    @IBOutlet var lightLabel: UILabel! {
        didSet {
            lightLabel.text = ""
        }
    }

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    var key: String!
}
