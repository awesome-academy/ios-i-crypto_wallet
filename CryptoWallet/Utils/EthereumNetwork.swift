//
//  Networks.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation
import Web3swift

enum EthereumNetwork {
    case mainnet
    case ropsten
    case rinkeby
    
    var web3Instance: web3? {
        switch self {
        case .mainnet:
            return Web3.InfuraMainnetWeb3()
        case .rinkeby:
            return Web3.InfuraRinkebyWeb3()
        case .ropsten:
            return Web3.InfuraRopstenWeb3()
        }
    }
}
