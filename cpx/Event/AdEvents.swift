//
//  AdEvents.swift
//  Moon
//
//  Created by PYTHON on 24/10/23.
//

//Campaign_Name

// MARK: - Ads specific events names here

class CouponEventName {
    static let copyCoupons: String = "copy_my_coupons"
    static let searchCoupons: String = "search_my_coupons"
    static let requestCoupon: String = "coupon_request_click"
    static let requestCouponSuccess: String = "coupon_request_success"
    static let searchCouponRequest: String = "search_coupon_request"
    static let clickStatisticsClient: String = "statistics_client_click"
    static let clickStatisticsDetail: String = "statistics_details"
}

// MARK: - Ad events

enum CouponEvents {
    @Event(name: CouponEventName.copyCoupons)
    static var copyCoupons: Event
    
    @Event(name: CouponEventName.searchCoupons)
    static var searchCoupons: Event
    
    @Event(name: CouponEventName.requestCoupon)
    static var requestCoupon: Event
    
    @Event(name: CouponEventName.requestCouponSuccess)
    static var requestCouponSuccess: Event
    
    @Event(name: CouponEventName.searchCouponRequest)
    static var searchCouponRequest: Event
    
    @Event(name: CouponEventName.clickStatisticsClient)
    static var clickStatisticsClient: Event
    
    @Event(name: CouponEventName.clickStatisticsDetail)
    static var clickStatisticsDetail: Event

}
