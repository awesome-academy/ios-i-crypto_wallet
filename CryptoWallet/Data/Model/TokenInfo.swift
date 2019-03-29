//
//  TokenList.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 3/29/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper
import Web3swift

final class TokenInfo: BaseModel {
    var balance = 0.0
    var contract: Contract?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        balance <- map["balance"]
        contract <- map["contract"]
    }
}
