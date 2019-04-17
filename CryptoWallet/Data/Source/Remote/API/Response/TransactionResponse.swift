//
//  TransactionResponse.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/15/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class TransactionResponse: Mappable {
    var transactions: [Transaction]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        transactions <- map["docs"]
    }
}
