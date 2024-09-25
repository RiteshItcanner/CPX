//
//  FBApplicationEventLogger.swift
//  Moon
//
//  Created by PYTHON on 24/01/24.
//

import Foundation
import FBSDKCoreKit

class FBApplicationEventLogger: NSObject, AnalyticsSDKProtocol {
    func createAliasUser() {}

    func registerUser(_ user: User) {
    }

    func deRegisterUser() {}

    func configure() {
    }

    func appDidFinishLaunch(app: UIApplication,
                            options: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(app,
                                               didFinishLaunchingWithOptions: options)
    }

    func appDidBecomeActive() {
        AppEvents.shared.activateApp()
    }

    func appOpenedFromExternalURL(_ app: UIApplication,
                                  url: URL,
                                  options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool? {
        ApplicationDelegate.shared.application(app,
                                               open: url,
                                               options: options)
        return true
    }

    func appRegisterRemoteNotification(_ app: UIApplication,
                                       deviceToken: Data) {
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ app: UIApplicationDelegate,
                                                          error: Error) {
    }

    func trackEvent(event: EventProtocol) {
    }
}
