//
//  TabbarEvents.swift
//  Moon
//
//  Created by PYTHON on 05/10/23.
//

// MARK: - Tabbar specific events names here

class TabbarEventName {
    static let couponsTab: String = "menu_my_coupon"
    static let statsTab: String = "menu_statictics"
    static let accountTab: String = "menu_account"
    static let notificationsTab: String = "menu_notification"
}

// MARK: - Tabbar specific parameters events names here

class TabbarEventParameterName {}

// MARK: - Tabbar events

enum TabbarEvent {
    @Event(name: TabbarEventName.notificationsTab)
    static var notifNav: Event

    @Event(name: TabbarEventName.statsTab)
    static var statsNav: Event

    @Event(name: TabbarEventName.accountTab)
    static var accountNav: Event
    
    @Event(name: TabbarEventName.couponsTab)
    static var myCouponsNav: Event

}
