// Copyright SIX DAY LLC. All rights reserved.

import UIKit

class ActivityViewController: UIActivityViewController {

    let navigation: UINavigationController

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UINavigationBar.appearance().barTintColor = nil // This fixes the issue with notes
        UINavigationBar.appearance().titleTextAttributes = nil // This makes the text black for messages and mail
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Set the tint globally via appearance proxy
        UINavigationBar.appearance().barTintColor = AppStyle.activityViewControllerNavigationBarTintColor
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: AppStyle.activityViewControllerNavigationBarText,
        ]
        navigation.navigationBar.barTintColor = AppStyle.activityViewControllerNavigationBarTintColor
        navigation.navigationBar.titleTextAttributes = [
            .foregroundColor: AppStyle.activityViewControllerNavigationBarText,
        ] // Used to manually set the navBar tint/text back look at this for more info on why https://stackoverflow.com/a/21653004
    }

    init(activityItems: [Any], applicationActivities: [UIActivity]?, navigation: UINavigationController) {
        self.navigation = navigation
        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    static func makeShareController(url: Any, navigationController: UINavigationController) -> ActivityViewController {
        return ActivityViewController(activityItems: [url], applicationActivities: nil, navigation: navigationController)
    }
}
