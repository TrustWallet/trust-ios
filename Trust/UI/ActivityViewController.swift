// Copyright SIX DAY LLC. All rights reserved.

import UIKit

class ActivityViewController: UIActivityViewController {
    func setCompletion(navigation: UINavigationController) {
        self.completionWithItemsHandler = { _, _, _, _ in
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
    }
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().barTintColor = nil // This fixes the issue with notes
        UINavigationBar.appearance().titleTextAttributes = nil // This makes the text black for messages and mail
    }

}
