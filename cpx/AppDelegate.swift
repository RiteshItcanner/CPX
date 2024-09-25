//
//  AppDelegate.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import GoogleSignIn
import MoEngageSDK
//import MoEngageInApps
import MoEngageMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    public var window: UIWindow?
    
    private let appID = Constant.moEngageWorkspaceId
    private var moEngage: MoEngage
    private var moMessaging: MoEngageSDKMessaging
    
    override init() {
        moEngage = MoEngage.sharedInstance
        moMessaging = MoEngageSDKMessaging.sharedInstance
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        SDKAnalyticsManager.shared.configureSDKs()
        SDKAnalyticsManager.shared.appDidFinishLaunch(app: application,
                                                      options: launchOptions)
        
        let sdkConfig = MoEngageSDKConfig(appId: appID, dataCenter: .data_center_01)
        
        sdkConfig.appGroupID = "group.com.itcan.cpxaffiliate.MoEngage"
        //        sdkConfig.enableLogs = true
        //        moEngage.initializeDefaultLiveInstance(sdkConfig,
        //                                               sdkState: .enabled)
        
#if DEBUG
        moEngage.initializeDefaultTestInstance(sdkConfig,
                                               sdkState: .enabled)
#else
        moEngage.initializeDefaultLiveInstance(sdkConfig,
                                               sdkState: .enabled)
#endif
        //
        PushPermissionHelper.checkPushEnabled { authStatus in
            guard authStatus == .authorized else { return }
            MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil,
                                                                              andUserNotificationCenterDelegate: nil)
        }
        //        moMessaging.setMessagingDelegate(self)
        //        moMessaging.disableBadgeReset(true)
        //        MoEngageSDKInApp.sharedInstance.setInAppDelegate(self)
        
        return true
    }
    
    // MARK:- UserNotifications Framework callback method
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //This is to only to display banner and enable notification sound
        completionHandler([.sound,.banner])
        
    }
    
    // MARK:- UserNotifications Framework callback method
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
        
        //Custom Handling of notification if Any
        let pushDictionary = response.notification.request.content.userInfo
        print(pushDictionary)
        
        completionHandler();
    }
    
    
    //Remote notification Registration callback methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngageSDKMessaging.sharedInstance.didFailToRegisterForPush()
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

// MARK: - MoEngage InApp Native Delegate

//extension AppDelegate: MoEngageInAppNativeDelegate {
//    func inAppShown(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign,
//                    forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
//        //OSLog.moengage.dump("InApp Shown with Campaign ID \(inappCampaign.campaignId)")
//    }
//
//    func inAppClicked(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign,
//                      andNavigationActionInfo navigationAction: MoEngageInApps.MoEngageInAppAction,
//                      forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
//        //OSLog.moengage.dump("InApp Dismissed with Campaign ID \(inappCampaign.campaignId)")
//    }
//
//    // Called when an inApp is clicked by the user,
//    // and it has been configured with a custom action
//    func inAppClicked(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign,
//                      andCustomActionInfo customAction: MoEngageInApps.MoEngageInAppAction,
//                      forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
//    }
//
//    // Called when an inApp is clicked by the user,
//    // and it has been configured with a navigation action
//    func inAppDismissed(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign,
//                        forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
//    }
//
//    func selfHandledInAppTriggered(withInfo inappCampaign: MoEngageInApps.MoEngageInAppSelfHandledCampaign,
//                                   forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
//    }
//}
//
//// MARK: - MoEngage Messaging Delegate
//
//extension AppDelegate: MoEngageMessagingDelegate {
//    func notificationClicked(withPushPayload userInfo: [AnyHashable: Any]) {
//        //OSLog.moengage.dump("notificationClicked:withPushPayload \(userInfo)")
//    }
//
//    func notificationRegistered(withDeviceToken deviceToken: String) {
////        OSLog.moengage.dump("notificationRegistered:withPushPayload \(deviceToken)")
//    }
//
//    func notificationReceived(withPushPayload userInfo: [AnyHashable: Any]) {
////        OSLog.moengage.dump("notificationReceived:withPushPayload \(userInfo)")
//    }
//}
