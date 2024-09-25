////
////  MoEngageApplicationEventLogger.swift
////  Moon
////
////  Created by PYTHON on 09/01/24.
////
//
//import Foundation
//import MoEngageAnalytics
//import MoEngageInApps
//import MoEngageSDK
//
//class MoEngageApplicationEventLogger: NSObject, AnalyticsSDKProtocol {
//    private let moAnalytics: MoEngageSDKAnalytics
//    private let moInApp: MoEngageSDKInApp
//
//    override init() {
//        moAnalytics = MoEngageSDKAnalytics.sharedInstance
//        moInApp = MoEngageSDKInApp.sharedInstance
//        super.init()
//        ConfigurationManager.shared.appLaunch += 1
//        checkAppIsUpdatedORFreshlyInstalled()
//    }
//
//    private func checkAppIsUpdatedORFreshlyInstalled() {
//        if ConfigurationManager.shared.appLaunch == 1 {
//            moAnalytics.appStatus(.install)
//        } else if let lastSavedAppVersion = ConfigurationManager.shared.appVersion,
//                  let currentSavedAppVersion = Bundle.main.releaseVersionNumber,
//                  lastSavedAppVersion != currentSavedAppVersion {
//            moAnalytics.appStatus(.update)
//        }
//        ConfigurationManager.shared.appVersion = Bundle.main.releaseVersionNumber
//    }
//
//    func createAliasUser() {}
//
//    func registerUser(_ user: User) {
//        moAnalytics.setUniqueID(user.hs_object_id)
//        moAnalytics.setFirstName(user.first_name + " " + user.last_name)
//        moAnalytics.setEmailID(user.email)
//        moAnalytics.setMobileNumber(user.moon_app_num_edit_hub)
//
//        // MARK: - Custom attributes
//
//        var selectedlanguage = "English"
//        if AppUtility.isRTL {
//            selectedlanguage = "Arabic"
//        }
//        moAnalytics.setUserAttribute(selectedlanguage,
//                                     withAttributeName: "Language")
//    }
//
//    func deRegisterUser() {
//        moAnalytics.resetUser()
//    }
//
//    func configure() {
//    }
//
//    func appDidFinishLaunch(app: UIApplication,
//                            options: [UIApplication.LaunchOptionsKey: Any]?) {
//    }
//
//    func appDidBecomeActive() {
//    }
//
//    func appOpenedFromExternalURL(_ app: UIApplication,
//                                  url: URL,
//                                  options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool? { return true }
//
//    func appRegisterRemoteNotification(_ app: UIApplication,
//                                       deviceToken: Data) {
//    }
//
//    func didFailToRegisterForRemoteNotificationsWithError(_ app: UIApplicationDelegate,
//                                                          error: Error) {
//    }
//
//    func trackEvent(event: EventProtocol) {
//        guard let eventName = event.names[.moEngage] else { return }
//        guard let eventParams = event.params[.moEngage] else { return }
//        let moEngageProperties = MoEngageProperties(withAttributes: eventParams)
//        moAnalytics.trackEvent(eventName,
//                               withProperties: moEngageProperties)
//    }
//
//    func invokeNudgeView() {
//        moInApp.showInApp()
//        moInApp.showNudge(atPosition: NudgePositionTop)
//    }
//
//    func invokeInApp(_ screenContext: String) {
////        moInApp.setCurrentInAppContexts([screenContext])
////        moInApp.showCampaign()
//    }
//}
