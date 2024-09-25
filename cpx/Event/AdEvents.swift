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
    static let requestCoupon: String = "coupon_request_click"
    static let requestCouponSuccess: String = "coupon_request_success"
}

// MARK: - Ad events

enum CouponEvents {
    @Event(name: CouponEventName.copyCoupons)
    static var copyCoupons: Event
    
    @Event(name: CouponEventName.requestCoupon)
    static var requestCoupon: Event
    
    @Event(name: CouponEventName.requestCouponSuccess)
    static var requestCouponSuccess: Event

}
