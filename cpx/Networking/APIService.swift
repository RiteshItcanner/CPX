//
//  APIService.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    
    private let apiClient = APIClient.shared

    private init() {}

    func sendOTP(email: String, completion: @escaping (Result<OTPResponse, OTPError>) -> Void) {
        let url = "https://dados.stag2.cpx.ae/api/send_otp"
        let headers: HTTPHeaders = ["Content-Type": "application/json", "token": Constant.token]
        let parameters: [String: Any] = ["email": email]

        apiClient.postRequest(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                if let status = response["status"] as? String, status == "success" {
                    // Parse the response into OTPResponse model
                    let otpResponse = OTPResponse(data: response["data"] as? [String: Any], message: response["message"] as? String)
                    completion(.success(otpResponse))
                } else {
                    // Parse the error response into OTPError model
                    let otpError = OTPError(message: response["message"] as? String ?? "Unknown error", code: response["code"] as? Int ?? 0)
                    completion(.failure(otpError))
                }
            case .failure(_):
                let otpError = OTPError(message: "Network or server error", code: -1)
                completion(.failure(otpError))
            }
        }
    }
    
    func confirmOTP(email: String, otp: String, completion: @escaping (Result<ConfirmOTPResponse, OTPError>) -> Void) {
        let url = "https://dados.stag2.cpx.ae/api/confirm_otp"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": Constant.token
        ]
        let parameters: [String: Any] = ["email": email, "otp": otp]

        apiClient.postRequest(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                if let status = response["status"] as? String, status == "success" {
                    do {
                        // Handle the successful response
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                        let otpResponse = try JSONDecoder().decode(ConfirmOTPResponse.self, from: jsonData)
                        completion(.success(otpResponse))
                    } catch {
                        // Handle JSON decoding error
                        let otpError = OTPError(message: error.localizedDescription, code: -2)
                        completion(.failure(otpError))
                    }
                } else if let status = response["status"] as? String, status == "error" {
                    // Handle the error response (403)
                    let message = (response["error"] as? [String: Any])?["message"] as? String ?? "Unknown error"
                    let code = (response["error"] as? [String: Any])?["status_code"] as? Int ?? 0
                    let otpError = OTPError(message: message, code: code)
                    completion(.failure(otpError))
                } else {
                    // Handle unexpected response format
                    let otpError = OTPError(message: "Unexpected response format", code: -1)
                    completion(.failure(otpError))
                }
                
            case .failure(let error):
                let otpError = OTPError(message: error.localizedDescription, code: (error as NSError).code)
                completion(.failure(otpError))
            }
        }
    }
    
    func getMyCoupons(userId: Int, page: Int, pagesize: Int, completion: @escaping (Result<CouponResponse, OTPError>) -> Void) {
        let url = "https://dados.stag2.cpx.ae/api/my-coupons"
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "token": Constant.token // Assuming token is managed in Constant
        ]
        let parameters: [String: Any] = [
            "affiliate_id": userId,
            "page": page,
            "pagesize": pagesize,
            "is_mobile_app": "1"
        ]

        print(parameters)
        apiClient.postRequestNew(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                if let status = response["status"] as? String, status == "success" {
                    do {
                        // Convert the response to JSON data and decode it into the CouponResponse model
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                        let couponResponse = try JSONDecoder().decode(CouponResponse.self, from: jsonData)
                        completion(.success(couponResponse))
                    } catch {
                        // Handle JSON decoding error
                        let otpError = OTPError(message: "Failed to parse coupon data: \(error.localizedDescription)", code: -2)
                        completion(.failure(otpError))
                    }
                } else if let status = response["status"] as? String, status == "error" {
                    // Handle API error response
                    let errorMessage = response["error"] as? String ?? "Unknown error"
                    let code = response["code"] as? Int ?? -1
                    let otpError = OTPError(message: errorMessage, code: code)
                    completion(.failure(otpError))
                } else {
                    // Handle unexpected response format
                    let otpError = OTPError(message: "Unexpected response format", code: -1)
                    completion(.failure(otpError))
                }
                
            case .failure(let error):
                // Handle network or server error
                let otpError = OTPError(message: error.localizedDescription, code: (error as NSError).code)
                completion(.failure(otpError))
            }
        }
    }
    
    func getUserDetails(userId: Int, completion: @escaping (Result<UserDetailsResponse, OTPError>) -> Void) {
        let url = "https://dados.stag2.cpx.ae/api/user-detail"
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "token": Constant.token // Assuming token is managed in Constant
        ]
        let parameters: [String: Any] = [
            "affiliate_id": userId
        ]

        print(parameters)
        apiClient.postRequestNew(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                if let status = response["status"] as? String, status == "success" {
                    do {
                        // Convert the response to JSON data and decode it into the CouponResponse model
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                        let couponResponse = try JSONDecoder().decode(UserDetailsResponse.self, from: jsonData)
                        completion(.success(couponResponse))
                    } catch {
                        // Handle JSON decoding error
                        let otpError = OTPError(message: "Failed to parse coupon data: \(error.localizedDescription)", code: -2)
                        completion(.failure(otpError))
                    }
                } else if let status = response["status"] as? String, status == "error" {
                    // Handle API error response
                    let errorMessage = response["error"] as? String ?? "Unknown error"
                    let code = response["code"] as? Int ?? -1
                    let otpError = OTPError(message: errorMessage, code: code)
                    completion(.failure(otpError))
                } else {
                    // Handle unexpected response format
                    let otpError = OTPError(message: "Unexpected response format", code: -1)
                    completion(.failure(otpError))
                }
                
            case .failure(let error):
                // Handle network or server error
                let otpError = OTPError(message: error.localizedDescription, code: (error as NSError).code)
                completion(.failure(otpError))
            }
        }
    }
    
    func getBankDetails(userId: Int, completion: @escaping (Result<BankDetailsResponse, OTPError>) -> Void) {
        let url = "https://dados.stag2.cpx.ae/api/bank-detail"
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "token": Constant.token // Assuming token is managed in Constant
        ]
        let parameters: [String: Any] = [
            "affiliate_id": userId
        ]

        print(parameters)
        apiClient.postRequestNew(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                if let status = response["status"] as? String, status == "success" {
                    do {
                        // Convert the response to JSON data and decode it into the CouponResponse model
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                        let couponResponse = try JSONDecoder().decode(BankDetailsResponse.self, from: jsonData)
                        completion(.success(couponResponse))
                    } catch {
                        // Handle JSON decoding error
                        let otpError = OTPError(message: "Failed to parse coupon data: \(error.localizedDescription)", code: -2)
                        completion(.failure(otpError))
                    }
                } else if let status = response["status"] as? String, status == "error" {
                    // Handle API error response
                    let errorMessage = response["error"] as? String ?? "Unknown error"
                    let code = response["code"] as? Int ?? -1
                    let otpError = OTPError(message: errorMessage, code: code)
                    completion(.failure(otpError))
                } else {
                    // Handle unexpected response format
                    let otpError = OTPError(message: "Unexpected response format", code: -1)
                    completion(.failure(otpError))
                }
                
            case .failure(let error):
                // Handle network or server error
                let otpError = OTPError(message: error.localizedDescription, code: (error as NSError).code)
                completion(.failure(otpError))
            }
        }
    }
    
    func getCouponRequest(userId: Int, page: Int, pagesize: Int, completion: @escaping (Result<CouponRequestResponse, OTPError>) -> Void) {
        let url = "https://dados.stag2.cpx.ae/api/requestcouponlist"
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "token": Constant.token // Assuming token is managed in Constant
        ]
        let parameters: [String: Any] = [
            "affiliate_id": userId,
            "page": page,
            "pagesize": pagesize
        ]

        print(parameters)
        apiClient.postRequestNew(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                if let status = response["status"] as? String, status == "success" {
                    do {
                        // Convert the response to JSON data and decode it into the CouponResponse model
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                        let couponResponse = try JSONDecoder().decode(CouponRequestResponse.self, from: jsonData)
                        completion(.success(couponResponse))
                    } catch {
                        // Handle JSON decoding error
                        let otpError = OTPError(message: "Failed to parse coupon data: \(error.localizedDescription)", code: -2)
                        completion(.failure(otpError))
                    }
                } else if let status = response["status"] as? String, status == "error" {
                    // Handle API error response
                    let errorMessage = response["error"] as? String ?? "Unknown error"
                    let code = response["code"] as? Int ?? -1
                    let otpError = OTPError(message: errorMessage, code: code)
                    completion(.failure(otpError))
                } else {
                    // Handle unexpected response format
                    let otpError = OTPError(message: "Unexpected response format", code: -1)
                    completion(.failure(otpError))
                }
                
            case .failure(let error):
                // Handle network or server error
                let otpError = OTPError(message: error.localizedDescription, code: (error as NSError).code)
                completion(.failure(otpError))
            }
        }
    }
    
    func getStats(userId: Int, page: Int, pagesize: Int, startDate: String, endDate: String, completion: @escaping (Result<StatsResponse, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let url = "https://dados.stag2.cpx.ae/api/statistics"
        
        let parameters: [String: Any] = [
            "timeperiod": "Daterange",
            "affiliate_id": userId,
            "page": page,
            "pagesize": pagesize,
            "startdate": startDate,
            "enddate": endDate,
            "advertiser_id": [] // Empty array as expected by the backend
        ]

        // Convert parameters dictionary to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            // Call the API with the JSON data
            apiClient.postRequestJsonData(url: url, jsonData: jsonData, headers: headers) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        let statsResponse = try decoder.decode(StatsResponse.self, from: response)
                        completion(.success(statsResponse))  // Return decoded StatsResponse in callback
                    } catch {
                        completion(.failure(error))  // Return decoding error in callback
                    }
                case .failure(let error):
                    completion(.failure(error))  // Return network error in callback
                }
            }
        } catch {
            completion(.failure(error))  // Return JSON serialization error in callback
        }
    }



    func getStatsData(userId: Int, page: Int, pagesize: Int, completion: @escaping (Result<StatsResponse, OTPError>) -> Void) {
        let url = "https://dados.stag2.cpx.ae/api/statistics"
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "token": Constant.token // Assuming token is managed in Constant
        ]
