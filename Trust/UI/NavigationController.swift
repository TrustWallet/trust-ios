// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import UIKit

class NavigationController: UINavigationController {
    private var viewControllersToChildCoordinators: [UIViewController: Coordinator] = [:]

    @discardableResult
    static func openFormSheet(
        for controller: UIViewController,
        in navigationController: NavigationController,
        barItem: UIBarButtonItem
        ) -> UIViewController {
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.navigationItem.leftBarButtonItem = barItem
            let nav = NavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .formSheet
            navigationController.present(nav, animated: true, completion: nil)
        } else {
            navigationController.pushViewController(controller, animated: true)
        }
        return controller
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        var preferredStyle: UIStatusBarStyle
        if
            topViewController is MasterBrowserViewController ||
            topViewController is DarkPassphraseViewController ||
            topViewController is DarkVerifyPassphraseViewController
        {
            preferredStyle = .default
        } else {
            preferredStyle = .lightContent
        }
        return preferredStyle
    }
}

extension NavigationController: PushableCoordinator {
    func pushCoordinator(_ coordinator: RootCoordinator) {
        viewControllersToChildCoordinators[coordinator.rootViewController] = coordinator
        pushViewController(coordinator.rootViewController, animated: true)
    }
    func popCoordinator(_ coordinator: RootCoordinator) {
        viewControllersToChildCoordinators.removeValue(forKey: coordinator.rootViewController)
        popViewController(animated: true)
    }
}
