//
//  Transaction.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/1/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import ObjectMapper

final class Transaction: BaseModel {
    var contractOperation: ContractOperation?
    var id = ""
    var blockNumber = 0.0
    var timeStamp = 0.0
    var nonce = 0.0
    var from = ""
    var to = ""
    var value = 0.0
    var gas = 0.0
    var gasPrice = 0.0
    var gasUsed = 0.0
    var input = ""
    var error = ""

    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        contractOperation <- map["operations"]
        id <- map["id"]
        blockNumber <- map["blockNumber"]
        timeStamp <- map["timeStamp"]
        nonce <- map["nonce"]
        from <- map["from"]
        to <- map["to"]
        value <- map["value"]
        gas <- map["gas"]
        gasPrice <- map["gasPrice"]
        gasUsed <- map["gasUsed"]
        input <- map["input"]
        error <- map["error"]
    }
}
