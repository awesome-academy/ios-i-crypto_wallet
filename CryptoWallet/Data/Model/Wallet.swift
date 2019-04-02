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
    var isHierarchicalDeterministic  = false
    
    init(walletName: String, walletAddress: String, keyData: Data, isHierarchicalDeterministic: Bool) {
        self.walletName = walletName
        self.walletAddress = walletAddress
        self.keyData = keyData
        self.isHierarchicalDeterministic = isHierarchicalDeterministic
    }
}

extension Wallet: Equatable {
    static func == (leftWallet: Wallet, rightWallet: Wallet) -> Bool {
        return leftWallet.walletAddress == rightWallet.walletAddress
    }
}
