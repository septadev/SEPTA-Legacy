// Septa. 2017

import UIKit

protocol RouteCellDisplayable {
    func setShortName(text: String)
    func setLongName(text: String)
    func setIcon(image: UIImage)
    func addAlert(_ alert: SeptaAlert?)
}

class RouteTableViewCell: UITableViewCell, RouteCellDisplayable {
    @IBOutlet private var routeShortNameLabel: UILabel!
    @IBOutlet private var routeLongNameLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!

    var alertsAreInteractive: Bool = true

    var targetForScheduleAction: TargetForScheduleAction! { return store.state.currentTargetForScheduleActions() }

    @IBOutlet var stackView: UIStackView! {
        didSet {
            stackView.isExclusiveTouch = true
        }
    }

    var enabled: Bool = true {
        didSet {
            routeShortNameLabel.textColor = enabled ? .black : SeptaColor.disabledText
            routeLongNameLabel.textColor = enabled ? .darkGray : SeptaColor.disabledText
        }
    }

    func setShortName(text: String) {
        routeShortNameLabel.text = text
    }

    func setLongName(text: String) {
        routeLongNameLabel.text = text
    }

    func setIcon(image: UIImage) {
        iconImageView.image = image
    }

    func addAlert(_ alert: SeptaAlert?) {
        stackView.addAlert(alert)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let gr = UITapGestureRecognizer(target: self, action: #selector(gestureReognizerTapped(gr:)))
        stackView.addGestureRecognizer(gr)
    }

    @objc func gestureReognizerTapped(gr: UITapGestureRecognizer) {
        if alertsAreInteractive {
            gr.cancelsTouchesInView = true
            let dismissModalAction = DismissModal(description: "Dismissing the modal to switch tabs")
            store.dispatch(dismissModalAction)
            let switchTabsAction = SwitchTabs(activeNavigationController: .alerts, description: "User tapped on alert")
            store.dispatch(switchTabsAction)
        }
    }
}
