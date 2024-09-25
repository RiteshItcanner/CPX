//
//  Constant.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

typealias SignUpValues = (email: String, name: String)

class Constant: NSObject {
    //    #if DEBUG1
    static let shared = Constant()
    static let commonBaseURL = "https://api.ims.directory/" // "https://stag.api.ims.directory/"
    static let adjustAppToken = ""
    static let ShadowRadius: CGFloat = 10.0
    static let token = "327c4084ac5452b7634b2066ae7c0ee291ea0d42b5cce110ff301b7c2af6b74916b68c3b67ee8a2c4fd2d4195e6811066dff81d940fd8b06=="
    static let moEngageWorkspaceId = "ECHZAMG1Y4J28IMCZMKKNBIO"
    static let authTken = "pat-eu1-59ba4565-4561-40e1-ba62-a3d2085a1232" // "pat-eu1-f02ead06-aaad-4b4e-87b1-c59d8b5fecf0"
    static let str_userdefault_key = "a"
    
    override private init() { }
}

enum Language: String {
    case english = "en"
    case arabic = "ar"
    
    var caseRawValue: String {
        switch self {
        case .arabic:
            return APPLocalizable.arabic
        case .english:
            return APPLocalizable.english
        }
    }
}

struct Device {
    // iDevice detection code
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH = Int(max(SCREEN_WIDTH, SCREEN_HEIGHT))
    static let SCREEN_MIN_LENGTH = Int(min(SCREEN_WIDTH, SCREEN_HEIGHT))
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568
    static let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6 = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X = IS_IPHONE && SCREEN_MAX_LENGTH >= 812
}

class Common {
    public static let `default` = Common()
    
    func addshadow(View: UIView, shadowRadius: CGFloat? = 0, shadowColor: UIColor? = UIColor.darkGray, shadowOpacity: Float? = 0, borderWidth: CGFloat? = 0, borderColor: UIColor? = UIColor.clear, cornerRadius: CGFloat? = 0, shadowOffset: CGSize? = CGSize.zero, IsMaskToBounds: Bool = false) {
        View.layer.shadowRadius = shadowRadius!
        View.layer.shadowColor = shadowColor?.cgColor
        View.layer.shadowOffset = shadowOffset!
        View.layer.shadowOpacity = shadowOpacity!
        View.layer.borderWidth = borderWidth!
        View.layer.borderColor = borderColor?.cgColor
        View.layer.cornerRadius = cornerRadius!
        View.layer.masksToBounds = IsMaskToBounds
    }
    
    func getPer(val: CGFloat, per: Int) -> CGFloat {
        if val > 0 {
            return ((CGFloat(per) * val) / 100)
        }
        return 0.0
    }
}

//extension UIResponder {
//    var defaultAlignment: NSTextAlignment {
//        return AppUtility.isRTL ? .right : .left
//    }
//}

//enum Currency: String, Codable, CaseIterable {
//    case usd = "USD"
//    case aed = "AED"
//    case sar = "SAR"
//    
//    var getRawValue: String {
//        switch self {
//        case .usd:
//            return APPLocalizable.usd
//        case .aed:
//            return APPLocalizable.aed
//        case .sar:
//            return APPLocalizable.sar
//        }
//    }
//    // Below Currencies Are Not In Scope For Now
//    /* case egp = "EGP"
//     case kwd = "KWD"
//     case qar = "QAR" */
//}

