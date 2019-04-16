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
    
    init() {
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
    
    static func mock() -> [Transaction]? {
        guard let wallet = Wallet.sharedWallet else {
            return nil
        }
        var transactions = [Transaction]()
        let tx1 = Transaction()
        tx1.timeStamp = 1_555_051_084
        tx1.from = "0x5af2be193a6abca9c8817001f45744777db30756"
        tx1.to = wallet.walletAddress
        tx1.value = 10
        let tx2 = Transaction()
        tx2.timeStamp = 1_555_050_900
        tx2.from = wallet.walletAddress
        tx2.to = "0x5af2be193a6abca9c8817001f45744777db30756"
        tx2.value = 5
        let tx3 = Transaction()
        tx3.timeStamp = 1_555_051_400
        tx3.from = wallet.walletAddress
        tx3.to = "0x5af2be193a6abca9c8817001f45744777db30756"
        tx3.contractOperation = ContractOperation()
        transactions.append(tx1)
        transactions.append(tx2)
        transactions.append(tx3)
        return transactions
    }
}
