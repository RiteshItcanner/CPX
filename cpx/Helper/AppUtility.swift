//
//  AppUtility.swift
//  cpx
//
//  Created by Ritesh Sinha on 20/09/24.
//

import AppTrackingTransparency
import Foundation
import SafariServices
import SVProgressHUD
import Toast_Swift
import UIKit

class AppUtility: NSObject {
    class func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    class func getUniqueImageName() -> String! {
        let dateString = stringFromCustomDate(fromDate: Date(), withFormat: "yyyyMMdd")
        let timeString = stringFromCustomDate(fromDate: Date(), withFormat: "HHmmss.SSSS")
        let string = "iPhone_\(dateString)_\(timeString.replacingOccurrences(of: ".", with: ""))"
        return string
    }

    class func stringFromCustomDate(fromDate date: Date, withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }

    class func isValidEmail(str: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }

    class func isValidPassword(str: String) -> Bool {
        let passwordRegEx = "^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: str)
    }

    class func isAnySpecialCharIsExist(str: String) -> Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format: "SELF MATCHES %@", regex)
        return testString.evaluate(with: str)
    }

    class func isOnlyCharIsExist(str: String, _ isAllowedWhiteSpace: Bool? = false) -> Bool {
        let regex = "^[a-zA-Z ]+$".replacingOccurrences(of: isAllowedWhiteSpace! ? "" : " ", with: "")
        let charString = NSPredicate(format: "SELF MATCHES %@", regex)
        return charString.evaluate(with: str)
    }

    class func isOnlyNumberIsExist(str: String) -> Bool {
        let regex = "^[0-9]+$"
        let charString = NSPredicate(format: "SELF MATCHES %@", regex)
        return charString.evaluate(with: str)
    }

    class func kfCacheURLGenerator(_ value: String) -> URL {
        let host = "https://"
        let domain = "test.com/"
        return URL(string: host + domain + value)!
    }

    class func showToast(withMessage message: String) {
        if let view = getTopViewController()?.view {
            ToastManager.shared.position = .bottom
            ToastManager.shared.style.backgroundColor = .gray
            ToastManager.shared.style.messageColor = UIColor.white
            ToastManager.shared.style.cornerRadius = 5.0
            ToastManager.shared.style.shadowOpacity = 1.0
            ToastManager.shared.style.shadowColor = UIColor.systemBlue
            view.makeToast(message)
        }
    }

    class func showProgressHUD() {
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.setForegroundColor(UIColor(named: "theme_blue") ?? .systemBlue)
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }

    class func getTopViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        return topViewController(for: rootViewController)
    }

    class func topViewController(for viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return topViewController(for: presentedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController {
            return topViewController(for: navigationController.visibleViewController ?? navigationController)
        }
        
        if let tabBarController = viewController as? UITabBarController {
            return topViewController(for: tabBarController.selectedViewController ?? tabBarController)
        }
        
        return viewController
    }

//    class func changeRTL() {
//        if !AppUtility.isRTL {
//            AppUtility.selectedLanguage = Language.arabic.rawValue
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
////            UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
//            ApplicationRoot.shared.showSplashScreen()
//        }
//    }
//
//    class func changeLTR() {
//        if AppUtility.isRTL {
//            AppUtility.selectedLanguage = Language.english.rawValue
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
////            UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
//            ApplicationRoot.shared.showSplashScreen()
//        }
//    }

//    class func openSafriVC(vc: BaseViewController,
//                           urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        let safariVC = SFSafariViewController(url: url)
//        safariVC.delegate = vc
//        PreConfigConstant.findPresentedViewController(vc).present(safariVC, animated: true)
//    }

    static var languageWhenLoggedOut: String {
        get {
            guard let language = UserDefaults.standard.value(forKey: "lan_logout") as? String else { return Language.english.rawValue }
            return language
        }
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: "lan_logout")
            UserDefaults.standard.synchronize()
        }
    }

    static var selectedLanguage: String {
        get {
            guard let language = UserDefaults.standard.value(forKey: "lan") as? String else { return Language.english.rawValue }
            return language
        }
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: "lan")
            UserDefaults.standard.synchronize()
            LanguageManager.shared.setAppLanguage(newValue)
        }
    }

    static var isRTL: Bool {
        guard Language(rawValue: selectedLanguage) == Language.arabic else { return false }
        return true
    }

    static var isRemovedPreviousVersionLocalNotifications: Bool {
        get {
            guard let notification = UserDefaults.standard.value(forKey: "isRemovedPreviousVersionLocalNotifications") as? Bool else { return false }
            return notification
        }
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: "isRemovedPreviousVersionLocalNotifications")
            UserDefaults.standard.synchronize()
        }
    }

}
