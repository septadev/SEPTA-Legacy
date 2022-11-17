//
//  HalfSheetTransitioningDelegate.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/16/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit

class HalfSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let viewController: ViewController
    init(viewController: ViewController) {
        self.viewController = viewController
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        return viewController.presentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfSheetAnimationIn()
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfSheetAnimationOut()
    }
}
