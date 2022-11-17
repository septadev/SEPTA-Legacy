// Septa. 2017

import ReSwift
import SeptaSchedule
import UIKit

class SelectRouteViewController: UIViewController, IdentifiableController {
    @IBOutlet var viewModel: RoutesViewModel!
    @IBOutlet var searchTextBox: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    let routeCellId = "routeCell"
    let viewController: ViewController = .routesViewController

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "embedHeader" {
            if let headerViewController = segue.destination as? SearchRoutesModalHeaderViewController {
                headerViewController.delegate = self
                headerViewController.textFieldDelegate = viewModel
            }
        }
    }
}

extension SelectRouteViewController: UpdateableFromViewModel {
    func viewModelUpdated() {
        guard let tableView = tableView else { return }
        tableView.reloadData()
    }

    func displayErrorMessage(message: String, shouldDismissAfterDisplay: Bool = false) {
        UIAlert.presentOKAlertFrom(viewController: self, withTitle: "Select Routes", message: message)
        if shouldDismissAfterDisplay {
            store.dispatch(DismissModal(description: "Dismissing after error"))
        }
    }
}

extension SelectRouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: routeCellId, for: indexPath) as? RouteTableViewCell else { return UITableViewCell() }

        viewModel.configureDisplayable(cell, atRow: indexPath.row)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.rowSelected(row: indexPath.row)
    }
}

extension SelectRouteViewController: SearchModalHeaderDelegate {
    func animatedLayoutNeeded(block _: @escaping (() -> Void), completion _: @escaping (() -> Void)) {
    }

    func layoutNeeded() {
    }

    func dismissModal() {
        let dismissAction = DismissModal(description: "Route should be dismissed")
        store.dispatch(dismissAction)
    }

    func updateActivityIndicator(animating _: Bool) {
    }

    func sortAlphaTapped(direction _: SortOrder) {}

    func sortByStopOrderTapped() {}
}
