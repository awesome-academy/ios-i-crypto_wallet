//
//  Wallet.swift
//  CryptoWallet
//
//  Created by Phan Dinh Van on 4/2/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

struct Wallet {
    var walletName = ""
    var walletAddress = ""
    var keyData: Data?
    var isHierarchicalDeterministic = false
    static var sharedWallet: Wallet?
}

extension Wallet: Equatable {
    static func == (leftWallet: Wallet, rightWallet: Wallet) -> Bool {
        return leftWallet.walletAddress == rightWallet.walletAddress
    }
}
