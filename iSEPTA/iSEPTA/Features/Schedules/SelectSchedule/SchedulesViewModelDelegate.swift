//
//  SchedulesViewModelDelegate.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/5/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation

@objc protocol SchedulesViewModelDelegate: AnyObject {
    func formIsComplete(_ complete: Bool)
}
