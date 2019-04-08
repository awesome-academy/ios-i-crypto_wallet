//
//  WalletValueRepository.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/9/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

protocol WalletValueDataRepository {
    func getWalletValueData(address: String, from: Double, completion: @escaping (BaseResult<WalletValueDataResponse>) -> Void)
}

final class WalletValueDataRepositoryImpl: WalletValueDataRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getWalletValueData(address: String, from: Double, completion: @escaping (BaseResult<WalletValueDataResponse>) -> Void) {
        let input = WalletValueDataRequest(address: address, from: from)
        api?.request(input: input) { (object: WalletValueDataResponse?, error) in
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
