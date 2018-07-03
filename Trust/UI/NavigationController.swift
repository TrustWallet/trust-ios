// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import UIKit

class NavigationController: UIViewController {

    // MARK: - Inputs

    private let rootViewController: UIViewController
    public var viewControllers: [UIViewController] = [] {
        didSet {
            childNavigationController.viewControllers = viewControllers
        }
    }

    var isToolbarHidden: Bool = true

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        childNavigationController.viewControllers = viewControllers
    }

    // MARK: - Mutable state

    private var viewControllersToChildCoordinators: [UIViewController: Coordinator] = [:]

    // MARK: - Lazy views

    private lazy var childNavigationController: UINavigationController =
        UINavigationController(rootViewController: self.rootViewController)

    // MARK: - Initialization

    init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        self.rootViewController = UIViewController()
        super.init(nibName: nil, bundle: nil)
    }

    init(_ rootViewController: UIViewController = UIViewController()) {
        self.rootViewController = rootViewController

        super.init(nibName: nil, bundle: nil)
    }

    init(rootViewController: UIViewController = UIViewController()) {
        self.rootViewController = rootViewController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        childNavigationController.delegate = self
        childNavigationController.interactivePopGestureRecognizer?.delegate = self

        addChildViewController(childNavigationController)
        view.addSubview(childNavigationController.view)
        childNavigationController.didMove(toParentViewController: self)

        childNavigationController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            childNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childNavigationController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            childNavigationController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            childNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    // MARK: - Public

    func pushCoordinator(_ coordinator: RootCoordinator, animated: Bool) {
        viewControllersToChildCoordinators[coordinator.rootViewController] = coordinator

        pushViewController(coordinator.rootViewController, animated: animated)
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        childNavigationController.pushViewController(viewController, animated: animated)
    }

    func pushViewController(viewController: UIViewController, animated: Bool) {
        childNavigationController.pushViewController(viewController, animated: animated)
    }

    func setNavigationBarHidden(_ asdfas: Bool, animated: Bool) {}
    func setToolbarHidden(_ asdfas: Bool, animated: Bool) {}

    // MARK: - UIGestureRecognizerDelegate

    @discardableResult
    static func openFormSheet(
        for controller: UIViewController,
        in navigationController: NavigationController,
        barItem: UIBarButtonItem
        ) -> UIViewController {
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.navigationItem.leftBarButtonItem = barItem
            let nav = NavigationController(controller)
            nav.modalPresentationStyle = .formSheet
            navigationController.present(nav, animated: true, completion: nil)
        } else {
            navigationController.pushViewController(viewController: controller, animated: true)
        }
        return controller
    }

//    open override var preferredStatusBarStyle: UIStatusBarStyle {
//        var preferredStyle: UIStatusBarStyle
//        if
//            topViewController is MasterBrowserViewController ||
//                topViewController is DarkPassphraseViewController ||
//                topViewController is DarkVerifyPassphraseViewController
//        {
//            preferredStyle = .default
//        } else {
//            preferredStyle = .lightContent
//        }
//        return preferredStyle
//    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Necessary to get the child navigation controller’s interactive pop gesture recognizer to work.
        return true
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool) {
        cleanUpChildCoordinators()
    }

    // MARK: - Private

    private func cleanUpChildCoordinators() {
        for viewController in viewControllersToChildCoordinators.keys {
            if !childNavigationController.viewControllers.contains(viewController) {
                viewControllersToChildCoordinators.removeValue(forKey: viewController)
            }
        }
    }
}