//        let headers: HTTPHeaders = HTTPHeaders()
//        let adArray = [String]()
        let filters: [String] = []
        let parameters: [String: Any] = [
            "timeperiod": "Daterange",
            "affiliate_id": userId,
            "page": page,
            "pagesize": pagesize,
            "startdate": "2024-09-01",
            "enddate": "2024-09-30",
            "advertiser_id": filters
        ]

        print(parameters)
        apiClient.postRequest(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                if let status = response["status"] as? String, status == "success" {
                    do {
                        // Convert the response to JSON data and decode it into the CouponResponse model
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                        let statsResponse = try JSONDecoder().decode(StatsResponse.self, from: jsonData)
                        completion(.success(statsResponse))
                    } catch {
                        // Handle JSON decoding error
                        let otpError = OTPError(message: "Failed to parse coupon data: \(error.localizedDescription)", code: -2)
                        completion(.failure(otpError))
                    }
                } else if let status = response["status"] as? String, status == "error" {
                    // Handle API error response
                    let errorMessage = response["error"] as? String ?? "Unknown error"
                    let code = response["code"] as? Int ?? -1
                    let otpError = OTPError(message: errorMessage, code: code)
                    completion(.failure(otpError))
                } else {
                    // Handle unexpected response format
                    let otpError = OTPError(message: "Unexpected response format", code: -1)
                    completion(.failure(otpError))
                }
                
            case .failure(let error):
                // Handle network or server error
                let otpError = OTPError(message: error.localizedDescription, code: (error as NSError).code)
                completion(.failure(otpError))
            }
        }
    }

}

