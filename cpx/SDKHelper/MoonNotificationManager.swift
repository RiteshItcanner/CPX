////
////  MoonNotificationManager.swift
////  Moon
////
////  Created by PYTHON on 05/10/23.
////
//
//import Foundation
//import UIKit
//enum NotificationService: CaseIterable {
//    case moEngage
//    case onesignal
//}
//
//protocol NotificationServiceProtocol {
//    func didFinishLaunching(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
//    func didRegisterForRemoteNotifications(with deviceToken: Data)
//    func didFailToRegisterForRemoteNotifications(with error: Error)
//    func willPresentNotification(with userInfo: [AnyHashable: Any])
//    func didReceiveNotification(with actionIdentifier: String,
//                                and userInfo: [AnyHashable: Any])
//    func registerUser(user:User)
//}
//
//protocol MoonNotificationManagerProtocol: NotificationServiceProtocol {
//    var servicesDict: [NotificationService: NotificationServiceProtocol] { get set }
//    func configureServices()
//}
//
//class MoonNotificationManager: MoonNotificationManagerProtocol {
//    
//    static let shared = MoonNotificationManager()
//    internal var servicesDict: [NotificationService: NotificationServiceProtocol] = [:]
//
//    func configureServices() {
//        NotificationService.allCases.forEach { service in
//            switch service {
//            case .moEngage:
//                self.servicesDict[.moEngage] = MoEngageNotificationService()
//            case .onesignal:
//                self.servicesDict[.onesignal] = OneSignalNotificationHelper()
//            }
//        }
//    }
//
//    func didFinishLaunching(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//        servicesDict.values.forEach { $0.didFinishLaunching(with: launchOptions) }
//    }
//
//    func didRegisterForRemoteNotifications(with deviceToken: Data) {
//        servicesDict.values.forEach { $0.didRegisterForRemoteNotifications(with: deviceToken) }
//    }
//
//    func didFailToRegisterForRemoteNotifications(with error: Error) {
//        servicesDict.values.forEach { $0.didFailToRegisterForRemoteNotifications(with: error) }
//    }
//
//    func willPresentNotification(with userInfo: [AnyHashable: Any]) {
//        servicesDict.values.forEach { $0.willPresentNotification(with: userInfo) }
//    }
//
//    func didReceiveNotification(with actionIdentifier: String,
//                                and userInfo: [AnyHashable: Any]) {
//        servicesDict.values.forEach { $0.didReceiveNotification(with: actionIdentifier,
//                                                                and: userInfo) }
//    }
//    
//    func registerUser(user: User) {
//        servicesDict.values.forEach { $0.registerUser(user: user) }
//    }
//}
