//
//  APIService.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/9/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct APIService {
    static let share = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init(adapterRequest: RequestAdapter? = Alamofire.SessionManager.default.adapter) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = adapterRequest
    }
    
    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?, _ error: BaseError?) -> Void) {
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No body")
        print("------------ END REQUEST INPUT\n")
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                print(response.request?.url ?? "Error")
                print(response)
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            let object = Mapper<T>().map(JSONObject: value)
                            completion(object, nil)
                        } else {
                            completion(nil, BaseError.httpError(httpCode: statusCode))
                        }
                    } else {
                        completion(nil, BaseError.unexpectedError)
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
                }
            }
    }
    
    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: [T]?, _ error: BaseError?) -> Void) {
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No body")
        print("------------ END REQUEST INPUT\n")
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            let object = Mapper<T>().mapArray(JSONObject: value)
                            completion(object, nil)
                        } else {
                            completion(nil, BaseError.httpError(httpCode: statusCode))
                        }
                    } else {
                        completion(nil, BaseError.unexpectedError)
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
                }
            }
    }
}
