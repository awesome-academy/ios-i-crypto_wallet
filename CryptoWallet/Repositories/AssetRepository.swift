//
//  AssetRepository.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/10/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

protocol AssetRepository {
    func getAssetList(address: String, completion: @escaping (BaseResult<TokenListResponse>) -> Void)
    func getCMCCoinInfo(completion: @escaping (BaseArrayResult<CMCCoinInfoResponse>) -> Void)
    func getEthereumInfo(completion: @escaping (BaseResult<EthereumMarketResponse>) -> Void)
    func getAssetMarket(contractAddress: String, completion: @escaping (BaseResult<AssetMarketResponse>) -> Void)
}

final class AssetRepositoryImpl: AssetRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getAssetList(address: String, completion: @escaping (BaseResult<TokenListResponse>) -> Void) {
        let input = TokenListRequest(address: address)
        api?.request(input: input) { (object: TokenListResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getCMCCoinInfo(completion: @escaping (BaseArrayResult<CMCCoinInfoResponse>) -> Void) {
        let input = CMCCoinInfoRequest()
        api?.request(input: input) { (object: [CMCCoinInfoResponse]?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getEthereumInfo(completion: @escaping (BaseResult<EthereumMarketResponse>) -> Void) {
        let input = EthereumMarketRequest()
        api?.request(input: input) { (object: EthereumMarketResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getAssetMarket(contractAddress: String, completion: @escaping (BaseResult<AssetMarketResponse>) -> Void) {
        let input = AssetMarketRequest(contractAddress: contractAddress)
        api?.request(input: input) { (object: AssetMarketResponse?, error) in
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