//enum FilterType: Codable, Equatable {
//    case dateRange(dateRange: String? = nil)
//    case today
//    case advertisers(String? = nil)
//    case coupon
//    case currency(Currency)
//    
//    var getRawValue: String {
//        switch self {
//        case let .dateRange(dateRange):
//            return (dateRange == nil || dateRange == "") ? "" : dateRange!
//        case .today:
//            return "Today"
//        case let .advertisers(advertiser):
//            return (advertiser == nil || advertiser == "") ? "Advertiser" : advertiser!
//        case .coupon:
//            return "Coupon"
//        case let .currency(currency):
//            return currency.rawValue
//        }
//    }
//    
//    var cutomRawValue: String {
//        switch self {
//        case .advertisers:
//            return "Advertiser"
//        case .currency:
//            return "Currency"
//        default:
//            return ""
//        }
//    }
//    
//    var isRangeValueSame: Bool {
//        switch self {
//        case let .dateRange(range):
//            let split = range?.replacingOccurrences(of: " ", with: "").split(separator: "-")
//            return String(split?.first ?? "") == String(split?.last ?? "")
//        default: break
//        }
//        return false
//    }
//    
//    var isCurrencyFilter: Bool {
//        switch self {
//        case .currency:
//            return true
//        default:
//            return false
//        }
//    }
//    
//    var rangeSplit: (fromDate: String, toDate: String)? {
//        switch self {
//        case let .dateRange(range):
//            let split = range?.split(separator: "-")
//            return (String(split?.first ?? ""), String(split?.last ?? ""))
//        default:
//            return nil
//        }
//    }
//    
//    func getCurrencyRate(filter: Currency) -> Double {
//        let allRate = ConfigurationManager.shared.currencyRate
//        var crurrencyRate: Double = 0.00
//        allRate.forEach { rate in
//            if rate.currency == filter.rawValue {
//                return crurrencyRate = rate.rate
//            }
//        }
//        return crurrencyRate
//    }
//}

enum SingUpInputState: String, CaseIterable {
    case emailName, number, platform, handle, followers, attachements, hear, brand
    
    var indexOfItemWithNumber: Int {
        switch self {
        case .emailName:
            return 0
        case .number:
            return 1
        case .platform:
            return 2
        /*case .handle:
            return 3
        case .followers:
            return 4*/
        case .attachements:
            return 3
        case .hear:
            return 4
        default:
            return .zero
        }
    }

    var indexOfItem: Int {
        switch self {
        case .emailName:
            return 0
        case .number:
            fallthrough
        case .platform:
            return 1
        /*case .handle:
            return 2
        case .followers:
            return 3*/
        case .attachements:
            return 2
        case .hear:
            return 3
        default:
            return .zero
        }
    }
    
    var scrTitle: String {
        switch self {
        case .emailName:
            return "Enter Your Name and email"
        case .platform:
            return "Choose your platform"
        case .handle:
            return "Enter your Website link"
        case .followers:
            return "Enter your number of followers"
        case .attachements:
            return "Upload a screenshot from your account"
        case .number:
            return ""
        case .hear:
            return "How Did You Hear About Us?"
        default:
            return ""
        }
    }
    
    func currentStateWithNumberFrom(index: Int) -> Self? {
        switch index {
        case 0:
            return SingUpInputState.emailName
        case 1:
            return SingUpInputState.number
        case 2:
            return SingUpInputState.platform
        /*case 3:
            return SingUpInputState.handle
        case 4:
            return SingUpInputState.followers*/
        case 3:
            return SingUpInputState.attachements
        case 4:
            return SingUpInputState.hear
        default:
            return nil
        }
    }

    func currentStateFrom(index: Int) -> Self? {
        switch index {
        case 0:
            return SingUpInputState.emailName
        case 1:
            return SingUpInputState.platform
        /*case 2:
            return SingUpInputState.handle
        case 3:
            return SingUpInputState.followers*/
        case 2:
            return SingUpInputState.attachements
        case 3:
            return SingUpInputState.hear
        default:
            return nil
        }
    }
}

enum BrandSingUpInputState: String, CaseIterable {
    case name, industry, serviceInterest, emailOrHandle, number, webURL, location, budget, adObject
    
    var indexOfRow: Int {
        switch self {
        case .name:
            return 0
        case .industry, .serviceInterest:
            return 1
        case .emailOrHandle:
            return 2
        case .number:
            return 3
        case .webURL:
            return 4
        case .location, .budget:
            return 5
        case .adObject:
            return 6
        }
    }

    func currentStateFrom(index: Int) -> Self? {
        switch index {
        case 0:
            return BrandSingUpInputState.name
        case 1:
            return BrandSingUpInputState.industry
        case 2:
            return BrandSingUpInputState.emailOrHandle
        case 3:
            return BrandSingUpInputState.number
        case 4:
            return BrandSingUpInputState.webURL
        case 5:
            return BrandSingUpInputState.location
        case 6:
            return BrandSingUpInputState.adObject
        default:
            return nil
        }
    }
}

