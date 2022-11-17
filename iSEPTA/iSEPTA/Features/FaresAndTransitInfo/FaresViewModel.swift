//
//  FaresViewModel.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/28/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit

class FaresViewModel {
    var items: [FaresPaymentModeViewModel]!

    init() {
        buildItems()
    }

    func buildItems() {
        items = [
            buildSeptaKeyPaymentMode(),
            buildCashPaymentMode(),
            buildTransPassPaymentMode(),
            buildTrailPassPaymentMode(),
            buildCrossCountyPaymentMode(),
            buildOneDayConveniencePassPaymentMode(),
            buildOneDayIndependencePassPaymentMode(),
        ]
    }

    func buildSeptaKeyPaymentMode() -> FaresPaymentModeViewModel {
        let attributedString = NSMutableAttributedString(string: "The Key Card is a contactless chip card and can be loaded and reloaded. \nLearn More about SEPTA Key »")
        attributedString.addAttributes([
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold),
            NSAttributedStringKey.foregroundColor: UIColor(red: 20.0 / 255.0, green: 75.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0),
        ], range: NSRange(location: 73, length: 28))

        return FaresPaymentModeViewModel(
            imageName: "septaKeyIcon",
            title: "SEPTA Key",
            description: attributedString,
            septaConnection: .septaKey
        )
    }

    func buildCashPaymentMode() -> FaresPaymentModeViewModel {
        let attributedString = NSMutableAttributedString(string: "Cash: $2.50\nSEPTA Key Card Quick Trip: $2.50\n")
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 6, length: 5))
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 39, length: 5))

        return FaresPaymentModeViewModel(
            imageName: "cashIcon",
            title: "Cash",
            description: attributedString,

            septaConnection: nil)
    }

    func buildTransPassPaymentMode() -> FaresPaymentModeViewModel {
        let attributedString = NSMutableAttributedString(string: "Weekly: $25.50\nMonthly: $96.50\nLoad Pass on SEPTA Key Card")
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 8, length: 6))
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 24, length: 6))

        return FaresPaymentModeViewModel(
            imageName: "weeklyIcon",
            title: "TransPass",
            description: attributedString,

            septaConnection: nil)
    }

    func buildTrailPassPaymentMode() -> FaresPaymentModeViewModel {
        let attributedString = NSMutableAttributedString(string: "Weekly and Monthly TrailPasses\nPrice varies by Zone.")
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 31, length: 12))

        return FaresPaymentModeViewModel(
            imageName: "trailPassIcon",
            title: "TrailPass",
            description: attributedString,
            septaConnection: nil)
    }

    func buildCrossCountyPaymentMode() -> FaresPaymentModeViewModel {
        let attributedString = NSMutableAttributedString(string: "Weekly Cross County Pass: $30.75\nMonthly Cross County Pass: $115.00")
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 26, length: 6))
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 60, length: 7))

        return FaresPaymentModeViewModel(
            imageName: "crossCountyIcon",
            title: "Cross County Pass",
            description: attributedString,
            septaConnection: nil)
    }

    func buildOneDayConveniencePassPaymentMode() -> FaresPaymentModeViewModel {
        let attributedString = NSMutableAttributedString(string: "Pass: $8.00 - good for 8 rides on any Transit route (not valid on Regional Rail)")
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 6, length: 5))
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 23, length: 7))

        return FaresPaymentModeViewModel(
            imageName: "oneDayIcon",
            title: "One Day Convenience Pass",
            description: attributedString,
            septaConnection: nil)
    }

    func buildOneDayIndependencePassPaymentMode() -> FaresPaymentModeViewModel {
        let attributedString = NSMutableAttributedString(string: "One Day Individual: $13.00\nOne Day Family: $30.00")
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 20, length: 6))
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold), range: NSRange(location: 43, length: 6))

        return FaresPaymentModeViewModel(
            imageName: "independenceIcon",
            title: "One Day Independence Pass",
            description: attributedString,
            septaConnection: nil)
    }
}
