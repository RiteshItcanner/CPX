//
//  User.swift
//  LalaCoupons
//
//  Created by shohib mohammed pathan on 27/05/20.
//  Copyright © 2020 Al Taathir. All rights reserved.
//

import EVReflection
import UIKit

@objc(BaseModel)
class BaseModel: EVObject {
}

class User: BaseModel {
    var _id: String! = ""
    var hs_object_id: String = ""
    var contact_sub_type: String = ""
    var moon_status: String = ""

    var first_name: String = ""
    var last_name: String = ""
    var first_name_hub: String = ""
    var last_name_hub: String = ""
    var email: String! = ""
    var birthDate: String! = ""
    var address: String! = ""
    var role: String = ""
    var api_token: String = ""
    var influencer_id: String = ""
    var updated_at: String = ""
    var created_at: String = ""
    var user_email: String = ""
    var user_name: String = ""
    var moon_app_num_edit_hub: String = ""
    var moon_app_add_edit_hub: String = ""
    var moon_app_birth_edit_hub: String = ""
    var account_holder_name: String = ""
    var account_number_1: String = ""
    var bank_name_1: String = ""

    var bank_branch: String = ""
    var main_bank_country: String = ""
    var swift_code_1: String = ""

    var iban_1: String = ""
    var instagram_story_rate: String = ""
    var instagram_post_rate: String = ""
    var instagram_reel_rate: String = ""
    var snapchat_rate: String = ""
    var tiktok_rate: String = ""
    var twitter_rate: String = ""
    var youtube_full_video_rate: String = ""
    var youtube_short_rate: String = ""
    var youtube_sponsored_video_rate: String = ""
    var name_arabic: String = ""
    var referral_link: String = ""

    required init() { }

    required init(coder decoder: NSCoder) {
        super.init()
        _id = decoder.decodeObject(forKey: "_id") as? String ?? ""
        hs_object_id = decoder.decodeObject(forKey: "hs_object_id") as? String ?? ""
        first_name = decoder.decodeObject(forKey: "first_name") as? String ?? ""
        last_name = decoder.decodeObject(forKey: "last_name") as? String ?? ""
        first_name_hub = decoder.decodeObject(forKey: "firstname") as? String ?? ""
        last_name_hub = decoder.decodeObject(forKey: "lastname") as? String ?? ""
        email = decoder.decodeObject(forKey: "email") as? String ?? ""
        birthDate = decoder.decodeObject(forKey: "date_of_birth") as? String ?? ""
        address = decoder.decodeObject(forKey: "address") as? String ?? ""
        role = decoder.decodeObject(forKey: "role") as? String ?? ""
        api_token = decoder.decodeObject(forKey: "api_token") as? String ?? ""
        influencer_id = decoder.decodeObject(forKey: "influencer_id") as? String ?? ""
        updated_at = decoder.decodeObject(forKey: "updated_at") as? String ?? ""
        created_at = decoder.decodeObject(forKey: "created_at") as? String ?? ""
        user_email = decoder.decodeObject(forKey: "user_email") as? String ?? ""
        user_name = decoder.decodeObject(forKey: "user_name") as? String ?? ""
        account_holder_name = decoder.decodeObject(forKey: "account_holder_name") as? String ?? ""
        account_number_1 = decoder.decodeObject(forKey: "account_number_1") as? String ?? ""
        bank_name_1 = decoder.decodeObject(forKey: "bank_name_1") as? String ?? ""
        bank_branch = decoder.decodeObject(forKey: "bank_branch") as? String ?? ""
        main_bank_country = decoder.decodeObject(forKey: "main_bank_country") as? String ?? ""
        swift_code_1 = decoder.decodeObject(forKey: "swift_code_1") as? String ?? ""
        iban_1 = decoder.decodeObject(forKey: "iban_1") as? String ?? ""
        instagram_post_rate = decoder.decodeObject(forKey: "instagram_post_rate") as? String ?? ""
        instagram_reel_rate = decoder.decodeObject(forKey: "instagram_reel_rate") as? String ?? ""
        instagram_story_rate = decoder.decodeObject(forKey: "instagram_story_rate") as? String ?? ""
        
        snapchat_rate = decoder.decodeObject(forKey: "snapchat_rate") as? String ?? ""
        tiktok_rate = decoder.decodeObject(forKey: "tiktok_rate") as? String ?? ""
        twitter_rate = decoder.decodeObject(forKey: "twitter_rate") as? String ?? ""
        youtube_full_video_rate = decoder.decodeObject(forKey: "youtube_full_video_rate") as? String ?? ""
        youtube_short_rate = decoder.decodeObject(forKey: "youtube_short_rate") as? String ?? ""
        youtube_sponsored_video_rate = decoder.decodeObject(forKey: "youtube_sponsored_video_rate") as? String ?? ""

        name_arabic = decoder.decodeObject(forKey: "name_arabic") as? String ?? ""
        referral_link = decoder.decodeObject(forKey: "referral_link") as? String ?? ""
        contact_sub_type = decoder.decodeObject(forKey: "contact_sub_type") as? String ?? ""
        moon_status = decoder.decodeObject(forKey: "moon_status") as? String ?? ""
    }

