import UIKit

extension UIApplication {
    class func rootViewController(vc: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = vc as? UINavigationController {
            return rootViewController(vc: navigationController.visibleViewController)
        }
        if let tabController = vc as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return rootViewController(vc: selected)
            }
        }
        if let presented = vc?.presentedViewController {
            return rootViewController(vc: presented)
        }
        return vc
    }
}
