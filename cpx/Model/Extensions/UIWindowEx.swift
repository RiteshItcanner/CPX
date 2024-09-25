
import UIKit
// import CleanroomLogger

extension UIWindow {
    /** The application's `keyWindow`, or `nil` if there isn't one. */
    public static var key: UIWindow? {
//        return AppDelegate.shared.window
        return nil
    }

    /** The topmost window in the application's window stack, or `nil`
     if the application has no windows. */
    public static var topmost: UIWindow? {
        return UIApplication.shared.windows.last
    }

    /** The bottommost window in the application's window stack, or `nil`
     if the application has no windows. */
    public static var bottommost: UIWindow? {
        return UIApplication.shared.windows.first
    }

    /** The application's "main" window, which will either be the `key` window
     (if there is one), or the `topmost` window (if there isn't). `nil` is
     returned when the application has no windows. */
    public static var main: UIWindow? {
        return key ?? topmost
    }

    private func findPresentedViewController(_ vc: UIViewController)
        -> UIViewController {
        if let nc = vc as? UINavigationController {
            if let visible = nc.topViewController {
                return findPresentedViewController(visible)
            }
        } else if let tbc = vc as? UITabBarController {
            if let selected = tbc.selectedViewController {
                return findPresentedViewController(selected)
            }
        }

        if let presented = vc.presentedViewController,
           !presented.isBeingDismissed, presented.popoverPresentationController == nil {
            return findPresentedViewController(presented)
        }

        for child in vc.children {
            return findPresentedViewController(child)
        }

        return vc
    }

    /** Walks the view controller hierarchy top-down from the window's
     `rootViewController` to determine the optimal `UIViewController` to use
     as the source of view controller presentations. `nil` will be returned if
     the receiver has no `rootViewController`. */
    public var modalPresentationController: UIViewController? {
        guard let rootVC = rootViewController else {
//            Log.debug?.message("The window \(self) has no rootViewController")
            return nil
        }

        let mpc = findPresentedViewController(rootVC)
//        Log.verbose?.message("modalPresentationController: \(mpc)")
        return mpc
    }

    public var activeNavigationController: UINavigationController? {
        guard let pc = modalPresentationController else {
//            Log.verbose?.message("activeNavigationController: nil")
            return nil
        }

        if let nc = pc as? UINavigationController {
//            Log.verbose?.message("activeNavigationController: \(nc)")
            return nc
        }

        var vc: UIViewController? = pc
        var nc: UINavigationController?
        while nc == nil, vc != nil {
            nc = vc!.navigationController
            vc = vc!.parent
        }

        if nc == nil {
            vc = pc.presentingViewController
            while vc != nil, (vc as? UINavigationController) == nil {
                vc = vc?.presentingViewController
            }
            nc = vc as? UINavigationController
        }

//        Log.verbose?.message("activeNavigationController: \(String(describing: nc))")

        return nc
    }

    public func dismissAllViewControllers(animated: Bool, completion: (() -> Void)? = nil) {
        guard let rootVC = rootViewController else { return }

        guard let dismissFrom = rootVC.presentedViewController?.presentingViewController else { return }

        dismissFrom.dismiss(animated: animated, completion: completion)
    }

    public var rootNavigationController: UINavigationController? {
        guard let rvc = rootViewController else {
//            Log.debug?.message("The window \(self) has no rootViewController")
            return nil
        }

        let nc = rvc.navigationController

//        Log.verbose?.message("rootNavigationController: \(String(describing: nc))")

        return nc
    }

    public var rootTabBarController: UITabBarController? {
        guard let rvc = rootViewController else {
//            Log.debug?.message("The window \(self) has no rootViewController")
            return nil
        }
   
        let tabBar = rvc.tabBarController

//        Log.verbose?.message("rootTabBarController: \(String(describing: tabBar))")

        return tabBar
    }
}

extension UIApplication {
    class func isRTL() -> Bool{
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    @objc var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
//            return Language(rawValue: AppUtility.selectedLanguage) == .arabic ? .rightToLeft : .leftToRight
            return .leftToRight
        }
    }
}

extension UIWindow {
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        switch(vc){
            
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
        default:
            if let presentedViewController = vc.presentedViewController {
                //print(presentedViewController)
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                }
                else{
                    return vc
                }
            }
            else{
                return vc
            }
        }
    }
}
