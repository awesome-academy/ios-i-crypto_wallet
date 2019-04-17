//
//  TransactionType.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/12/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

enum TransactionType {
    case sent
    case received
    case pending
    case smartContractCall
    case transferTokenTo(token: String)
    case transferTokenFrom(token: String)
    
    func toString() -> String {
        switch self {
        case .pending:
            return "Pending"
        case .received:
            return "Received"
        case .sent:
            return "Sent"
        case .smartContractCall:
            return "Smart Contract Call"
        case .transferTokenTo(let token), .transferTokenFrom(let token):
            return "Transfer \(token)"
        }
    }
}
