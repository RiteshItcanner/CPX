//
//  APIClient.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import Alamofire

class APIClient {
    static let shared = APIClient()

    private init() {}
    
    func postRequest(url: String, parameters: [String: Any], headers: HTTPHeaders, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    if let data = response.data, let dataString = String(data: data, encoding: .utf8) {
                        print("Raw response data: \(dataString)")
                    }
                    switch response.result {
                    case .success(let value):
                        if let json = value as? [String: Any] {
                            completion(.success(json))
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    func postRequestNew(url: String, parameters: [String: Any], headers: HTTPHeaders, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                .responseJSON { response in
//                    print(response)
                    if let data = response.data, let dataString = String(data: data, encoding: .utf8) {
                        print("Raw response data: \(dataString)")
                    }
                    switch response.result {
                    case .success(let value):
                        if let json = value as? [String: Any] {
                            completion(.success(json))
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    func postRequestJsonData(url: String, jsonData: Data, headers: HTTPHeaders, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.upload(jsonData, to: url, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    completion(.success(data))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



}

