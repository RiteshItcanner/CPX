//
//  FirebaseApplicationEventLogger.swift
//  Moon
//
//  Created by PYTHON on 05/10/23.
//

import Firebase

class FirebaseApplicationEventLogger: NSObject, AnalyticsSDKProtocol {
    func createAliasUser() {}

    func registerUser(_ user: User) {
        Analytics.setUserID(user._id)
        Analytics.setUserProperty(user.influencer_id, forName: "influencer_id")
        Analytics.setUserProperty(user.first_name_hub + user.last_name_hub, forName: "name")
        Analytics.setUserProperty(user.email, forName: "email")
    }

    func deRegisterUser() {}

    func configure() {
    }

    func appDidFinishLaunch(app: UIApplication,
                            options: [UIApplication.LaunchOptionsKey: Any]?) {
//        initFirebase()
    }

    func appDidBecomeActive() {
    }

    func appOpenedFromExternalURL(_ app: UIApplication,
                                  url: URL,
                                  options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool? { return true }

    func appRegisterRemoteNotification(_ app: UIApplication,
                                       deviceToken: Data) {
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ app: UIApplicationDelegate,
                                                          error: Error) {
    }

    func trackEvent(event: EventProtocol) {
        if let name = event.names[.firebase] {
            var eventName = name
            let params = event.params[.firebase]
            eventName = name.replacingOccurrences(of: " ",
                                                  with: "_")
            Analytics.logEvent(eventName,
                               parameters: params)
        }
    }

    fileprivate func initFirebase() {
        #if DEBUG
            var newArguments = ProcessInfo.processInfo.arguments
            newArguments.append("-FIRDebugEnabled")
            newArguments.append("-FIRAnalyticsDebugEnabled")
            ProcessInfo.processInfo.setValue(newArguments, forKey: "arguments")
        #endif

        // Configure
        var filePath: String!
        filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")

        let options = FirebaseOptions(contentsOfFile: filePath)!
        FirebaseApp.configure(options: options)
    }
}
