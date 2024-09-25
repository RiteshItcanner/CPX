//
//  PushPermissionHelper.swift
//  BeeInvites
//
//  Created by PYTHON on 28/04/23.
//
import UIKit
import UserNotifications

class PushPermissionHelper {
    class func checkPushEnabled(handler: @escaping ((UNAuthorizationStatus) -> Void)) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { settings in
            handler(settings.authorizationStatus)
        })
    }

    class func promptPushPermission(handler: @escaping ((UNAuthorizationStatus) -> Void)) {
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            // Enable or disable features based on authorization.
            DispatchQueue.main.async {
                if granted {
                    self.getNotificationSettings()
                    handler(UNAuthorizationStatus.authorized)
                } else {
                    handler(UNAuthorizationStatus.denied)
                }
            }
        }
    }

    @available(iOS 12.0, *)
    class func promptProvisionalPushPermission(handler: @escaping ((UNAuthorizationStatus) -> Void)) {
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .badge, .sound, .provisional, .providesAppNotificationSettings]) { granted, _ in
            // Enable or disable features based on authorisation.
            DispatchQueue.main.async {
                if granted {
                    self.getNotificationSettings()
                    handler(UNAuthorizationStatus.authorized)
                } else {
                    handler(UNAuthorizationStatus.denied)
                }
            }
        }
    }

    class func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if #available(iOS 12.0, *) {
                guard settings.authorizationStatus == .authorized ||
                    settings.authorizationStatus == .provisional else { return }
                
                let categoryIdentifier = "OSNotificationCarousel"
                let carouselNext = UNNotificationAction(identifier: "OSNotificationCarousel.next", title: "👉", options: [])
                let carouselPrevious = UNNotificationAction(identifier: "OSNotificationCarousel.previous", title: "👈", options: [])
                let carouselCategory = UNNotificationCategory(identifier: categoryIdentifier, actions: [carouselNext, carouselPrevious], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([carouselCategory])
            } else {
                guard settings.authorizationStatus == .authorized else { return }
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
//                AppDelegate.shared.notificationApplicationService.configurePushNotifications()
            }
        }
    }
}