//struct Category: Codable {
//    var imageName: String
//    var name: String
//    var isSelected: Bool = false
//    
//    func getEngCategory() -> String {
//        switch name {
//        case APPLocalizable.beauty:
//            return "Beauty"
//        case APPLocalizable.motherhood:
//            return "Motherhood"
//        case APPLocalizable.fashion:
//            return "Fashion"
//        case APPLocalizable.fitness:
//            return "Fitness"
//        case APPLocalizable.home:
//            return "Home"
//        case APPLocalizable.fragrance:
//            return "Fragrance"
//        default:
//            return "All"
//        }
//    }
//    
//    mutating func updateSelection(value: Bool) {
//        isSelected = value
//    }
//}

//struct Constants {
//    var localNotifications: [LocalNotification] {
//        return [LocalNotification(title: APPLocalizable.app_title, body: APPLocalizable.noti_first_msg),
//                LocalNotification(title: APPLocalizable.app_title, body: APPLocalizable.noti_second_msg),
//                LocalNotification(title: APPLocalizable.app_title, body: APPLocalizable.noti_third_msg),
//                LocalNotification(title: APPLocalizable.app_title, body: APPLocalizable.noti_forth_msg)]
//    }
//    
//    static func getMyCouponsCategories() -> [Category] {
//        return [Category(imageName: "icn_all", name: APPLocalizable.all, isSelected: true),
//                Category(imageName: "icn_beauty", name: APPLocalizable.beauty),
//                Category(imageName: "icn_motherhood", name: APPLocalizable.motherhood),
//                Category(imageName: "icn_fashion", name: APPLocalizable.fashion),
//                Category(imageName: "icn_fitness", name: APPLocalizable.fitness),
//                Category(imageName: "icn_home", name: APPLocalizable.home),
//                Category(imageName: "icn_fragrance", name: APPLocalizable.fragrance)]
//    }
//    static let countriesInDropDown = ["United Arab Emirates", "Saudi Arabia", "Kuwait", "Oman", "Bahrain", "Qatar", "India", "Jordan", "Egypt", "United States", "United Kingdom", "Canada", "Lebanon", "Algeria", "Australia", "Belgium", "France", "Germany", "Indonesia", "Libyan Arab Jamahiriya", "Morocco", "Turkey", "Tunisia"]
//}

struct Font {
    
    struct AktivGrotsek {
        static let regular = "AktivGrotesk-Regular"
        static let bold = "AktivGrotesk-Bold"
        static let medium = "AktivGrotesk-Medium"
    }
    
    struct AktivGrotsekExtended {
        static let regular = "AktivGroteskEx-Regular"
        static let bold = "AktivGroteskEx-Bold"
        static let medium = "AktivGroteskEx-Medium"
    }
    
}

enum Platform: String {
    case twitter = "X"
    case instagram = "Instagram"
    case snapchat = "Snapchat"
    case facebook = "Facebook"
    case tiktok = "TikTok"
    
//    func getValidationMsgForState(state: SingUpInputState) -> String {
//        switch self {
//        case .twitter:
//            return twitterMsg(state)
//        case .instagram:
//            return instagramMsg(state)
//        case .snapchat:
//            return snapchatMsg(state)
//        case .facebook:
//            return facebookMsg(state)
//        case .tiktok:
//            return tiktokMsg(state)
//        }
//    }
    
//    func twitterMsg(_ state: SingUpInputState) -> String {
//        switch state {
//        case .handle:
//            return APPLocalizable.enter_twitter_handle
//        case .followers:
//            return APPLocalizable.enter_twitter_followers
//        case .attachements:
//            return APPLocalizable.enter_twitter_screenshot
//        default:
//            return ""
//        }
//    }
    
//    func instagramMsg(_ state: SingUpInputState) -> String {
//        switch state {
//        case .handle:
//            return APPLocalizable.enter_instagram_handle
//        case .followers:
//            return APPLocalizable.enter_instagram_followers
//        case .attachements:
//            return APPLocalizable.enter_instagram_screenshot
//        default:
//            return ""
//        }
//    }
//    
//    func facebookMsg(_ state: SingUpInputState) -> String {
//        switch state {
//        case .handle:
//            return APPLocalizable.enter_facebook_handle
//        case .followers:
//            return APPLocalizable.enter_facebook_followers
//        case .attachements:
//            return APPLocalizable.enter_facebook_followers
//        default:
//            return ""
//        }
//    }
//    
//    func snapchatMsg(_ state: SingUpInputState) -> String {
//        switch state {
//        case .handle:
//            return APPLocalizable.enter_snapchat_handle
//        case .followers:
//            return APPLocalizable.enter_snapchat_followers
//        case .attachements:
//            return APPLocalizable.enter_snapchat_screenshot
//        default:
//            return ""
//        }
//    }
//    
//    func tiktokMsg(_ state: SingUpInputState) -> String {
//        switch state {
//        case .handle:
//            return APPLocalizable.enter_tiktok_handle
//        case .followers:
//            return APPLocalizable.enter_tiktok_followers
//        case .attachements:
//            return APPLocalizable.enter_tiktok_screenshot
//        default:
//            return ""
//        }
//    }
}

