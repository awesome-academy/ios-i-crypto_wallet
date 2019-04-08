//
//  Operation.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class ContractOperation: BaseModel {
    var transactionId = ""
    var contractTransaction: ContractTransaction?
    var value = ""
    var to = ""
    var from = ""
    var type = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        transactionId <- map["transactionId"]
        contractTransaction <- map["contract"]
        value <- map["value"]
        to <- map["to"]
        from <- map["from"]
        type <- map["type"]
    }
}
