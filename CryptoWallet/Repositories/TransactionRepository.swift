//
//  TransactionRepository.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/15/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

protocol TransactionRepository {
    func getTransactionList(walletAddress: String, page: Int, contractAddress: String, completion: @escaping (BaseResult<TransactionResponse>) -> Void)
    func getTransactionList(walletAddress: String, page: Int, completion: @escaping (BaseResult<TransactionResponse>) -> Void)
}

final class TransactionRepositoryImpl: TransactionRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getTransactionList(walletAddress: String, page: Int, contractAddress: String, completion: @escaping (BaseResult<TransactionResponse>) -> Void) {
        let input = TransactionRequest(walletAddress: walletAddress, page: page, contractAddress: contractAddress)
        api?.request(input: input) { (object: TransactionResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getTransactionList(walletAddress: String, page: Int, completion: @escaping (BaseResult<TransactionResponse>) -> Void) {
        getTransactionList(walletAddress: walletAddress, page: page, contractAddress: "", completion: completion)
    }
}