struct NotificationKey {
    static let updateNotifications: String = "UpdateNotifications"
    static let tabSwtichNotification: String = "TabSwtichNotification"
}

enum AccFieldType {
    case personalDetails, bankDetails, favBrands, linkaat, support, language, refer, delete, postRates, contactUs
    
    var title: String {
        switch self {
        case .personalDetails:         return APPLocalizable.personal_details
        case .bankDetails:       return APPLocalizable.bank_details
        case .favBrands:       return "Favorite Brands"
        case .linkaat:      return APPLocalizable.linkaat
        case .support:      return APPLocalizable.support_policies
        case .language:     return APPLocalizable.language
        case .refer:        return APPLocalizable.refer
        case .delete:    return APPLocalizable.delete_acc
        case .postRates:    return APPLocalizable.post_rates
        case .contactUs:    return APPLocalizable.contact_us
        }
    }
    
    var image: String {
        switch self {
        case .personalDetails:         return "user"
        case .bankDetails:         return "bank"
        case .favBrands:         return "Star"
        case .linkaat:       return "link"
        case .support:        return "supportMenu"
        case .language:          return "languageMenu"
        case .refer:        return ""
        case .delete:      return ""
        case .postRates:      return "postratesMenu"
        case .contactUs:      return ""
        }
    }
    
    var rowHeight: CGFloat {
        switch self {
        case .personalDetails:       return 60
        case .bankDetails:        return 60
        case .favBrands:        return 60
        case .linkaat:          return 60
        case .support:        return 60
        case .language:      return 60
        case .refer:    return 60
        case .delete:    return 60
        case .postRates:    return 60
        case .contactUs:    return 60
        default:            return 60
        }
    }
    
}

func getFirstAndLastDateOfCurrentMonth() -> (monthNumber: Int, firstDate: String, lastDate: String)? {
    let calendar = Calendar.current
    let today = Date()
    
    // Get the current month number
    let monthNumber = calendar.component(.month, from: today)
    
    // Get the first date of the current month
    guard let firstDate = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else { return nil }

    // Get the last date of the current month
    guard let lastDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDate) else { return nil }
    
    // Date formatter to convert Date to "yyyy-MM-dd" format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let firstDateString = dateFormatter.string(from: firstDate)
    let lastDateString = dateFormatter.string(from: lastDate)
    
    return (monthNumber, firstDateString, lastDateString)
}


func getFirstAndLastDate(of month: Int? = nil, in year: Int? = nil) -> (firstDate: String, lastDate: String)? {
    let calendar = Calendar.current
    let today = Date()

    // Use passed year or default to the current year
    let year = year ?? calendar.component(.year, from: today)
    
    // Use passed month or default to the current month
    let month = month ?? calendar.component(.month, from: today)

    // Ensure month is between 1 and 12
    guard (1...12).contains(month) else { return nil }
    
    // Get the first date of the specified month and year
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = 1
    
    guard let firstDate = calendar.date(from: components) else { return nil }

    // Get the last date of the specified month
    guard let lastDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDate) else { return nil }

    // Date formatter to convert Date to "yyyy-MM-dd" format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let firstDateString = dateFormatter.string(from: firstDate)
    let lastDateString = dateFormatter.string(from: lastDate)
    
    return (firstDateString, lastDateString)
}

func getCurrentMonthAndYearName() -> (monthName: String, year: Int) {
    let today = Date()
    let calendar = Calendar.current

    // Get the current year
    let year = calendar.component(.year, from: today)

    // DateFormatter to get the full month name
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"  // "MMMM" gives full month name (e.g., September)
    
    let monthName = dateFormatter.string(from: today)
    
    return (monthName, year)
}
