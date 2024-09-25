//
//  Coupons.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import Foundation

// MARK: - CouponResponse
struct CouponResponse: Codable {
    let status: String
    let code: Int
    let message: String
    let data: CouponDataClass
}

struct CouponDataClass: Codable {
    let totals: Totals
    let coupons: [Coupon]
    let offers: [Offer]
    
    enum CodingKeys: String, CodingKey {
        case totals
        case coupons
        case offers
    }
}

struct Totals: Codable {
    let totalCoupons: String
    let totalPage: Int

    enum CodingKeys: String, CodingKey {
        case totalCoupons = "total_coupons"
        case totalPage = "total_page"
    }
}

// MARK: - Coupon
struct Coupon: Codable {
    let offerName, coupon: String
    let offerLogo: String?
    let advertiser, couponOffering: String
    let assignmentDate: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case offerName = "offer_name"
        case coupon
        case offerLogo = "offer_logo"
        case advertiser
        case couponOffering = "coupon_offering"
        case assignmentDate = "assignment_date"
        case status
    }
}

struct Offer: Codable {
    let offerId, offerName: String
    let offerLogo: String

    enum CodingKeys: String, CodingKey {
        case offerId = "offer_id"
        case offerName = "offer_name"
        case offerLogo = "offer_logo"
    }
}

struct CouponRequestResponse: Codable {
    let status: String
    let result: Bool
    let message: String
    let code: Int
    let data: [Datum]
}

struct Datum: Codable {
    let couponCode, team: String
    let function: String
    let brandName: String
    let industry: String
    let globalNewPayout, globalReturningPayout: String
    let newAREPayout, returningAREPayout: String
    let newBHRPayout, returningBHRPayout, newEGYPayout, returningEGYPayout: String
    let newKWTPayout, returningKWTPayout: String
    let newOMNPayout, returningOMNPayout, newQATPayout, returningQATPayout: String
    let newSAUPayout, returningSAUPayout: String
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case couponCode = "Coupon_Code"
        case team = "Team"
        case function = "Function"
        case brandName = "Brand_Name_"
        case industry = "Industry"
        case globalNewPayout = "Global_New_Payout"
        case globalReturningPayout = "Global_Returning_Payout"
        case newAREPayout = "New_ARE_Payout"
        case returningAREPayout = "Returning_ARE_Payout"
        case newBHRPayout = "New_BHR_Payout"
        case returningBHRPayout = "Returning_BHR_Payout"
        case newEGYPayout = "New_EGY_Payout"
        case returningEGYPayout = "Returning_EGY_Payout"
        case newKWTPayout = "New_KWT_Payout"
        case returningKWTPayout = "Returning_KWT_Payout"
        case newOMNPayout = "New_OMN_Payout"
        case returningOMNPayout = "Returning_OMN_Payout"
        case newQATPayout = "New_QAT_Payout"
        case returningQATPayout = "Returning_QAT_Payout"
        case newSAUPayout = "New_SAU_Payout"
        case returningSAUPayout = "Returning_SAU_Payout"
        case url = "URL"
    }
}

// MARK: -> Stats Model
struct StatsResponse: Codable {
    let status: String
    let code: Int
    let message: String
    let data: StatsDataClass
}

struct StatsDataClass: Codable {
    let totals: StatsTotals
    let conversions: [Conversion]
    let clients: [Client]
}

struct Client: Codable {
    let id: String
    let name: String
    let logo: String?
}

struct Conversion: Codable {
    let totalSaleAmount: Double
    let totalConversions: Int
    let totalPayout: Double
    let totalNetPayout: Double
    let totalNetConversion: Int
    let advertiser: String
    let advertiserID: String
    let advertiserLogo: String?
    let detailsConversion: [DetailsConversion]

    enum CodingKeys: String, CodingKey {
        case totalSaleAmount = "total_sale_amount"
        case totalConversions = "total_conversions"
        case totalPayout = "total_payout"
        case totalNetPayout = "total_net_payout"
        case totalNetConversion = "total_net_conversion"
        case advertiser
        case advertiserID = "advertiser_id"
        case advertiserLogo = "advertiser_logo"
        case detailsConversion = "details_conversion"
    }
}

struct DetailsConversion: Codable {
    let advertiser: String
    let advertiserID: String
    let advertiserLogo: String
    let couponCode: String
    let saleAmount: String
    let conversions: Int
    let payout: String
    let netPayout: String
    let netConversion: Int

    enum CodingKeys: String, CodingKey {
        case advertiser
        case advertiserID = "advertiser_id"
        case advertiserLogo = "advertiser_logo"
        case couponCode = "coupon_code"
        case saleAmount = "sale_amount"
        case conversions
        case payout
        case netPayout = "net_payout"
        case netConversion = "net_conversion"
    }
}

struct StatsTotals: Codable {
    let totalConversions: Int
    let totalPage: Int
    let totalPayout: Int
    let totalAdvertiser: Int

    enum CodingKeys: String, CodingKey {
        case totalConversions = "total_conversions"
        case totalPage = "total_page"
        case totalPayout = "total_payout"
        case totalAdvertiser = "total_advertiser"
    }
}
