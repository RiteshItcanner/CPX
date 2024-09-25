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
