//
//  AuthEvents.swift
//  Moon
//
//  Created by PYTHON on 17/10/23.
//

// MARK: - Auth specific events names here

class AuthEventName {
    static let login: String = "login_success"
    static let logout: String = "logout"
    static let logoutSuccess: String = "logout_success"
}

// MARK: - Auth specific parameters events names here

class AuthEventParameterName {}

// MARK: - Auth events

enum AuthEvent {
    @Event(name: AuthEventName.login)
    static var login: Event
    
    @Event(name: AuthEventName.logout)
    static var logout: Event
    
    @Event(name: AuthEventName.logoutSuccess)
    static var logoutSuccess: Event

}


class AppEventName {
    static let clickPersonalDetails: String = "personal_details_click"
    static let clickBankDetails: String = "bank_details_click"
    static let clickSupportpolicy: String = "support_policy_click"
    static let clickFaq: String = "faqs_click"
    static let clickTerms: String = "terms_and_condition_click"
    static let clickPrivacyPolicy: String = "privacy_policy_click"
    static let deleteAccount: String = "delete_account"
    static let deleteAccountSuccess: String = "delete_account_success"
}

enum AppEvent {
    @Event(name: AppEventName.clickPersonalDetails)
    static var clickPersonalDetails: Event
    
    @Event(name: AppEventName.clickBankDetails)
    static var clickBankDetails: Event
    
    @Event(name: AppEventName.clickPrivacyPolicy)
    static var clickPrivacyPolicy: Event
    
    @Event(name: AppEventName.clickSupportpolicy)
    static var clickSupportpolicy: Event
    
    @Event(name: AppEventName.clickFaq)
    static var clickFaq: Event
    
    @Event(name: AppEventName.clickTerms)
    static var clickTerms: Event
    
    @Event(name: AppEventName.deleteAccount)
    static var deleteAccount: Event
    
    @Event(name: AppEventName.deleteAccountSuccess)
    static var deleteAccountSuccess: Event

}