    override func encode(with coder: NSCoder) {
        coder.encode(_id, forKey: "_id")
        coder.encode(first_name, forKey: "first_name")
        coder.encode(last_name, forKey: "last_name")
        coder.encode(first_name_hub, forKey: "firstname")
        coder.encode(last_name_hub, forKey: "lastname")
        coder.encode(email, forKey: "email")

        coder.encode(birthDate, forKey: "date_of_birth")
        coder.encode(address, forKey: "address")

        coder.encode(role, forKey: "role")
        coder.encode(api_token, forKey: "api_token")
        coder.encode(influencer_id, forKey: "influencer_id")
        coder.encode(updated_at, forKey: "updated_at")
        coder.encode(created_at, forKey: "created_at")
        coder.encode(user_email, forKey: "user_email")
        coder.encode(user_name, forKey: "user_name")
        coder.encode(moon_app_num_edit_hub, forKey: "moon_app_num_edit")
        coder.encode(account_holder_name, forKey: "account_holder_name")
        coder.encode(account_number_1, forKey: "account_number_1")
        coder.encode(bank_name_1, forKey: "bank_name_1")

        coder.encode(bank_branch, forKey: "bank_branch")
        coder.encode(main_bank_country, forKey: "main_bank_country")
        coder.encode(swift_code_1, forKey: "swift_code_1")

        coder.encode(iban_1, forKey: "iban_1")
        coder.encode(instagram_post_rate, forKey: "instagram_post_rate")
        coder.encode(instagram_reel_rate, forKey: "instagram_reel_rate")
        coder.encode(instagram_story_rate, forKey: "instagram_story_rate")
        
        coder.encode(snapchat_rate, forKey: "snapchat_rate")
        coder.encode(tiktok_rate, forKey: "tiktok_rate")
        coder.encode(twitter_rate, forKey: "twitter_rate")
        coder.encode(youtube_full_video_rate, forKey: "youtube_full_video_rate")
        coder.encode(youtube_short_rate, forKey: "youtube_short_rate")
        coder.encode(youtube_sponsored_video_rate, forKey: "youtube_sponsored_video_rate")
        
        coder.encode(name_arabic, forKey: "name_arabic")
        coder.encode(referral_link, forKey: "referral_link")
        coder.encode(contact_sub_type, forKey: "contact_sub_type")
        coder.encode(moon_status, forKey: "moon_status")

//        self.name_arabic = decoder.decodeObject(forKey: "name_arabic") as? String ?? ""
    }

    func getUserName() -> String {
//        let name = AppUtility.isRTL ? name_arabic : [first_name_hub, last_name_hub].joined(separator: " ") // ((first_name_hub) + (last_name_hub))
//        return name
        return ""
    }
}
