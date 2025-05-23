//
//  Login.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import Foundation

struct SuccessResponse: Codable {
    let status: String?
    let code: Int?
    let result: Bool?
    let message: String?
    let data: CouponReqSubmitData?
}

struct CouponReqSubmitData: Codable {
    let id: String?
    let properties: CouponReqSubmitProperties?
    let createdAt: String?
    let updatedAt: String?
    let archived: Bool?
}

struct CouponReqSubmitProperties: Codable {
    let hs_body_preview: String?
    let hs_body_preview_html: String?
    let hs_body_preview_is_truncated: String?
    let hs_createdate: String?
    let hs_lastmodifieddate: String?
    let hs_object_id: String?
    let hs_object_source: String?
    let hs_object_source_id: String?
    let hs_object_source_label: String?
    let hs_task_body: String?
    let hs_task_completion_count: String?
    let hs_task_family: String?
    let hs_task_for_object_type: String?
    let hs_task_is_all_day: String?
    let hs_task_is_completed: String?
    let hs_task_is_completed_call: String?
    let hs_task_is_completed_email: String?
    let hs_task_is_completed_linked_in: String?
    let hs_task_is_completed_sequence: String?
    let hs_task_is_overdue: String?
    let hs_task_is_past_due_date: String?
    let hs_task_missed_due_date: String?
    let hs_task_missed_due_date_count: String?
    let hs_task_priority: String?
    let hs_task_status: String?
    let hs_task_subject: String?
    let hs_task_type: String?
    let hs_timestamp: String?
}


struct OTPResponse {
    let message: String?
    let data: [String: Any]?

    init(data: [String: Any]?, message: String?) {
        self.data = data
        self.message = message ?? "Success"
    }
}

struct OTPError: Error {
    let message: String?
    let code: Int?

    init(message: String, code: Int) {
        self.message = message
        self.code = code
    }
}

struct ConfirmOTPResponse: Codable {
    let status: String
    let code: Int
    let message: String
    let data: ConfirmOTPData
}

struct ConfirmOTPData: Codable {
    let message: String
    let id: String
    let status: String
    let email: String
    let company: String
    let firstName: String
    let lastName: String?
    let phone: String
    let cellPhone: String
    let accessToken: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case message
        case id
        case status
        case email
        case company
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case cellPhone = "cell_phone"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}

// MARK: -> User Details
struct UserDetailsResponse: Codable {
    let status: String
    let code: Int
    let result: Bool
    let message: String
    let data: UserDetailsData
}

struct UserDetailsData: Codable {
    let email, phone, company, name, birth_date: String?
    let address1: String?
    let address2: String?
    let city: String?
    let zipcode: String?
    let country: String?
    let experienceNo, experienceType: String?
    let type: String?
    let idProof, termsAndConditions: String?
}

// MARK: - Bank Details
struct BankDetailsResponse: Codable {
    let status: String
    let code: Int
    let result: Bool
    let message: String
    let data: BankDetailsData?
}

struct BankDetailsData: Codable {
    let bankName: String?
    let accountNumber: String?
    let beneficiaryName: String?
    let ibanNumber: String?
    let bankBranch: String?
    let bankCountry: String?
    let swiftNumber: String?

    enum CodingKeys: String, CodingKey {
        case bankName = "bank_name"
        case accountNumber = "account_number"
        case beneficiaryName = "beneficiary_name"
        case ibanNumber = "iban_number"
        case bankBranch = "bank_branch"
        case bankCountry = "bank_country"
        case swiftNumber = "swift_number"
    }
}

