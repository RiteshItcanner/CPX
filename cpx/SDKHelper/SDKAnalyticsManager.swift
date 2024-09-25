//
//  AnalyticsManager.swift
//  LalaCoupons
//
//  Created by PYTHON on 26/08/23.
//  Copyright © 2023 Lala. All rights reserved.
//

import UIKit

enum TrackingSDK: CaseIterable {
//    case adjust
    case firebase
//    case moEngage
//    case meta
}

protocol AnalyticsParamReturnProtocol {
    func params() -> [String: Any]?
}

protocol AnalyticsSDKProtocol {
    // Note: The below three methods are called once in lifetime of user usage in app
    // When user is using app without registering in our app
    func createAliasUser()
    // When user Registers or Login in our app
    func registerUser(_ user: User)
    // When user Logout or Uninstall in our app
    func deRegisterUser()

    // Update the user properties based on user's activities, it is used mostly creating user profile
    func configure()

    // Track events for user actions
    func trackEvent(event: EventProtocol)

    // Configure Event Loggers Initialisation and other lifecycle methods
    func appDidFinishLaunch(app: UIApplication,
                            options: [UIApplication.LaunchOptionsKey: Any]?)
    func appDidBecomeActive()
    @discardableResult
    func appOpenedFromExternalURL(_ app: UIApplication,
                                  url: URL,
                                  options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool?
    func appRegisterRemoteNotification(_ app: UIApplication,
                                       deviceToken: Data)
    func didFailToRegisterForRemoteNotificationsWithError(_ app: UIApplicationDelegate,
                                                          error: Error)
}

protocol AnalyticsManagerProtocol: AnalyticsSDKProtocol {
    var loggersDict: [TrackingSDK: AnalyticsSDKProtocol] { get set }
    func configureSDKs()
    func getLoggerInstanceOfType(sdk: TrackingSDK) -> AnalyticsSDKProtocol?
    func trackEvent(_ event: EventProtocol,
                    params: [String: Any],
                    paramsContract: AnalyticsParamReturnProtocol?)
}

class SDKAnalyticsManager: AnalyticsManagerProtocol {
    static let shared = SDKAnalyticsManager()
    internal var loggersDict = [TrackingSDK: AnalyticsSDKProtocol]()

    func configureSDKs() {
        TrackingSDK.allCases.forEach { sdk in
            switch sdk {
//            case .adjust:
//                self.loggersDict[.adjust] = AdjustApplicationEventLogger()
            case .firebase:
                self.loggersDict[.firebase] = FirebaseApplicationEventLogger()
//            case .moEngage:
//                self.loggersDict[.moEngage] = MoEngageApplicationEventLogger()
//            case .meta:
//                self.loggersDict[.meta] = FBApplicationEventLogger()
            }
        }
        configure()
    }

    func getLoggerInstanceOfType(sdk: TrackingSDK) -> AnalyticsSDKProtocol? {
        return loggersDict[sdk]
    }

    func createAliasUser() {
        loggersDict.values.forEach { logger in
            logger.createAliasUser()
        }
    }

    func registerUser(_ user: User) {
        loggersDict.values.forEach { logger in
            logger.registerUser(user)
        }
    }

    func deRegisterUser() {
        loggersDict.values.forEach { logger in
            logger.deRegisterUser()
        }
    }

    func appDidFinishLaunch(app: UIApplication,
                            options: [UIApplication.LaunchOptionsKey: Any]?) {
        loggersDict.values.forEach { logger in
            logger.appDidFinishLaunch(app: app, options: options)
        }
    }

    func appDidBecomeActive() {
        loggersDict.values.forEach { logger in
            logger.appDidBecomeActive()
        }
    }

    func appOpenedFromExternalURL(_ app: UIApplication,
                                  url: URL,
                                  options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool? {
        return true
    }

    func appRegisterRemoteNotification(_ app: UIApplication,
                                       deviceToken: Data) {
        loggersDict.values.forEach { logger in
            logger.appRegisterRemoteNotification(app,
                                                 deviceToken: deviceToken)
        }
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ app: UIApplicationDelegate,
                                                          error: Error) {
        loggersDict.values.forEach { logger in
            logger.didFailToRegisterForRemoteNotificationsWithError(app, error: error)
        }
    }

    func configure() {
        loggersDict.values.forEach { logger in
            logger.configure()
        }
    }

    internal func trackEvent(event: EventProtocol) {
        loggersDict.values.forEach { logger in
            logger.trackEvent(event: event)
        }
    }

    // Convenience track event method
    func trackEvent(_ event: EventProtocol,
                    params: [String: Any],
                    paramsContract: AnalyticsParamReturnProtocol? = nil) {
        var event = event

        // Append params to event
        if !params.isEmpty {
            for (trackingSDK, trackingSDKParams) in event.params {
                var mutableTrackingSDKParams = trackingSDKParams
                mutableTrackingSDKParams.merge(params) { _, right -> Any in
                    right
                }
                event.params[trackingSDK] = mutableTrackingSDKParams
            }
        }

        // Add contract params to event
        if let params = paramsContract?.params(),
           !params.isEmpty {
            for (trackingSDK, trackingSDKParams) in event.params {
                var mutableTrackingSDKParams = trackingSDKParams
                mutableTrackingSDKParams.merge(params) { _, right -> Any in
                    right
                }
                event.params[trackingSDK] = mutableTrackingSDKParams
            }
        }

        // track event call
        loggersDict.values.forEach { logger in
            logger.trackEvent(event: event)
        }
    }
    
//    func invokeNudgeView() {
//        loggersDict.values.forEach { logger in
//            if let _moEngage = logger as? MoEngageApplicationEventLogger {
//                _moEngage.invokeNudgeView()
//            }
//        }
//    }
}
