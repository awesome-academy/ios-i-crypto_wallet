//
//  CronJobRepository.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/11/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

protocol CronJobRepository {
    func trackWallet(address: String, completion: @escaping (BaseResult<CronJobResponse>) -> Void)
    func checkWallet(address: String, completion: @escaping (BaseResult<CheckCronJobResponse>) -> Void)
}

final class CronJobRepositoryImpl: CronJobRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func trackWallet(address: String, completion: @escaping (BaseResult<CronJobResponse>) -> Void) {
        let input = CronJobRequest(address: address)
        api?.request(input: input) { (object: CronJobResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func checkWallet(address: String, completion: @escaping (BaseResult<CheckCronJobResponse>) -> Void) {
        let input = CheckCronJobRequest(address: address)
        api?.request(input: input) { (object: CheckCronJobResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
