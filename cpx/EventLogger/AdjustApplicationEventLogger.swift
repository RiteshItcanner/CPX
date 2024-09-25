////
////  AdjustApplicationEventLogger.swift
////  LalaCoupons
////
////  Created by PYTHON on 28/08/23.
////  Copyright © 2023 Lala. All rights reserved.
////
//
//import Adjust
//
//class AdjustApplicationEventLogger: NSObject, AnalyticsSDKProtocol {
//    private var userDetails: User?
//    private enum AdjustEventname: String {
//        case adMarkDone = "Event_mark_as_done_click"
//        case adOpen = "Event_Ad_open"
//        case calendarClick = "Event_calender"
//        case brandScroll = "Event_brand_scroll"
//        case copyCount = "Event_copy_count"
//        case languageSwitch = "Event_Lang"
//        case login = "login_success"
//        case signup = "signup_success"
//        case plannerNav = "Planner_navigation"
//        case staticNav = "Statistics_navigation"
//        case accountNav = "Account_navigation"
//        case reqCoupon = "Request_coupon"
//        case logout = "Logout"
//        case deleteAcc = "Delete_account"
//
//        var getAdjustToken: String? {
//            switch self {
//            case .adMarkDone:
//                return "2lvn8d"
//            case .adOpen:
//                return "mogz2h"
//            case .calendarClick:
//                return "i0ib6z"
//            case .brandScroll:
//                return "k6h166"
//            case .copyCount:
//                return "l4uoo8"
//            case .languageSwitch:
//                return "39edd5"
//            case .plannerNav:
//                return "t3u4cb"
//            case .staticNav:
//                return "8gspc0"
//            case .accountNav:
//                return "ssg6gn"
//            case .login:
//                return "5swxd7"
//            case .signup:
//                return "uvxapx"
//            case .reqCoupon:
//                return "rd91eg"
//            case .logout:
//                return "wry7o8"
//            case .deleteAcc:
//                return "7z3uzz"
//            }
//        }
//    }
//
//    func createAliasUser() {}
//
//    func registerUser(_ user: User) {
//        self.userDetails = user
//        if let user = userDetails {
//            Adjust.addSessionPartnerParameter("customer_id", 
//                                              value: user.hs_object_id)
//        }
//    }
//
//    func deRegisterUser() {}
//
//    func configure() {}
//
//    func appDidFinishLaunch(app: UIApplication,
//                            options: [UIApplication.LaunchOptionsKey: Any]?) {
//        let token = "j5zalgun5fcw"
//        var environment: String
////        #if DEBUG
////            environment = ADJEnvironmentSandbox
////        #else
////            environment = ADJEnvironmentProduction
////        #endif
//        environment = ADJEnvironmentProduction
//
//        let config = ADJConfig(appToken: token,
//                               environment: environment)
//        config?.logLevel = ADJLogLevelVerbose
//        config?.delegate = self
//        Adjust.appDidLaunch(config)
//    }
//
//    func appDidBecomeActive() {}
//
//    func appOpenedFromExternalURL(_ app: UIApplication,
//                                  url: URL,
//                                  options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool? { return true }
//
//    func appRegisterRemoteNotification(_ app: UIApplication,
//                                       deviceToken: Data) {
//        Adjust.setDeviceToken(deviceToken)
//    }
//
//    func didFailToRegisterForRemoteNotificationsWithError(_ app: UIApplicationDelegate,
//                                                          error: Error) {}
//
//    func trackEvent(event: EventProtocol) {
//        if let eventName = event.names[.adjust] {
//            if let token = AdjustEventname(rawValue: eventName)?.getAdjustToken {
//                let adjustEvent = ADJEvent(eventToken: token)
//                if let params = event.params[.adjust] as? [String: String] {
//                    params.forEach { key, value in
//                        adjustEvent?.addPartnerParameter(key, value: value)
//                    }
//                    if let user = userDetails {
//                        adjustEvent?.addPartnerParameter("hubspot_contact_id", 
//                                                         value: user.hs_object_id)
//                        adjustEvent?.addPartnerParameter("email",
//                                                         value: user.email)
//                        adjustEvent?.addPartnerParameter("name", 
//                                                         value: (user.first_name + user.last_name))
//                        adjustEvent?.addPartnerParameter("mobile_number",
//                                                         value: user.moon_app_num_edit_hub)
//                        Adjust.addSessionPartnerParameter("customer_id", value: user.hs_object_id)
//                    }
//                }
//                Adjust.trackEvent(adjustEvent)
//            }
//        }
//    }
//}
//
//extension AdjustApplicationEventLogger: AdjustDelegate {}
